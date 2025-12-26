import 'package:flutter/material.dart';
import 'dart:ui';

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
        title: const Text('Severs'),
        flexibleSpace: Container(
          alignment: Alignment.centerRight,
          child: Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.cached)),
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
      body: ListView.builder(
        itemCount: (items.length / 2).ceil(),
        itemBuilder: (context, rowIndex) {
          int firstIndex = rowIndex * 2;
          int secondIndex = firstIndex + 1;

          return Row(
            children: [
              Expanded(
                child: _buildItem(items[firstIndex]["name"], firstIndex),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: secondIndex < items.length
                    ? _buildItem(items[secondIndex]["name"], secondIndex)
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
  Widget _buildItem(String name, int index) {
    return Container(
      margin: const EdgeInsets.all(12), //外层间隔
      height: 250,
      child: Stack(
        children: [
          // 毛玻璃效果背景
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20), //模糊强度
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue[100]?.withOpacity(0.5), //透明度，增强毛玻璃效果
                borderRadius: BorderRadius.circular(8),
                // 去掉边框
              ),
            ),
          ),
          // 卡片内容
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ), // 增加内边距
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //信息显示
                Expanded(
                  flex: 9,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6), //低明度
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                const SizedBox(height: 10), // 增加底部栏上方间隔
                //组件底部显示状态栏
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //运行状态
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: const EdgeInsets.only(right: 5), // 状态图标右侧间隔
                          decoration: BoxDecoration(
                            color: items[index]['running']
                                ? Colors.green[200]?.withOpacity(0.9)
                                : const Color.fromARGB(
                                    255,
                                    247,
                                    115,
                                    106,
                                  ).withOpacity(0.9),
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: Icon(
                            items[index]['running']
                                ? Icons.power_settings_new
                                : Icons.close,
                            color: Colors.white,
                            size: 17,
                          ),
                        ),
                      ),
                      //IP地址
                      Expanded(
                        flex: 4,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 5,
                          ), // IP栏左右间隔
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(
                              0.7,
                            ), // 降低透明度，与整体效果协调
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              items[index]['address'],
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      //删除按钮
                      Expanded(
                        flex: 1,
                        child: SizedBox.expand(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: Colors.red[100]?.withOpacity(
                                0.9,
                              ), // 半透明浅红色背景
                              alignment: Alignment.center,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("确认删除"),
                                    content: Text(
                                      "确定要删除服务器 ${items[index]['name']} 吗？",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("取消"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            items.removeAt(index);
                                          });
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                            255,
                                            241,
                                            148,
                                            142,
                                          ).withOpacity(0.9),
                                        ),
                                        child: const Text("删除"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
