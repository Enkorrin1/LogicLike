import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('ru'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In ru, this message translates to:
  /// **'LogicLike'**
  String get appTitle;

  /// No description provided for @loadingMission.
  ///
  /// In ru, this message translates to:
  /// **'Готовим миссию...'**
  String get loadingMission;

  /// No description provided for @navHome.
  ///
  /// In ru, this message translates to:
  /// **'Домой'**
  String get navHome;

  /// No description provided for @navChallenge.
  ///
  /// In ru, this message translates to:
  /// **'Задание'**
  String get navChallenge;

  /// No description provided for @navParent.
  ///
  /// In ru, this message translates to:
  /// **'Родителю'**
  String get navParent;

  /// No description provided for @onboardingSubmitSaving.
  ///
  /// In ru, this message translates to:
  /// **'Готовим маршрут'**
  String get onboardingSubmitSaving;

  /// No description provided for @onboardingSubmitCreateHero.
  ///
  /// In ru, this message translates to:
  /// **'Создать героя'**
  String get onboardingSubmitCreateHero;

  /// No description provided for @onboardingDefaultHero.
  ///
  /// In ru, this message translates to:
  /// **'Юный герой'**
  String get onboardingDefaultHero;

  /// No description provided for @onboardingTitle.
  ///
  /// In ru, this message translates to:
  /// **'Создай героя'**
  String get onboardingTitle;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Лев покажет миссию дня, а дальше ребенок сам выберет тренировки.'**
  String get onboardingSubtitle;

  /// No description provided for @childNameLabel.
  ///
  /// In ru, this message translates to:
  /// **'Имя ребенка'**
  String get childNameLabel;

  /// No description provided for @childNameError.
  ///
  /// In ru, this message translates to:
  /// **'Введите имя героя'**
  String get childNameError;

  /// No description provided for @onboardingMissionPill.
  ///
  /// In ru, this message translates to:
  /// **'старт миссии'**
  String get onboardingMissionPill;

  /// No description provided for @onboardingAgeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Возраст героя'**
  String get onboardingAgeTitle;

  /// No description provided for @unlockMission.
  ///
  /// In ru, this message translates to:
  /// **'Миссия'**
  String get unlockMission;

  /// No description provided for @unlockGames.
  ///
  /// In ru, this message translates to:
  /// **'Игры'**
  String get unlockGames;

  /// No description provided for @unlockPrizes.
  ///
  /// In ru, this message translates to:
  /// **'Призы'**
  String get unlockPrizes;

  /// No description provided for @ageYears.
  ///
  /// In ru, this message translates to:
  /// **'{years, plural, one{{years} год} few{{years} года} many{{years} лет} other{{years} лет}}'**
  String ageYears(num years);

  /// No description provided for @languageArabic.
  ///
  /// In ru, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @languageGerman.
  ///
  /// In ru, this message translates to:
  /// **'Deutsch'**
  String get languageGerman;

  /// No description provided for @languageEnglish.
  ///
  /// In ru, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageSpanish.
  ///
  /// In ru, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// No description provided for @languageFrench.
  ///
  /// In ru, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// No description provided for @languageHindi.
  ///
  /// In ru, this message translates to:
  /// **'हिन्दी'**
  String get languageHindi;

  /// No description provided for @languageItalian.
  ///
  /// In ru, this message translates to:
  /// **'Italiano'**
  String get languageItalian;

  /// No description provided for @languageJapanese.
  ///
  /// In ru, this message translates to:
  /// **'日本語'**
  String get languageJapanese;

  /// No description provided for @languageKorean.
  ///
  /// In ru, this message translates to:
  /// **'한국어'**
  String get languageKorean;

  /// No description provided for @languagePortuguese.
  ///
  /// In ru, this message translates to:
  /// **'Português'**
  String get languagePortuguese;

  /// No description provided for @languageRussian.
  ///
  /// In ru, this message translates to:
  /// **'Русский'**
  String get languageRussian;

  /// No description provided for @languageChinese.
  ///
  /// In ru, this message translates to:
  /// **'中文'**
  String get languageChinese;

  /// No description provided for @settingsLanguage.
  ///
  /// In ru, this message translates to:
  /// **'Язык'**
  String get settingsLanguage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'de',
        'en',
        'es',
        'fr',
        'hi',
        'it',
        'ja',
        'ko',
        'pt',
        'ru',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
