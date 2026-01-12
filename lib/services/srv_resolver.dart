import 'dart:io';

/// SRV 记录解析结果
/// 包含解析后的目标主机和端口
class SrvRecord {
  /// 目标主机地址
  final String target;

  /// 端口号
  final int port;

  /// 优先级（数值越小优先级越高）
  final int priority;

  /// 权重（用于负载均衡）
  final int weight;

  SrvRecord({
    required this.target,
    required this.port,
    this.priority = 0,
    this.weight = 0,
  });

  @override
  String toString() =>
      'SrvRecord(target: $target, port: $port, priority: $priority, weight: $weight)';
}

/// SRV 记录解析器
/// 用于解析 Minecraft 服务器的 SRV 记录
class SrvResolver {
  /// Minecraft SRV 记录前缀
  static const String _minecraftSrvPrefix = '_minecraft._tcp.';

  /// DNS 查询超时时间
  static const Duration _dnsTimeout = Duration(seconds: 5);

  /// 解析 Minecraft 服务器的 SRV 记录
  /// [domain] 域名（如 play.example.com）
  /// 返回 SrvRecord，如果没有 SRV 记录则返回 null
  static Future<SrvRecord?> resolveMcSrv(String domain) async {
    // 构建完整的 SRV 查询域名
    final srvDomain = '$_minecraftSrvPrefix$domain';

    try {
      // 使用 nslookup/dig 命令查询 SRV 记录
      // 由于 Dart 的 InternetAddress.lookup 不支持 SRV 记录，
      // 我们使用命令行工具来查询
      final result = await _querySrvRecord(srvDomain);
      return result;
    } catch (e) {
      // SRV 查询失败，返回 null
      return null;
    }
  }

  /// 使用系统命令查询 SRV 记录
  /// [srvDomain] 完整的 SRV 查询域名
  static Future<SrvRecord?> _querySrvRecord(String srvDomain) async {
    try {
      ProcessResult result;

      if (Platform.isWindows) {
        // Windows: 使用 nslookup 命令
        result = await Process.run('nslookup', [
          '-type=SRV',
          srvDomain,
        ], runInShell: true).timeout(_dnsTimeout);

        return _parseNslookupOutput(result.stdout.toString());
      } else {
        // Linux/macOS: 使用 dig 命令
        result = await Process.run('dig', [
          '+short',
          'SRV',
          srvDomain,
        ], runInShell: true).timeout(_dnsTimeout);

        return _parseDigOutput(result.stdout.toString());
      }
    } catch (e) {
      // 命令执行失败
      return null;
    }
  }

  /// 解析 nslookup 命令的输出（Windows）
  /// 输出格式示例：
  /// ```
  /// _minecraft._tcp.example.com    SRV service location:
  ///         priority       = 0
  ///         weight         = 5
  ///         port           = 25565
  ///         svr hostname   = mc.example.com
  /// ```
  static SrvRecord? _parseNslookupOutput(String output) {
    try {
      // 匹配端口
      final portMatch = RegExp(
        r'port\s*=\s*(\d+)',
        caseSensitive: false,
      ).firstMatch(output);
      // 匹配目标主机
      final hostMatch = RegExp(
        r'svr hostname\s*=\s*([^\s\r\n]+)',
        caseSensitive: false,
      ).firstMatch(output);
      // 匹配优先级
      final priorityMatch = RegExp(
        r'priority\s*=\s*(\d+)',
        caseSensitive: false,
      ).firstMatch(output);
      // 匹配权重
      final weightMatch = RegExp(
        r'weight\s*=\s*(\d+)',
        caseSensitive: false,
      ).firstMatch(output);

      if (portMatch != null && hostMatch != null) {
        final port = int.parse(portMatch.group(1)!);
        String target = hostMatch.group(1)!;
        // 移除末尾的点（如果有）
        if (target.endsWith('.')) {
          target = target.substring(0, target.length - 1);
        }

        return SrvRecord(
          target: target,
          port: port,
          priority: priorityMatch != null
              ? int.parse(priorityMatch.group(1)!)
              : 0,
          weight: weightMatch != null ? int.parse(weightMatch.group(1)!) : 0,
        );
      }
    } catch (e) {
      // 解析失败
    }
    return null;
  }

  /// 解析 dig 命令的输出（Linux/macOS）
  /// 输出格式示例：
  /// ```
  /// 0 5 25565 mc.example.com.
  /// ```
  /// 格式：priority weight port target
  static SrvRecord? _parseDigOutput(String output) {
    try {
      final lines = output.trim().split('\n');
      for (final line in lines) {
        final parts = line.trim().split(RegExp(r'\s+'));
        if (parts.length >= 4) {
          final priority = int.tryParse(parts[0]) ?? 0;
          final weight = int.tryParse(parts[1]) ?? 0;
          final port = int.tryParse(parts[2]);
          String target = parts[3];

          if (port != null && target.isNotEmpty) {
            // 移除末尾的点（如果有）
            if (target.endsWith('.')) {
              target = target.substring(0, target.length - 1);
            }

            return SrvRecord(
              target: target,
              port: port,
              priority: priority,
              weight: weight,
            );
          }
        }
      }
    } catch (e) {
      // 解析失败
    }
    return null;
  }

  /// 检查地址是否为 IP 地址
  /// [address] 要检查的地址
  /// 返回 true 如果是 IP 地址
  static bool isIpAddress(String address) {
    // 匹配 IPv4 地址
    final ipv4Pattern = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');
    // 匹配 IPv6 地址
    final ipv6Pattern = RegExp(r'^([0-9a-fA-F]{0,4}:){2,7}[0-9a-fA-F]{0,4}$');

    return ipv4Pattern.hasMatch(address) || ipv6Pattern.hasMatch(address);
  }
}
