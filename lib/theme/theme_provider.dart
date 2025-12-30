import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider with ChangeNotifier {
  final Box _settingsBox = Hive.box('serverListBox');
  static const String _themeColorKey = 'themeColor';

  // 主题颜色映射
  final Map<String, Color> _colorMap = {
    //在这里添加新主题
    'Blue': const Color.fromARGB(210, 33, 150, 243),
    'Green': const Color.fromARGB(210, 76, 175, 80),
    'Red': const Color.fromARGB(210, 244, 67, 54),
    'Yellow': const Color.fromARGB(210, 255, 235, 59),
    'Orange': const Color.fromARGB(210, 255, 152, 0),
    'Purple': const Color.fromARGB(210, 156, 39, 176),
    'Pink': const Color.fromARGB(210, 233, 30, 99),
    'Cyan': const Color.fromARGB(210, 0, 188, 212),
    'Grey': const Color.fromARGB(210, 96, 125, 139),
  };

  String _currentColorName = 'Blue';

  ThemeProvider() {
    // 从Hive加载保存的主题颜色
    final savedColor = _settingsBox.get(_themeColorKey);
    if (savedColor != null && _colorMap.containsKey(savedColor)) {
      _currentColorName = savedColor;
    }
  }

  Color get currentColor => _colorMap[_currentColorName]!;

  String get currentColorName => _currentColorName;

  List<String> get availableColors => _colorMap.keys.toList();

  void changeThemeColor(String colorName) {
    if (_colorMap.containsKey(colorName)) {
      _currentColorName = colorName;
      // 保存到Hive
      _settingsBox.put(_themeColorKey, colorName);
      notifyListeners();
    }
  }

  ThemeData getTheme() {
    return ThemeData(
      fontFamily: 'FMinecraft',
      colorScheme: ColorScheme.fromSeed(
        seedColor: currentColor,
        primary: currentColor.withValues(alpha: 0.5),
      ),
      useMaterial3: true,
    );
  }
}
