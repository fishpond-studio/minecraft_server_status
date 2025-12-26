import 'package:flutter/material.dart';

import '../widget/server_card.dart';
import '../widget/add_server_dialog.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final List<Map<String, dynamic>> items = []; // 存储数据
  late DateTime date; // 日期变量

  @override
  void initState() {
    super.initState();
    _updateDate(); // 初始化日期
  }

  // 更新日期方法
  void _updateDate() {
    setState(() {
      date = DateTime.now(); // 获取当前日期时间
    });
  }

  void _addItem(Map<String, dynamic> item) {
    setState(() {
      items.add(item);
    });
  }

  void _removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Severs'),
        flexibleSpace: Container(
          alignment: Alignment.centerRight,
          child: Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(onPressed: _updateDate, icon: Icon(Icons.cached)),
                SizedBox(width: 8),
                //日期显示
                Text(
                  '${date.month}/${date.day}',
                  style: TextStyle(
                    fontSize: 24,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.blue[50],
        child: ListView.builder(
          itemCount: (items.length / 2).ceil(),
          itemBuilder: (context, rowIndex) {
            int firstIndex = rowIndex * 2;
            int secondIndex = firstIndex + 1;

            return Row(
              children: [
                Expanded(
                  child: ServerCard(
                    item: items[firstIndex],
                    onDelete: () => _removeItem(firstIndex),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: secondIndex < items.length
                      ? ServerCard(
                          item: items[secondIndex],
                          onDelete: () => _removeItem(secondIndex),
                        )
                      : const SizedBox(),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// 弹出输入框
  Future<void> _showAddDialog() async {
    // 弹出对话框 等待输入
    final result = await showAddServerDialog(context);
    if (result != null) {
      _addItem({...result, 'running': false});
    }
  }
}
