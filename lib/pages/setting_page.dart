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
      appBar: AppBar(centerTitle: true, title: const Text('Settings')),

      body: Container(
        child: Column(
          children: [
            //更换背景图片
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(alignment: Alignment.centerLeft),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('更换背景图片'),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
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
