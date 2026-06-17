// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'LogicLike';

  @override
  String get loadingMission => 'ミッションの準備中...';

  @override
  String get navHome => '家';

  @override
  String get navChallenge => 'クエスト';

  @override
  String get navParent => '親';

  @override
  String get onboardingSubmitSaving => 'ルートの準備中';

  @override
  String get onboardingSubmitCreateHero => 'ヒーローの作成';

  @override
  String get onboardingDefaultHero => '若き英雄';

  @override
  String get onboardingTitle => 'ヒーローを作成する';

  @override
  String get onboardingSubtitle => 'ライオンが毎日のミッションを示し、子供は頭脳ゲームを選択できます。';

  @override
  String get childNameLabel => '子供の名前';

  @override
  String get childNameError => 'ヒーロー名を入力してください';

  @override
  String get onboardingMissionPill => 'ミッション開始';

  @override
  String get onboardingAgeTitle => 'ヒーローの年齢';

  @override
  String get unlockMission => 'ミッション';

  @override
  String get unlockGames => 'ゲーム';

  @override
  String get unlockPrizes => '賞品';

  @override
  String ageYears(num years) {
    return '$years 歳';
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
  String get settingsLanguage => '言語';
}
