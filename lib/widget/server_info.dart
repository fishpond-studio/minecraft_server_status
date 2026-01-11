import 'package:flutter/material.dart';
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

    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Version and Latency Bar
          Row(
            children: [
              _buildCompactBadge(
                context,
                Icons.bolt_rounded, //在这里写延迟！！！！
                info != null && info!.containsKey('latency')
                    ? '${info?['latency']}ms'
                    : '--',
                colorScheme.primary,
              ),
              const SizedBox(width: 8),
              _buildCompactBadge(
                context, //在这里写版本！！！
                Icons.terminal_rounded,
                info?['version']?['name']?.toString().split(' ').last ?? '--',
                colorScheme.secondary,
              ),
            ],
          ),
          const Spacer(), //这里是中间那一大块空白
          // World Name
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              info?['description'] ??
                  (info?['online'] == false
                      ? 'Server Offline'
                      : l10n.notAvailable),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontFamily: 'FMinecraft',
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 12),
          // Player Bar
          _buildPlayerBar(context),
        ],
      ),
    );
  }

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
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
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

  Widget _buildPlayerBar(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    int online = 0;
    int max = 0;
    if (info != null && info?['players'] != null) {
      final players = info?['players'];
      if (players is Map) {
        online = players['online'] ?? 0;
        max = players['max'] ?? 20;
      }
    }
    if (max == 0) max = 20;
    double progress = online / max;
    if (progress > 1.0) progress = 1.0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.players,
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
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
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: theme.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.5),
            valueColor: AlwaysStoppedAnimation<Color>(
              progress > 0.8
                  ? Colors.orange
                  : (info?['online'] == false
                        ? Colors.grey
                        : Colors.greenAccent),
            ),
          ),
        ),
      ],
    );
  }
}
