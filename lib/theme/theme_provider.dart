import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider with ChangeNotifier {
  final Box _settingsBox = Hive.box('serverListBox');
  static const String _themeColorKey = 'themeColor';
  static const String _localeTagKey = 'localeTag';
  static const String _isDarkModeKey = 'isDarkMode';
  static const String _fontFamilyKey = 'fontFamily';
  static const String _updateIntervalKey = 'updateInterval';
  static const String _saveIntervalKey = 'saveInterval';

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

  // 可用字体列表
  final List<String> _availableFonts = [
    'System',
    'FMinecraft',
    'FJetBrainsMono',
  ];

  String _currentColorName = 'Blue';
  String? _localeTag;
  bool _isDarkMode = false;
  String _currentFontFamily = 'FMinecraft';
  int _updateInterval = 60; // 默认 60 秒
  int _saveInterval = 300; // 默认 300 秒

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

    final savedFontFamily = _settingsBox.get(_fontFamilyKey);
    if (savedFontFamily is String &&
        _availableFonts.contains(savedFontFamily)) {
      _currentFontFamily = savedFontFamily;
    }

    final savedUpdateInterval = _settingsBox.get(_updateIntervalKey);
    if (savedUpdateInterval is int) {
      _updateInterval = savedUpdateInterval;
    }

    final savedSaveInterval = _settingsBox.get(_saveIntervalKey);
    if (savedSaveInterval is int) {
      _saveInterval = savedSaveInterval;
    }
  }

  Color get currentColor => _colorMap[_currentColorName]!;

  String get currentColorName => _currentColorName;

  List<String> get availableColors => _colorMap.keys.toList();

  Locale? get locale => _localeTag == null ? null : Locale(_localeTag!);

  String get currentLocaleTag => _localeTag ?? 'system';

  bool get isDarkMode => _isDarkMode;

  String get currentFontFamily => _currentFontFamily;

  List<String> get availableFonts => _availableFonts;

  int get updateInterval => _updateInterval;

  int get saveInterval => _saveInterval;

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

  void changeFontFamily(String fontFamily) {
    if (_availableFonts.contains(fontFamily)) {
      _currentFontFamily = fontFamily;
      _settingsBox.put(_fontFamilyKey, fontFamily);
      notifyListeners();
    }
  }

  void changeUpdateInterval(int interval) {
    _updateInterval = interval;
    _settingsBox.put(_updateIntervalKey, interval);
    notifyListeners();
  }

  void changeSaveInterval(int interval) {
    _saveInterval = interval;
    _settingsBox.put(_saveIntervalKey, interval);
    notifyListeners();
  }

  ThemeData getTheme() {
    // Ensure the color is fully opaque for the seed to work best with Material 3
    final seedColor = currentColor.withValues(alpha: 1.0);

    return ThemeData(
      fontFamily: _currentFontFamily == 'System' ? null : _currentFontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
      ),
      useMaterial3: true,
    );
  }
}
