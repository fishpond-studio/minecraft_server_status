import 'package:hive_flutter/hive_flutter.dart';

class ServerListDataBase {
  final List<Map<String, String>> items = [];

  final _serverListBox = Hive.box('serverListBox');

  void loadData() {
    final data = _serverListBox.get("ITEMS", defaultValue: []);
    items
      ..clear()
      ..addAll(
        (data as List).map((e) => Map<String, String>.from(e as Map)).toList(),
      );
  }

  void updateDataBase() {
    _serverListBox.put("ITEMS", items);
  }
}
