import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mc_sentinel/l10n/app_localizations.dart';
import 'package:mc_sentinel/services/minecraft_server_status.dart';

/// 服务器信息组件
/// 显示服务器的延迟、版本、描述和玩家人数等信息
class ServerInfo extends StatefulWidget {
  /// 服务器地址
  final String host;

  /// 服务器端口
  final String port;

  const ServerInfo({super.key, required this.host, required this.port});

  @override
  State<ServerInfo> createState() => ServerInfoState();
}

/// 服务器信息组件状态
class ServerInfoState extends State<ServerInfo> {
  /// Minecraft 服务器状态查询服务
  late MinecraftServerStatus server;

  /// 服务器信息数据
  Map? info;

  /// 最后更新时间
  DateTime? lastUpdated;

  /// 定时刷新定时器
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _initServer();
    // 启动定期刷新（每 60 秒一次）
    _refreshTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      loadServerInfo();
    });
  }

  /// 初始化服务器连接
  void _initServer() {
    final host = widget.host.trim();
    final port = int.tryParse(widget.port.trim()) ?? 25565;

    server = MinecraftServerStatus(host: host, port: port);
    loadServerInfo();
  }

  @override
  void dispose() {
    // 取消定时器
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ServerInfo oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 如果服务器地址或端口发生变化，重新初始化
    if (oldWidget.host != widget.host || oldWidget.port != widget.port) {
      _initServer();
    }
  }

  /// 加载服务器信息
  Future<void> loadServerInfo() async {
    try {
      final data = await server.getServerStatus();
      if (!mounted) return;
      setState(() {
        info = data;
        lastUpdated = DateTime.now();
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => info = {'online': false, 'error': e.toString()});
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // ==================== 主容器 ====================
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // ==================== 版本和延迟信息栏 ====================
          Row(
            children: [
              // 延迟徽章
              _buildCompactBadge(
                context,
                Icons.bolt_rounded, // 闪电图标表示延迟
                info != null && info!.containsKey('latency')
                    ? '${info?['latency']}ms'
                    : '--',
                colorScheme.primary,
              ),
              const SizedBox(width: 8),
              // 版本徽章
              _buildCompactBadge(
                context,
                Icons.terminal_rounded, // 终端图标表示版本
                info?['version']?['name']?.toString().split(' ').last ?? '--',
                colorScheme.secondary,
              ),
            ],
          ),
          // ==================== 中间空白区域 ====================
          const Spacer(),
          // ==================== 服务器描述文字 ====================
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              info?['description'] ??
                  (info?['online'] == false
                      ? 'Server Offline'
                      : l10n.notAvailable),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontFamily: 'FMinecraft', // Minecraft 风格字体
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 12),
          // ==================== 玩家人数进度条 ====================
          _buildPlayerBar(context),
        ],
      ),
    );
  }

  /// 构建紧凑型徽章组件
  /// [context] 上下文
  /// [icon] 图标
  /// [text] 显示文字
  /// [color] 主题颜色
  Widget _buildCompactBadge(
    BuildContext context,
    IconData icon,
    String text,
    Color color,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer, // 背景颜色
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)), // 边框颜色
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 图标
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          // 文字
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建玩家人数进度条
  /// [context] 上下文
  Widget _buildPlayerBar(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 获取在线人数和最大人数
    int online = 0;
    int max = 0;
    if (info != null && info?['players'] != null) {
      final players = info?['players'];
      if (players is Map) {
        online = players['online'] ?? 0;
        max = players['max'] ?? 20;
      }
    }
    // 确保最大人数不为0，避免除以0
    if (max == 0) max = 20;
    // 计算进度比例
    double progress = online / max;
    if (progress > 1.0) progress = 1.0;

    return Column(
      children: [
        // ==================== 玩家人数标签行 ====================
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // "玩家" 标签
            Text(
              l10n.players,
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            // "在线/最大" 数值
            Text(
              '$online / $max',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        // ==================== 进度条 ====================
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: theme.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.5), // 背景颜色
            valueColor: AlwaysStoppedAnimation<Color>(
              // 根据人数比例和在线状态设置颜色
              progress > 0.8
                  ? Colors
                        .orange // 人数超过80%显示橙色
                  : (info?['online'] == false
                        ? Colors
                              .grey // 离线显示灰色
                        : Colors.greenAccent), // 正常显示绿色
            ),
          ),
        ),
      ],
    );
  }
}
