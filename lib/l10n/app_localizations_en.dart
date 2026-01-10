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
  String get nameLabel => 'Name';

  @override
  String get addressLabel => 'Address';

  @override
  String get portLabel => 'Port';

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
  String get about => 'About';

  @override
  String get sponsor => 'Sponsor';

  @override
  String get developers => 'Developers';

  @override
  String get sourceCode => 'Source Code';

  @override
  String get save => 'Save';

  @override
  String get serverDetails => 'Server Details';

  @override
  String get playerCount => 'Player Count';

  @override
  String get serverLoad => 'Server Load';

  @override
  String get pingLatency => 'Ping Latency';

  @override
  String get players => 'Players';

  @override
  String get usage => 'Usage';

  @override
  String get ms => 'ms';

  @override
  String get last24Hours => 'Last 24 Hours';

  @override
  String get noData => 'No data available';

  @override
  String get sponsorTitle => 'Eh? You really want to sponsor?';

  @override
  String get sponsorBenefitsTitle => 'What do you get for sponsoring?';

  @override
  String get sponsorBenefit1 =>
      '1. Your name will be listed in the sponsor list(Actually there is no sponsor list)';

  @override
  String get sponsorBenefit2 => '2. You get a hug from IDK~~';

  @override
  String get sponsorNote =>
      'Don\'t sponsor! It\'s just a practice project. Come hang out in our community instead!';

  @override
  String get joinCommunity => 'Join Community';

  @override
  String get communityName => 'Group Name';

  @override
  String get communityId => 'Group ID/Link';

  @override
  String get copy => 'Copy';
}
