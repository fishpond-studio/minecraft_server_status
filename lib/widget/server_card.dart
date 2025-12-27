import 'package:flutter/material.dart';

class ServerCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onDelete;

  const ServerCard({super.key, required this.item, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).primaryColor.withOpacity(0.4), //半透明替代毛玻璃背景
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                  width: 1.5,
                ),
                //边框效果
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.8),
                    blurRadius: 8,
                    offset: Offset(2, 5),
                  ),
                ], //阴影效果
              ),
            ),
          ),
          // 卡片内容
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ), // 内边距
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //信息显示
                Expanded(
                  flex: 13,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6), //低明度
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 9), // 增加底部栏上方间隔
                //组件底部显示状态栏
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //运行状态
                      Expanded(
                        flex: 2,
                        child: SizedBox.expand(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              padding: WidgetStateProperty.all(EdgeInsets.zero),
                              alignment: Alignment.center,

                              backgroundColor:
                                  WidgetStateProperty.resolveWith<Color?>((
                                    states,
                                  ) {
                                    if (item['running']) {
                                      // 按下时
                                      if (states.contains(
                                        WidgetState.pressed,
                                      )) {
                                        return Colors.green[400]?.withOpacity(
                                          0.9,
                                        );
                                      }
                                      // 默认
                                      return Colors.green[200]?.withOpacity(
                                        0.9,
                                      );
                                    } else {
                                      // 按下时
                                      if (states.contains(
                                        WidgetState.pressed,
                                      )) {
                                        return Colors.red[400]?.withOpacity(
                                          0.9,
                                        );
                                      }
                                      // 默认
                                      return Colors.red[200]?.withOpacity(0.9);
                                    }
                                  }),
                            ),
                            onPressed: () {},
                            child: Icon(
                              item['running']
                                  ? Icons.power_settings_new
                                  : Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      //IP地址
                      Expanded(
                        flex: 5,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 5,
                          ), // IP栏左右间隔
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7), // 透明度
                            borderRadius: BorderRadius.circular(20),
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
                        flex: 2,
                        child: SizedBox.expand(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              padding: WidgetStateProperty.all(EdgeInsets.zero),
                              alignment: Alignment.center,

                              backgroundColor:
                                  WidgetStateProperty.resolveWith<Color?>((
                                    states,
                                  ) {
                                    // 按下时
                                    if (states.contains(WidgetState.pressed)) {
                                      return Colors.red[400]?.withOpacity(0.9);
                                    }
                                    // 默认
                                    return Colors.red[200]?.withOpacity(0.9);
                                  }),
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
                                        onPressed: () {
                                          Navigator.pop(context); //删除之后取消对话框
                                          onDelete();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red[300]
                                              ?.withOpacity(0.9),
                                        ),
                                        child: const Text(
                                          "删除",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 20,
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
