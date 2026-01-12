import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mc_sentinel/l10n/app_localizations.dart';
import 'package:mc_sentinel/services/minecraft_server_status.dart';
import 'package:hive/hive.dart';
import 'dart:ui';
import 'dart:async';

class ServerDetailPage extends StatefulWidget {
  final Map<String, dynamic> serverItem;

  const ServerDetailPage({super.key, required this.serverItem});

  @override
  State<ServerDetailPage> createState() => _ServerDetailPageState();
}

class _ServerDetailPageState extends State<ServerDetailPage> {
  late MinecraftServerStatus _serverService;
  Map<String, dynamic>? _currentStatus;
  bool _isLoading = true;
  Timer? _refreshTimer;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initServer();
    // 启动定期刷新 (每 60 秒一次)
    _refreshTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      _fetchStatus();
    });
  }

  void _initServer() {
    final address = widget.serverItem['address']?.toString().trim() ?? '';
    final portStr = widget.serverItem['port']?.toString().trim() ?? '25565';
    final port = int.tryParse(portStr) ?? 25565;

    _serverService = MinecraftServerStatus(host: address, port: port);
    _fetchStatus();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchStatus() async {
    try {
      final status = await _serverService.getServerStatus();
      if (mounted) {
        setState(() {
          _currentStatus = status;
          _isLoading = false;
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _currentStatus = {'online': false};
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  // 从 Hive 获取历史数据并转换为图表坐标点
  List<FlSpot> _getPlayerCountData() {
    final box = Hive.box('serverListBox');
    final historyKey =
        'history_${widget.serverItem['address']}_${widget.serverItem['port']}';
    List history = box.get(historyKey, defaultValue: []);

    if (history.isEmpty) return [];

    // 将最近 24 小时的数据点映射到 0-23 的 X 轴（简单线性映射）
    final now = DateTime.now().millisecondsSinceEpoch;
    final dayAgo = now - 24 * 60 * 60 * 1000;

    return history.where((e) => e['timestamp'] > dayAgo).map((e) {
      double x = (e['timestamp'] - dayAgo) / (24 * 60 * 60 * 1000) * 23;
      return FlSpot(x, (e['players'] as num).toDouble());
    }).toList();
  }

  // 从 Hive 获取延迟历史数据
  List<FlSpot> _getLatencyData() {
    final box = Hive.box('serverListBox');
    final historyKey =
        'history_${widget.serverItem['address']}_${widget.serverItem['port']}';
    List history = box.get(historyKey, defaultValue: []);

    if (history.isEmpty) return [];

    final now = DateTime.now().millisecondsSinceEpoch;
    final dayAgo = now - 24 * 60 * 60 * 1000;

    return history.where((e) => e['timestamp'] > dayAgo).map((e) {
      double x = (e['timestamp'] - dayAgo) / (24 * 60 * 60 * 1000) * 23;
      return FlSpot(x, (e['latency'] as num).toDouble());
    }).toList();
  }

  // 计算玩家数据的最大值，用于动态调整Y轴
  double _getMaxPlayerCount() {
    final data = _getPlayerCountData();
    if (data.isEmpty) return 10; // 默认最小值为10

    // 找出最大玩家数
    double maxPlayers = data
        .map((spot) => spot.y)
        .reduce((a, b) => a > b ? a : b);

    // 向上取整到最近的10的倍数，并添加20%的缓冲空间
    double buffer = maxPlayers * 0.2;
    double maxY = ((maxPlayers + buffer) / 10).ceil() * 10;

    // 确保最小为10
    return maxY < 10 ? 10 : maxY;
  }

  // 计算延迟数据的最大值，用于动态调整Y轴
  double _getMaxLatency() {
    final data = _getLatencyData();
    if (data.isEmpty) return 100; // 默认最小值为100ms

    // 找出最大延迟
    double maxLatency = data
        .map((spot) => spot.y)
        .reduce((a, b) => a > b ? a : b);

    // 向上取整到最近的50的倍数，并添加20%的缓冲空间
    double buffer = maxLatency * 0.2;
    double maxY = ((maxLatency + buffer) / 50).ceil() * 50;

    // 确保最小为100ms
    return maxY < 100 ? 100 : maxY;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AppBar(
              centerTitle: true,
              elevation: 0,
              backgroundColor: colorScheme.surface.withValues(alpha: 0.7),
              title: Text(
                widget.serverItem['name'] ?? l10n.serverDetails,
                style: TextStyle(
                  fontFamily: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.fontFamily,
                  fontWeight: FontWeight.w900,
                  fontSize: 26,
                  color: colorScheme.onSurface,
                ),
              ),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: colorScheme.onSurface,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.surface,
                  colorScheme.primaryContainer.withValues(alpha: 0.1),
                  colorScheme.surface,
                ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 服务器基本信息卡片
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _buildInfoCard(context, l10n),
                  const SizedBox(height: 24),

                  // 玩家人数折线图
                  _buildChartCard(
                    context,
                    title: l10n.playerCount,
                    subtitle: l10n.last24Hours,
                    data: _getPlayerCountData(),
                    color: Colors.blue,
                    unit: l10n.players,
                    maxY: _getMaxPlayerCount(), // 动态调整Y轴最大值
                  ),
                  const SizedBox(height: 24),
                  // 延迟折线图
                  _buildChartCard(
                    context,
                    title: l10n.pingLatency,
                    subtitle: l10n.last24Hours,
                    data: _getLatencyData(),
                    color: Colors.green,
                    unit: l10n.ms,
                    maxY: _getMaxLatency(), // 动态调整Y轴最大值
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
            Theme.of(context).colorScheme.surface.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //服务器详情
          Text(
            l10n.serverDetails,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          //服务器名称
          const SizedBox(height: 8),
          _buildInfoRow(
            context,
            l10n.nameLabel,
            widget.serverItem['name']?.toString() ?? 'N/A',
          ),
          //服务器版本
          const SizedBox(height: 8),
          _buildInfoRow(
            context,
            l10n.version,
            _currentStatus?['version']?['name']?.toString() ?? 'N/A',
          ),
          //服务器地址
          const SizedBox(height: 8),
          _buildInfoRow(
            context,
            l10n.addressLabel,
            widget.serverItem['address']?.toString() ?? 'N/A',
          ),
          //服务器端口
          const SizedBox(height: 8),
          _buildInfoRow(
            context,
            l10n.portLabel,
            widget.serverItem['port']?.toString() ?? 'N/A',
          ),
          //服务器状态
          const SizedBox(height: 8),
          _buildInfoRow(
            context,
            'Status',
            _currentStatus?['online'] != false ? 'Online' : 'Offline',
            valueColor: _currentStatus?['online'] != false
                ? Colors.green
                : Colors.red,
          ),
          if (_currentStatus?['online'] != false &&
              _currentStatus?['latency'] != null) ...[
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              l10n.pingLatency,
              '${_currentStatus!['latency']} ms',
              valueColor: _currentStatus!['latency'] < 100
                  ? Colors.green
                  : (_currentStatus!['latency'] < 200
                        ? Colors.orange
                        : Colors.red),
            ),
          ],
          if (_errorMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: TextStyle(
                fontSize: 12,
                color: Colors.red.withValues(alpha: 0.7),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: valueColor ?? Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildChartCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required List<FlSpot> data,
    required Color color,
    required String unit,
    required double maxY,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
            Theme.of(context).colorScheme.surface.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY / 4,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: 0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 6,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            '${value.toInt()}h',
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.5),
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: maxY / 4,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}$unit',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.5),
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 23,
                minY: 0,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: data,
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [
                        color.withValues(alpha: 0.8),
                        color.withValues(alpha: 0.5),
                      ],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          color.withValues(alpha: 0.3),
                          color.withValues(alpha: 0.05),
                        ],
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) =>
                        Theme.of(context).colorScheme.surface,
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        return LineTooltipItem(
                          '${touchedSpot.y.toStringAsFixed(1)} $unit',
                          TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      }).toList();
                    },
                  ),
                  handleBuiltInTouches: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
