// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'LogicLike';

  @override
  String get loadingMission => 'Preparing the mission...';

  @override
  String get navHome => 'Home';

  @override
  String get navChallenge => 'Quest';

  @override
  String get navParent => 'Parent';

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
  String get onboardingMissionPill => 'mission start';

  @override
  String get onboardingAgeTitle => 'Hero age';

  @override
  String get unlockMission => 'Mission';

  @override
  String get unlockGames => 'Games';

  @override
  String get unlockPrizes => 'Prizes';

  @override
  String ageYears(num years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years years',
      one: '$years year',
    );
    return '$_temp0';
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
  String get settingsLanguage => 'Language';
}
