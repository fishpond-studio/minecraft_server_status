import 'package:flutter/material.dart';
import 'package:is_mc_fk_running/l10n/app_localizations.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:is_mc_fk_running/data/database.dart';

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

  // 更新日期方法

  void _addItem(Map<String, dynamic> item) {
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

  void _updateItem(int index, Map<String, dynamic> newItem) {
    setState(() {
      db.items[index] = newItem;
    });
    db.updateDataBase();
  }

  /// 弹出输入框
  Future<void> _showAddDialog() async {
    // 弹出对话框 等待输入
    final result = await showAddServerDialog(context);
    if (result != null) {
      _addItem({...result, 'running': false});
    }
  }

  /// 弹出编辑框
  Future<void> _showEditDialog(int index, Map<String, dynamic> item) async {
    final result = await showAddServerDialog(context, initialValue: item);
    if (result != null) {
      if (result['delete'] == true) {
        _removeItem(index);
      } else {
        _updateItem(index, {...item, ...result});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // 必须调用super.build(context)
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      extendBodyBehindAppBar: true, // Allow body to extend behind AppBar
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          l10n.servers,
          style: TextStyle(
            fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        actions: [
          // IconButton(onPressed: null, icon: const Icon(Icons.cached, size: 20)),
        ],
        backgroundColor: Colors.transparent, // Transparent to show gradient
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: SafeArea( // Use SafeArea to avoid overlap with system UI
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 每行两列
            crossAxisSpacing: 16, // 列间距
            mainAxisSpacing: 16, // 行间距
            childAspectRatio: 0.75, // 宽高比，根据 ServerCard 调整
          ),
          itemCount: db.items.length,
          itemBuilder: (context, index) {
            return ServerCard(
              item: db.items[index],
              onEdit: () => _showEditDialog(index, db.items[index]),
            );
          },
        ),
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
