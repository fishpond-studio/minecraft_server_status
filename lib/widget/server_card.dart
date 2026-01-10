import 'package:flutter/material.dart';
import 'package:is_mc_fk_running/widget/server_info.dart';
import 'package:is_mc_fk_running/pages/server_detail_page.dart';

class ServerCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onEdit;

  const ServerCard({super.key, required this.item, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 导航到服务器详情页面
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServerDetailPage(serverItem: item),
          ),
        );
      },
      child: SizedBox(
        height: 250,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(
                        context,
                      ).colorScheme.surface.withValues(alpha: 0.8),
                      Theme.of(
                        context,
                      ).colorScheme.surface.withValues(alpha: 0.5),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  //边框效果
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).shadowColor.withValues(alpha: 0.1),
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ], //阴影效果
                ),
              ),
            ),
            // 卡片内容
            Container(
              padding: const EdgeInsets.all(12), // 内边距
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //信息显示
                  Expanded(
                    flex: 13,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest
                            .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: ServerInfo(
                          host: item['address'],
                          port: item['port'],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12), // 底部栏上方间隔
                  //组件底部显示状态栏
                  SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //运行状态
                        _buildActionButton(
                          context,
                          icon: item['running']
                              ? Icons.power_settings_new
                              : Icons.play_arrow_rounded,
                          color: item['running'] ? Colors.green : Colors.orange,
                          // 切换运行状态按钮
                          onTap: () {
                            // TODO: 实现切换运行状态功能
                          },
                        ),

                        // Server名称
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.surface.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.1),
                              ),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: Text(
                                  item['name'],
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        //编辑按钮
                        _buildActionButton(
                          context,
                          icon: Icons.edit,
                          color: Colors.blue,
                          onTap: onEdit,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return AspectRatio(
      aspectRatio: 1,
      child: Material(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}
