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
  /// In en, this message translates to:
  /// **'LogicUpX'**
  String get appTitle;

  /// No description provided for @loadingMission.
  ///
  /// In en, this message translates to:
  /// **'Preparing the mission...'**
  String get loadingMission;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navChallenge.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get navChallenge;

  /// No description provided for @navParent.
  ///
  /// In en, this message translates to:
  /// **'Parent'**
  String get navParent;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get commonReset;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language: {language}'**
  String languageChanged(Object language);

  /// No description provided for @languageButtonSemantics.
  ///
  /// In en, this message translates to:
  /// **'Change language. Current: {language}'**
  String languageButtonSemantics(Object language);

  /// No description provided for @onboardingSubmitSaving.
  ///
  /// In en, this message translates to:
  /// **'Preparing route'**
  String get onboardingSubmitSaving;

  /// No description provided for @onboardingSubmitCreateHero.
  ///
  /// In en, this message translates to:
  /// **'Create hero'**
  String get onboardingSubmitCreateHero;

  /// No description provided for @onboardingDefaultHero.
  ///
  /// In en, this message translates to:
  /// **'Young hero'**
  String get onboardingDefaultHero;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a hero'**
  String get onboardingTitle;

  /// No description provided for @onboardingHeroSummary.
  ///
  /// In en, this message translates to:
  /// **'{name}, {age}'**
  String onboardingHeroSummary(Object age, Object name);

  /// No description provided for @onboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The lion will show the daily mission, then your child can choose brain training.'**
  String get onboardingSubtitle;

  /// No description provided for @childNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Child name'**
  String get childNameLabel;

  /// No description provided for @childNameError.
  ///
  /// In en, this message translates to:
  /// **'Enter hero name'**
  String get childNameError;

  /// No description provided for @onboardingMissionPill.
  ///
  /// In en, this message translates to:
  /// **'mission start'**
  String get onboardingMissionPill;

  /// No description provided for @onboardingAgeTitle.
  ///
  /// In en, this message translates to:
  /// **'Hero age'**
  String get onboardingAgeTitle;

  /// No description provided for @unlockMission.
  ///
  /// In en, this message translates to:
  /// **'Mission'**
  String get unlockMission;

  /// No description provided for @unlockGames.
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get unlockGames;

  /// No description provided for @unlockPrizes.
  ///
  /// In en, this message translates to:
  /// **'Prizes'**
  String get unlockPrizes;

  /// No description provided for @ageYears.
  ///
  /// In en, this message translates to:
  /// **'{years} years'**
  String ageYears(int years);

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi,\n{name}'**
  String homeGreeting(Object name);

  /// No description provided for @homeStarsHint.
  ///
  /// In en, this message translates to:
  /// **'Stars grow from missions and unlock new prizes.'**
  String get homeStarsHint;

  /// No description provided for @homeLockedLevelHint.
  ///
  /// In en, this message translates to:
  /// **'This level opens after new stars.'**
  String get homeLockedLevelHint;

  /// No description provided for @homeStreakSavedHint.
  ///
  /// In en, this message translates to:
  /// **'Streak saved! A new mission arrives tomorrow.'**
  String get homeStreakSavedHint;

  /// No description provided for @homeStreakNeedMissionHint.
  ///
  /// In en, this message translates to:
  /// **'Complete the daily mission to save the streak.'**
  String get homeStreakNeedMissionHint;

  /// No description provided for @homeStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily streak'**
  String get homeStreakTitle;

  /// No description provided for @homeStreakDays.
  ///
  /// In en, this message translates to:
  /// **'{days} days in a row!'**
  String homeStreakDays(int days);

  /// No description provided for @homeStreakWaiting.
  ///
  /// In en, this message translates to:
  /// **'mission is waiting'**
  String get homeStreakWaiting;

  /// No description provided for @homeMissionDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily mission'**
  String get homeMissionDaily;

  /// No description provided for @homeMissionFreePlay.
  ///
  /// In en, this message translates to:
  /// **'Free play'**
  String get homeMissionFreePlay;

  /// No description provided for @homeTrainingOpen.
  ///
  /// In en, this message translates to:
  /// **'Training is open'**
  String get homeTrainingOpen;

  /// No description provided for @homeLevel.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String homeLevel(int level);

  /// No description provided for @homeMissionStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get homeMissionStart;

  /// No description provided for @homeMissionChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get homeMissionChoose;

  /// No description provided for @homeMissionTag.
  ///
  /// In en, this message translates to:
  /// **'Main mission'**
  String get homeMissionTag;

  /// No description provided for @homeFreePlayTitle.
  ///
  /// In en, this message translates to:
  /// **'Play yourself'**
  String get homeFreePlayTitle;

  /// No description provided for @homeFreePlaySubtitle.
  ///
  /// In en, this message translates to:
  /// **'choose a hero and train your brain'**
  String get homeFreePlaySubtitle;

  /// No description provided for @homeMiniGamesTitle.
  ///
  /// In en, this message translates to:
  /// **'Mini-games'**
  String get homeMiniGamesTitle;

  /// No description provided for @homeMiniGamesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'quick training after levels'**
  String get homeMiniGamesSubtitle;

  /// No description provided for @homeQuickPairs.
  ///
  /// In en, this message translates to:
  /// **'Pairs'**
  String get homeQuickPairs;

  /// No description provided for @homeQuickPath.
  ///
  /// In en, this message translates to:
  /// **'Path'**
  String get homeQuickPath;

  /// No description provided for @homeQuickCount.
  ///
  /// In en, this message translates to:
  /// **'Count'**
  String get homeQuickCount;

  /// No description provided for @homeProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'My progress'**
  String get homeProgressTitle;

  /// No description provided for @homeProgressStars.
  ///
  /// In en, this message translates to:
  /// **'{current} / {total} stars'**
  String homeProgressStars(int current, int total);

  /// No description provided for @homeCollectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Collection'**
  String get homeCollectionTitle;

  /// No description provided for @homeCollectionStickers.
  ///
  /// In en, this message translates to:
  /// **'stickers'**
  String get homeCollectionStickers;

  /// No description provided for @homeLevelsTitle.
  ///
  /// In en, this message translates to:
  /// **'Levels'**
  String get homeLevelsTitle;

  /// No description provided for @homeLevelsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'8 training themes, not a calendar'**
  String get homeLevelsSubtitle;

  /// No description provided for @homeNodeCompleted.
  ///
  /// In en, this message translates to:
  /// **'done'**
  String get homeNodeCompleted;

  /// No description provided for @homeNodePlay.
  ///
  /// In en, this message translates to:
  /// **'play'**
  String get homeNodePlay;

  /// No description provided for @homeNodeSoon.
  ///
  /// In en, this message translates to:
  /// **'soon'**
  String get homeNodeSoon;

  /// No description provided for @homeMapStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get homeMapStart;

  /// No description provided for @homeMapShapes.
  ///
  /// In en, this message translates to:
  /// **'Shapes'**
  String get homeMapShapes;

  /// No description provided for @homeMapPairs.
  ///
  /// In en, this message translates to:
  /// **'Pairs'**
  String get homeMapPairs;

  /// No description provided for @homeMapCount.
  ///
  /// In en, this message translates to:
  /// **'Count'**
  String get homeMapCount;

  /// No description provided for @homeMapPath.
  ///
  /// In en, this message translates to:
  /// **'Path'**
  String get homeMapPath;

  /// No description provided for @homeMapRhythm.
  ///
  /// In en, this message translates to:
  /// **'Rhythm'**
  String get homeMapRhythm;

  /// No description provided for @homeMapCompare.
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get homeMapCompare;

  /// No description provided for @homeMapFinal.
  ///
  /// In en, this message translates to:
  /// **'Final'**
  String get homeMapFinal;

  /// No description provided for @parentTitle.
  ///
  /// In en, this message translates to:
  /// **'Parent area'**
  String get parentTitle;

  /// No description provided for @parentIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Calm zone for adults'**
  String get parentIntroTitle;

  /// No description provided for @parentIntroBody.
  ///
  /// In en, this message translates to:
  /// **'Profile, progress, language and future subscription live separately from the child mission.'**
  String get parentIntroBody;

  /// No description provided for @parentProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Family profile'**
  String get parentProfileTitle;

  /// No description provided for @parentLocalBadge.
  ///
  /// In en, this message translates to:
  /// **'local'**
  String get parentLocalBadge;

  /// No description provided for @parentChildLabel.
  ///
  /// In en, this message translates to:
  /// **'Child'**
  String get parentChildLabel;

  /// No description provided for @parentAgeLabel.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get parentAgeLabel;

  /// No description provided for @parentCompletedTasksLabel.
  ///
  /// In en, this message translates to:
  /// **'Tasks completed'**
  String get parentCompletedTasksLabel;

  /// No description provided for @parentLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get parentLanguageLabel;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get settingsLanguage;

  /// No description provided for @parentSubscriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Family subscription'**
  String get parentSubscriptionTitle;

  /// No description provided for @parentSubscriptionSoon.
  ///
  /// In en, this message translates to:
  /// **'soon'**
  String get parentSubscriptionSoon;

  /// No description provided for @parentSubscriptionBody.
  ///
  /// In en, this message translates to:
  /// **'Payment status, family seats and plan management will appear here.'**
  String get parentSubscriptionBody;

  /// No description provided for @parentFamilySeatsLabel.
  ///
  /// In en, this message translates to:
  /// **'Family seats'**
  String get parentFamilySeatsLabel;

  /// No description provided for @parentFamilySeatsValue.
  ///
  /// In en, this message translates to:
  /// **'planned'**
  String get parentFamilySeatsValue;

  /// No description provided for @parentPaymentLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get parentPaymentLabel;

  /// No description provided for @parentPaymentValue.
  ///
  /// In en, this message translates to:
  /// **'not connected'**
  String get parentPaymentValue;

  /// No description provided for @parentResetProfile.
  ///
  /// In en, this message translates to:
  /// **'Reset profile'**
  String get parentResetProfile;

  /// No description provided for @parentResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset profile?'**
  String get parentResetTitle;

  /// No description provided for @parentResetBody.
  ///
  /// In en, this message translates to:
  /// **'Onboarding will open again and local progress will be cleared.'**
  String get parentResetBody;

  /// No description provided for @challengeTitle.
  ///
  /// In en, this message translates to:
  /// **'Brain games'**
  String get challengeTitle;

  /// No description provided for @challengeDayDone.
  ///
  /// In en, this message translates to:
  /// **'Day complete'**
  String get challengeDayDone;

  /// No description provided for @challengeDailyMission.
  ///
  /// In en, this message translates to:
  /// **'Daily mission'**
  String get challengeDailyMission;

  /// No description provided for @challengeDayDoneBody.
  ///
  /// In en, this message translates to:
  /// **'Reward received. You can repeat or play freely.'**
  String get challengeDayDoneBody;

  /// No description provided for @challengeDailyBody.
  ///
  /// In en, this message translates to:
  /// **'Complete 3 steps to save the streak and collect the prize.'**
  String get challengeDailyBody;

  /// No description provided for @challengePrize.
  ///
  /// In en, this message translates to:
  /// **'prize'**
  String get challengePrize;

  /// No description provided for @challengeMissionProgress.
  ///
  /// In en, this message translates to:
  /// **'Mission progress'**
  String get challengeMissionProgress;

  /// No description provided for @countOfTotal.
  ///
  /// In en, this message translates to:
  /// **'{count} of {total}'**
  String countOfTotal(int count, int total);

  /// No description provided for @challengeRepeatMission.
  ///
  /// In en, this message translates to:
  /// **'Repeat mission'**
  String get challengeRepeatMission;

  /// No description provided for @challengeStepsTraining.
  ///
  /// In en, this message translates to:
  /// **'{steps} steps for training'**
  String challengeStepsTraining(int steps);

  /// No description provided for @challengeStepNumber.
  ///
  /// In en, this message translates to:
  /// **'Step {step}'**
  String challengeStepNumber(int step);

  /// No description provided for @challengeAgain.
  ///
  /// In en, this message translates to:
  /// **'again'**
  String get challengeAgain;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String minutesShort(int minutes);

  /// No description provided for @challengeBrainGymTitle.
  ///
  /// In en, this message translates to:
  /// **'Brain gym'**
  String get challengeBrainGymTitle;

  /// No description provided for @challengeBrainGymSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} areas, play in any order'**
  String challengeBrainGymSubtitle(int count);

  /// No description provided for @challengeAreaLevels.
  ///
  /// In en, this message translates to:
  /// **'{done}/{total} levels'**
  String challengeAreaLevels(int done, int total);

  /// No description provided for @challengeAreaCompleted.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} complete'**
  String challengeAreaCompleted(int done, int total);

  /// No description provided for @challengeStateCompleted.
  ///
  /// In en, this message translates to:
  /// **'done'**
  String get challengeStateCompleted;

  /// No description provided for @challengeStateNext.
  ///
  /// In en, this message translates to:
  /// **'next'**
  String get challengeStateNext;

  /// No description provided for @challengeStatePlay.
  ///
  /// In en, this message translates to:
  /// **'play'**
  String get challengeStatePlay;

  /// No description provided for @challengeLevelNumber.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String challengeLevelNumber(int level);

  /// No description provided for @challengeHideHint.
  ///
  /// In en, this message translates to:
  /// **'Hide hint'**
  String get challengeHideHint;

  /// No description provided for @challengeShowHint.
  ///
  /// In en, this message translates to:
  /// **'Show hint'**
  String get challengeShowHint;

  /// No description provided for @challengeDailyTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily task'**
  String get challengeDailyTaskTitle;

  /// No description provided for @challengePuzzleTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Puzzle'**
  String get challengePuzzleTaskTitle;

  /// No description provided for @challengeDailyPath.
  ///
  /// In en, this message translates to:
  /// **'Daily path'**
  String get challengeDailyPath;

  /// No description provided for @challengeFreePlay.
  ///
  /// In en, this message translates to:
  /// **'Free play'**
  String get challengeFreePlay;

  /// No description provided for @challengeExcellent.
  ///
  /// In en, this message translates to:
  /// **'Great!'**
  String get challengeExcellent;

  /// No description provided for @challengeFlyNext.
  ///
  /// In en, this message translates to:
  /// **'Flying next'**
  String get challengeFlyNext;

  /// No description provided for @challengeAllDone.
  ///
  /// In en, this message translates to:
  /// **'All set'**
  String get challengeAllDone;

  /// No description provided for @challengePlayMore.
  ///
  /// In en, this message translates to:
  /// **'Play more'**
  String get challengePlayMore;

  /// No description provided for @challengeMyCollection.
  ///
  /// In en, this message translates to:
  /// **'My collection'**
  String get challengeMyCollection;

  /// No description provided for @challengeDailyCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily mission complete!'**
  String get challengeDailyCompleteTitle;

  /// No description provided for @challengeDailyCompleteBody.
  ///
  /// In en, this message translates to:
  /// **'You finished all steps. Collect the prize and play freely.'**
  String get challengeDailyCompleteBody;

  /// No description provided for @challengeRewardStars.
  ///
  /// In en, this message translates to:
  /// **'stars'**
  String get challengeRewardStars;

  /// No description provided for @challengeRewardStreak.
  ///
  /// In en, this message translates to:
  /// **'streak'**
  String get challengeRewardStreak;

  /// No description provided for @challengeRewardSteps.
  ///
  /// In en, this message translates to:
  /// **'steps'**
  String get challengeRewardSteps;

  /// No description provided for @challengeWhatNextTitle.
  ///
  /// In en, this message translates to:
  /// **'What next?'**
  String get challengeWhatNextTitle;

  /// No description provided for @challengeWhatNextBody.
  ///
  /// In en, this message translates to:
  /// **'Choose a hero: logic, memory, attention, count or path.'**
  String get challengeWhatNextBody;

  /// No description provided for @challengeProgressStep.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String challengeProgressStep(int current, int total);

  /// No description provided for @challengeChooseAnswer.
  ///
  /// In en, this message translates to:
  /// **'Choose an answer'**
  String get challengeChooseAnswer;

  /// No description provided for @challengeSelectedAnswer.
  ///
  /// In en, this message translates to:
  /// **'Answer: {answer}'**
  String challengeSelectedAnswer(Object answer);

  /// No description provided for @challengePickDifferentAnswer.
  ///
  /// In en, this message translates to:
  /// **'Choose another answer'**
  String get challengePickDifferentAnswer;

  /// No description provided for @challengeCorrectAnswer.
  ///
  /// In en, this message translates to:
  /// **'Correct!'**
  String get challengeCorrectAnswer;

  /// No description provided for @challengeChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking'**
  String get challengeChecking;

  /// No description provided for @challengeCheck.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get challengeCheck;

  /// No description provided for @challengeCorrectFeedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Great!'**
  String get challengeCorrectFeedbackTitle;

  /// No description provided for @challengeRetryFeedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Almost there'**
  String get challengeRetryFeedbackTitle;

  /// No description provided for @challengeCorrectFeedbackText.
  ///
  /// In en, this message translates to:
  /// **'The answer is correct. Moving on!'**
  String get challengeCorrectFeedbackText;

  /// No description provided for @hintLogic.
  ///
  /// In en, this message translates to:
  /// **'The rule repeats. Find the start of the next repeat and continue the row.'**
  String get hintLogic;

  /// No description provided for @hintMemory.
  ///
  /// In en, this message translates to:
  /// **'First remember which pictures were opened. Then look for the matching pair.'**
  String get hintMemory;

  /// No description provided for @hintAttention.
  ///
  /// In en, this message translates to:
  /// **'Compare details one by one: color, shape, size and place.'**
  String get hintAttention;

  /// No description provided for @hintMath.
  ///
  /// In en, this message translates to:
  /// **'Count in small groups so it is easier not to lose track.'**
  String get hintMath;

  /// No description provided for @hintSpace.
  ///
  /// In en, this message translates to:
  /// **'Follow the path from start to finish and name the next turn.'**
  String get hintSpace;

  /// No description provided for @collectionTitle.
  ///
  /// In en, this message translates to:
  /// **'My collection'**
  String get collectionTitle;

  /// No description provided for @collectionDayPrize.
  ///
  /// In en, this message translates to:
  /// **'Day prize'**
  String get collectionDayPrize;

  /// No description provided for @collectionCosmoPrizes.
  ///
  /// In en, this message translates to:
  /// **'Space prizes'**
  String get collectionCosmoPrizes;

  /// No description provided for @collectionUnlocked.
  ///
  /// In en, this message translates to:
  /// **'{unlocked} of {total} open'**
  String collectionUnlocked(int total, int unlocked);

  /// No description provided for @collectionNewPrizeTitle.
  ///
  /// In en, this message translates to:
  /// **'New day prize'**
  String get collectionNewPrizeTitle;

  /// No description provided for @collectionNewPrizeBody.
  ///
  /// In en, this message translates to:
  /// **'Astronaut added to the collection.'**
  String get collectionNewPrizeBody;

  /// No description provided for @collectionSnackUnlocked.
  ///
  /// In en, this message translates to:
  /// **'{title} is already in the collection.'**
  String collectionSnackUnlocked(Object title);

  /// No description provided for @collectionSnackLocked.
  ///
  /// In en, this message translates to:
  /// **'Opens after new levels.'**
  String get collectionSnackLocked;

  /// No description provided for @collectionNewBadge.
  ///
  /// In en, this message translates to:
  /// **'new'**
  String get collectionNewBadge;

  /// No description provided for @collectionLockedLevel.
  ///
  /// In en, this message translates to:
  /// **'{level} lvl.'**
  String collectionLockedLevel(int level);

  /// No description provided for @parentOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Parent overview'**
  String get parentOverviewTitle;

  /// No description provided for @parentOverviewBody.
  ///
  /// In en, this message translates to:
  /// **'Profile {name}, progress, today\'s plan, and tips for practice at home.'**
  String parentOverviewBody(String name);

  /// No description provided for @parentStarsCount.
  ///
  /// In en, this message translates to:
  /// **'{stars} stars'**
  String parentStarsCount(int stars);

  /// No description provided for @parentMissionClosed.
  ///
  /// In en, this message translates to:
  /// **'mission done'**
  String get parentMissionClosed;

  /// No description provided for @parentMissionWaiting.
  ///
  /// In en, this message translates to:
  /// **'mission waiting'**
  String get parentMissionWaiting;

  /// No description provided for @parentProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Child progress'**
  String get parentProgressTitle;

  /// No description provided for @parentOverviewBadge.
  ///
  /// In en, this message translates to:
  /// **'overview'**
  String get parentOverviewBadge;

  /// No description provided for @parentLevelsLabel.
  ///
  /// In en, this message translates to:
  /// **'Levels'**
  String get parentLevelsLabel;

  /// No description provided for @parentLevelsValue.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total}'**
  String parentLevelsValue(int completed, int total);

  /// No description provided for @parentTodayLabel.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get parentTodayLabel;

  /// No description provided for @parentTodayValue.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total}'**
  String parentTodayValue(int done, int total);

  /// No description provided for @parentStarsLabel.
  ///
  /// In en, this message translates to:
  /// **'Stars'**
  String get parentStarsLabel;

  /// No description provided for @parentContentLabel.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get parentContentLabel;

  /// No description provided for @parentContentValue.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total}'**
  String parentContentValue(int done, int total);

  /// No description provided for @parentTodayPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s plan'**
  String get parentTodayPlanTitle;

  /// No description provided for @parentTodayPlanBody.
  ///
  /// In en, this message translates to:
  /// **'A short series without pressure: 2-3 calm tries are better than one long tired session.'**
  String get parentTodayPlanBody;

  /// No description provided for @parentPuzzleMeta.
  ///
  /// In en, this message translates to:
  /// **'{skill} • {minutes} min'**
  String parentPuzzleMeta(String skill, int minutes);

  /// No description provided for @parentAreasTitle.
  ///
  /// In en, this message translates to:
  /// **'Development areas'**
  String get parentAreasTitle;

  /// No description provided for @parentBalanceBadge.
  ///
  /// In en, this message translates to:
  /// **'balance'**
  String get parentBalanceBadge;

  /// No description provided for @parentAreasBody.
  ///
  /// In en, this message translates to:
  /// **'This is an adult map: children should see missions and heroes, not dry categories.'**
  String get parentAreasBody;

  /// No description provided for @parentRecommendationDone.
  ///
  /// In en, this message translates to:
  /// **'Today\'s mission is done. This is a good moment to praise effort, not speed.'**
  String get parentRecommendationDone;

  /// No description provided for @parentRecommendationRemaining.
  ///
  /// In en, this message translates to:
  /// **'There is progress today: {remaining} tasks left.'**
  String parentRecommendationRemaining(int remaining);

  /// No description provided for @parentRecommendationStart.
  ///
  /// In en, this message translates to:
  /// **'Today, start with one short 4-6 minute mission.'**
  String get parentRecommendationStart;

  /// No description provided for @parentRecommendationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get parentRecommendationsTitle;

  /// No description provided for @parentHomeBadge.
  ///
  /// In en, this message translates to:
  /// **'at home'**
  String get parentHomeBadge;

  /// No description provided for @parentPaceLabel.
  ///
  /// In en, this message translates to:
  /// **'Pace'**
  String get parentPaceLabel;

  /// No description provided for @parentWeekFocusLabel.
  ///
  /// In en, this message translates to:
  /// **'Week focus'**
  String get parentWeekFocusLabel;

  /// No description provided for @parentFocusArea.
  ///
  /// In en, this message translates to:
  /// **'The area that needs the most attention now is \"{areaTitle}\": {areaSubtitle}.'**
  String parentFocusArea(String areaTitle, String areaSubtitle);

  /// No description provided for @parentDiscussLabel.
  ///
  /// In en, this message translates to:
  /// **'How to discuss'**
  String get parentDiscussLabel;

  /// No description provided for @parentDiscussBody.
  ///
  /// In en, this message translates to:
  /// **'After a task, ask: \"How did you find the rule?\" This builds explanation, not guessing.'**
  String get parentDiscussBody;

  /// No description provided for @parentFamilySecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'Family and safety'**
  String get parentFamilySecurityTitle;

  /// No description provided for @parentStorageLabel.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get parentStorageLabel;

  /// No description provided for @parentStorageLocal.
  ///
  /// In en, this message translates to:
  /// **'on device'**
  String get parentStorageLocal;

  /// No description provided for @notificationDailyTitle.
  ///
  /// In en, this message translates to:
  /// **'A new mission is waiting'**
  String get notificationDailyTitle;

  /// No description provided for @notificationDailyBody.
  ///
  /// In en, this message translates to:
  /// **'{name}, solve one small puzzle and keep the star streak glowing.'**
  String notificationDailyBody(String name);

  /// No description provided for @notificationEveningTitle.
  ///
  /// In en, this message translates to:
  /// **'One step before bedtime?'**
  String get notificationEveningTitle;

  /// No description provided for @notificationEveningBody.
  ///
  /// In en, this message translates to:
  /// **'{name} has a short mission left. 5 calm minutes are enough.'**
  String notificationEveningBody(String name);

  /// No description provided for @parentRemindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get parentRemindersTitle;

  /// No description provided for @parentReminderStatusOn.
  ///
  /// In en, this message translates to:
  /// **'on'**
  String get parentReminderStatusOn;

  /// No description provided for @parentReminderStatusOff.
  ///
  /// In en, this message translates to:
  /// **'off'**
  String get parentReminderStatusOff;

  /// No description provided for @parentRemindersBody.
  ///
  /// In en, this message translates to:
  /// **'A gentle daily nudge helps return to the mission without pressure.'**
  String get parentRemindersBody;

  /// No description provided for @parentReminderDailyLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily mission'**
  String get parentReminderDailyLabel;

  /// No description provided for @parentReminderDailyValue.
  ///
  /// In en, this message translates to:
  /// **'18:30 every day'**
  String get parentReminderDailyValue;

  /// No description provided for @parentReminderFollowUpLabel.
  ///
  /// In en, this message translates to:
  /// **'Evening follow-up'**
  String get parentReminderFollowUpLabel;

  /// No description provided for @parentReminderFollowUpValue.
  ///
  /// In en, this message translates to:
  /// **'20:15 if the mission is waiting'**
  String get parentReminderFollowUpValue;

  /// No description provided for @parentReminderToggleLabel.
  ///
  /// In en, this message translates to:
  /// **'Return reminders'**
  String get parentReminderToggleLabel;

  /// No description provided for @parentReminderToggleOn.
  ///
  /// In en, this message translates to:
  /// **'LogicUpX will invite the child back to one short mission.'**
  String get parentReminderToggleOn;

  /// No description provided for @parentReminderToggleOff.
  ///
  /// In en, this message translates to:
  /// **'Reminders are off. The app will stay quiet.'**
  String get parentReminderToggleOff;

  /// No description provided for @parentAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get parentAccountTitle;

  /// No description provided for @parentAccountBody.
  ///
  /// In en, this message translates to:
  /// **'Sign in to sync progress, unlock subscriptions and restore purchases on another device.'**
  String get parentAccountBody;

  /// No description provided for @parentAccountStatusGuest.
  ///
  /// In en, this message translates to:
  /// **'guest'**
  String get parentAccountStatusGuest;

  /// No description provided for @parentAccountAction.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get parentAccountAction;

  /// No description provided for @accountTitle.
  ///
  /// In en, this message translates to:
  /// **'Account sign in'**
  String get accountTitle;

  /// No description provided for @accountHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Keep the family profile close'**
  String get accountHeroTitle;

  /// No description provided for @accountHeroBody.
  ///
  /// In en, this message translates to:
  /// **'Use Google, Apple or email to prepare cloud sync, purchases and safe parent access.'**
  String get accountHeroBody;

  /// No description provided for @accountStatusGuest.
  ///
  /// In en, this message translates to:
  /// **'guest mode'**
  String get accountStatusGuest;

  /// No description provided for @accountAppleButton.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get accountAppleButton;

  /// No description provided for @accountGoogleButton.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get accountGoogleButton;

  /// No description provided for @accountAuthLoading.
  ///
  /// In en, this message translates to:
  /// **'Checking...'**
  String get accountAuthLoading;

  /// No description provided for @accountProviderGoogle.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get accountProviderGoogle;

  /// No description provided for @accountProviderApple.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get accountProviderApple;

  /// No description provided for @accountProviderEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get accountProviderEmail;

  /// No description provided for @accountSignedInTitle.
  ///
  /// In en, this message translates to:
  /// **'Signed in'**
  String get accountSignedInTitle;

  /// No description provided for @accountSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get accountSignOut;

  /// No description provided for @accountGoogleSuccessSnack.
  ///
  /// In en, this message translates to:
  /// **'Signed in with Google.'**
  String get accountGoogleSuccessSnack;

  /// No description provided for @accountGoogleCanceledSnack.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in was canceled.'**
  String get accountGoogleCanceledSnack;

  /// No description provided for @accountGoogleUnsupportedSnack.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in is not supported on this platform yet.'**
  String get accountGoogleUnsupportedSnack;

  /// No description provided for @accountGoogleConfigSnack.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in needs OAuth client configuration for this app.'**
  String get accountGoogleConfigSnack;

  /// No description provided for @accountGoogleErrorSnack.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in failed: {error}'**
  String accountGoogleErrorSnack(Object error);

  /// No description provided for @accountBenefitGoogleTitle.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in'**
  String get accountBenefitGoogleTitle;

  /// No description provided for @accountBenefitGoogleBody.
  ///
  /// In en, this message translates to:
  /// **'Use a Google account for quick parent access once OAuth is configured.'**
  String get accountBenefitGoogleBody;

  /// No description provided for @accountEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Email access'**
  String get accountEmailTitle;

  /// No description provided for @accountSignInTab.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get accountSignInTab;

  /// No description provided for @accountCreateTab.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get accountCreateTab;

  /// No description provided for @accountEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get accountEmailLabel;

  /// No description provided for @accountPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get accountPasswordLabel;

  /// No description provided for @accountConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get accountConfirmPasswordLabel;

  /// No description provided for @accountRememberDevice.
  ///
  /// In en, this message translates to:
  /// **'Remember this device'**
  String get accountRememberDevice;

  /// No description provided for @accountSubmitSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get accountSubmitSignIn;

  /// No description provided for @accountSubmitCreate.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get accountSubmitCreate;

  /// No description provided for @accountForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get accountForgotPassword;

  /// No description provided for @accountRestorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get accountRestorePurchases;

  /// No description provided for @accountPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'Children keep playing locally until account services are connected.'**
  String get accountPrivacyNote;

  /// No description provided for @accountBenefitSyncTitle.
  ///
  /// In en, this message translates to:
  /// **'Progress sync'**
  String get accountBenefitSyncTitle;

  /// No description provided for @accountBenefitSyncBody.
  ///
  /// In en, this message translates to:
  /// **'A signed-in profile can later move stars and practice history between devices.'**
  String get accountBenefitSyncBody;

  /// No description provided for @accountBenefitAppleTitle.
  ///
  /// In en, this message translates to:
  /// **'Apple sign-in ready'**
  String get accountBenefitAppleTitle;

  /// No description provided for @accountBenefitAppleBody.
  ///
  /// In en, this message translates to:
  /// **'The button is in place for Sign in with Apple credentials.'**
  String get accountBenefitAppleBody;

  /// No description provided for @accountBenefitPurchaseTitle.
  ///
  /// In en, this message translates to:
  /// **'Purchases and subscriptions'**
  String get accountBenefitPurchaseTitle;

  /// No description provided for @accountBenefitPurchaseBody.
  ///
  /// In en, this message translates to:
  /// **'Restore access after reinstalling or changing devices.'**
  String get accountBenefitPurchaseBody;

  /// No description provided for @accountEmailError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get accountEmailError;

  /// No description provided for @accountPasswordError.
  ///
  /// In en, this message translates to:
  /// **'Use at least 6 characters'**
  String get accountPasswordError;

  /// No description provided for @accountPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get accountPasswordMismatch;

  /// No description provided for @accountDemoSnack.
  ///
  /// In en, this message translates to:
  /// **'Signed in with email locally. Connect a backend to verify passwords on the server.'**
  String get accountDemoSnack;

  /// No description provided for @accountAppleSnack.
  ///
  /// In en, this message translates to:
  /// **'Apple sign-in UI is ready for the native auth handler.'**
  String get accountAppleSnack;

  /// No description provided for @accountRestoreSnack.
  ///
  /// In en, this message translates to:
  /// **'Purchase restore UI is ready for StoreKit.'**
  String get accountRestoreSnack;

  /// No description provided for @accountResetDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get accountResetDialogTitle;

  /// No description provided for @accountResetDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Password reset emails will be sent after account backend is connected.'**
  String get accountResetDialogBody;

  /// No description provided for @accountResetDialogAction.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get accountResetDialogAction;
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
