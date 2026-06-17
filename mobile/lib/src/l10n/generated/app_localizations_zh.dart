// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'LogicLike';

  @override
  String get loadingMission => '准备任务...';

  @override
  String get navHome => '家';

  @override
  String get navChallenge => '寻求';

  @override
  String get navParent => '家长';

  @override
  String get onboardingSubmitSaving => '准备路线';

  @override
  String get onboardingSubmitCreateHero => '创建英雄';

  @override
  String get onboardingDefaultHero => '少年英雄';

  @override
  String get onboardingTitle => '创建一个英雄';

  @override
  String get onboardingSubtitle => '狮子会展示每日任务，然后孩子可以选择益智游戏。';

  @override
  String get childNameLabel => '孩子姓名';

  @override
  String get childNameError => '输入英雄名字';

  @override
  String get onboardingMissionPill => '任务开始';

  @override
  String get onboardingAgeTitle => '英雄时代';

  @override
  String get unlockMission => '使命';

  @override
  String get unlockGames => '游戏';

  @override
  String get unlockPrizes => '奖品';

  @override
  String ageYears(num years) {
    return '$years 岁';
  }

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get languageItalian => 'Italiano';

  @override
  String get languageJapanese => '日本語';

  @override
  String get languageKorean => '한국어';

  @override
  String get languagePortuguese => 'Português';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageChinese => '中文';

  @override
  String get settingsLanguage => '语言';
}
