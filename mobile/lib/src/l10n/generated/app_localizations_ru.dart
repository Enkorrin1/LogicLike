// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'LogicLike';

  @override
  String get loadingMission => 'Готовим миссию...';

  @override
  String get navHome => 'Домой';

  @override
  String get navChallenge => 'Задание';

  @override
  String get navParent => 'Родителю';

  @override
  String get onboardingSubmitSaving => 'Готовим маршрут';

  @override
  String get onboardingSubmitCreateHero => 'Создать героя';

  @override
  String get onboardingDefaultHero => 'Юный герой';

  @override
  String get onboardingTitle => 'Создай героя';

  @override
  String get onboardingSubtitle =>
      'Лев покажет миссию дня, а дальше ребенок сам выберет тренировки.';

  @override
  String get childNameLabel => 'Имя ребенка';

  @override
  String get childNameError => 'Введите имя героя';

  @override
  String get onboardingMissionPill => 'старт миссии';

  @override
  String get onboardingAgeTitle => 'Возраст героя';

  @override
  String get unlockMission => 'Миссия';

  @override
  String get unlockGames => 'Игры';

  @override
  String get unlockPrizes => 'Призы';

  @override
  String ageYears(num years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years лет',
      many: '$years лет',
      few: '$years года',
      one: '$years год',
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
  String get settingsLanguage => 'Язык';
}
