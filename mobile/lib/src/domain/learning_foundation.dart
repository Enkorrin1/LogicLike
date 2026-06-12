enum AgeBandId {
  age4to5,
  age6,
  age7to8,
}

enum PuzzleType {
  oddOneOut,
  sequenceComplete,
  pairMatch,
  categorySort,
  pathPuzzle,
  countBridge,
  visualCompare,
  analogy,
}

enum SkillTag {
  attention,
  memory,
  pattern,
  classification,
  arithmetic,
  spatial,
  reasoning,
}

enum RewardType {
  sticker,
  badge,
  booster,
  avatarItem,
}

enum MapNodeState {
  completed,
  current,
  locked,
}

class AgeBand {
  const AgeBand({
    required this.id,
    required this.minAgeInclusive,
    required this.maxAgeInclusive,
    required this.titleKey,
  });

  final AgeBandId id;
  final int minAgeInclusive;
  final int maxAgeInclusive;
  final String titleKey;

  bool contains(int age) {
    return age >= minAgeInclusive && age <= maxAgeInclusive;
  }
}

class LevelMap {
  const LevelMap({
    required this.id,
    required this.titleKey,
    required this.subtitleKey,
    required this.nodes,
  });

  final String id;
  final String titleKey;
  final String subtitleKey;
  final List<MapNode> nodes;
}

class MapNode {
  const MapNode({
    required this.id,
    required this.order,
    required this.titleKey,
    required this.subtitleKey,
    required this.lessonId,
    required this.requiredStarsToUnlock,
    required this.ageBandId,
  });

  final String id;
  final int order;
  final String titleKey;
  final String subtitleKey;
  final String lessonId;
  final int requiredStarsToUnlock;
  final AgeBandId ageBandId;

  MapNodeState stateForStars(int stars) {
    if (stars > requiredStarsToUnlock) {
      return MapNodeState.completed;
    }
    if (stars >= requiredStarsToUnlock) {
      return MapNodeState.current;
    }
    return MapNodeState.locked;
  }
}

class Lesson {
  const Lesson({
    required this.id,
    required this.titleKey,
    required this.stepIds,
    required this.xpReward,
    required this.maxHearts,
  });

  final String id;
  final String titleKey;
  final List<String> stepIds;
  final int xpReward;
  final int maxHearts;
}

class LessonStep {
  const LessonStep({
    required this.id,
    required this.lessonId,
    required this.order,
    required this.puzzleId,
    required this.internalSkillTag,
  });

  final String id;
  final String lessonId;
  final int order;
  final String puzzleId;
  final SkillTag internalSkillTag;
}

class PuzzleDefinition {
  const PuzzleDefinition({
    required this.id,
    required this.levelId,
    required this.type,
    required this.skillTag,
    required this.payloadRef,
    required this.correctAnswerKey,
    required this.hintKeys,
  });

  final String id;
  final String levelId;
  final PuzzleType type;
  final SkillTag skillTag;
  final String payloadRef;
  final String correctAnswerKey;
  final List<String> hintKeys;
}

class PuzzleAttempt {
  const PuzzleAttempt({
    required this.puzzleId,
    required this.childAge,
    required this.startAtIso8601,
    required this.endAtIso8601,
    required this.isCorrect,
    required this.usedHints,
    required this.answerKeyUsed,
    required this.spentSeconds,
  });

  final String puzzleId;
  final int childAge;
  final String startAtIso8601;
  final String endAtIso8601;
  final bool isCorrect;
  final int usedHints;
  final String answerKeyUsed;
  final int spentSeconds;
}

class RewardDefinition {
  const RewardDefinition({
    required this.id,
    required this.type,
    required this.titleKey,
    required this.descriptionKey,
    required this.visualKey,
    required this.xpCost,
    required this.unlockedAfterStars,
  });

  final String id;
  final RewardType type;
  final String titleKey;
  final String descriptionKey;
  final String visualKey;
  final int xpCost;
  final int unlockedAfterStars;
}

class ChildProgress {
  const ChildProgress({
    required this.childId,
    required this.completedLevels,
    required this.stars,
    required this.totalXp,
    required this.completedRewards,
    required this.failedAttempts,
    required this.maxStreak,
    required this.lastPlayedAtIso8601,
  });

  final String childId;
  final List<String> completedLevels;
  final int stars;
  final int totalXp;
  final List<String> completedRewards;
  final int failedAttempts;
  final int maxStreak;
  final String? lastPlayedAtIso8601;

  int get starsForLevelMap => stars;

  ChildProgress copyWith({
    List<String>? completedLevels,
    int? stars,
    int? totalXp,
    List<String>? completedRewards,
    int? failedAttempts,
    int? maxStreak,
    String? lastPlayedAtIso8601,
    String? childId,
  }) {
    return ChildProgress(
      childId: childId ?? this.childId,
      completedLevels: completedLevels ?? this.completedLevels,
      stars: stars ?? this.stars,
      totalXp: totalXp ?? this.totalXp,
      completedRewards: completedRewards ?? this.completedRewards,
      failedAttempts: failedAttempts ?? this.failedAttempts,
      maxStreak: maxStreak ?? this.maxStreak,
      lastPlayedAtIso8601: lastPlayedAtIso8601 ?? this.lastPlayedAtIso8601,
    );
  }
}

class FoundationCatalog {
  static const List<AgeBand> ageBands = [
    AgeBand(
      id: AgeBandId.age4to5,
      minAgeInclusive: 4,
      maxAgeInclusive: 5,
      titleKey: 'age_band_4_to_5',
    ),
    AgeBand(
      id: AgeBandId.age6,
      minAgeInclusive: 6,
      maxAgeInclusive: 6,
      titleKey: 'age_band_6',
    ),
    AgeBand(
      id: AgeBandId.age7to8,
      minAgeInclusive: 7,
      maxAgeInclusive: 8,
      titleKey: 'age_band_7_to_8',
    ),
  ];

  static const LevelMap starterMap = LevelMap(
    id: 'map.main',
    titleKey: 'map_main_title',
    subtitleKey: 'map_main_subtitle',
    nodes: [
      MapNode(
        id: 'node.001',
        order: 1,
        titleKey: 'node_001_title',
        subtitleKey: 'node_001_subtitle',
        lessonId: 'lesson.001',
        requiredStarsToUnlock: 0,
        ageBandId: AgeBandId.age4to5,
      ),
      MapNode(
        id: 'node.002',
        order: 2,
        titleKey: 'node_002_title',
        subtitleKey: 'node_002_subtitle',
        lessonId: 'lesson.002',
        requiredStarsToUnlock: 1,
        ageBandId: AgeBandId.age4to5,
      ),
      MapNode(
        id: 'node.003',
        order: 3,
        titleKey: 'node_003_title',
        subtitleKey: 'node_003_subtitle',
        lessonId: 'lesson.003',
        requiredStarsToUnlock: 2,
        ageBandId: AgeBandId.age4to5,
      ),
      MapNode(
        id: 'node.004',
        order: 4,
        titleKey: 'node_004_title',
        subtitleKey: 'node_004_subtitle',
        lessonId: 'lesson.004',
        requiredStarsToUnlock: 3,
        ageBandId: AgeBandId.age6,
      ),
      MapNode(
        id: 'node.005',
        order: 5,
        titleKey: 'node_005_title',
        subtitleKey: 'node_005_subtitle',
        lessonId: 'lesson.005',
        requiredStarsToUnlock: 4,
        ageBandId: AgeBandId.age6,
      ),
      MapNode(
        id: 'node.006',
        order: 6,
        titleKey: 'node_006_title',
        subtitleKey: 'node_006_subtitle',
        lessonId: 'lesson.006',
        requiredStarsToUnlock: 5,
        ageBandId: AgeBandId.age7to8,
      ),
      MapNode(
        id: 'node.007',
        order: 7,
        titleKey: 'node_007_title',
        subtitleKey: 'node_007_subtitle',
        lessonId: 'lesson.007',
        requiredStarsToUnlock: 6,
        ageBandId: AgeBandId.age7to8,
      ),
      MapNode(
        id: 'node.008',
        order: 8,
        titleKey: 'node_008_title',
        subtitleKey: 'node_008_subtitle',
        lessonId: 'lesson.008',
        requiredStarsToUnlock: 7,
        ageBandId: AgeBandId.age7to8,
      ),
    ],
  );

  static const List<Lesson> starterLessons = [
    Lesson(
      id: 'lesson.001',
      titleKey: 'lesson_001_title',
      stepIds: ['step.001.1', 'step.001.2', 'step.001.3'],
      xpReward: 20,
      maxHearts: 5,
    ),
    Lesson(
      id: 'lesson.002',
      titleKey: 'lesson_002_title',
      stepIds: ['step.002.1', 'step.002.2', 'step.002.3'],
      xpReward: 24,
      maxHearts: 5,
    ),
  ];

  static const List<RewardDefinition> starterRewards = [
    RewardDefinition(
      id: 'reward.sticker.star',
      type: RewardType.sticker,
      titleKey: 'reward_star_sticker_title',
      descriptionKey: 'reward_star_sticker_desc',
      visualKey: 'reward_star_sticker_visual',
      xpCost: 50,
      unlockedAfterStars: 5,
    ),
  ];
}
