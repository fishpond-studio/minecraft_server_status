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
            //自定义设置部分
            Container(
              height: 500,
              //上下外边距  左右外边距
              margin: const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
              //上下内边距  左右内边距
              //padding: const EdgeInsets.symmetric(horizontal: 9),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(25),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Column(
                  children: [
                    //日间/夜晚模式
                    Container(
                      height: 50,
                      //左右外边距
                      //margin: const EdgeInsets.symmetric(horizontal: 9),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            alignment: Alignment.centerLeft,
                            shape: const RoundedRectangleBorder(), // 去掉圆角
                          ),
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

                    //更换背景图片
                    Container(
                      height: 50,
                      //左右外边距
                      //margin: const EdgeInsets.symmetric(horizontal: 9),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            alignment: Alignment.centerLeft,
                            shape: const RoundedRectangleBorder(), // 去掉圆角
                          ),
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
