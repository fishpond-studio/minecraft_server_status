import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:is_mc_fk_running/l10n/app_localizations.dart';
import 'package:is_mc_fk_running/services/minecraft_server_status.dart';

class ServerInfo extends StatefulWidget {
  final String host;
  final String port;

  const ServerInfo({super.key, required this.host, required this.port});

  @override
  State<ServerInfo> createState() => ServerInfoState();
}

class ServerInfoState extends State<ServerInfo> {
  late MinecraftServerStatus server;
  Map? info;
  DateTime? lastUpdated;

  @override
  void initState() {
    super.initState();
    _initServer();
  }

  void _initServer() {
    server = MinecraftServerStatus(
      host: widget.host,
      port: int.parse(widget.port),
    );
    loadServerInfo();
  }

  @override
  void didUpdateWidget(covariant ServerInfo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.host != widget.host || oldWidget.port != widget.port) {
      _initServer();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> loadServerInfo() async {
    try {
      info = await server.getServerStatus();
      lastUpdated = DateTime.now();
    } catch (e) {
      if (!mounted) return;
      setState(() => info = {'online': false, 'error': e.toString()});
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      color: theme.colorScheme.surface.withValues(alpha: 0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 头部：图标 + 地址
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.dns,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${widget.host}:${widget.port}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(
              height: 1,
              thickness: 1,
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),

          //版本、世界名称、延迟、最后更新时间
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoRow(
                  context,
                  Icons.info_outline,
                  l10n.version,
                  info?['version']?['name'] ?? l10n.notAvailable,
                ),
                _buildInfoRow(
                  context,
                  Icons.map_outlined,
                  l10n.worldName,
                  info?['description'] ?? l10n.notAvailable,
                ),
                _buildInfoRow(
                  context,
                  Icons.timer_outlined,
                  l10n.latency,
                  info != null && info!.containsKey('latency')
                      ? '${info?['latency']} ms'
                      : l10n.notAvailable,
                ),
                _buildInfoRow(
                  context,
                  Icons.access_time,
                  l10n.lastUpdated,
                  lastUpdated != null
                      ? DateFormat('HH:mm:ss').format(lastUpdated!)
                      : l10n.notAvailable,
                ),

                // 玩家信息
                Builder(
                  builder: (context) {
                    int online = 0;
                    int max = 0;
                    if (info != null && info?['players'] != null) {
                      final players = info?['players'];
                      if (players is Map) {
                        online = players['online'] ?? 0;
                        max = players['max'] ?? 8;
                      }
                    }
                    if (max == 0) max = 8;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 玩家数量
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.people_outline,
                                  size: 16,
                                  color: theme.colorScheme.secondary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.onlinePlayers,
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                            Text(
                              '$online / $max',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: online / max,
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(3),
                          backgroundColor:
                              theme.colorScheme.surfaceContainerHighest,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            online / max > 0.9 ? Colors.red : Colors.green,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.secondary),
        const SizedBox(width: 8),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 标签文本
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
