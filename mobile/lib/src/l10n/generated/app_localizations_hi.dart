// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'LogicLike';

  @override
  String get loadingMission => 'मिशन की तैयारी...';

  @override
  String get navHome => 'घर';

  @override
  String get navChallenge => 'खोज';

  @override
  String get navParent => 'माता-पिता';

  @override
  String get onboardingSubmitSaving => 'मार्ग तैयार किया जा रहा है';

  @override
  String get onboardingSubmitCreateHero => 'हीरो बनाएं';

  @override
  String get onboardingDefaultHero => 'युवा नायक';

  @override
  String get onboardingTitle => 'एक हीरो बनाएं';

  @override
  String get onboardingSubtitle =>
      'शेर दैनिक मिशन दिखाएगा, फिर बच्चा दिमागी खेल चुन सकता है।';

  @override
  String get childNameLabel => 'बच्चे का नाम';

  @override
  String get childNameError => 'नायक का नाम दर्ज करें';

  @override
  String get onboardingMissionPill => 'मिशन प्रारंभ';

  @override
  String get onboardingAgeTitle => 'हीरो की उम्र';

  @override
  String get unlockMission => 'उद्देश्य';

  @override
  String get unlockGames => 'खेल';

  @override
  String get unlockPrizes => 'पुरस्कार';

  @override
  String ageYears(num years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years साल',
      one: '$years वर्ष',
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
  String get settingsLanguage => 'भाषा';
}
