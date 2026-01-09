import 'package:flutter/material.dart';
import 'package:is_mc_fk_running/widget/edit_server_dialog.dart';
import 'package:is_mc_fk_running/widget/server_info.dart';
import 'package:is_mc_fk_running/widget/server_info_controller.dart';

class ServerCard extends StatefulWidget {
  final Map<String, String> item;
  final VoidCallback onDelete;
  final ValueChanged<Map<String, String>> onEdit;
  final ServerInfoController controller;

  const ServerCard({
    super.key,
    required this.item,
    required this.onDelete,
    required this.onEdit,
    required this.controller,
  });

  @override
  State<ServerCard> createState() => _ServerCardState();
}

class _ServerCardState extends State<ServerCard> {
  Future<void> _showEditDialog(
    BuildContext context,
    Map<String, String> item,
  ) async {
    // 弹出对话框 等待输入

    final result = await showEditServerDialog(context, item);
    if (result == null) return;
    widget.onEdit(result);
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.item['name'] ?? '';
    final address = widget.item['address'] ?? '';
    final port = widget.item['port'] ?? '';

    return SizedBox(
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
                ).primaryColor.withValues(alpha: 0.4), //半透明替代毛玻璃背景
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                  width: 1.5,
                ),
                //边框效果
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).primaryColor.withValues(alpha: 0.6),
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
                  child: ServerInfo(
                    host: address,
                    port: port,
                    controller: widget.controller,
                  ),
                ),
                const SizedBox(height: 9), // 底部栏上方间隔
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
                                    if (states.contains(WidgetState.pressed)) {
                                      return Colors.grey[800]?.withValues(
                                        alpha: 0.9,
                                      );
                                    }
                                    // 默认
                                    return Colors.grey[600]?.withValues(
                                      alpha: 0.9,
                                    );
                                  }),
                            ),
                            onPressed: () =>
                                _showEditDialog(context, widget.item),
                            child: Icon(
                              Icons.settings,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      // Server名称
                      Expanded(
                        flex: 5,
                        child: Container(
                          //内边距
                          padding: EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 0,
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 0,
                          ), // 名称栏左右间隔
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.7), // 透明度
                            borderRadius: BorderRadius.circular(15),
                            // 边框
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.5),
                              width: 1.5,
                            ),
                            //阴影
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 1),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: Offset(1, 2), // 阴影方向
                              ),
                            ],
                          ),
                          child: Center(
                            child: FittedBox(
                              alignment: Alignment.center,
                              fit: BoxFit.scaleDown,
                              child: Text(
                                name,
                                overflow: TextOverflow.visible,
                                softWrap: false,
                                style: TextStyle(
                                  fontSize: 200, // 设置一个较大的默认值，让FittedBox调整
                                  color: Theme.of(context).colorScheme.primary
                                      .withAlpha(200)
                                      .withBlue(100)
                                      .withGreen(150),
                                ),
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
                                      return Colors.red[800]?.withValues(
                                        alpha: 0.9,
                                      );
                                    }
                                    // 默认
                                    return Colors.red[600]?.withValues(
                                      alpha: 0.9,
                                    );
                                  }),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("确认删除"),
                                    content: Text(
                                      "确定要删除服务器 ${widget.item['name']} 吗？",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("取消"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context); //删除之后取消对话框
                                          widget.onDelete();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red[300]
                                              ?.withValues(alpha: 0.9),
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
