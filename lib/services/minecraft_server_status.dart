import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:is_mc_fk_running/services/var_int.dart';

/// 自定义异常：Minecraft 服务器连接异常
class MinecraftConnectionException implements Exception {
  final String message;
  MinecraftConnectionException(this.message);

  @override
  String toString() => 'MinecraftConnectionException: $message';
}

/// 自定义异常：数据解析异常
class MinecraftParseException implements Exception {
  final String message;
  MinecraftParseException(this.message);

  @override
  String toString() => 'MinecraftParseException: $message';
}

class MinecraftServerStatus {
  // 协议常量
  static const int _packetID = 0x00;
  static const int _nextState = 1;
  static const int _expectedPacketId = 0;
  static const int _defaultProtocolVersion = -1;

  // 超时设置
  static const Duration _connectionTimeout = Duration(seconds: 5);
  static const Duration _responseTimeout = Duration(seconds: 10);
  final String host;
  final int port;

  MinecraftServerStatus({required this.host, this.port = 25565}) {
    if (host.isEmpty) {
      throw ArgumentError.value(host, 'host', 'host cannot be empty.');
    }
    if (host.codeUnits.length > 255) {
      throw ArgumentError.value(host, 'host', 'host is too long.');
    }
    if (port < 1 || port > 65535) {
      throw ArgumentError.value(port, 'port', 'port must between 1 to 65535');
    }
  }

  List<int> _getHostBytes(String host) {
    final hostBytes = ascii.encode(host);
    return [...VarInt.encode(hostBytes.length), ...hostBytes];
  }

  List<int> _getPortBytes(int port) => [(port >> 8) & 0xFF, port & 0xFF];

  List<int> _getHandshakePacket({
    int protocolVersion = _defaultProtocolVersion,
  }) => [
    _packetID,
    ...VarInt.encode(protocolVersion),
    ..._getHostBytes(host),
    ..._getPortBytes(port),
    _nextState,
  ];

  Future<List<int>> _socketConnect() async {
    Socket? socket;
    try {
      // 建立连接（带超时控制）
      socket = await Socket.connect(host, port).timeout(
        _connectionTimeout,
        onTimeout: () {
          throw MinecraftConnectionException(
            'Connection timeout (${_connectionTimeout.inSeconds}s) - Unable to connect to $host:$port',
          );
        },
      );

      // 发送 handshake 包
      final handshakePacket = _getHandshakePacket();
      socket.add(
        Uint8List.fromList([
          ...VarInt.encode(handshakePacket.length),
          ...handshakePacket,
        ]),
      );

      // 发送状态请求
      socket.add(
        Uint8List.fromList([
          0x01, // 状态请求数据包长度
          _packetID,
        ]),
      );

      // 接收响应（带超时控制）
      final completer = Completer<List<int>>();
      final buffer = <int>[];
      late StreamSubscription<Uint8List> subscription;

      subscription = socket.listen(
        (Uint8List data) {
          buffer.addAll(data);

          // 检查是否接收到完整数据包
          if (buffer.isNotEmpty) {
            try {
              int offset = 0;
              int packetLengthLength = VarInt.getVarIntLength(
                buffer,
                index: offset,
              );

              // 检查是否接收到完整的长度数据
              if (buffer.length >= offset + packetLengthLength) {
                int packetLength = VarInt.decode(
                  buffer.sublist(offset, offset + packetLengthLength),
                );

                // 检查是否接收到完整的数据包
                if (buffer.length >=
                    offset + packetLengthLength + packetLength) {
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
              if (!completer.isCompleted) {
                completer.completeError(
                  MinecraftParseException('Failed to parse packet length: $e'),
                );
              }
              subscription.cancel();
              socket?.close();
            }
          }
        },
        onError: (e) {
          if (!completer.isCompleted) {
            completer.completeError(
              MinecraftConnectionException('Network error: $e'),
            );
          }
          subscription.cancel();
          socket?.close();
        },
        onDone: () {
          if (!completer.isCompleted) {
            completer.completeError(
              MinecraftConnectionException(
                'Connection closed unexpectedly, incomplete response data received (${buffer.length} bytes)',
              ),
            );
          }
        },
      );

      // 等待响应（带超时）
      return await completer.future.timeout(
        _responseTimeout,
        onTimeout: () {
          throw MinecraftConnectionException(
            'Response timeout (${_responseTimeout.inSeconds}s) - Server not responding',
          );
        },
      );
    } catch (e) {
      socket?.close();
      if (e is MinecraftConnectionException) {
        rethrow;
      }
      throw MinecraftConnectionException('Connection failed: $e');
    }
  }

  Future<Map<String, dynamic>> getServerStatus() async {
    try {
      final received = await _socketConnect();
      int offset = 0;

      // 验证数据长度
      if (received.isEmpty) {
        throw MinecraftParseException('Received empty response data');
      }

      // 检查数据包 ID
      final packetID = received[offset];
      if (packetID != _expectedPacketId) {
        throw MinecraftParseException(
          'Unexpected packet ID: $packetID (expected: $_expectedPacketId)',
        );
      }
      offset += 1;

      // 验证偏移量
      if (offset >= received.length) {
        throw MinecraftParseException(
          'Packet too short: missing JSON length information',
        );
      }

      // 解析 JSON 长度
      int jsonLengthLength = VarInt.getVarIntLength(received, index: offset);

      if (offset + jsonLengthLength > received.length) {
        throw MinecraftParseException(
          'Packet too short: unable to read complete JSON length',
        );
      }

      int jsonLength = VarInt.decode(
        received.sublist(offset, offset + jsonLengthLength),
      );
      offset += jsonLengthLength;

      // 验证 JSON 数据完整性
      if (offset + jsonLength > received.length) {
        throw MinecraftParseException(
          'Incomplete JSON data: expected $jsonLength bytes, but only ${received.length - offset} bytes',
        );
      }

      // 提取并解析 JSON
      final jsonData = received.sublist(offset, offset + jsonLength);
      final jsonString = utf8.decode(jsonData);

      try {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      } catch (e) {
        throw MinecraftParseException(
          'JSON parsing failed: $e\nJSON content: $jsonString',
        );
      }
    } catch (e) {
      if (e is MinecraftParseException || e is MinecraftConnectionException) {
        rethrow;
      }
      throw MinecraftParseException('Failed to get server status: $e');
    }
  }
}
