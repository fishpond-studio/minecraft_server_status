import 'package:hive_flutter/hive_flutter.dart';

class ServerListDataBase {
  final List<Map<String, String>> items = [];

  final _serverListBox = Hive.box('serverListBox');

  void loadData() {
    try {
      final data = _serverListBox.get("ITEMS", defaultValue: []);
      print('📦 从 Hive 加载数据，原始数据长度: ${(data as List).length}');

      items
        ..clear()
        ..addAll(
          data
              .map((e) {
                try {
                  final map = e as Map;
                  // 只保留服务器相关的字段，并确保所有值都是字符串
                  final item = {
                    'name': map['name']?.toString() ?? '',
                    'address': map['address']?.toString() ?? '',
                    'port': map['port']?.toString() ?? '25565',
                  };

                  // 检查是否为有效的服务器项
                  if (item['address']?.isEmpty ?? true) {
                    print('⚠️ 跳过无效服务器项（address为空）: $item');
                    return null;
                  }

                  return item;
                } catch (e) {
                  print('❌ 处理服务器项时出错: $e');
                  return null;
                }
              })
              .whereType<Map<String, String>>()
              .toList(),
        );

      print('✅ 成功加载 ${items.length} 个服务器');
    } catch (e) {
      print('❌ 加载数据时出错: $e');
    }
  }

  void updateDataBase() {
    _serverListBox.put("ITEMS", items);
  }
}
