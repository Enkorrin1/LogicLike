// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'LogicLike';

  @override
  String get loadingMission => 'Preparing the mission...';

  @override
  String get navHome => '집';

  @override
  String get navChallenge => '탐구';

  @override
  String get navParent => '조상';

  @override
  String get onboardingSubmitSaving => 'Preparing route';

  @override
  String get onboardingSubmitCreateHero => 'Create hero';

  @override
  String get onboardingDefaultHero => 'Young hero';

  @override
  String get onboardingTitle => 'Create a hero';

  @override
  String get onboardingSubtitle =>
      'The lion will show the daily mission, then the child can choose brain games.';

  @override
  String get childNameLabel => 'Child name';

  @override
  String get childNameError => 'Enter hero name';

  @override
  String get onboardingMissionPill => '임무 시작';

  @override
  String get onboardingAgeTitle => 'Hero age';

  @override
  String get unlockMission => '사명';

  @override
  String get unlockGames => '계략';

  @override
  String get unlockPrizes => '상금';

  @override
  String ageYears(num years) {
    return '$years 세';
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
  String get settingsLanguage => '언어';
}
