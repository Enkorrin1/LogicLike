// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'LogicLike';

  @override
  String get loadingMission => 'Preparare la missione...';

  @override
  String get navHome => 'Casa';

  @override
  String get navChallenge => 'Ricerca';

  @override
  String get navParent => 'Genitore';

  @override
  String get onboardingSubmitSaving => 'Preparazione del percorso';

  @override
  String get onboardingSubmitCreateHero => 'Crea eroe';

  @override
  String get onboardingDefaultHero => 'Giovane eroe';

  @override
  String get onboardingTitle => 'Crea un eroe';

  @override
  String get onboardingSubtitle =>
      'Il leone mostrerà la missione quotidiana, poi il bambino potrà scegliere i giochi cerebrali.';

  @override
  String get childNameLabel => 'Nome del bambino';

  @override
  String get childNameError => 'Inserisci il nome dell\'eroe';

  @override
  String get onboardingMissionPill => 'inizio missione';

  @override
  String get onboardingAgeTitle => 'L\'età dell\'eroe';

  @override
  String get unlockMission => 'Missione';

  @override
  String get unlockGames => 'Giochi';

  @override
  String get unlockPrizes => 'Premi';

  @override
  String ageYears(num years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years anni',
      one: '$years anno',
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
  String get settingsLanguage => 'Lingua';
}
