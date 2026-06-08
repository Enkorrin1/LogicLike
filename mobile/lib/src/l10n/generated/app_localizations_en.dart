// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'LogicLike';

  @override
  String get homeTab => 'Home';

  @override
  String get challengeTab => 'Quest';

  @override
  String get parentTab => 'Parent';

  @override
  String homeGreeting(Object childName) {
    return 'Hi,\n$childName';
  }

  @override
  String get dailyStreakTitle => 'Daily streak';

  @override
  String get streakStart => 'Start!';

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '$count day',
    );
    return '$_temp0';
  }

  @override
  String dayCountShort(Object count) {
    return '$count d';
  }

  @override
  String get missionOpenButton => 'Open';

  @override
  String get missionStartShortButton => 'Start';

  @override
  String get missionStartButton => 'Start quest';

  @override
  String get homeMissionCompletedTitle => 'Mission\ncomplete!';

  @override
  String get homeMissionHelpTitle => 'Help the astronaut\ncollect stars!';

  @override
  String get dailyChallengeTag => 'Daily quest';

  @override
  String get myProgressTitle => 'My progress';

  @override
  String levelLabel(Object level) {
    return 'Level $level';
  }

  @override
  String get myCollectionTitle => 'My collection';

  @override
  String stickerCountLabel(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'stickers',
      one: 'sticker',
    );
    return '$_temp0';
  }

  @override
  String homeParentHint(Object ageLabel, Object goalLabel, num minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes min this week',
      one: '$minutes min this week',
    );
    return '$ageLabel • $goalLabel • $_temp0';
  }

  @override
  String ageYears(num years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years years',
      one: '$years year',
    );
    return '$_temp0';
  }

  @override
  String get goalLogicLabel => 'Logic';

  @override
  String get goalLogicDescription => 'Patterns, reasoning, and finding rules.';

  @override
  String get goalMathLabel => 'Math';

  @override
  String get goalMathDescription => 'Numbers, counting, and careful solutions.';

  @override
  String get goalAttentionLabel => 'Focus';

  @override
  String get goalAttentionDescription =>
      'Attention, memory, and comparing details.';

  @override
  String get onboardingTitle => 'Set up LogicLike';

  @override
  String get onboardingSubtitle =>
      'Create a family profile so daily quests match the child\'s age and goal.';

  @override
  String get childNameLabel => 'Child\'s name';

  @override
  String get childNameError => 'Enter a name';

  @override
  String get ageSectionTitle => 'Age';

  @override
  String get learningGoalSectionTitle => 'Learning goal';

  @override
  String get learningGoalShortTitle => 'Goal';

  @override
  String get startButton => 'Start';

  @override
  String get savingButton => 'Saving';

  @override
  String get onboardingHeroTitle => 'First flight ready';

  @override
  String get parentTag => 'Parent';

  @override
  String get parentDashboardTitle => 'Family hub';

  @override
  String familyProfileSummary(
      Object ageLabel, Object childName, Object goalLabel) {
    return '$childName • $ageLabel • $goalLabel';
  }

  @override
  String get currentStreakMetric => 'streak';

  @override
  String get sessionsMetric => 'sessions';

  @override
  String get minutesMetric => 'minutes';

  @override
  String get childrenProfilesTitle => 'Child profiles';

  @override
  String get addChildButton => 'Add child';

  @override
  String childProgressChallengeCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count quests',
      one: '$count quest',
    );
    return '$_temp0';
  }

  @override
  String ageGoalSummary(Object ageLabel, Object goalLabel) {
    return '$ageLabel • $goalLabel';
  }

  @override
  String get newChildTitle => 'New child';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get addButton => 'Add';

  @override
  String get analyticsTitle => 'Practice analytics';

  @override
  String get streakMetricLabel => 'Streak';

  @override
  String get bestStreakLabel => 'Best';

  @override
  String get last7DaysLabel => 'Last 7 days';

  @override
  String get weeklyMinutesLabel => 'Minutes';

  @override
  String sessionsCountShort(Object count) {
    return '$count sess.';
  }

  @override
  String minutesShort(Object count) {
    return '$count min';
  }

  @override
  String minutesNarrow(Object count) {
    return '$count m';
  }

  @override
  String get lastSkillLabel => 'Last skill';

  @override
  String get lastSessionLabel => 'Last session';

  @override
  String get notAvailable => 'Not yet';

  @override
  String get weeklyRhythmTitle => 'Weekly rhythm';

  @override
  String get weeklyRhythmSubtitle => 'Practice days and minutes for each day.';

  @override
  String get subscriptionTitle => 'Family subscription';

  @override
  String get currentPlanLabel => 'Current plan';

  @override
  String get familySeatsLabel => 'Family seats';

  @override
  String get updatedLabel => 'Updated';

  @override
  String get recommendedLabel => 'Best value';

  @override
  String get currentPlanButton => 'Current plan';

  @override
  String get chooseButton => 'Choose';

  @override
  String get resetProfilePanel => 'Reset the local profile and run setup again';

  @override
  String get resetButton => 'Reset';

  @override
  String get resetDialogTitle => 'Reset profile?';

  @override
  String get resetDialogBody =>
      'Onboarding will open again and local progress will be cleared.';

  @override
  String get resetConfirmButton => 'Reset';

  @override
  String get limitPaidMessage => 'All family seats are already used.';

  @override
  String get limitStarterMessage =>
      'More profiles are available on the family plan.';

  @override
  String get planStarterLabel => 'Starter';

  @override
  String get planStarterPrice => '0 ₽';

  @override
  String get planStarterCapacity => '1 child profile';

  @override
  String get planStarterDescription => 'Short daily loop and local progress.';

  @override
  String get planMonthlyLabel => 'Family monthly';

  @override
  String get planMonthlyPrice => '399 ₽/mo';

  @override
  String get planFamilyCapacity => 'up to 3 child profiles';

  @override
  String get planMonthlyDescription =>
      'Full access, family profiles, and parent analytics.';

  @override
  String get planAnnualLabel => 'Family annual';

  @override
  String get planAnnualPrice => '2990 ₽/yr';

  @override
  String get planAnnualDescription =>
      'The same access, with better value for annual billing.';

  @override
  String get planActiveStatus => 'Active';

  @override
  String get planInactiveStatus => 'Not active';

  @override
  String get missionCompletedTitle => 'Mission complete!';

  @override
  String childGoCta(Object childName) {
    return '$childName, let\'s go!';
  }

  @override
  String get chooseAnswerTitle => 'Choose an answer';

  @override
  String get checkingButton => 'Saving';

  @override
  String get checkAnswerButton => 'Check';

  @override
  String answerCorrect(Object explanation) {
    return 'Correct! $explanation';
  }

  @override
  String answerAlmost(Object hint) {
    return 'Almost. $hint';
  }

  @override
  String get challengeCompletedToday => 'Today\'s quest is complete';

  @override
  String get weekdayMondayShort => 'Mon';

  @override
  String get weekdayTuesdayShort => 'Tue';

  @override
  String get weekdayWednesdayShort => 'Wed';

  @override
  String get weekdayThursdayShort => 'Thu';

  @override
  String get weekdayFridayShort => 'Fri';

  @override
  String get weekdaySaturdayShort => 'Sat';

  @override
  String get weekdaySundayShort => 'Sun';

  @override
  String get skillPatterns => 'Patterns';

  @override
  String get skillCountingToFive => 'Counting to five';

  @override
  String get skillComparison => 'Comparison';

  @override
  String get skillSequences => 'Sequences';

  @override
  String get skillAdditionToTen => 'Addition to ten';

  @override
  String get skillWorkingMemory => 'Working memory';

  @override
  String get skillLogicDeduction => 'Logic and deduction';

  @override
  String get skillMathThinking => 'Math thinking';

  @override
  String get skillDetailComparison => 'Detail comparison';

  @override
  String get challengeShapePathTitle => 'Shape path';

  @override
  String get challengeShapePathPrompt =>
      'Look at the row and find what comes next.';

  @override
  String get challengeShapePathQuestion =>
      'Circle, square, circle, square. What comes next?';

  @override
  String get challengeShapePathHint =>
      'The shapes alternate: one shape, then the other, then the first again.';

  @override
  String get challengeShapePathExplanation =>
      'After the square comes a circle again, because the row repeats every two shapes.';

  @override
  String get challengeToyCountTitle => 'Toy count';

  @override
  String get challengeToyCountPrompt =>
      'Count the objects and choose the exact answer.';

  @override
  String get challengeToyCountQuestion =>
      'There are 2 blocks and 1 ball on the shelf. How many toys are there?';

  @override
  String get challengeToyCountHint =>
      'Count the blocks first, then add the ball.';

  @override
  String get challengeToyCountExplanation =>
      '2 blocks and 1 ball make 3 toys altogether.';

  @override
  String get challengeOddCardTitle => 'Odd card out';

  @override
  String get challengeOddCardPrompt =>
      'Find the item that is different from the others.';

  @override
  String get challengeOddCardQuestion =>
      'Apple, pear, ball, banana. Which one does not belong?';

  @override
  String get challengeOddCardHint =>
      'Three items can be eaten, and one is for playing.';

  @override
  String get challengeOddCardExplanation =>
      'The ball does not belong: apple, pear, and banana are fruits.';

  @override
  String get challengeLogicTrainTitle => 'Logic train';

  @override
  String get challengeLogicTrainPrompt => 'Place the train cars by the rule.';

  @override
  String get challengeLogicTrainQuestion =>
      'Red, blue, blue, red, blue, blue. What comes next?';

  @override
  String get challengeLogicTrainHint =>
      'The rule repeats in groups of three: one red and two blue.';

  @override
  String get challengeLogicTrainExplanation =>
      'The next car is red: after two blue cars, a new group starts.';

  @override
  String get challengeStickerSumTitle => 'Sticker album';

  @override
  String get challengeStickerSumPrompt => 'Add two small groups of objects.';

  @override
  String get challengeStickerSumQuestion =>
      'Nika had 3 stickers, then got 2 more. How many does she have now?';

  @override
  String get challengeStickerSumHint =>
      'Start with three and count two more steps.';

  @override
  String get challengeStickerSumExplanation =>
      '3 + 2 = 5, so she has five stickers.';

  @override
  String get challengeMemoryPairsTitle => 'Memory pairs';

  @override
  String get challengeMemoryPairsPrompt =>
      'Remember the matching pair for each item.';

  @override
  String get challengeMemoryPairsQuestion => 'What goes with a key?';

  @override
  String get challengeMemoryPairsHint => 'A key is used to open something.';

  @override
  String get challengeMemoryPairsExplanation =>
      'A key goes with a lock: together they make a meaningful pair.';

  @override
  String get challengeCodeGridTitle => 'Code grid';

  @override
  String get challengeCodeGridPrompt =>
      'Solve the rule and choose the right cell.';

  @override
  String get challengeCodeGridQuestion =>
      'The first row is 2, 4, 6. The second is 3, 5, ?. What number is missing?';

  @override
  String get challengeCodeGridHint =>
      'The numbers in the second row also grow by 2.';

  @override
  String get challengeCodeGridExplanation =>
      'After 3 and 5 comes 7: each step adds two.';

  @override
  String get challengeNumberBridgeTitle => 'Number bridge';

  @override
  String get challengeNumberBridgePrompt =>
      'Connect the numbers to build the right route.';

  @override
  String get challengeNumberBridgeQuestion =>
      'You have 4, 2, and 1. How can you make 7?';

  @override
  String get challengeNumberBridgeHint => 'Try using all the numbers once.';

  @override
  String get challengeNumberBridgeExplanation =>
      '4 + 2 + 1 = 7, so all three numbers together make the target.';

  @override
  String get challengeDetailCountTitle => 'Detail map';

  @override
  String get challengeDetailCountPrompt =>
      'Hold several details in mind and compare them.';

  @override
  String get challengeDetailCountQuestion =>
      'There are 3 red circles, 2 blue squares, and 1 green star. Which group has the most?';

  @override
  String get challengeDetailCountHint => 'Compare the amounts: 3, 2, and 1.';

  @override
  String get challengeDetailCountExplanation =>
      'The red circles are the most: there are three of them.';

  @override
  String get choiceTriangle => 'Triangle';

  @override
  String get choiceCircle => 'Circle';

  @override
  String get choiceStar => 'Star';

  @override
  String get choiceApple => 'Apple';

  @override
  String get choiceBall => 'Ball';

  @override
  String get choiceBanana => 'Banana';

  @override
  String get choiceBlue => 'Blue';

  @override
  String get choiceRed => 'Red';

  @override
  String get choiceGreen => 'Green';

  @override
  String get choiceLock => 'Lock';

  @override
  String get choiceShoe => 'Shoe';

  @override
  String get choiceCloud => 'Cloud';

  @override
  String get choiceBlueSquares => 'Blue squares';

  @override
  String get choiceRedCircles => 'Red circles';

  @override
  String get choiceGreenStars => 'Green stars';

  @override
  String mapLessonTitle(Object lesson) {
    return 'Lesson $lesson';
  }

  @override
  String get mapLessonSubtitle =>
      'Logic, counting, and focus in one short lesson';

  @override
  String get mapStartButton => 'Start';

  @override
  String get mapNodeStart => 'Start';

  @override
  String get mapNodeShapes => 'Shapes';

  @override
  String get mapNodePairs => 'Pairs';

  @override
  String get mapNodeCounting => 'Counting';

  @override
  String get mapNodePath => 'Path';

  @override
  String get mapNodeRhythm => 'Rhythm';

  @override
  String get mapNodeCompare => 'Compare';

  @override
  String get mapNodeFinal => 'Final';

  @override
  String get mapNodeCompleted => 'done';

  @override
  String get mapNodeCurrent => 'open';

  @override
  String get mapNodeLocked => 'locked';

  @override
  String mapPreviewTitle(Object lesson) {
    return 'Lesson $lesson';
  }

  @override
  String mapPreviewSteps(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count steps',
      one: '$count step',
    );
    return '$_temp0';
  }

  @override
  String mapPreviewReward(Object xp) {
    return '+$xp XP';
  }

  @override
  String mapPreviewHearts(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hearts',
      one: '$count heart',
    );
    return '$_temp0';
  }

  @override
  String get mapPreviewBody =>
      'A short lesson with mixed puzzles: logic, counting, comparison, and focus.';

  @override
  String get mapPreviewStart => 'Start lesson';

  @override
  String get mapPreviewClose => 'Later';

  @override
  String lessonProgress(Object current, Object total) {
    return 'Step $current of $total';
  }

  @override
  String get lessonNextButton => 'Next';

  @override
  String get lessonFinishButton => 'Finish lesson';

  @override
  String get lessonCompleteTitle => 'Lesson complete!';

  @override
  String get lessonCompleteBody => 'You unlocked the next step on the map.';

  @override
  String get lessonRewardStars => '+1 star';

  @override
  String lessonRewardXp(Object xp) {
    return '+$xp XP';
  }

  @override
  String get lessonBackToMap => 'Back home';

  @override
  String get courseCatalogTitle => 'Courses and puzzles';

  @override
  String get courseLogicTitle => 'Logic';

  @override
  String get courseLogicSubtitle => 'Rules, odd one out, and reasoning';

  @override
  String get courseMathTitle => 'Math';

  @override
  String get courseMathSubtitle => 'Counting, sums, and comparison';

  @override
  String get courseSpatialTitle => 'Shapes';

  @override
  String get courseSpatialSubtitle => 'Form, paths, and space';

  @override
  String get courseAttentionTitle => 'Focus';

  @override
  String get courseAttentionSubtitle => 'Details, memory, and attention';

  @override
  String get courseRebusTitle => 'Rebuses';

  @override
  String get courseRebusSubtitle => 'Pictures, words, and riddles';

  @override
  String get courseMixedTitle => 'Daily mix';

  @override
  String get courseMixedSubtitle => 'Different puzzles in a row';

  @override
  String progressCardBody(Object level, Object stars) {
    return 'Level $level • $stars stars';
  }

  @override
  String collectionCardBody(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stickers',
      one: '$count sticker',
    );
    return '$_temp0';
  }

  @override
  String get dailyMissionBody =>
      'A short set of logic, counting, and focus puzzles.';

  @override
  String get openCourseButton => 'Open';

  @override
  String courseProgress(Object completed, Object total) {
    return '$completed of $total lessons complete';
  }

  @override
  String courseLessonTitle(Object lesson) {
    return 'Lesson $lesson';
  }

  @override
  String courseLessonMeta(num steps, Object xp) {
    String _temp0 = intl.Intl.pluralLogic(
      steps,
      locale: localeName,
      other: '$steps steps',
      one: '$steps step',
    );
    return '$_temp0 • +$xp XP';
  }

  @override
  String get courseStartLessonButton => 'Start';

  @override
  String get courseRepeatButton => 'Repeat';

  @override
  String get showHintButton => 'Hint';

  @override
  String get hideHintButton => 'Hide hint';

  @override
  String get lessonStickerUnlockedTitle => 'New sticker!';

  @override
  String get lessonStickerUnlockedBody =>
      'Your collection grew after the lesson.';

  @override
  String get lessonRewardCollection => '+1 sticker';

  @override
  String get lessonRewardStreak => 'Streak grows';

  @override
  String get challengeShadowMatchTitle => 'Shadow match';

  @override
  String get challengeShadowMatchPrompt =>
      'Find the object that fits the shadow.';

  @override
  String get challengeShadowMatchQuestion =>
      'The shadow has a tall body and two small wings. What is it?';

  @override
  String get challengeShadowMatchHint =>
      'Look at the whole outline of the object.';

  @override
  String get challengeShadowMatchExplanation =>
      'The rocket matches the shadow: it has a tall body and two side wings.';

  @override
  String get challengeBalanceScaleTitle => 'Balance scale';

  @override
  String get challengeBalanceScalePrompt =>
      'Compare the sides and choose what is missing.';

  @override
  String get challengeBalanceScaleQuestion =>
      'Left side has 2 apples. Right side has 1 apple and ?. What should you add?';

  @override
  String get challengeBalanceScaleHint =>
      'Both sides need the same number of apples.';

  @override
  String get challengeBalanceScaleExplanation =>
      'One more apple makes the right side equal to the left: 2 and 2.';

  @override
  String get challengeShapeRotationTitle => 'Shape turn';

  @override
  String get challengeShapeRotationPrompt =>
      'Imagine the shape turning around.';

  @override
  String get challengeShapeRotationQuestion =>
      'A triangle turns to the right. Which card shows the same shape?';

  @override
  String get challengeShapeRotationHint =>
      'Turning changes direction, but not the shape itself.';

  @override
  String get challengeShapeRotationExplanation =>
      'It is the same triangle: it turned, but did not become a different shape.';

  @override
  String get choiceRocket => 'Rocket';

  @override
  String get choicePlanet => 'Planet';

  @override
  String get choiceSameTriangle => 'Same triangle';

  @override
  String get choiceSquare => 'Square';

  @override
  String get skillInsightsTitle => 'Skills and recommendations';

  @override
  String get strongestAreaLabel => 'Strong area';

  @override
  String get practiceFocusLabel => 'Focus area';

  @override
  String get recommendedPracticeLabel => 'Practice next';

  @override
  String get noSkillDataLabel => 'Not enough data yet';

  @override
  String get recommendationKeepGoing =>
      'Keep doing short lessons: recommendations get sharper after a few sessions.';

  @override
  String get recommendationPracticeFocus =>
      'Add 1-2 short lessons for this area during the week.';
}
