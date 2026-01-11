import 'dart:math';
import 'package:hive/hive.dart';

/// 测试数据生成器
/// 用于快速生成折线图测试数据，无需等待自动收集
class TestDataGenerator {
  /// 为指定服务器生成 24 小时的测试数据
  /// [address] 服务器地址
  /// [port] 服务器端口
  /// [playerPattern] 玩家数量模式：'random', 'peak', 'stable'
  static void generateTestData({
    required String address,
    required int port,
    String playerPattern = 'peak',
  }) {
    final box = Hive.box('serverListBox');
    final historyKey = 'history_${address}_$port';
    final now = DateTime.now();
    final random = Random();

    List<Map<String, dynamic>> testData = [];

    // 生成过去 24 小时的数据（每 10 分钟一个数据点，共 144 个点）
    for (int i = 0; i < 144; i++) {
      final timestamp = now.millisecondsSinceEpoch - (144 - i) * 10 * 60 * 1000;
      final hour = DateTime.fromMillisecondsSinceEpoch(timestamp).hour;

      int players;
      switch (playerPattern) {
        case 'random':
          // 随机模式：完全随机的玩家数
          players = random.nextInt(50);
          break;
        case 'peak':
          // 高峰模式：模拟真实服务器的使用情况
          // 凌晨人少，下午和晚上人多
          if (hour >= 0 && hour < 6) {
            players = 2 + random.nextInt(8); // 2-10人
          } else if (hour >= 6 && hour < 12) {
            players = 10 + random.nextInt(20); // 10-30人
          } else if (hour >= 12 && hour < 18) {
            players = 35 + random.nextInt(25); // 35-60人
          } else if (hour >= 18 && hour < 22) {
            players = 40 + random.nextInt(30); // 40-70人
          } else {
            players = 15 + random.nextInt(20); // 15-35人
          }
          break;
        case 'stable':
          // 稳定模式：保持相对稳定的玩家数
          players = 30 + random.nextInt(10); // 30-40人
          break;
        default:
          players = 0;
      }

      // 延迟在 5-100ms 之间，偶尔会有较高的延迟
      final latency =
          10 +
          random.nextInt(30) +
          (random.nextBool() ? random.nextInt(50) : 0);

      testData.add({
        'timestamp': timestamp,
        'players': players,
        'latency': latency,
      });
    }

    box.put(historyKey, testData);
    print('✅ 已为服务器 $address:$port 生成 ${testData.length} 个测试数据点');
    print('📊 数据模式: $playerPattern');
  }

  /// 清除所有测试数据
  static void clearAllTestData() {
    final box = Hive.box('serverListBox');
    final keys = box.keys
        .where((key) => key.toString().startsWith('history_'))
        .toList();

    for (var key in keys) {
      box.delete(key);
    }

    print('🗑️ 已清除所有历史数据');
  }

  /// 为所有服务器生成测试数据
  static void generateForAllServers(List<Map<String, String>> servers) {
    for (var server in servers) {
      final address = server['address'];
      final port = int.tryParse(server['port'] ?? '25565');

      if (address != null && port != null) {
        generateTestData(
          address: address,
          port: port,
          playerPattern: 'peak', // 使用高峰模式
        );
      }
    }
  }
}
