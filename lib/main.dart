import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'pages/routes_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 初始化hive
  await Hive.initFlutter();
  // 打开一个盒子
  await Hive.openBox('serverListBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Is MC FK Running?',
      theme: ThemeData(
        fontFamily: 'FMinecraft',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(210, 13, 34, 32),
          primary: Color.fromARGB(133, 121, 155, 93),
        ),
        useMaterial3: true,
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color,
            fontFamily: 'FMinecraft',
          ),
        ),
      ),
      home: const RoutesPages(),
    );
  }
}
