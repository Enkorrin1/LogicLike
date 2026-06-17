// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'LogicLike';

  @override
  String get loadingMission => 'تحضير المهمة...';

  @override
  String get navHome => 'بيت';

  @override
  String get navChallenge => 'كويست';

  @override
  String get navParent => 'الوالد';

  @override
  String get onboardingSubmitSaving => 'تحضير الطريق';

  @override
  String get onboardingSubmitCreateHero => 'خلق البطل';

  @override
  String get onboardingDefaultHero => 'البطل الشاب';

  @override
  String get onboardingTitle => 'خلق بطلا';

  @override
  String get onboardingSubtitle =>
      'سيظهر الأسد المهمة اليومية، ثم يمكن للطفل اختيار ألعاب الدماغ.';

  @override
  String get childNameLabel => 'اسم الطفل';

  @override
  String get childNameError => 'أدخل اسم البطل';

  @override
  String get onboardingMissionPill => 'بداية المهمة';

  @override
  String get onboardingAgeTitle => 'عمر البطل';

  @override
  String get unlockMission => 'مهمة';

  @override
  String get unlockGames => 'ألعاب';

  @override
  String get unlockPrizes => 'الجوائز';

  @override
  String ageYears(num years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years سنين',
      many: '$years سنين',
      few: '$years سنين',
      two: '$years سنين',
      one: '$years سنة',
      zero: '$years سنين',
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
  String get settingsLanguage => 'اللغة';
}
