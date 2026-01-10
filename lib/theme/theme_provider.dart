import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider with ChangeNotifier {
  final Box _settingsBox = Hive.box('serverListBox');
  static const String _themeColorKey = 'themeColor';
  static const String _localeTagKey = 'localeTag';
  static const String _isDarkModeKey = 'isDarkMode';

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
  String? _localeTag;
  bool _isDarkMode = false;

  ThemeProvider() {
    // 从Hive加载保存的主题颜色
    final savedColor = _settingsBox.get(_themeColorKey);
    if (savedColor != null && _colorMap.containsKey(savedColor)) {
      _currentColorName = savedColor;
    }

    final savedLocaleTag = _settingsBox.get(_localeTagKey);
    if (savedLocaleTag is String && savedLocaleTag.isNotEmpty) {
      _localeTag = savedLocaleTag;
    }

    final savedIsDarkMode = _settingsBox.get(_isDarkModeKey);
    if (savedIsDarkMode is bool) {
      _isDarkMode = savedIsDarkMode;
    }
  }

  Color get currentColor => _colorMap[_currentColorName]!;

  String get currentColorName => _currentColorName;

  List<String> get availableColors => _colorMap.keys.toList();

  Locale? get locale => _localeTag == null ? null : Locale(_localeTag!);

  String get currentLocaleTag => _localeTag ?? 'system';

  bool get isDarkMode => _isDarkMode;

  ThemeData get theme => getTheme();

  void changeLocaleTag(String tag) {
    if (tag == 'system') {
      _localeTag = null;
      _settingsBox.delete(_localeTagKey);
    } else {
      _localeTag = tag;
      _settingsBox.put(_localeTagKey, tag);
    }
    notifyListeners();
  }

  void changeThemeColor(String colorName) {
    if (_colorMap.containsKey(colorName)) {
      _currentColorName = colorName;
      // 保存到Hive
      _settingsBox.put(_themeColorKey, colorName);
      notifyListeners();
    }
  }

  void toggleThemeMode(bool isDark) {
    _isDarkMode = isDark;
    _settingsBox.put(_isDarkModeKey, _isDarkMode);
    notifyListeners();
  }

  ThemeData getTheme() {
    return ThemeData(
      fontFamily: 'FMinecraft',
      colorScheme: ColorScheme.fromSeed(
        seedColor: currentColor,
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        primary: currentColor.withValues(alpha: 0.5),
      ),
      useMaterial3: true,
    );
  }
}
