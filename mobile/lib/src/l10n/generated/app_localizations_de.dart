// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'LogicLike';

  @override
  String get loadingMission => 'Vorbereitung der Mission...';

  @override
  String get navHome => 'Heim';

  @override
  String get navChallenge => 'Suche';

  @override
  String get navParent => 'Elternteil';

  @override
  String get onboardingSubmitSaving => 'Route vorbereiten';

  @override
  String get onboardingSubmitCreateHero => 'Erstelle einen Helden';

  @override
  String get onboardingDefaultHero => 'Junger Held';

  @override
  String get onboardingTitle => 'Erstelle einen Helden';

  @override
  String get onboardingSubtitle =>
      'Der Löwe zeigt die tägliche Mission, dann kann das Kind Denkspiele auswählen.';

  @override
  String get childNameLabel => 'Kindername';

  @override
  String get childNameError => 'Geben Sie den Namen des Helden ein';

  @override
  String get onboardingMissionPill => 'Missionsstart';

  @override
  String get onboardingAgeTitle => 'Heldenalter';

  @override
  String get unlockMission => 'Mission';

  @override
  String get unlockGames => 'Spiele';

  @override
  String get unlockPrizes => 'Preise';

  @override
  String ageYears(num years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years Jahre',
      one: '$years Jahr',
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
  String get settingsLanguage => 'Sprache';
}
