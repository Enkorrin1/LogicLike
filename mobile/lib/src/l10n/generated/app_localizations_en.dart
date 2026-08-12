// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Logic Loka';

  @override
  String get loadingMission => 'Preparing the mission...';

  @override
  String get navHome => 'Home';

  @override
  String get navChallenge => 'Task';

  @override
  String get navParent => 'Parent';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonReset => 'Reset';

  @override
  String languageChanged(Object language) {
    return 'Language: $language';
  }

  @override
  String languageButtonSemantics(Object language) {
    return 'Change language. Current: $language';
  }

  @override
  String get onboardingSubmitSaving => 'Preparing route';

  @override
  String get onboardingSubmitCreateHero => 'Create hero';

  @override
  String get onboardingDefaultHero => 'Young hero';

  @override
  String get onboardingTitle => 'Create a hero';

  @override
  String onboardingHeroSummary(Object age, Object name) {
    return '$name, $age';
  }

  @override
  String get onboardingSubtitle =>
      'The lion will show the daily mission, then your child can choose brain training.';

  @override
  String get childNameLabel => 'Child name';

  @override
  String get childNameError => 'Enter hero name';

  @override
  String get onboardingMissionPill => 'mission start';

  @override
  String get onboardingAgeTitle => 'Hero age';

  @override
  String get unlockMission => 'Mission';

  @override
  String get unlockGames => 'Games';

  @override
  String get unlockPrizes => 'Prizes';

  @override
  String ageYears(int years) {
    return '$years years';
  }

  @override
  String homeGreeting(Object name) {
    return 'Hi,\n$name';
  }

  @override
  String get homeStarsHint => 'Stars grow from missions and unlock new prizes.';

  @override
  String get homeLockedLevelHint => 'This level opens after new stars.';

  @override
  String get homeStreakSavedHint =>
      'Streak saved! A new mission arrives tomorrow.';

  @override
  String get homeStreakNeedMissionHint =>
      'Complete the daily mission to save the streak.';

  @override
  String get homeStreakTitle => 'Daily streak';

  @override
  String homeStreakDays(int days) {
    return '$days days in a row!';
  }

  @override
  String get homeStreakWaiting => 'mission is waiting';

  @override
  String get homeMissionDaily => 'Daily mission';

  @override
  String get homeMissionFreePlay => 'Free play';

  @override
  String get homeTrainingOpen => 'Training is open';

  @override
  String homeLevel(int level) {
    return 'Level $level';
  }

  @override
  String get homeMissionStart => 'Start';

  @override
  String get homeMissionChoose => 'Choose';

  @override
  String get homeMissionTag => 'Main mission';

  @override
  String get homeFreePlayTitle => 'Play yourself';

  @override
  String get homeFreePlaySubtitle => 'choose a hero and train your brain';

  @override
  String get homeMiniGamesTitle => 'Mini-games';

  @override
  String get homeMiniGamesSubtitle => 'quick training after levels';

  @override
  String get homeQuickPairs => 'Pairs';

  @override
  String get homeQuickPath => 'Path';

  @override
  String get homeQuickCount => 'Count';

  @override
  String get homeProgressTitle => 'My progress';

  @override
  String homeProgressStars(int current, int total) {
    return '$current / $total stars';
  }

  @override
  String get homeCollectionTitle => 'Collection';

  @override
  String get homeCollectionStickers => 'stickers';

  @override
  String get homeLevelsTitle => 'Levels';

  @override
  String get homeLevelsSubtitle => '8 training themes, not a calendar';

  @override
  String get homeNodeCompleted => 'done';

  @override
  String get homeNodePlay => 'play';

  @override
  String get homeNodeSoon => 'soon';

  @override
  String get homeMapStart => 'Start';

  @override
  String get homeMapShapes => 'Shapes';

  @override
  String get homeMapPairs => 'Pairs';

  @override
  String get homeMapCount => 'Count';

  @override
  String get homeMapPath => 'Path';

  @override
  String get homeMapRhythm => 'Rhythm';

  @override
  String get homeMapCompare => 'Compare';

  @override
  String get homeMapFinal => 'Final';

  @override
  String get parentTitle => 'Parent area';

  @override
  String get parentIntroTitle => 'Calm zone for adults';

  @override
  String get parentIntroBody =>
      'Profile, progress, language and future subscription live separately from the child mission.';

  @override
  String get parentProfileTitle => 'Family profile';

  @override
  String get parentLocalBadge => 'local';

  @override
  String get parentChildLabel => 'Child';

  @override
  String get parentAgeLabel => 'Age';

  @override
  String get parentCompletedTasksLabel => 'Tasks completed';

  @override
  String get parentLanguageLabel => 'Language';

  @override
  String get settingsLanguage => 'App language';

  @override
  String get parentSubscriptionTitle => 'Family subscription';

  @override
  String get parentSubscriptionSoon => 'soon';

  @override
  String get parentSubscriptionBody =>
      'Launch tariff ladder: Free access, monthly Premium Family, and Annual at the early-stage price.';

  @override
  String get parentFamilySeatsLabel => 'Family seats';

  @override
  String get parentFamilySeatsValue => 'planned';

  @override
  String get parentPaymentLabel => 'Payment';

  @override
  String get parentPaymentValue => 'not connected';

  @override
  String get parentSubscriptionLaunchBadge => 'early price';

  @override
  String get parentSubscriptionCurrentFree => 'Free';

  @override
  String get parentSubscriptionFreeTitle => 'Free';

  @override
  String get parentSubscriptionFreePrice => '\$0';

  @override
  String get parentSubscriptionFreeBody =>
      'A gentle start for trying the daily loop.';

  @override
  String get parentSubscriptionFeatureDaily => 'Daily mission';

  @override
  String get parentSubscriptionFeatureStarter => 'Starter levels';

  @override
  String get parentSubscriptionFeatureLocalProgress =>
      'Local progress on this device';

  @override
  String get parentSubscriptionFreeCta => 'Current access';

  @override
  String get parentSubscriptionPremiumTitle => 'Premium Family';

  @override
  String get parentSubscriptionPremiumPrice => '\$5.99/mo';

  @override
  String get parentSubscriptionPremiumBadge => 'launch price';

  @override
  String get parentSubscriptionPremiumBody =>
      'Full family access while the content library is still growing.';

  @override
  String get parentSubscriptionFeatureAllLevels => 'All current and new levels';

  @override
  String get parentSubscriptionFeatureParentTips => 'Parent recommendations';

  @override
  String get parentSubscriptionFeaturePurchaseRestore =>
      'Prepared for purchase restore';

  @override
  String get parentSubscriptionPremiumCta => 'Choose monthly';

  @override
  String get parentSubscriptionAnnualTitle => 'Annual';

  @override
  String get parentSubscriptionAnnualPrice => '\$39.99/year';

  @override
  String get parentSubscriptionAnnualBadge => 'best value';

  @override
  String get parentSubscriptionAnnualBody =>
      'Premium Family for a year at the early-stage annual price.';

  @override
  String get parentSubscriptionFeatureAnnualValue =>
      'Lower than 12 monthly payments';

  @override
  String get parentSubscriptionFeatureYearAccess =>
      '12 months of family access';

  @override
  String get parentSubscriptionFeatureUpdatesIncluded =>
      'New levels included during the year';

  @override
  String get parentSubscriptionAnnualCta => 'Choose annual';

  @override
  String get parentSubscriptionFuturePriceNote =>
      'Later, when there are many high-quality levels: \$7.99/mo and \$49.99/year.';

  @override
  String get parentSubscriptionBillingSoonSnack =>
      'Billing is not connected yet. These plans are ready for StoreKit and Google Play Billing.';

  @override
  String get parentResetProfile => 'Reset profile';

  @override
  String get parentResetTitle => 'Reset profile?';

  @override
  String get parentResetBody =>
      'Onboarding will open again and local progress will be cleared.';

  @override
  String get challengeTitle => 'Brain games';

  @override
  String get challengeDayDone => 'Day complete';

  @override
  String get challengeDailyMission => 'Daily mission';

  @override
  String get challengeDayDoneBody =>
      'Reward received. You can repeat or play freely.';

  @override
  String get challengeDailyBody =>
      'Complete 3 steps to save the streak and collect the prize.';

  @override
  String get challengePrize => 'prize';

  @override
  String get challengeMissionProgress => 'Mission progress';

  @override
  String countOfTotal(int count, int total) {
    return '$count of $total';
  }

  @override
  String get challengeRepeatMission => 'Repeat mission';

  @override
  String challengeStepsTraining(int steps) {
    return '$steps steps for training';
  }

  @override
  String challengeStepNumber(int step) {
    return 'Step $step';
  }

  @override
  String get challengeAgain => 'again';

  @override
  String minutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String get challengeBrainGymTitle => 'Brain gym';

  @override
  String challengeBrainGymSubtitle(int count) {
    return '$count areas, play in any order';
  }

  @override
  String challengeAreaLevels(int done, int total) {
    return '$done/$total levels';
  }

  @override
  String challengeAreaCompleted(int done, int total) {
    return '$done of $total complete';
  }

  @override
  String get challengeStateCompleted => 'done';

  @override
  String get challengeStateNext => 'next';

  @override
  String get challengeStatePlay => 'play';

  @override
  String challengeLevelNumber(int level) {
    return 'Level $level';
  }

  @override
  String get challengeHideHint => 'Hide hint';

  @override
  String get challengeShowHint => 'Show hint';

  @override
  String get challengeDailyTaskTitle => 'Daily task';

  @override
  String get challengePuzzleTaskTitle => 'Puzzle';

  @override
  String get challengeDailyPath => 'Daily path';

  @override
  String get challengeFreePlay => 'Free play';

  @override
  String get challengeExcellent => 'Great!';

  @override
  String get challengeFlyNext => 'Flying next';

  @override
  String get challengeAllDone => 'All set';

  @override
  String get challengePlayMore => 'Play more';

  @override
  String get challengeMyCollection => 'My collection';

  @override
  String get challengeDailyCompleteTitle => 'Daily mission complete!';

  @override
  String get challengeDailyCompleteBody =>
      'You finished all steps. Collect the prize and play freely.';

  @override
  String get challengeRewardStars => 'stars';

  @override
  String get challengeRewardStreak => 'streak';

  @override
  String get challengeRewardSteps => 'steps';

  @override
  String get challengeWhatNextTitle => 'What next?';

  @override
  String get challengeWhatNextBody =>
      'Choose a hero: logic, memory, attention, count or path.';

  @override
  String challengeProgressStep(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get challengeChooseAnswer => 'Choose an answer';

  @override
  String challengeSelectedAnswer(Object answer) {
    return 'Answer: $answer';
  }

  @override
  String get challengePickDifferentAnswer => 'Choose another answer';

  @override
  String get challengeCorrectAnswer => 'Correct!';

  @override
  String get challengeChecking => 'Checking';

  @override
  String get challengeCheck => 'Check';

  @override
  String get challengeCorrectFeedbackTitle => 'Great!';

  @override
  String get challengeRetryFeedbackTitle => 'Almost there';

  @override
  String get challengeCorrectFeedbackText =>
      'The answer is correct. Moving on!';

  @override
  String get hintLogic =>
      'The rule repeats. Find the start of the next repeat and continue the row.';

  @override
  String get hintMemory =>
      'First remember which pictures were opened. Then look for the matching pair.';

  @override
  String get hintAttention =>
      'Compare details one by one: color, shape, size and place.';

  @override
  String get hintMath =>
      'Count in small groups so it is easier not to lose track.';

  @override
  String get hintSpace =>
      'Follow the path from start to finish and name the next turn.';

  @override
  String get collectionTitle => 'My collection';

  @override
  String get collectionDayPrize => 'Day prize';

  @override
  String get collectionCosmoPrizes => 'Space prizes';

  @override
  String collectionUnlocked(int total, int unlocked) {
    return '$unlocked of $total open';
  }

  @override
  String get collectionNewPrizeTitle => 'New day prize';

  @override
  String get collectionNewPrizeBody => 'Astronaut added to the collection.';

  @override
  String collectionSnackUnlocked(Object title) {
    return '$title is already in the collection.';
  }

  @override
  String get collectionSnackLocked => 'Opens after new levels.';

  @override
  String get collectionNewBadge => 'new';

  @override
  String collectionLockedLevel(int level) {
    return '$level lvl.';
  }

  @override
  String get parentOverviewTitle => 'Parent overview';

  @override
  String parentOverviewBody(String name) {
    return 'Profile $name, progress, today\'s plan, and tips for practice at home.';
  }

  @override
  String parentStarsCount(int stars) {
    return '$stars stars';
  }

  @override
  String get parentMissionClosed => 'mission done';

  @override
  String get parentMissionWaiting => 'mission waiting';

  @override
  String get parentProgressTitle => 'Child progress';

  @override
  String get parentOverviewBadge => 'overview';

  @override
  String get parentLevelsLabel => 'Levels';

  @override
  String parentLevelsValue(int completed, int total) {
    return '$completed of $total';
  }

  @override
  String get parentTodayLabel => 'Today';

  @override
  String parentTodayValue(int done, int total) {
    return '$done of $total';
  }

  @override
  String get parentStarsLabel => 'Stars';

  @override
  String get parentContentLabel => 'Content';

  @override
  String parentContentValue(int done, int total) {
    return '$done of $total';
  }

  @override
  String get parentTodayPlanTitle => 'Today\'s plan';

  @override
  String get parentTodayPlanBody =>
      'A short series without pressure: 2-3 calm tries are better than one long tired session.';

  @override
  String parentPuzzleMeta(String skill, int minutes) {
    return '$skill • $minutes min';
  }

  @override
  String get parentAreasTitle => 'Development areas';

  @override
  String get parentBalanceBadge => 'balance';

  @override
  String get parentAreasBody =>
      'This is an adult map: children should see missions and heroes, not dry categories.';

  @override
  String get parentRecommendationDone =>
      'Today\'s mission is done. This is a good moment to praise effort, not speed.';

  @override
  String parentRecommendationRemaining(int remaining) {
    return 'There is progress today: $remaining tasks left.';
  }

  @override
  String get parentRecommendationStart =>
      'Today, start with one short 4-6 minute mission.';

  @override
  String get parentRecommendationsTitle => 'Recommendations';

  @override
  String get parentHomeBadge => 'at home';

  @override
  String get parentPaceLabel => 'Pace';

  @override
  String get parentWeekFocusLabel => 'Week focus';

  @override
  String parentFocusArea(String areaTitle, String areaSubtitle) {
    return 'The area that needs the most attention now is \"$areaTitle\": $areaSubtitle.';
  }

  @override
  String get parentDiscussLabel => 'How to discuss';

  @override
  String get parentDiscussBody =>
      'After a task, ask: \"How did you find the rule?\" This builds explanation, not guessing.';

  @override
  String get parentFamilySecurityTitle => 'Family and safety';

  @override
  String get parentStorageLabel => 'Storage';

  @override
  String get parentStorageLocal => 'on device';

  @override
  String get notificationDailyTitle => 'A new mission is waiting';

  @override
  String notificationDailyBody(String name) {
    return '$name, solve one small puzzle and keep the star streak glowing.';
  }

  @override
  String get notificationEveningTitle => 'One step before bedtime?';

  @override
  String notificationEveningBody(String name) {
    return '$name has a short mission left. 5 calm minutes are enough.';
  }

  @override
  String get parentRemindersTitle => 'Reminders';

  @override
  String get parentReminderStatusOn => 'on';

  @override
  String get parentReminderStatusOff => 'off';

  @override
  String get parentRemindersBody =>
      'A gentle daily nudge helps return to the mission without pressure.';

  @override
  String get parentReminderDailyLabel => 'Daily mission';

  @override
  String get parentReminderDailyValue => '18:30 every day';

  @override
  String get parentReminderFollowUpLabel => 'Evening follow-up';

  @override
  String get parentReminderFollowUpValue => '20:15 if the mission is waiting';

  @override
  String get parentReminderToggleLabel => 'Return reminders';

  @override
  String get parentReminderToggleOn =>
      'Logic Loka will invite the child back to one short mission.';

  @override
  String get parentReminderToggleOff =>
      'Reminders are off. The app will stay quiet.';

  @override
  String get parentAccountTitle => 'Account';

  @override
  String get parentAccountBody =>
      'Sign in to sync progress, unlock subscriptions and restore purchases on another device.';

  @override
  String get parentAccountStatusGuest => 'guest';

  @override
  String get parentAccountAction => 'Sign in';

  @override
  String get accountTitle => 'Account sign in';

  @override
  String get accountHeroTitle => 'Keep the family profile close';

  @override
  String get accountHeroBody =>
      'Use Google, Apple or email to prepare cloud sync, purchases and safe parent access.';

  @override
  String get accountStatusGuest => 'guest mode';

  @override
  String get accountAppleButton => 'Continue with Apple';

  @override
  String get accountGoogleButton => 'Continue with Google';

  @override
  String get accountAuthLoading => 'Checking...';

  @override
  String get accountProviderGoogle => 'Google';

  @override
  String get accountProviderApple => 'Apple';

  @override
  String get accountProviderEmail => 'Email';

  @override
  String get accountSignedInTitle => 'Signed in';

  @override
  String get accountSignOut => 'Sign out';

  @override
  String get accountGoogleSuccessSnack => 'Signed in with Google.';

  @override
  String get accountGoogleCanceledSnack => 'Google sign-in was canceled.';

  @override
  String get accountGoogleUnsupportedSnack =>
      'Google sign-in is not supported on this platform yet.';

  @override
  String get accountGoogleConfigSnack =>
      'Google sign-in needs OAuth client configuration for this app.';

  @override
  String accountGoogleErrorSnack(Object error) {
    return 'Google sign-in failed: $error';
  }

  @override
  String get accountBenefitGoogleTitle => 'Google sign-in';

  @override
  String get accountBenefitGoogleBody =>
      'Use a Google account for quick parent access once OAuth is configured.';

  @override
  String get accountEmailTitle => 'Email access';

  @override
  String get accountSignInTab => 'Sign in';

  @override
  String get accountCreateTab => 'Create';

  @override
  String get accountEmailLabel => 'Email';

  @override
  String get accountPasswordLabel => 'Password';

  @override
  String get accountConfirmPasswordLabel => 'Confirm password';

  @override
  String get accountRememberDevice => 'Remember this device';

  @override
  String get accountSubmitSignIn => 'Sign in';

  @override
  String get accountSubmitCreate => 'Create account';

  @override
  String get accountForgotPassword => 'Forgot password';

  @override
  String get accountRestorePurchases => 'Restore purchases';

  @override
  String get accountPrivacyNote =>
      'Children keep playing locally until account services are connected.';

  @override
  String get accountBenefitSyncTitle => 'Progress sync';

  @override
  String get accountBenefitSyncBody =>
      'A signed-in profile can later move stars and practice history between devices.';

  @override
  String get accountBenefitAppleTitle => 'Apple sign-in ready';

  @override
  String get accountBenefitAppleBody =>
      'The button is in place for Sign in with Apple credentials.';

  @override
  String get accountBenefitPurchaseTitle => 'Purchases and subscriptions';

  @override
  String get accountBenefitPurchaseBody =>
      'Restore access after reinstalling or changing devices.';

  @override
  String get accountEmailError => 'Enter a valid email';

  @override
  String get accountPasswordError => 'Use at least 6 characters';

  @override
  String get accountPasswordMismatch => 'Passwords do not match';

  @override
  String get accountDemoSnack =>
      'Signed in with email locally. Connect a backend to verify passwords on the server.';

  @override
  String get accountAppleSnack =>
      'Apple sign-in UI is ready for the native auth handler.';

  @override
  String get accountRestoreSnack =>
      'Purchase restore UI is ready for StoreKit.';

  @override
  String get accountResetDialogTitle => 'Reset password';

  @override
  String get accountResetDialogBody =>
      'Password reset emails will be sent after account backend is connected.';

  @override
  String get accountResetDialogAction => 'Got it';

  @override
  String get puzzleListenPrompt => 'Listen to the task';

  @override
  String get puzzleStopNarration => 'Stop narration';
}
