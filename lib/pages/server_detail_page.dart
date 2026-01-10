import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:is_mc_fk_running/l10n/app_localizations.dart';

class ServerDetailPage extends StatefulWidget {
  final Map<String, dynamic> serverItem;

  const ServerDetailPage({super.key, required this.serverItem});

  @override
  State<ServerDetailPage> createState() => _ServerDetailPageState();
}

class _ServerDetailPageState extends State<ServerDetailPage> {
  // TODO: 玩家人数数据 - 请接入真实数据源
  // 数据格式: List<FlSpot>，其中 FlSpot(x, y)
  //   - x: 时间点（0-23 表示24小时）
  //   - y: 玩家数量
  // 示例: [FlSpot(0, 10), FlSpot(1, 15), FlSpot(2, 12), ...]
  // 可以从数据库、API或本地存储获取历史数据
  List<FlSpot> _getPlayerCountData() {
    // 返回空数据，等待接入真实数据
    return [];

    // 接入真实数据示例（取消注释并修改）:
    // return widget.serverItem['playerHistory']
    //     ?.asMap()
    //     .entries
    //     .map((entry) => FlSpot(entry.key.toDouble(), entry.value.toDouble()))
    //     .toList() ?? [];
  }

  // TODO: 延迟数据 - 请接入真实数据源
  // 数据格式: List<FlSpot>，其中 FlSpot(x, y)
  //   - x: 时间点（0-23 表示24小时）
  //   - y: 延迟时间（毫秒）
  // 示例: [FlSpot(0, 15), FlSpot(1, 18), FlSpot(2, 12), ...]
  // 可以定期ping服务器并记录响应时间
  List<FlSpot> _getLatencyData() {
    // 返回空数据，等待接入真实数据
    return [];

    // 接入真实数据示例（取消注释并修改）:
    // return widget.serverItem['latencyHistory']
    //     ?.asMap()
    //     .entries
    //     .map((entry) => FlSpot(entry.key.toDouble(), entry.value.toDouble()))
    //     .toList() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          widget.serverItem['name'] ?? l10n.serverDetails,
          style: TextStyle(
            fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(
                context,
              ).colorScheme.primaryContainer.withValues(alpha: 0.3),
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 服务器基本信息卡片
                _buildInfoCard(context, l10n),
                const SizedBox(height: 24),

                // 玩家人数折线图
                _buildChartCard(
                  context,
                  title: l10n.playerCount,
                  subtitle: l10n.last24Hours,
                  data: _getPlayerCountData(),
                  color: Colors.blue,
                  unit: l10n.players,
                  maxY: 70,
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
                  maxY: 100,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
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
            widget.serverItem['name'] ?? 'N/A',
          ),
          //服务器版本
          const SizedBox(height: 8),
          _buildInfoRow(
            context,
            l10n.version,
            widget.serverItem['version'] ?? 'N/A',
          ),
          //服务器地址
          const SizedBox(height: 8),
          _buildInfoRow(
            context,
            l10n.addressLabel,
            widget.serverItem['address'] ?? 'N/A',
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
            widget.serverItem['running'] == true ? 'Online' : 'Offline',
            valueColor: widget.serverItem['running'] == true
                ? Colors.green
                : Colors.red,
          ),
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
