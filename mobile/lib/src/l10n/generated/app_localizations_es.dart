// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'LogicLike';

  @override
  String get loadingMission => 'Preparando la misión...';

  @override
  String get navHome => 'Hogar';

  @override
  String get navChallenge => 'Búsqueda';

  @override
  String get navParent => 'Padre';

  @override
  String get onboardingSubmitSaving => 'Preparando ruta';

  @override
  String get onboardingSubmitCreateHero => 'Crear héroe';

  @override
  String get onboardingDefaultHero => 'joven héroe';

  @override
  String get onboardingTitle => 'crear un héroe';

  @override
  String get onboardingSubtitle =>
      'El león mostrará la misión diaria y luego el niño podrá elegir juegos mentales.';

  @override
  String get childNameLabel => 'nombre del niño';

  @override
  String get childNameError => 'Introduce el nombre del héroe';

  @override
  String get onboardingMissionPill => 'inicio de la misión';

  @override
  String get onboardingAgeTitle => 'Edad del héroe';

  @override
  String get unlockMission => 'Misión';

  @override
  String get unlockGames => 'Juegos';

  @override
  String get unlockPrizes => 'Premios';

  @override
  String ageYears(num years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years años',
      one: '$years año',
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
  String get settingsLanguage => 'Idioma';
}
