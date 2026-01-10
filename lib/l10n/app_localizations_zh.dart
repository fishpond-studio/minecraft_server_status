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
  String get nameLabel => '名称';

  @override
  String get addressLabel => '地址';

  @override
  String get portLabel => '端口';

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

  @override
  String get serverDetails => '服务器详情';

  @override
  String get playerCount => '玩家人数';

  @override
  String get serverLoad => '服务器占用';

  @override
  String get pingLatency => '延迟';

  @override
  String get players => '玩家';

  @override
  String get usage => '占用率';

  @override
  String get ms => '毫秒';

  @override
  String get last24Hours => '最近24小时';

  @override
  String get noData => '暂无数据';

  @override
  String get sponsorTitle => '诶?你真的要赞助吗?';

  @override
  String get sponsorBenefitsTitle => '赞助后可以得到什么?';

  @override
  String get sponsorBenefit1 => '1. 你的名字将被放在应用的赞助列表中(其实没有)';

  @override
  String get sponsorBenefit2 => '2. 将会得到IDK的抱抱~~';

  @override
  String get sponsorNote => '别赞助啦，只是个练手的小项目，快来我的群里玩一玩';

  @override
  String get joinCommunity => '加入社区';

  @override
  String get communityName => '群组名称';

  @override
  String get communityId => '群号/链接';

  @override
  String get copy => '复制';
}
