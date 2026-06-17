// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'LogicLike';

  @override
  String get loadingMission => 'Preparando a missão...';

  @override
  String get navHome => 'Lar';

  @override
  String get navChallenge => 'Busca';

  @override
  String get navParent => 'Pai';

  @override
  String get onboardingSubmitSaving => 'Preparando rota';

  @override
  String get onboardingSubmitCreateHero => 'Criar herói';

  @override
  String get onboardingDefaultHero => 'Jovem herói';

  @override
  String get onboardingTitle => 'Crie um herói';

  @override
  String get onboardingSubtitle =>
      'O leão mostrará a missão diária, então a criança poderá escolher jogos cerebrais.';

  @override
  String get childNameLabel => 'Nome da criança';

  @override
  String get childNameError => 'Digite o nome do herói';

  @override
  String get onboardingMissionPill => 'início da missão';

  @override
  String get onboardingAgeTitle => 'Idade do herói';

  @override
  String get unlockMission => 'Missão';

  @override
  String get unlockGames => 'Jogos';

  @override
  String get unlockPrizes => 'Prêmios';

  @override
  String ageYears(num years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years anos',
      one: '$years ano',
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
