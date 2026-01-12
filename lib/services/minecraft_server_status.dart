import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:mc_sentinel/services/var_int.dart';
import 'package:mc_sentinel/services/srv_resolver.dart';

/// 自定义异常：Minecraft 服务器连接异常
/// 当无法连接到服务器或连接超时时抛出
class MinecraftConnectionException implements Exception {
  /// 异常消息
  final String message;
  MinecraftConnectionException(this.message);

  @override
  String toString() => 'MinecraftConnectionException: $message';
}

/// 自定义异常：数据解析异常
/// 当服务器响应数据格式不正确或解析失败时抛出
class MinecraftParseException implements Exception {
  /// 异常消息
  final String message;
  MinecraftParseException(this.message);

  @override
  String toString() => 'MinecraftParseException: $message';
}

/// Minecraft 服务器状态查询服务
/// 使用 Minecraft 协议查询服务器状态（玩家数、版本、MOTD等）
/// 支持 SRV 记录解析
class MinecraftServerStatus {
  // ==================== 协议常量 ====================
  /// 数据包 ID（状态请求）
  static const int _packetID = 0x00;

  /// 下一个状态（1 = 状态查询）
  static const int _nextState = 1;

  /// 期望的响应数据包 ID
  static const int _expectedPacketId = 0;

  /// 默认协议版本（-1 表示不指定）
  static const int _defaultProtocolVersion = -1;

  // ==================== 超时设置 ====================
  /// 连接超时时间（5秒）
  static const Duration _connectionTimeout = Duration(seconds: 5);

  /// 响应超时时间（10秒）
  static const Duration _responseTimeout = Duration(seconds: 10);

  /// 原始服务器地址（用户输入的地址）
  final String host;

  /// 原始端口号（用户输入的端口）
  final int port;

  /// 解析后的实际服务器地址
  String? _resolvedHost;

  /// 解析后的实际端口号
  int? _resolvedPort;

  /// 是否已解析 SRV
  bool _srvResolved = false;

  /// 是否使用了 SRV 记录
  bool _usedSrv = false;

  /// 构造函数
  /// [host] 服务器地址（支持域名和 IP），不能为空
  /// [port] 服务器端口，默认 25565
  MinecraftServerStatus({required this.host, this.port = 25565}) {
    // 验证主机地址不为空
    if (host.isEmpty) {
      throw ArgumentError.value(host, 'host', '主机地址不能为空');
    }
    // 验证主机地址长度不超过255字节
    if (host.codeUnits.length > 255) {
      throw ArgumentError.value(host, 'host', '主机地址过长');
    }
    // 验证端口号在有效范围内
    if (port < 1 || port > 65535) {
      throw ArgumentError.value(port, 'port', '端口号必须在 1-65535 之间');
    }
  }

  /// 获取实际连接的主机地址
  String get resolvedHost => _resolvedHost ?? host;

  /// 获取实际连接的端口号
  int get resolvedPort => _resolvedPort ?? port;

  /// 是否使用了 SRV 记录
  bool get usedSrvRecord => _usedSrv;

  /// 解析 SRV 记录
  /// 如果用户输入的是域名且使用默认端口，尝试查询 SRV 记录
  Future<void> _resolveSrv() async {
    // 如果已经解析过，直接返回
    if (_srvResolved) return;
    _srvResolved = true;

    // 如果是 IP 地址，不需要查询 SRV
    if (SrvResolver.isIpAddress(host)) {
      _resolvedHost = host;
      _resolvedPort = port;
      return;
    }

    // 如果用户指定了非默认端口，不查询 SRV（用户明确指定了端口）
    if (port != 25565) {
      _resolvedHost = host;
      _resolvedPort = port;
      return;
    }

    // 尝试查询 SRV 记录
    try {
      final srvRecord = await SrvResolver.resolveMcSrv(host);
      if (srvRecord != null) {
        _resolvedHost = srvRecord.target;
        _resolvedPort = srvRecord.port;
        _usedSrv = true;
        return;
      }
    } catch (e) {
      // SRV 查询失败，使用原始地址
    }

    // 使用原始地址
    _resolvedHost = host;
    _resolvedPort = port;
  }

  /// 将主机地址转换为字节数组
  /// [hostStr] 主机地址字符串
  /// 返回包含长度前缀的字节列表
  List<int> _getHostBytes(String hostStr) {
    final hostBytes = ascii.encode(hostStr);
    return [...VarInt.encode(hostBytes.length), ...hostBytes];
  }

  /// 将端口号转换为字节数组（大端序）
  /// [portNum] 端口号
  /// 返回2字节的端口号表示
  List<int> _getPortBytes(int portNum) => [
    (portNum >> 8) & 0xFF,
    portNum & 0xFF,
  ];

  /// 构建握手数据包
  /// [protocolVersion] 协议版本号
  /// 返回完整的握手数据包字节列表
  List<int> _getHandshakePacket({
    int protocolVersion = _defaultProtocolVersion,
  }) => [
    _packetID, // 数据包 ID
    ...VarInt.encode(protocolVersion), // 协议版本
    ..._getHostBytes(resolvedHost), // 主机地址
    ..._getPortBytes(resolvedPort), // 端口号
    _nextState, // 下一个状态
  ];

  /// 建立 Socket 连接并获取服务器响应
  /// 返回服务器响应的原始字节数据
  Future<List<int>> _socketConnect() async {
    // 先解析 SRV 记录
    await _resolveSrv();

    Socket? socket;
    try {
      // ==================== 建立连接（带超时控制）====================
      socket = await Socket.connect(resolvedHost, resolvedPort).timeout(
        _connectionTimeout,
        onTimeout: () {
          throw MinecraftConnectionException(
            '连接超时 (${_connectionTimeout.inSeconds}秒) - 无法连接到 $resolvedHost:$resolvedPort',
          );
        },
      );

      // ==================== 发送握手包 ====================
      final handshakePacket = _getHandshakePacket();
      socket.add(
        Uint8List.fromList([
          ...VarInt.encode(handshakePacket.length), // 数据包长度
          ...handshakePacket, // 数据包内容
        ]),
      );

      // ==================== 发送状态请求 ====================
      socket.add(
        Uint8List.fromList([
          0x01, // 状态请求数据包长度
          _packetID, // 数据包 ID
        ]),
      );

      // ==================== 接收响应（带超时控制）====================
      final completer = Completer<List<int>>();
      final buffer = <int>[];
      late StreamSubscription<Uint8List> subscription;

      subscription = socket.listen(
        (Uint8List data) {
          // 将接收到的数据添加到缓冲区
          buffer.addAll(data);

          // 检查是否接收到完整数据包
          if (buffer.isNotEmpty) {
            try {
              int offset = 0;
              // 获取数据包长度字段的长度
              int packetLengthLength = VarInt.getVarIntLength(
                buffer,
                index: offset,
              );

              // 检查是否接收到完整的长度数据
              if (buffer.length >= offset + packetLengthLength) {
                // 解析数据包长度
                int packetLength = VarInt.decode(
                  buffer.sublist(offset, offset + packetLengthLength),
                );

                // 检查是否接收到完整的数据包
                if (buffer.length >=
                    offset + packetLengthLength + packetLength) {
                  // 提取完整数据包
                  final fullPacket = buffer.sublist(
                    offset + packetLengthLength,
                    offset + packetLengthLength + packetLength,
                  );
                  if (!completer.isCompleted) {
                    completer.complete(fullPacket);
                  }
                  subscription.cancel();
                  socket?.close();
                }
              }
            } catch (e) {
              // 解析失败，返回错误
              if (!completer.isCompleted) {
                completer.completeError(
                  MinecraftParseException('解析数据包长度失败: $e'),
                );
              }
              subscription.cancel();
              socket?.close();
            }
          }
        },
        onError: (e) {
          // 网络错误处理
          if (!completer.isCompleted) {
            completer.completeError(MinecraftConnectionException('网络错误: $e'));
          }
          subscription.cancel();
          socket?.close();
        },
        onDone: () {
          // 连接意外关闭处理
          if (!completer.isCompleted) {
            completer.completeError(
              MinecraftConnectionException(
                '连接意外关闭，接收到不完整的响应数据 (${buffer.length} 字节)',
              ),
            );
          }
        },
      );

      // ==================== 等待响应（带超时）====================
      return await completer.future.timeout(
        _responseTimeout,
        onTimeout: () {
          throw MinecraftConnectionException(
            '响应超时 (${_responseTimeout.inSeconds}秒) - 服务器无响应',
          );
        },
      );
    } catch (e) {
      // 关闭连接并重新抛出异常
      socket?.close();
      if (e is MinecraftConnectionException) {
        rethrow;
      }
      throw MinecraftConnectionException('连接失败: $e');
    }
  }

  /// 获取服务器状态
  /// 返回包含服务器信息的 Map，包括：
  /// - version: 服务器版本信息
  /// - players: 玩家信息（在线人数、最大人数）
  /// - description: 服务器描述（MOTD）
  /// - latency: 连接延迟（毫秒）
  /// - online: 是否在线
  /// - resolvedHost: 解析后的实际主机地址
  /// - resolvedPort: 解析后的实际端口
  /// - usedSrv: 是否使用了 SRV 记录
  Future<Map<String, dynamic>> getServerStatus() async {
    // 开始计时，用于测量延迟
    final stopwatch = Stopwatch()..start();
    try {
      // 获取服务器响应
      final received = await _socketConnect();
      // 停止计时
      stopwatch.stop();
      // 计算延迟（毫秒）
      final latency = stopwatch.elapsedMilliseconds;
      int offset = 0;

      // ==================== 验证数据长度 ====================
      if (received.isEmpty) {
        throw MinecraftParseException('接收到空的响应数据');
      }

      // ==================== 检查数据包 ID ====================
      final packetID = received[offset];
      if (packetID != _expectedPacketId) {
        throw MinecraftParseException(
          '意外的数据包 ID: $packetID (期望: $_expectedPacketId)',
        );
      }
      offset += 1;

      // ==================== 验证偏移量 ====================
      if (offset >= received.length) {
        throw MinecraftParseException('数据包过短: 缺少 JSON 长度信息');
      }

      // ==================== 解析 JSON 长度 ====================
      int jsonLengthLength = VarInt.getVarIntLength(received, index: offset);

      if (offset + jsonLengthLength > received.length) {
        throw MinecraftParseException('数据包过短: 无法读取完整的 JSON 长度');
      }

      int jsonLength = VarInt.decode(
        received.sublist(offset, offset + jsonLengthLength),
      );
      offset += jsonLengthLength;

      // ==================== 验证 JSON 数据完整性 ====================
      if (offset + jsonLength > received.length) {
        throw MinecraftParseException(
          '不完整的 JSON 数据: 期望 $jsonLength 字节，但只有 ${received.length - offset} 字节',
        );
      }

      // ==================== 提取并解析 JSON ====================
      final jsonData = received.sublist(offset, offset + jsonLength);
      final jsonString = utf8.decode(jsonData);

      try {
        // 解析 JSON 并添加额外信息
        final Map<String, dynamic> result =
            jsonDecode(jsonString) as Map<String, dynamic>;
        result['latency'] = latency; // 添加延迟信息
        result['online'] = true; // 标记为在线
        result['resolvedHost'] = resolvedHost; // 添加解析后的主机
        result['resolvedPort'] = resolvedPort; // 添加解析后的端口
        result['usedSrv'] = _usedSrv; // 是否使用了 SRV 记录
        return result;
      } catch (e) {
        throw MinecraftParseException('JSON 解析失败: $e\nJSON 内容: $jsonString');
      }
    } catch (e) {
      // 重新抛出已知异常
      if (e is MinecraftParseException || e is MinecraftConnectionException) {
        rethrow;
      }
      throw MinecraftParseException('获取服务器状态失败: $e');
    }
  }

  /// 获取服务器延迟（Ping）
  /// 返回延迟毫秒数，如果连接失败返回 -1
  Future<int> getPing() async {
    final stopwatch = Stopwatch()..start();
    try {
      await getServerStatus();
      stopwatch.stop();
      return stopwatch.elapsedMilliseconds;
    } catch (e) {
      return -1;
    }
  }

  /// 静态方法：仅解析 SRV 记录
  /// [domain] 域名
  /// 返回解析后的 (host, port)，如果没有 SRV 记录则返回原始值
  static Future<({String host, int port})> resolveSrvRecord(
    String domain, {
    int defaultPort = 25565,
  }) async {
    // 如果是 IP 地址，直接返回
    if (SrvResolver.isIpAddress(domain)) {
      return (host: domain, port: defaultPort);
    }

    // 尝试查询 SRV 记录
    try {
      final srvRecord = await SrvResolver.resolveMcSrv(domain);
      if (srvRecord != null) {
        return (host: srvRecord.target, port: srvRecord.port);
      }
    } catch (e) {
      // SRV 查询失败
    }

    return (host: domain, port: defaultPort);
  }
}
