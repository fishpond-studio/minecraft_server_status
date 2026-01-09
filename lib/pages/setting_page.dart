import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

class PictureChange extends StatefulWidget {
  const PictureChange({super.key});

  @override
  State<PictureChange> createState() => _PictureChangeState();
}

class _PictureChangeState extends State<PictureChange> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Settings'),
        backgroundColor: Theme.of(
          context,
        ).colorScheme.primary.withValues(alpha: 0.15),
      ),

      body: Container(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        child: Column(
          children: [
            //自定义设置部分
            Container(
              height: 500,
              //上下外边距  左右外边距
              margin: const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
              //上下内边距  左右内边距
              //padding: const EdgeInsets.symmetric(horizontal: 9),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.15),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(2, 5), // 阴影方向
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Column(
                  children: [
                    //日间/夜晚模式
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.1),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.brightness_6, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    '日间/夜晚模式',
                                    style: TextStyle(
                                      fontFamily: 'FMinecraft',
                                      color: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.color,
                                    ),
                                  ),
                                ],
                              ),
                              Transform.scale(
                                scale: 0.8, // 调整开关大小
                                child: Switch(
                                  value: false,
                                  onChanged: (value) {
                                    value = true; // 切换模式的逻辑
                                    setState(() {});
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    //分隔线
                    Divider(
                      color: Colors.grey[800],
                      thickness: 0.3,
                      height: 0.3, //消除空隙
                      indent: 16,
                      endIndent: 16,
                    ),

                    // //先挖个坑，这个俺不会(((
                    // //更换背景图片
                    // Container(
                    //   height: 50,
                    //   decoration: BoxDecoration(
                    //     color: Theme.of(
                    //       context,
                    //     ).colorScheme.primary.withValues(alpha: 0.1),
                    //   ),
                    //   child: SizedBox(
                    //     width: double.infinity,
                    //     child: TextButton(
                    //       onPressed: () {},
                    //       style: TextButton.styleFrom(
                    //         alignment: Alignment.centerLeft,
                    //         shape: const RoundedRectangleBorder(), // 去掉圆角
                    //       ),
                    //       child: Padding(
                    //         padding: const EdgeInsets.symmetric(horizontal: 5),
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             Row(
                    //               children: [
                    //                 Icon(
                    //                   Icons.image,
                    //                   size: 20,
                    //                   color: Colors.black,
                    //                 ),
                    //                 SizedBox(width: 8),
                    //                 Text(
                    //                   '更换背景图片',
                    //                   style: TextStyle(
                    //                     fontFamily: 'FMinecraft',
                    //                     color: Theme.of(
                    //                       context,
                    //                     ).textTheme.bodyMedium?.color,
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //             const Icon(
                    //               Icons.arrow_forward_ios,
                    //               size: 20,
                    //               color: Colors.black,
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // //分隔线
                    // Divider(
                    //   color: Colors.grey[800],
                    //   thickness: 0.3,
                    //   height: 0.3, //消除空隙
                    //   indent: 16,
                    //   endIndent: 16,
                    // ),
                    //更换主题颜色
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.1),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.trip_origin, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    '更换主题颜色',
                                    style: TextStyle(
                                      fontFamily: 'FMinecraft',
                                      color: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.color,
                                    ),
                                  ),
                                ],
                              ),
                              Transform.scale(
                                scale: 0.8, // 开关大小
                                child: Consumer<ThemeProvider>(
                                  builder: (context, themeProvider, child) {
                                    return DropdownMenu(
                                      initialSelection:
                                          themeProvider.currentColorName,
                                      onSelected: (value) {
                                        if (value != null) {
                                          themeProvider.changeThemeColor(value);
                                        }
                                      },
                                      dropdownMenuEntries: themeProvider
                                          .availableColors
                                          .map(
                                            (color) => DropdownMenuEntry(
                                              value: color,
                                              label: color,
                                            ),
                                          )
                                          .toList(),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
