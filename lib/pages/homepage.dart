import 'package:flutter/material.dart';

DateTime now = DateTime.now();
DateTime date = DateTime(now.month, now.day);

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final List<Map<String, dynamic>> items = []; // 存储数据

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Severs'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.inversePrimary,
              width: 9.0,
            ),
          ),
          alignment: Alignment.centerRight,
          child: Text(
            '${date.month}/${date.day}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: (items.length / 2).ceil(),
        itemBuilder: (context, rowIndex) {
          int firstIndex = rowIndex * 2;
          int secondIndex = firstIndex + 1;

          return Row(
            children: [
              Expanded(child: _buildItem(items[firstIndex], firstIndex)),
              const SizedBox(width: 8),
              Expanded(
                child: secondIndex < items.length
                    ? _buildItem(items[secondIndex], secondIndex)
                    : const SizedBox(),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// 弹出输入框
  void _showAddDialog() {
    String inputName = "";
    String inputAddress = "";
    String inputPort = "";
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("添加新服务器"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: "名称(Sever)",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  inputName = value;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: "地址",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  inputAddress = value;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: "端口(25565)",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  inputPort = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // 取消
              child: const Text("取消"),
            ),
            ElevatedButton(
              onPressed: () {
                if (inputName.trim().isEmpty) {
                  inputName = "Sever";
                }
                if (inputPort.trim().isEmpty) {
                  inputPort = "25565";
                }
                if (inputAddress.trim().isEmpty) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text("请输入地址")));
                }
                if (inputAddress.trim().isNotEmpty) {
                  setState(() {
                    items.add({
                      'name': inputName.trim(),
                      'address': inputAddress.trim(),
                      'port': inputPort.trim(),
                      'running': false,
                    });
                    print(items);
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("添加"),
            ),
          ],
        );
      },
    );
  }

  /// 构建单个组件
  Widget _buildItem(Map<String, dynamic> item, int index) {
    return Container(
      margin: const EdgeInsets.all(8),
      height: 200,
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue),
      ),
      child: Stack(
        children: [
          // 左上角编号
          Positioned(
            left: 8,
            top: 8,
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue,
              child: Text(
                '${index + 1}',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
          // 中间的文字
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  item['name'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (item['address'] != null && item['address'].isNotEmpty)
                  Text(
                    item['address'],
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ElevatedButton(
                  onPressed: () {
                    print(item);
                  },
                  child: const Text('输出地址'),
                ),
              ],
            ),
          ),
          //删除按钮
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              icon: const Icon(Icons.close, size: 20, color: Colors.red),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                setState(() {
                  items.removeAt(index);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
