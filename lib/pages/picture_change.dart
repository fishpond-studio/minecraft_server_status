import 'package:flutter/material.dart';

class PictureChange extends StatefulWidget {
  const PictureChange({super.key});

  @override
  State<PictureChange> createState() => _PictureChangeState();
}

class _PictureChangeState extends State<PictureChange> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            //更换背景图片
            Container(
              child: Row(
                children: [
                  Expanded(flex: 4, child: Text('更换背景图片')),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(Icons.arrow_forward_ios),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),

            //更换主题颜色

            //更换字体颜色

            //更换运行状态颜色

            //更换删除按钮颜色
          ],
        ),
      ),
    );
  }
}
