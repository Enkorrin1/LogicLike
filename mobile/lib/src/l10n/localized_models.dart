import 'package:intl/intl.dart';

import '../domain/adaptive_learning.dart';
import '../domain/daily_challenge.dart';
import '../domain/family_profile.dart';
import '../domain/learning_foundation.dart';
import '../domain/motivation_plan.dart';
import '../domain/parent_weekly_report.dart';
import '../domain/puzzle_content.dart';
import 'generated/app_localizations.dart';

extension LocalizedModels on AppLocalizations {
  String labelForAge(ChildAge age) {
    return ageYears(age.years);
  }

  String labelForGoal(LearningGoal goal) {
    return switch (goal) {
      LearningGoal.logic => goalLogicLabel,
      LearningGoal.math => goalMathLabel,
      LearningGoal.attention => goalAttentionLabel,
    };
  }

  String descriptionForGoal(LearningGoal goal) {
    return switch (goal) {
      LearningGoal.logic => goalLogicDescription,
      LearningGoal.math => goalMathDescription,
      LearningGoal.attention => goalAttentionDescription,
    };
  }

  String titleForCourse(CourseDefinition course) {
    return switch (course.track) {
      CourseTrack.logic => courseLogicTitle,
      CourseTrack.math => courseMathTitle,
      CourseTrack.spatial => courseSpatialTitle,
      CourseTrack.attention => courseAttentionTitle,
      CourseTrack.rebus => courseRebusTitle,
      CourseTrack.mixed => courseMixedTitle,
    };
  }

  String subtitleForCourse(CourseDefinition course) {
    return switch (course.track) {
      CourseTrack.logic => courseLogicSubtitle,
      CourseTrack.math => courseMathSubtitle,
      CourseTrack.spatial => courseSpatialSubtitle,
      CourseTrack.attention => courseAttentionSubtitle,
      CourseTrack.rebus => courseRebusSubtitle,
      CourseTrack.mixed => courseMixedSubtitle,
    };
  }

  String courseArcSummary(CourseDefinition course) {
    final ru = localeName.startsWith('ru');
    final skills = FoundationCatalog.primarySkillTagsForCourse(course)
        .take(3)
        .map(skillTagLabel)
        .join(ru ? ', ' : ', ');
    return ru
        ? 'От разминки к сложным задачам: $skills'
        : 'From warm-up to challenge: $skills';
  }

  String lessonDifficultyLabel(LessonDifficultyTier tier) {
    final ru = localeName.startsWith('ru');
    return switch (tier) {
      LessonDifficultyTier.starter => ru ? 'Легкий старт' : 'Easy start',
      LessonDifficultyTier.growing => ru ? 'Становится сложнее' : 'Growing',
      LessonDifficultyTier.confident => ru ? 'Уверенный уровень' : 'Confident',
      LessonDifficultyTier.challenge => ru ? 'Вызов' : 'Challenge',
    };
  }

  String lessonStepRoleLabel(LessonStepRole role) {
    final ru = localeName.startsWith('ru');
    return switch (role) {
      LessonStepRole.warmUp => ru ? 'Разминка' : 'Warm-up',
      LessonStepRole.core => ru ? 'Основная задача' : 'Core',
      LessonStepRole.stretch => ru ? 'Задача на рост' : 'Stretch',
      LessonStepRole.review => ru ? 'Повторение' : 'Review',
    };
  }

  String lessonSkillMixLabel(List<SkillTag> tags) {
    final visibleTags = tags.take(2).map(skillTagLabel).toList();
    if (visibleTags.isEmpty) {
      return localeName.startsWith('ru') ? 'Смешанные навыки' : 'Mixed skills';
    }
    return visibleTags.join(' + ');
  }

  String labelForPuzzleWorld(PuzzleWorld world) {
    final ru = localeName.startsWith('ru');
    return switch (world) {
      PuzzleWorld.space => ru ? 'Космос' : 'Space',
      PuzzleWorld.forest => ru ? 'Лес' : 'Forest',
      PuzzleWorld.sea => ru ? 'Море' : 'Sea',
      PuzzleWorld.toyCity => ru ? 'Город игрушек' : 'Toy City',
      PuzzleWorld.magicSchool => ru ? 'Магическая школа' : 'Magic School',
      PuzzleWorld.laboratory => ru ? 'Лаборатория' : 'Laboratory',
      PuzzleWorld.farm => ru ? 'Ферма' : 'Farm',
    };
  }

  String labelForPuzzleCharacter(PuzzleCharacter character) {
    final ru = localeName.startsWith('ru');
    return switch (character) {
      PuzzleCharacter.leo => ru ? 'Лёва' : 'Leo',
      PuzzleCharacter.nickAstronaut => ru ? 'Ник' : 'Nick',
      PuzzleCharacter.robi => ru ? 'Роби' : 'Robi',
      PuzzleCharacter.owlCoach => ru ? 'Совёнок' : 'Owl Coach',
    };
  }

  String skillTagLabel(SkillTag tag) {
    final ru = localeName.startsWith('ru');
    return switch (tag) {
      SkillTag.attention => ru ? 'внимание' : 'focus',
      SkillTag.memory => ru ? 'память' : 'memory',
      SkillTag.pattern => ru ? 'закономерности' : 'patterns',
      SkillTag.classification => ru ? 'сравнение' : 'comparison',
      SkillTag.arithmetic => ru ? 'счет' : 'counting',
      SkillTag.spatial => ru ? 'пространство' : 'space',
      SkillTag.reasoning => ru ? 'логика' : 'reasoning',
    };
  }

  String adaptiveModeLabel(AdaptiveDifficultyMode mode) {
    final ru = localeName.startsWith('ru');
    return switch (mode) {
      AdaptiveDifficultyMode.warmUp => ru ? 'Мягкий режим' : 'Warm-up mode',
      AdaptiveDifficultyMode.steady => ru ? 'Обычный режим' : 'Steady mode',
      AdaptiveDifficultyMode.stretch => ru ? 'Сложнее' : 'Stretch mode',
    };
  }

  String adaptiveReasonLabel(AdaptiveLessonPlan plan) {
    final ru = localeName.startsWith('ru');
    final accuracy = plan.recentAccuracy == null
        ? null
        : NumberFormat.percentPattern(localeName).format(plan.recentAccuracy);
    return switch (plan.reason) {
      AdaptiveReason.noRecentPractice => ru
          ? 'Начинаем мягко: пока мало свежей практики.'
          : 'Starting gently: there is not much recent practice yet.',
      AdaptiveReason.returningAfterBreak => ru
          ? 'После перерыва начинаем с более легких вариантов.'
          : 'After a break, the next lesson starts with lighter variants.',
      AdaptiveReason.needsSupport => ru
          ? 'Добавляем поддержку: точность ${accuracy ?? 'пока неизвестна'}, подсказок ${plan.recentHints}, ошибок ${plan.recentWrongAttempts}.'
          : 'Adding support: accuracy ${accuracy ?? 'not available yet'}, hints ${plan.recentHints}, mistakes ${plan.recentWrongAttempts}.',
      AdaptiveReason.steadyPractice => ru
          ? 'Темп подходит: продолжаем обычную сложность.'
          : 'The pace looks right: continuing at steady difficulty.',
      AdaptiveReason.readyForChallenge => ru
          ? 'Последние занятия уверенные: можно дать задачи чуть сложнее.'
          : 'Recent lessons look confident: the next tasks can be a little harder.',
    };
  }

  String motivationTitle(MotivationPlan plan) {
    final ru = localeName.startsWith('ru');
    if (plan.dailyGoalComplete) {
      return ru ? 'Бонус дня готов' : 'Daily bonus ready';
    }
    return ru ? 'Бонус дня' : 'Daily bonus';
  }

  String motivationBody(MotivationPlan plan) {
    final ru = localeName.startsWith('ru');
    if (plan.dailyGoalComplete) {
      return ru
          ? 'Отличный темп. Завтра серия продолжится.'
          : 'Great pace. Come back tomorrow to keep the streak going.';
    }
    final lessonWord = plan.sessionsLeftToday == 1 ? 'lesson' : 'lessons';
    return ru
        ? 'Пройди ещё ${plan.sessionsLeftToday} короткий урок, чтобы закрыть цель.'
        : 'Finish ${plan.sessionsLeftToday} more short $lessonWord to complete today.';
  }

  String motivationProgressLabel(MotivationPlan plan) {
    final ru = localeName.startsWith('ru');
    return ru
        ? '${plan.completedTodaySessions} из ${plan.dailyGoalSessions} сегодня'
        : '${plan.completedTodaySessions} of ${plan.dailyGoalSessions} today';
  }

  String motivationRewardLabel(MotivationPlan plan) {
    final ru = localeName.startsWith('ru');
    final left = plan.starsToNextReward;
    if (left == null) {
      return ru ? 'Все награды открыты' : 'All rewards unlocked';
    }
    if (left == 0) {
      return ru ? 'Новая награда открыта' : 'New reward unlocked';
    }
    return ru ? 'До награды: $left звезд' : '$left stars to reward';
  }

  String motivationStreakLabel(MotivationPlan plan) {
    final ru = localeName.startsWith('ru');
    final left = (plan.nextStreakMilestone - plan.currentStreak).clamp(0, 99);
    if (left == 0) {
      return ru ? 'Серия на рубеже' : 'Streak milestone';
    }
    return ru ? 'До серии: $left дней' : '$left days to streak';
  }

  String parentWeeklyReportTitle() {
    return localeName.startsWith('ru')
        ? 'План на неделю'
        : 'Weekly action plan';
  }

  String parentWeeklyStatusLabel(ParentWeeklyStatus status) {
    final ru = localeName.startsWith('ru');
    return switch (status) {
      ParentWeeklyStatus.gettingStarted =>
        ru ? 'Нужно больше данных' : 'More data needed',
      ParentWeeklyStatus.needsSupport =>
        ru ? 'Нужна поддержка' : 'Support needed',
      ParentWeeklyStatus.steady => ru ? 'Хороший темп' : 'Steady progress',
      ParentWeeklyStatus.strong => ru ? 'Сильная неделя' : 'Strong week',
    };
  }

  String parentWeeklySummary(ParentWeeklyReport report) {
    final ru = localeName.startsWith('ru');
    final accuracy = report.accuracy == null
        ? null
        : NumberFormat.percentPattern(localeName).format(report.accuracy);
    return ru
        ? 'Занятий: ${report.sessionsCount}, минут: ${report.minutes}, точность: ${accuracy ?? 'пока нет'}.'
        : 'Sessions: ${report.sessionsCount}, minutes: ${report.minutes}, accuracy: ${accuracy ?? 'not available yet'}.';
  }

  List<String> parentWeeklyActions(ParentWeeklyReport report) {
    final ru = localeName.startsWith('ru');
    return switch (report.status) {
      ParentWeeklyStatus.gettingStarted => ru
          ? const [
              'Проведите 2 коротких занятия по 3-5 минут.',
              'Не подсказывайте сразу: дайте ребенку выбрать самому.',
              'После занятия посмотрите ошибки в истории практики.',
            ]
          : const [
              'Do 2 short sessions of 3-5 minutes.',
              'Let the child choose before giving hints.',
              'After practice, review mistakes in the history panel.',
            ],
      ParentWeeklyStatus.needsSupport => ru
          ? const [
              'Повторите 1-2 легких урока перед новым уровнем.',
              'Просите ребенка объяснять выбор вслух.',
              'Смотрите на точность, а не на скорость.',
            ]
          : const [
              'Repeat 1-2 easier lessons before a new level.',
              'Ask the child to explain each choice out loud.',
              'Prioritize accuracy over speed this week.',
            ],
      ParentWeeklyStatus.steady => ru
          ? const [
              'Сохраняйте 2-3 занятия в неделю.',
              'Добавьте один урок из зоны фокуса.',
              'Продолжайте без длинных сессий: коротко и регулярно.',
            ]
          : const [
              'Keep 2-3 practice sessions this week.',
              'Add one lesson from the focus area.',
              'Keep sessions short and consistent.',
            ],
      ParentWeeklyStatus.strong => ru
          ? const [
              'Можно дать один более сложный урок.',
              'Закрепите успех повтором через 1-2 дня.',
              'Откройте коллекцию и отметьте новую награду.',
            ]
          : const [
              'Try one slightly harder lesson.',
              'Reinforce progress with a review in 1-2 days.',
              'Open the collection and celebrate the next reward.',
            ],
    };
  }

  String titleForLesson(Lesson lesson, {required int fallbackNumber}) {
    return switch (lesson.titleKey) {
      'lesson_001_title' => lesson_001_title,
      'lesson_002_title' => lesson_002_title,
      'lesson_003_title' => lesson_003_title,
      'lesson_004_title' => lesson_004_title,
      'lesson_005_title' => lesson_005_title,
      'lesson_006_title' => lesson_006_title,
      'lesson_007_title' => lesson_007_title,
      'lesson_008_title' => lesson_008_title,
      'lesson_009_title' => lesson_009_title,
      'lesson_010_title' => lesson_010_title,
      'lesson_011_title' => lesson_011_title,
      'lesson_012_title' => lesson_012_title,
      'lesson_013_title' => lesson_013_title,
      'lesson_014_title' => lesson_014_title,
      'lesson_015_title' => lesson_015_title,
      'lesson_016_title' => lesson_016_title,
      'lesson_017_title' => lesson_017_title,
      'lesson_018_title' => lesson_018_title,
      'lesson_019_title' => lesson_019_title,
      'lesson_020_title' => lesson_020_title,
      'lesson_021_title' => lesson_021_title,
      'lesson_022_title' => lesson_022_title,
      'lesson_023_title' => lesson_023_title,
      'lesson_024_title' => lesson_024_title,
      'lesson_025_title' => lesson_025_title,
      'lesson_026_title' => lesson_026_title,
      'lesson_027_title' => lesson_027_title,
      'lesson_028_title' => lesson_028_title,
      'lesson_029_title' => lesson_029_title,
      'lesson_030_title' => lesson_030_title,
      'lesson_031_title' => lesson_031_title,
      'lesson_032_title' => lesson_032_title,
      'lesson_033_title' => lesson_033_title,
      'lesson_034_title' => lesson_034_title,
      'lesson_035_title' => lesson_035_title,
      'lesson_036_title' => lesson_036_title,
      'lesson_037_title' => lesson_037_title,
      'lesson_038_title' => lesson_038_title,
      'lesson_039_title' => lesson_039_title,
      'lesson_040_title' => lesson_040_title,
      'lesson_041_title' => lesson_041_title,
      'lesson_042_title' => lesson_042_title,
      'lesson_043_title' => lesson_043_title,
      'lesson_044_title' => lesson_044_title,
      'lesson_045_title' => lesson_045_title,
      'lesson_046_title' => lesson_046_title,
      'lesson_047_title' => lesson_047_title,
      'lesson_048_title' => lesson_048_title,
      'lesson_049_title' => lesson_049_title,
      'lesson_050_title' => lesson_050_title,
      'lesson_051_title' => lesson_051_title,
      'lesson_052_title' => lesson_052_title,
      'lesson_053_title' => lesson_053_title,
      'lesson_054_title' => lesson_054_title,
      'lesson_055_title' => lesson_055_title,
      'lesson_056_title' => lesson_056_title,
      'lesson_057_title' => lesson_057_title,
      'lesson_058_title' => lesson_058_title,
      'lesson_059_title' => lesson_059_title,
      'lesson_060_title' => lesson_060_title,
      _ => courseLessonTitle(fallbackNumber),
    };
  }

  String labelForPlan(FamilySubscriptionPlan plan) {
    return switch (plan) {
      FamilySubscriptionPlan.starter => planStarterLabel,
      FamilySubscriptionPlan.monthly => planMonthlyLabel,
      FamilySubscriptionPlan.annual => planAnnualLabel,
    };
  }

  String priceForPlan(FamilySubscriptionPlan plan) {
    return switch (plan) {
      FamilySubscriptionPlan.starter => planStarterPrice,
      FamilySubscriptionPlan.monthly => planMonthlyPrice,
      FamilySubscriptionPlan.annual => planAnnualPrice,
    };
  }

  String capacityForPlan(FamilySubscriptionPlan plan) {
    return switch (plan) {
      FamilySubscriptionPlan.starter => planStarterCapacity,
      FamilySubscriptionPlan.monthly => planFamilyCapacity,
      FamilySubscriptionPlan.annual => planFamilyCapacity,
    };
  }

  String descriptionForPlan(FamilySubscriptionPlan plan) {
    return switch (plan) {
      FamilySubscriptionPlan.starter => planStarterDescription,
      FamilySubscriptionPlan.monthly => planMonthlyDescription,
      FamilySubscriptionPlan.annual => planAnnualDescription,
    };
  }

  String statusForPlan(FamilySubscriptionPlan plan) {
    return plan.isPaid ? planActiveStatus : planInactiveStatus;
  }

  String formatShortDate(DateTime date) {
    return DateFormat.yMd(localeName).format(date);
  }

  String weekdayShort(DateTime date) {
    return switch (date.weekday) {
      DateTime.monday => weekdayMondayShort,
      DateTime.tuesday => weekdayTuesdayShort,
      DateTime.wednesday => weekdayWednesdayShort,
      DateTime.thursday => weekdayThursdayShort,
      DateTime.friday => weekdayFridayShort,
      DateTime.saturday => weekdaySaturdayShort,
      DateTime.sunday => weekdaySundayShort,
      _ => weekdaySundayShort,
    };
  }

  String titleForChallenge(DailyChallenge challenge) {
    return switch (challenge.visualId) {
      'shape-path' => challengeShapePathTitle,
      'fruit-pattern' => challengeFruitPatternTitle,
      'toy-count' => challengeToyCountTitle,
      'odd-card' => challengeOddCardTitle,
      'logic-train' => challengeLogicTrainTitle,
      'sticker-sum' => challengeStickerSumTitle,
      'memory-pairs' => challengeMemoryPairsTitle,
      'lock-key' => challengeLockKeyTitle,
      'shadow-match' => challengeShadowMatchTitle,
      'balance-scale' => challengeBalanceScaleTitle,
      'shape-rotation' => challengeShapeRotationTitle,
      'code-grid' => challengeCodeGridTitle,
      'number-bridge' => challengeNumberBridgeTitle,
      'detail-count' => challengeDetailCountTitle,
      'space-sequence' => challengeSpaceSequenceTitle,
      'shape-stack' => challengeShapeStackTitle,
      _ => challenge.title,
    };
  }

  String promptForChallenge(DailyChallenge challenge) {
    return switch (challenge.visualId) {
      'shape-path' => challengeShapePathPrompt,
      'fruit-pattern' => challengeFruitPatternPrompt,
      'toy-count' => challengeToyCountPrompt,
      'odd-card' => challengeOddCardPrompt,
      'logic-train' => challengeLogicTrainPrompt,
      'sticker-sum' => challengeStickerSumPrompt,
      'memory-pairs' => challengeMemoryPairsPrompt,
      'lock-key' => challengeLockKeyPrompt,
      'shadow-match' => challengeShadowMatchPrompt,
      'balance-scale' => challengeBalanceScalePrompt,
      'shape-rotation' => challengeShapeRotationPrompt,
      'code-grid' => challengeCodeGridPrompt,
      'number-bridge' => challengeNumberBridgePrompt,
      'detail-count' => challengeDetailCountPrompt,
      'space-sequence' => challengeSpaceSequencePrompt,
      'shape-stack' => challengeShapeStackPrompt,
      _ => challenge.prompt,
    };
  }

  String questionForChallenge(DailyChallenge challenge) {
    if (challenge.isLessonVariant) {
      return _variantQuestion(challenge);
    }

    return switch (challenge.visualId) {
      'shape-path' => challengeShapePathQuestion,
      'fruit-pattern' => challengeFruitPatternQuestion,
      'toy-count' => challengeToyCountQuestion,
      'odd-card' => challengeOddCardQuestion,
      'logic-train' => challengeLogicTrainQuestion,
      'sticker-sum' => challengeStickerSumQuestion,
      'memory-pairs' => challengeMemoryPairsQuestion,
      'lock-key' => challengeLockKeyQuestion,
      'shadow-match' => challengeShadowMatchQuestion,
      'balance-scale' => challengeBalanceScaleQuestion,
      'shape-rotation' => challengeShapeRotationQuestion,
      'code-grid' => challengeCodeGridQuestion,
      'number-bridge' => challengeNumberBridgeQuestion,
      'detail-count' => challengeDetailCountQuestion,
      'space-sequence' => challengeSpaceSequenceQuestion,
      'shape-stack' => challengeShapeStackQuestion,
      _ => challenge.question,
    };
  }

  String skillForChallenge(DailyChallenge challenge) {
    return localizedSkill(challenge.skill);
  }

  String hintForChallenge(DailyChallenge challenge) {
    if (challenge.isLessonVariant) {
      return _variantHint(challenge);
    }

    return switch (challenge.visualId) {
      'shape-path' => challengeShapePathHint,
      'fruit-pattern' => challengeFruitPatternHint,
      'toy-count' => challengeToyCountHint,
      'odd-card' => challengeOddCardHint,
      'logic-train' => challengeLogicTrainHint,
      'sticker-sum' => challengeStickerSumHint,
      'memory-pairs' => challengeMemoryPairsHint,
      'lock-key' => challengeLockKeyHint,
      'shadow-match' => challengeShadowMatchHint,
      'balance-scale' => challengeBalanceScaleHint,
      'shape-rotation' => challengeShapeRotationHint,
      'code-grid' => challengeCodeGridHint,
      'number-bridge' => challengeNumberBridgeHint,
      'detail-count' => challengeDetailCountHint,
      'space-sequence' => challengeSpaceSequenceHint,
      'shape-stack' => challengeShapeStackHint,
      _ => challenge.hint,
    };
  }

  String explanationForChallenge(DailyChallenge challenge) {
    if (challenge.isLessonVariant) {
      return _variantExplanation(challenge);
    }

    return switch (challenge.visualId) {
      'shape-path' => challengeShapePathExplanation,
      'fruit-pattern' => challengeFruitPatternExplanation,
      'toy-count' => challengeToyCountExplanation,
      'odd-card' => challengeOddCardExplanation,
      'logic-train' => challengeLogicTrainExplanation,
      'sticker-sum' => challengeStickerSumExplanation,
      'memory-pairs' => challengeMemoryPairsExplanation,
      'lock-key' => challengeLockKeyExplanation,
      'shadow-match' => challengeShadowMatchExplanation,
      'balance-scale' => challengeBalanceScaleExplanation,
      'shape-rotation' => challengeShapeRotationExplanation,
      'code-grid' => challengeCodeGridExplanation,
      'number-bridge' => challengeNumberBridgeExplanation,
      'detail-count' => challengeDetailCountExplanation,
      'space-sequence' => challengeSpaceSequenceExplanation,
      'shape-stack' => challengeShapeStackExplanation,
      'memory-recall' => challengeMemoryRecallExplanation,
      'sorting-rule' => challengeSortingRuleExplanation,
      'missing-piece' => challengeMissingPieceExplanation,
      'logic-deduction' => challengeLogicDeductionExplanation,
      _ => challenge.explanation,
    };
  }

  String choiceLabelFor(DailyChallenge challenge, ChallengeChoice choice) {
    return switch ('${challenge.visualId}:${choice.id}') {
      'shape-path:triangle' => choiceTriangle,
      'shape-path:circle' => choiceCircle,
      'shape-path:star' => choiceStar,
      'fruit-pattern:apple' => choiceApple,
      'fruit-pattern:banana' => choiceBanana,
      'fruit-pattern:pear' => choicePear,
      'toy-count:2' => '2',
      'toy-count:3' => '3',
      'toy-count:4' => '4',
      'odd-card:apple' => choiceApple,
      'odd-card:ball' => choiceBall,
      'odd-card:banana' => choiceBanana,
      'logic-train:blue' => choiceBlue,
      'logic-train:red' => choiceRed,
      'logic-train:green' => choiceGreen,
      'sticker-sum:4' => '4',
      'sticker-sum:5' => '5',
      'sticker-sum:6' => '6',
      'memory-pairs:lock' => choiceLock,
      'memory-pairs:shoe' => choiceShoe,
      'memory-pairs:cloud' => choiceCloud,
      'lock-key:lock' => choiceLock,
      'lock-key:shoe' => choiceShoe,
      'lock-key:cloud' => choiceCloud,
      'shadow-match:rocket' => choiceRocket,
      'shadow-match:planet' => choicePlanet,
      'shadow-match:star' => choiceStar,
      'balance-scale:apple' => choiceApple,
      'balance-scale:star' => choiceStar,
      'balance-scale:ball' => choiceBall,
      'shape-rotation:same' => choiceSameTriangle,
      'shape-rotation:circle' => choiceCircle,
      'shape-rotation:square' => choiceSquare,
      'code-grid:6' => '6',
      'code-grid:7' => '7',
      'code-grid:8' => '8',
      'number-bridge:4+2+1' => '4 + 2 + 1',
      'number-bridge:4+1' => '4 + 1',
      'number-bridge:2+1' => '2 + 1',
      'detail-count:blue-squares' => choiceBlueSquares,
      'detail-count:red-circles' => choiceRedCircles,
      'detail-count:green-stars' => choiceGreenStars,
      'space-sequence:rocket' => choiceRocket,
      'space-sequence:planet' => choicePlanet,
      'space-sequence:star' => choiceStar,
      'shape-stack:square' => choiceSquare,
      'shape-stack:circle' => choiceCircle,
      'shape-stack:triangle' => choiceTriangle,
      'memory-recall:star' => choiceStar,
      'memory-recall:key' => choiceKey,
      'memory-recall:banana' => choiceBanana,
      'memory-recall:triangle' => choiceTriangle,
      'sorting-rule:pear' => choicePear,
      'sorting-rule:star' => choiceStar,
      'sorting-rule:planet' => choicePlanet,
      'sorting-rule:lock' => choiceLock,
      'missing-piece:circle' => choiceCircle,
      'missing-piece:star' => choiceStar,
      'missing-piece:key' => choiceKey,
      'logic-deduction:rocket' => choiceRocket,
      'logic-deduction:key' => choiceKey,
      'logic-deduction:banana' => choiceBanana,
      'path-maze:left' => localeName.startsWith('ru') ? 'влево' : 'left',
      'path-maze:right' => localeName.startsWith('ru') ? 'вправо' : 'right',
      'path-maze:up' => localeName.startsWith('ru') ? 'вверх' : 'up',
      'path-maze:down' => localeName.startsWith('ru') ? 'вниз' : 'down',
      _ => _choiceText(choice),
    };
  }

  String _variantQuestion(DailyChallenge challenge) {
    final ru = localeName.startsWith('ru');
    final labels = [for (final token in challenge.tokens) _itemName(token)];
    final nums = challenge.numbers;
    return switch (challenge.visualId) {
      'shape-path' || 'fruit-pattern' || 'space-sequence' || 'shape-stack' => ru
          ? '${labels[0]}, ${labels[1]}, ${labels[0]}, ${labels[1]}. Что дальше?'
          : '${labels[0]}, ${labels[1]}, ${labels[0]}, ${labels[1]}. What comes next?',
      'toy-count' => ru
          ? 'На полке ${nums[0]} куб. и ${nums[1]} мяч. Сколько игрушек всего?'
          : 'There are ${nums[0]} blocks and ${nums[1]} balls. How many toys are there?',
      'sticker-sum' => ru
          ? 'Было ${nums[0]} наклеек, потом добавили ${nums[1]}. Сколько стало?'
          : 'There were ${nums[0]} stickers, then ${nums[1]} more arrived. How many now?',
      'odd-card' => ru
          ? '${labels.join(', ')}. Что лишнее?'
          : '${labels.join(', ')}. Which one does not belong?',
      'logic-train' => ru
          ? '${labels[0]}, ${labels[1]}, ${labels[1]}, ${labels[0]}, ${labels[1]}, ${labels[1]}. Какой следующий?'
          : '${labels[0]}, ${labels[1]}, ${labels[1]}, ${labels[0]}, ${labels[1]}, ${labels[1]}. What comes next?',
      'memory-pairs' || 'lock-key' => ru
          ? 'Что подходит к предмету «${_itemName(challenge.tokens[0])}»?'
          : 'What goes with ${_itemName(challenge.tokens[0])}?',
      'shadow-match' => ru
          ? 'Какая картинка подходит к тени: ${_shadowClue(challenge.tokens[0])}?'
          : 'Which picture matches the shadow: ${_shadowClue(challenge.tokens[0])}?',
      'balance-scale' => ru
          ? 'Слева ${nums[0]} ябл. Справа ${nums[1]} ябл. и ?. Сколько добавить?'
          : 'Left side has ${nums[0]} apples. Right side has ${nums[1]} apples and ?. What should you add?',
      'shape-rotation' => ru
          ? 'Треугольник повернули: ${_turnName(challenge.tokens[0])}. Какая карточка показывает ту же фигуру?'
          : 'The triangle turned ${_turnName(challenge.tokens[0])}. Which card shows the same shape?',
      'code-grid' => ru
          ? 'Первая строка: ${nums[0]}, ${nums[1]}, ${nums[2]}. Вторая: ${nums[3]}, ${nums[4]}, ?. Какое число пропущено?'
          : 'First row: ${nums[0]}, ${nums[1]}, ${nums[2]}. Second: ${nums[3]}, ${nums[4]}, ?. What number is missing?',
      'number-bridge' => ru
          ? 'Есть числа ${nums[0]}, ${nums[1]} и ${nums[2]}. Как получить ${nums[3]}?'
          : 'You have ${nums[0]}, ${nums[1]}, and ${nums[2]}. How can you make ${nums[3]}?',
      'path-maze' => ru
          ? 'Помоги предмету «${labels[0]}» добраться до «${labels[1]}». Куда идти на развилке?'
          : 'Help ${labels[0]} get to ${labels[1]}. Which way should it go at the fork?',
      'memory-recall' => ru
          ? 'Запомни ряд: ${labels[0]}, ${labels[1]}, ${labels[2]}. Какая карточка спряталась?'
          : 'Remember the row: ${labels[0]}, ${labels[1]}, ${labels[2]}. Which card is hidden?',
      'sorting-rule' => ru
          ? 'В коробке уже есть ${labels[0]} и ${labels[1]}. Что подходит по тому же правилу?'
          : 'The box already has ${labels[0]} and ${labels[1]}. What follows the same rule?',
      'missing-piece' => ru
          ? 'У картинки «${labels[0]}» не хватает детали. Какая деталь подходит?'
          : 'The ${labels[0]} picture is missing a part. Which part fits?',
      'logic-deduction' => ru
          ? '${_deductionClue(challenge.tokens[0])}. ${_deductionClue(challenge.tokens[1])}. Что это?'
          : '${_deductionClue(challenge.tokens[0])}. ${_deductionClue(challenge.tokens[1])}. What is it?',
      'detail-count' => ru
          ? 'Есть ${nums[0]} красных кругов, ${nums[1]} синих квадратов и ${nums[2]} зеленых звезд. Чего больше всего?'
          : 'There are ${nums[0]} red circles, ${nums[1]} blue squares, and ${nums[2]} green stars. Which group has the most?',
      _ => challenge.question,
    };
  }

  String _variantHint(DailyChallenge challenge) {
    final ru = localeName.startsWith('ru');
    return switch (challenge.visualId) {
      'toy-count' || 'sticker-sum' || 'number-bridge' => ru
          ? 'Сложи числа по одному и проверь сумму.'
          : 'Add the numbers one by one and check the total.',
      'balance-scale' => ru
          ? 'На двух сторонах должно получиться одинаковое количество.'
          : 'Both sides need to have the same amount.',
      'code-grid' => ru
          ? 'Посмотри, на сколько увеличивается число в каждой строке.'
          : 'Look at how much the number grows in each row.',
      'odd-card' => ru
          ? 'Найди три предмета с общим правилом, а потом оставшийся.'
          : 'Find the three items that share a rule, then the remaining one.',
      'memory-pairs' || 'lock-key' => ru
          ? 'Вспомни, какие два предмета обычно работают вместе.'
          : 'Think of two objects that usually work together.',
      'shadow-match' || 'shape-rotation' => ru
          ? 'Смотри на форму целиком, а не на цвет.'
          : 'Look at the whole shape, not the color.',
      'path-maze' => ru
          ? 'Проследи дорожку от старта до цели и выбери направление на развилке.'
          : 'Follow the road from start to finish and choose the direction at the fork.',
      'memory-recall' => ru
          ? 'Закрой пальцем ряд и проверь, какой предмет был последним.'
          : 'Cover the row and check which object was last.',
      'sorting-rule' => ru
          ? 'Найди два предмета с общим свойством, потом выбери третий такой же.'
          : 'Find the shared property, then choose one more matching item.',
      'missing-piece' => ru
          ? 'Смотри на форму пустого места, а не только на цвет.'
          : 'Look at the missing shape, not only the color.',
      'logic-deduction' => ru
          ? 'Используй обе подсказки сразу и убери неподходящие варианты.'
          : 'Use both clues together and remove choices that do not fit.',
      _ => ru
          ? 'Правило повторяется. Найди начало нового повтора.'
          : 'The rule repeats. Find the start of the next repeat.',
    };
  }

  String _variantExplanation(DailyChallenge challenge) {
    final ru = localeName.startsWith('ru');
    final correct = _itemName(challenge.correctChoiceId);
    final nums = challenge.numbers;
    return switch (challenge.visualId) {
      'toy-count' || 'sticker-sum' => ru
          ? '${nums[0]} + ${nums[1]} = ${nums[2]}, значит ответ ${nums[2]}.'
          : '${nums[0]} + ${nums[1]} = ${nums[2]}, so the answer is ${nums[2]}.',
      'balance-scale' => ru
          ? 'Нужно добавить ${nums[2]}, тогда справа тоже будет ${nums[0]}.'
          : 'Add ${nums[2]}, so the right side also has ${nums[0]}.',
      'code-grid' => ru
          ? 'Шаг равен ${nums[6]}, поэтому после ${nums[4]} идет ${nums[5]}.'
          : 'The step is ${nums[6]}, so ${nums[5]} comes after ${nums[4]}.',
      'number-bridge' => ru
          ? '${nums[0]} + ${nums[1]} + ${nums[2]} = ${nums[3]}.'
          : '${nums[0]} + ${nums[1]} + ${nums[2]} = ${nums[3]}.',
      'detail-count' => ru
          ? 'Сравниваем ${nums[0]}, ${nums[1]} и ${nums[2]}. Больше всего: $correct.'
          : 'Compare ${nums[0]}, ${nums[1]}, and ${nums[2]}. The largest group is $correct.',
      'path-maze' => ru
          ? 'Верная дорожка ведёт ${_directionName(challenge.correctChoiceId)}.'
          : 'The correct road goes ${_directionName(challenge.correctChoiceId)}.',
      'memory-recall' => ru
          ? 'Спрятанная карточка: $correct. Она была в запомненном ряду.'
          : 'The hidden card is $correct. It was in the remembered row.',
      'sorting-rule' => ru
          ? '$correct подходит к правилу этой коробки.'
          : '$correct follows the box rule.',
      'missing-piece' => ru
          ? 'Подходит деталь: $correct. Она закрывает пустое место.'
          : 'The fitting part is $correct. It completes the empty place.',
      'logic-deduction' => ru
          ? 'Ответ: $correct. Он подходит ко всем подсказкам.'
          : 'The answer is $correct. It matches every clue.',
      _ => ru
          ? 'Правильный ответ: $correct. Он продолжает правило этой задачи.'
          : 'The correct answer is $correct. It continues this puzzle rule.',
    };
  }

  String _choiceText(ChallengeChoice choice) {
    if (choice.id.contains('+')) {
      return choice.id.replaceAll('+', ' + ');
    }
    if (int.tryParse(choice.id) != null) {
      return choice.id;
    }
    return _itemName(choice.id);
  }

  String _itemName(String id) {
    final ru = localeName.startsWith('ru');
    return switch (id) {
      'circle' => choiceCircle,
      'square' => choiceSquare,
      'triangle' => choiceTriangle,
      'star' => choiceStar,
      'apple' => choiceApple,
      'banana' => choiceBanana,
      'pear' => choicePear,
      'ball' => choiceBall,
      'rocket' => choiceRocket,
      'planet' => choicePlanet,
      'lock' => choiceLock,
      'key' => choiceKey,
      'shoe' => choiceShoe,
      'cloud' => choiceCloud,
      'red' => choiceRed,
      'blue' => choiceBlue,
      'green' => choiceGreen,
      'same' => choiceSameTriangle,
      'red-circles' => choiceRedCircles,
      'blue-squares' => choiceBlueSquares,
      'green-stars' => choiceGreenStars,
      'foot' => ru ? 'нога' : 'a foot',
      'rain' => ru ? 'дождь' : 'rain',
      'left' || 'right' || 'up' || 'down' => _directionName(id),
      _ => id,
    };
  }

  String _directionName(String id) {
    final ru = localeName.startsWith('ru');
    return switch (id) {
      'left' => ru ? 'влево' : 'left',
      'right' => ru ? 'вправо' : 'right',
      'up' => ru ? 'вверх' : 'up',
      'down' => ru ? 'вниз' : 'down',
      _ => id,
    };
  }

  String _turnName(String id) {
    final ru = localeName.startsWith('ru');
    return switch (id) {
      'right' => ru ? 'вправо' : 'right',
      'left' => ru ? 'влево' : 'left',
      'half' => ru ? 'на половину круга' : 'halfway around',
      _ => id,
    };
  }

  String _shadowClue(String id) {
    final ru = localeName.startsWith('ru');
    return switch (id) {
      'rocket' =>
        ru ? 'высокий корпус и два крыла' : 'a tall body with two wings',
      'planet' => ru ? 'круглая форма с кольцом' : 'a round shape with a ring',
      'star' => ru ? 'пять острых лучей' : 'five sharp points',
      _ => _itemName(id),
    };
  }

  String _deductionClue(String id) {
    final ru = localeName.startsWith('ru');
    return switch (id) {
      'flies' => ru ? 'Он летает' : 'It can fly',
      'not-fruit' => ru ? 'Это не фрукт' : 'It is not a fruit',
      'opens' => ru ? 'Он что-то открывает' : 'It opens something',
      'not-cloud' => ru ? 'Это не облако' : 'It is not a cloud',
      'fruit' => ru ? 'Это фрукт' : 'It is a fruit',
      'yellow' => ru ? 'Он желтый' : 'It is yellow',
      _ => _itemName(id),
    };
  }

  String localizedSkill(String skill) {
    return switch (skill) {
      'Закономерности' => skillPatterns,
      'Счет до пяти' => skillCountingToFive,
      'Сравнение' => skillComparison,
      'Последовательности' => skillSequences,
      'Сложение до десяти' => skillAdditionToTen,
      'Рабочая память' => skillWorkingMemory,
      'Логика и дедукция' => skillLogicDeduction,
      'Математическое мышление' => skillMathThinking,
      'Сравнение деталей' => skillDetailComparison,
      'Логика' => goalLogicLabel,
      'Внимание' => goalAttentionLabel,
      'Patterns' => skillPatterns,
      'Working memory' => skillWorkingMemory,
      'Comparison' => skillComparison,
      'Math thinking' => skillMathThinking,
      'Spatial reasoning' => courseSpatialTitle,
      'Logic and deduction' => skillLogicDeduction,
      'Detail comparison' => skillDetailComparison,
      _ => skill,
    };
  }
}
