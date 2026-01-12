import 'dart:async';
import 'package:hive/hive.dart';
import 'package:mc_sentinel/services/minecraft_server_status.dart';

/// 数据收集服务
/// 负责定期收集服务器状态并保存到 Hive 数据库
class DataCollectorService {
  static final DataCollectorService _instance =
      DataCollectorService._internal();
  factory DataCollectorService() => _instance;
  DataCollectorService._internal();

  final Map<String, Timer> _serverTimers = {};

  /// 开始收集指定服务器的数据
  /// [address] 服务器地址
  /// [port] 服务器端口
  /// [intervalMinutes] 收集间隔（分钟），默认5分钟
  void startCollecting({
    required String address,
    required int port,
    int intervalMinutes = 5,
  }) {
    final serverKey = '${address}_$port';

    // 如果已经在收集，先停止
    stopCollecting(address, port);

    // 立即收集一次
    _collectData(address, port);

    // 设置定时器
    _serverTimers[serverKey] = Timer.periodic(
      Duration(minutes: intervalMinutes),
      (timer) => _collectData(address, port),
    );
  }

  /// 停止收集指定服务器的数据
  void stopCollecting(String address, int port) {
    final serverKey = '${address}_$port';
    _serverTimers[serverKey]?.cancel();
    _serverTimers.remove(serverKey);
  }

  /// 停止所有数据收集
  void stopAll() {
    for (var timer in _serverTimers.values) {
      timer.cancel();
    }
    _serverTimers.clear();
  }

  /// 收集单个服务器的数据
  Future<void> _collectData(String address, int port) async {
    try {
      final service = MinecraftServerStatus(host: address, port: port);
      final status = await service.getServerStatus();

      if (status['online'] == false) {
        // 服务器离线，也记录一下（0人在线，0延迟）
        _saveToHistory(address, port, {
          'players': {'online': 0},
          'latency': 0,
        });
      } else {
        _saveToHistory(address, port, status);
      }
    } catch (e) {
      // 收集失败，记录为离线
      _saveToHistory(address, port, {
        'players': {'online': 0},
        'latency': 0,
      });
    }
  }

  /// 将数据保存到 Hive
  void _saveToHistory(String address, int port, Map<String, dynamic> status) {
    try {
      final box = Hive.box('serverListBox');
      final historyKey = 'history_${address}_$port';

      List history = box.get(historyKey, defaultValue: []);
      final now = DateTime.now();

      // 记录玩家人数和延迟
      history.add({
        'timestamp': now.millisecondsSinceEpoch,
        'players': status['players']?['online'] ?? 0,
        'latency': status['latency'] ?? 0,
      });

      // 只保留最近 24 小时的数据
      final dayAgo = now.millisecondsSinceEpoch - 24 * 60 * 60 * 1000;
      history = history.where((e) => e['timestamp'] > dayAgo).toList();

      // 如果数据点太多（超过 2000 个），做额外清理
      if (history.length > 2000) {
        history.removeRange(0, history.length - 2000);
      }

      box.put(historyKey, history);
    } catch (e) {
      print('保存历史数据失败: $e');
    }
  }

  /// 为所有服务器启动数据收集
  void startCollectingForAllServers(List<Map<String, String>> servers) {
    for (var server in servers) {
      final address = server['address'];
      final port = int.tryParse(server['port'] ?? '25565');

      if (address != null && port != null) {
        startCollecting(address: address, port: port);
      }
    }
  }

  /// 获取指定服务器的历史数据数量
  int getHistoryCount(String address, int port) {
    try {
      final box = Hive.box('serverListBox');
      final historyKey = 'history_${address}_$port';
      List history = box.get(historyKey, defaultValue: []);
      return history.length;
    } catch (e) {
      return 0;
    }
  }

  /// 清除指定服务器的历史数据
  void clearHistory(String address, int port) {
    try {
      final box = Hive.box('serverListBox');
      final historyKey = 'history_${address}_$port';
      box.delete(historyKey);
    } catch (e) {
      print('清除历史数据失败: $e');
    }
  }
}
