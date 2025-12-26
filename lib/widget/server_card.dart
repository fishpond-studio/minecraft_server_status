import 'package:flutter/material.dart';

class ServerCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onDelete;

  const ServerCard({super.key, required this.item, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12), //外层间隔
      height: 250,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue[100]?.withValues(alpha: 0.95), //半透明替代毛玻璃背景
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.blue[200]!.withValues(alpha: 0.95),
                  width: 1.5,
                ), //边框效果
                boxShadow: [
                  BoxShadow(
                    color:
                        Colors.blue[200]?.withValues(alpha: 0.8) ??
                        Colors.transparent,
                    blurRadius: 8,
                    offset: Offset(0, 5),
                  ),
                ], //阴影效果
              ),
            ),
          ),
          // 卡片内容
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ), // 内边距
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //信息显示
                Expanded(
                  flex: 9,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.6), //低明度
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
                            color: item['running']
                                ? Colors.green[200]?.withValues(alpha: 0.9)
                                : const Color.fromARGB(
                                    255,
                                    247,
                                    115,
                                    106,
                                  ).withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: Icon(
                            item['running']
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
                            color: Colors.white.withValues(alpha: 0.7), // 透明度
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              item['address'],
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
                              backgroundColor: Colors.red[100]?.withValues(
                                alpha: 0.9,
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
                                      "确定要删除服务器 ${item['name']} 吗？",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("取消"),
                                      ),
                                      ElevatedButton(
                                        onPressed: onDelete,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                            255,
                                            241,
                                            148,
                                            142,
                                          ).withValues(alpha: 0.9),
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
