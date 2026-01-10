// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Is MC FK Running?';

  @override
  String get home => '主页';

  @override
  String get settings => '设置';

  @override
  String get servers => '服务器';

  @override
  String get dayNightMode => '日间/夜晚模式';

  @override
  String get changeThemeColor => '更换主题颜色';

  @override
  String get language => '语言';

  @override
  String get languageSystem => '跟随系统';

  @override
  String get languageChinese => '中文';

  @override
  String get languageEnglish => 'English';

  @override
  String get addServerTitle => '添加新服务器';

  @override
  String get nameLabel => '名称(Server)';

  @override
  String get addressLabel => '地址';

  @override
  String get portLabel => '端口(25565)';

  @override
  String get cancel => '取消';

  @override
  String get add => '添加';

  @override
  String get delete => '删除';

  @override
  String confirmDeleteServer(String serverName) {
    return '确定要删除服务器 $serverName 吗？';
  }

  @override
  String get enterAddress => '请输入地址';

  @override
  String get invalidPort => '端口号必须为1-65535之间的数字';

  @override
  String get defaultServerName => 'Server';

  @override
  String get notAvailable => 'N/A';

  @override
  String get onlinePlayers => '在线人数';

  @override
  String get version => '版本';

  @override
  String get worldName => '存档名称';

  @override
  String get lastUpdated => '最后更新';

  @override
  String get latency => '延迟';

  @override
  String get editServerTitle => '编辑服务器';

  @override
  String get about => '关于';

  @override
  String get sponsor => '赞助';

  @override
  String get developers => '开发者';

  @override
  String get sourceCode => '源代码';

  @override
  String get save => '保存';
}
