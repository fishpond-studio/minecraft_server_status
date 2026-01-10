// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Is MC FK Running?';

  @override
  String get home => 'Home';

  @override
  String get settings => 'Settings';

  @override
  String get servers => 'Servers';

  @override
  String get dayNightMode => 'Day/Night Mode';

  @override
  String get changeThemeColor => 'Theme Color';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'System';

  @override
  String get languageChinese => '中文';

  @override
  String get languageEnglish => 'English';

  @override
  String get addServerTitle => 'Add Server';

  @override
  String get nameLabel => 'Name (Server)';

  @override
  String get addressLabel => 'Address';

  @override
  String get portLabel => 'Port (25565)';

  @override
  String get cancel => 'Cancel';

  @override
  String get add => 'Add';

  @override
  String get delete => 'Delete';

  @override
  String confirmDeleteServer(String serverName) {
    return 'Delete server $serverName?';
  }

  @override
  String get enterAddress => 'Please enter an address';

  @override
  String get invalidPort => 'Port must be a number between 1 and 65535';

  @override
  String get defaultServerName => 'Server';

  @override
  String get notAvailable => 'N/A';

  @override
  String get onlinePlayers => 'Online Players';

  @override
  String get version => 'Version';

  @override
  String get worldName => 'World Name';

  @override
  String get lastUpdated => 'Last Updated';

  @override
  String get latency => 'Latency';

  @override
  String get editServerTitle => 'Edit Server';

  @override
  String get save => 'Save';

  @override
  String get serverStatus => 'Server Status';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get motd => 'MOTD';

  @override
  String get noMotd => 'No MOTD';

  @override
  String get playersChart => 'Players Chart';

  @override
  String get latencyChart => 'Latency Chart';
}
