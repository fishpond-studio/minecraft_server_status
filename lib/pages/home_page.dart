import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:is_mc_fk_running/data/database.dart';
import 'package:is_mc_fk_running/widget/server_info_controller.dart';

import '../widget/server_card.dart';
import '../widget/add_server_dialog.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with AutomaticKeepAliveClientMixin<Homepage> {
  final _serverListBox = Hive.box('serverListBox');
  ServerListDataBase db = ServerListDataBase(); // 引入数据

  List<ServerInfoController> get controllers =>
      List.generate(db.items.length, (_) => ServerInfoController());

  @override
  bool get wantKeepAlive => true; // 保持页面状态

  @override
  void initState() {
    if (_serverListBox.get("ITEMS") == null) {
      // 第一次打开显示欢迎页面 引导用户输入内容

      // 转到欢迎页面
    } else {
      db.loadData();
    }
    super.initState();
  }

  void _updateServerInfo() {
    for (final c in controllers) {
      c.refresh?.call();
    }
  }

  void _addItem(Map<String, String> item) {
    setState(() {
      db.items.add(item);
    });
    db.updateDataBase();
  }

  void _removeItem(int index) {
    setState(() {
      db.items.removeAt(index);
    });
    db.updateDataBase();
  }

  void _editItem(int index, Map<String, String> item) {
    setState(() {
      db.items[index] = item;
    });
    db.updateDataBase();
  }

  /// 弹出输入框
  Future<void> _showAddDialog() async {
    // 弹出对话框 等待输入
    final result = await showAddServerDialog(context);
    if (result != null) {
      _addItem({...result});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // 必须调用super.build(context)
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Servers',
          style: TextStyle(
            fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _updateServerInfo,
            icon: const Icon(Icons.cached, size: 20),
          ),
        ],
        backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.15),
      ),

      body: Container(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
        child: GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 每行两列
            crossAxisSpacing: 16, // 列间距
            mainAxisSpacing: 16, // 行间距
            childAspectRatio: 0.9, // 宽高比，根据 ServerCard 调整
          ),
          itemCount: db.items.length,
          itemBuilder: (context, index) {
            return ServerCard(
              item: db.items[index],
              onDelete: () => _removeItem(index),
              onEdit: (item) => _editItem(index, item),
              controller: controllers[index],
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.5,
        focusElevation: 2,
        hoverElevation: 2,
        onPressed: _showAddDialog,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25), // 圆角大小
        ),
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
    );
  }
}
