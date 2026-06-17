// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'LogicLike';

  @override
  String get loadingMission => 'Préparation de la mission...';

  @override
  String get navHome => 'Maison';

  @override
  String get navChallenge => 'Quête';

  @override
  String get navParent => 'Mère';

  @override
  String get onboardingSubmitSaving => 'Préparation de l\'itinéraire';

  @override
  String get onboardingSubmitCreateHero => 'Créer un héros';

  @override
  String get onboardingDefaultHero => 'Jeune héros';

  @override
  String get onboardingTitle => 'Créer un héros';

  @override
  String get onboardingSubtitle =>
      'Le lion montrera la mission quotidienne, puis l\'enfant pourra choisir des jeux cérébraux.';

  @override
  String get childNameLabel => 'Nom de l\'enfant';

  @override
  String get childNameError => 'Entrez le nom du héros';

  @override
  String get onboardingMissionPill => 'début de mission';

  @override
  String get onboardingAgeTitle => 'Âge du héros';

  @override
  String get unlockMission => 'Mission';

  @override
  String get unlockGames => 'Jeux';

  @override
  String get unlockPrizes => 'Prix';

  @override
  String ageYears(num years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years années',
      one: '$years année',
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
  String get settingsLanguage => 'Langue';
}
