import 'learning_foundation.dart';

enum PuzzleContentType {
  patternSequence,
  oddOneOut,
  counting,
  comparison,
  pairMatching,
  shadowMatch,
  spatialRotation,
  pathLogic,
  memoryRecall,
  sortingRule,
  missingPiece,
  visualMathStory,
  symbolCode,
  logicDeduction,
}

enum PuzzleWorld {
  space,
  forest,
  sea,
  toyCity,
  magicSchool,
  laboratory,
  farm,
}

enum PuzzleCharacter {
  leo,
  nickAstronaut,
  robi,
  owlCoach,
}

enum CharacterPose {
  idle,
  happy,
  thinking,
  hint,
  victory,
}

enum PuzzleAnimationCue {
  answerBounce,
  wrongShake,
  characterCelebrate,
  hintGlow,
  starsFly,
  pathMove,
  objectReveal,
}

class PuzzleLocalizationKeys {
  const PuzzleLocalizationKeys({
    required this.title,
    required this.prompt,
    required this.question,
    required this.hint,
    required this.explanation,
  });

  final String title;
  final String prompt;
  final String question;
  final String hint;
  final String explanation;

  List<String> get all => [title, prompt, question, hint, explanation];
}

class PuzzleContent {
  const PuzzleContent({
    required this.id,
    required this.familyId,
    required this.contentType,
    required this.world,
    required this.character,
    required this.characterPose,
    required this.ageBands,
    required this.difficultyTier,
    required this.skillTags,
    required this.sceneAsset,
    required this.requiredObjectIds,
    required this.requiredColorIds,
    required this.requiredNumberSlots,
    required this.localizationKeys,
    required this.animationCues,
    this.supportingAssets = const [],
  });

  final String id;
  final String familyId;
  final PuzzleContentType contentType;
  final PuzzleWorld world;
  final PuzzleCharacter character;
  final CharacterPose characterPose;
  final List<AgeBandId> ageBands;
  final LessonDifficultyTier difficultyTier;
  final List<SkillTag> skillTags;
  final String sceneAsset;
  final List<String> supportingAssets;
  final List<String> requiredObjectIds;
  final List<String> requiredColorIds;
  final int requiredNumberSlots;
  final PuzzleLocalizationKeys localizationKeys;
  final List<PuzzleAnimationCue> animationCues;

  bool supportsAgeBand(AgeBandId ageBandId) {
    return ageBands.contains(ageBandId);
  }
}

class PuzzleWorldTheme {
  const PuzzleWorldTheme({
    required this.world,
    required this.accentColor,
    required this.textColor,
    required this.gradientColors,
    required this.sceneColors,
    required this.ambientAsset,
  });

  final PuzzleWorld world;
  final int accentColor;
  final int textColor;
  final List<int> gradientColors;
  final List<int> sceneColors;
  final String ambientAsset;
}

class PuzzleContentCatalog {
  const PuzzleContentCatalog._();

  static const puzzleAssetRoot = 'assets/images/puzzles';
  static const generatedAssetRoot = 'assets/images/generated';

  static const worldThemes = <PuzzleWorldTheme>[
    PuzzleWorldTheme(
      world: PuzzleWorld.space,
      accentColor: 0xFF4F7DF3,
      textColor: 0xFF143763,
      gradientColors: [0xFFE8F5FF, 0xFFDDF8F4],
      sceneColors: [0xFFEAF4FF, 0xFFD9F9FF],
      ambientAsset: '$puzzleAssetRoot/rocket.svg',
    ),
    PuzzleWorldTheme(
      world: PuzzleWorld.forest,
      accentColor: 0xFF35B37E,
      textColor: 0xFF174E3C,
      gradientColors: [0xFFEAF9EA, 0xFFFFF5D8],
      sceneColors: [0xFFF1FAE7, 0xFFFFF2D6],
      ambientAsset: '$puzzleAssetRoot/apple.svg',
    ),
    PuzzleWorldTheme(
      world: PuzzleWorld.sea,
      accentColor: 0xFF28A9E0,
      textColor: 0xFF164C69,
      gradientColors: [0xFFE2F8FF, 0xFFDFF8F4],
      sceneColors: [0xFFE7FBFF, 0xFFDDF8F4],
      ambientAsset: '$puzzleAssetRoot/cloud.svg',
    ),
    PuzzleWorldTheme(
      world: PuzzleWorld.toyCity,
      accentColor: 0xFFFF9D2E,
      textColor: 0xFF6B3B11,
      gradientColors: [0xFFFFF2D6, 0xFFFFE8EF],
      sceneColors: [0xFFFFF6E6, 0xFFFFEAF2],
      ambientAsset: '$puzzleAssetRoot/toy_cube_orange.svg',
    ),
    PuzzleWorldTheme(
      world: PuzzleWorld.magicSchool,
      accentColor: 0xFF9C6AF2,
      textColor: 0xFF463176,
      gradientColors: [0xFFF1E9FF, 0xFFFFEDF7],
      sceneColors: [0xFFF6EEFF, 0xFFFFF0FA],
      ambientAsset: '$puzzleAssetRoot/key.svg',
    ),
    PuzzleWorldTheme(
      world: PuzzleWorld.laboratory,
      accentColor: 0xFF18B7AE,
      textColor: 0xFF164C55,
      gradientColors: [0xFFE5FAF7, 0xFFEAF4FF],
      sceneColors: [0xFFEAFBF8, 0xFFEFF6FF],
      ambientAsset: '$puzzleAssetRoot/sign_question.svg',
    ),
    PuzzleWorldTheme(
      world: PuzzleWorld.farm,
      accentColor: 0xFFFF6F6B,
      textColor: 0xFF743330,
      gradientColors: [0xFFFFF2D8, 0xFFFFECE8],
      sceneColors: [0xFFFFF8E7, 0xFFFFEFEA],
      ambientAsset: '$puzzleAssetRoot/apple.svg',
    ),
  ];

  static const contents = <PuzzleContent>[
    PuzzleContent(
      id: 'content.shape_path.space_shapes',
      familyId: 'shape-path',
      contentType: PuzzleContentType.patternSequence,
      world: PuzzleWorld.space,
      character: PuzzleCharacter.leo,
      characterPose: CharacterPose.thinking,
      ageBands: [AgeBandId.age4to5, AgeBandId.age6],
      difficultyTier: LessonDifficultyTier.starter,
      skillTags: [SkillTag.pattern, SkillTag.spatial],
      sceneAsset: '$puzzleAssetRoot/shape_circle.svg',
      supportingAssets: [
        '$puzzleAssetRoot/shape_square.svg',
        '$puzzleAssetRoot/shape_triangle.svg',
        '$puzzleAssetRoot/shape_star.svg',
      ],
      requiredObjectIds: ['circle', 'square', 'triangle', 'star'],
      requiredColorIds: ['teal', 'blue', 'purple', 'yellow'],
      requiredNumberSlots: 0,
      localizationKeys: PuzzleLocalizationKeys(
        title: 'challengeShapePathTitle',
        prompt: 'challengeShapePathPrompt',
        question: 'challengeShapePathQuestion',
        hint: 'challengeShapePathHint',
        explanation: 'challengeShapePathExplanation',
      ),
      animationCues: [
        PuzzleAnimationCue.answerBounce,
        PuzzleAnimationCue.hintGlow,
      ],
    ),
    PuzzleContent(
      id: 'content.fruit_pattern.forest_row',
      familyId: 'fruit-pattern',
      contentType: PuzzleContentType.patternSequence,
      world: PuzzleWorld.forest,
      character: PuzzleCharacter.leo,
      characterPose: CharacterPose.happy,
      ageBands: [AgeBandId.age4to5, AgeBandId.age6],
      difficultyTier: LessonDifficultyTier.starter,
      skillTags: [SkillTag.pattern],
      sceneAsset: '$puzzleAssetRoot/apple.svg',
      supportingAssets: [
        '$puzzleAssetRoot/banana.svg',
        '$puzzleAssetRoot/pear.svg',
      ],
      requiredObjectIds: ['apple', 'banana', 'pear'],
      requiredColorIds: ['red', 'yellow', 'green'],
      requiredNumberSlots: 0,
      localizationKeys: PuzzleLocalizationKeys(
        title: 'challengeFruitPatternTitle',
        prompt: 'challengeFruitPatternPrompt',
        question: 'challengeFruitPatternQuestion',
        hint: 'challengeFruitPatternHint',
        explanation: 'challengeFruitPatternExplanation',
      ),
      animationCues: [
        PuzzleAnimationCue.answerBounce,
        PuzzleAnimationCue.objectReveal,
      ],
    ),
    PuzzleContent(
      id: 'content.toy_count.toy_shelf',
      familyId: 'toy-count',
      contentType: PuzzleContentType.counting,
      world: PuzzleWorld.toyCity,
      character: PuzzleCharacter.robi,
      characterPose: CharacterPose.idle,
      ageBands: [AgeBandId.age4to5, AgeBandId.age6],
      difficultyTier: LessonDifficultyTier.starter,
      skillTags: [SkillTag.arithmetic, SkillTag.attention],
      sceneAsset: '$puzzleAssetRoot/toy_cube_orange.svg',
      supportingAssets: [
        '$puzzleAssetRoot/toy_cube_blue.svg',
        '$puzzleAssetRoot/ball.svg',
      ],
      requiredObjectIds: ['cube', 'ball'],
      requiredColorIds: ['orange', 'blue'],
      requiredNumberSlots: 3,
      localizationKeys: PuzzleLocalizationKeys(
        title: 'challengeToyCountTitle',
        prompt: 'challengeToyCountPrompt',
        question: 'challengeToyCountQuestion',
        hint: 'challengeToyCountHint',
        explanation: 'challengeToyCountExplanation',
      ),
      animationCues: [
        PuzzleAnimationCue.answerBounce,
        PuzzleAnimationCue.starsFly,
      ],
    ),
    PuzzleContent(
      id: 'content.odd_card.picnic_cards',
      familyId: 'odd-card',
      contentType: PuzzleContentType.oddOneOut,
      world: PuzzleWorld.forest,
      character: PuzzleCharacter.owlCoach,
      characterPose: CharacterPose.thinking,
      ageBands: [AgeBandId.age4to5, AgeBandId.age6, AgeBandId.age7to8],
      difficultyTier: LessonDifficultyTier.growing,
      skillTags: [SkillTag.classification, SkillTag.attention],
      sceneAsset: '$puzzleAssetRoot/puzzle_card.svg',
      supportingAssets: [
        '$puzzleAssetRoot/apple.svg',
        '$puzzleAssetRoot/banana.svg',
        '$puzzleAssetRoot/pear.svg',
        '$puzzleAssetRoot/ball.svg',
        '$puzzleAssetRoot/cloud.svg',
        '$puzzleAssetRoot/shoe.svg',
      ],
      requiredObjectIds: [
        'apple',
        'banana',
        'pear',
        'ball',
        'cloud',
        'shoe',
      ],
      requiredColorIds: ['red', 'yellow', 'green', 'blue', 'purple'],
      requiredNumberSlots: 0,
      localizationKeys: PuzzleLocalizationKeys(
        title: 'challengeOddCardTitle',
        prompt: 'challengeOddCardPrompt',
        question: 'challengeOddCardQuestion',
        hint: 'challengeOddCardHint',
        explanation: 'challengeOddCardExplanation',
      ),
      animationCues: [
        PuzzleAnimationCue.answerBounce,
        PuzzleAnimationCue.wrongShake,
      ],
    ),
    PuzzleContent(
      id: 'content.logic_train.station_pattern',
      familyId: 'logic-train',
      contentType: PuzzleContentType.patternSequence,
      world: PuzzleWorld.toyCity,
      character: PuzzleCharacter.robi,
      characterPose: CharacterPose.thinking,
      ageBands: [AgeBandId.age6, AgeBandId.age7to8],
      difficultyTier: LessonDifficultyTier.growing,
      skillTags: [SkillTag.pattern, SkillTag.reasoning],
      sceneAsset: '$puzzleAssetRoot/train_red.svg',
      supportingAssets: [
        '$puzzleAssetRoot/train_blue.svg',
        '$puzzleAssetRoot/train_green.svg',
      ],
      requiredObjectIds: ['train'],
      requiredColorIds: ['red', 'blue', 'green'],
      requiredNumberSlots: 0,
      localizationKeys: PuzzleLocalizationKeys(
        title: 'challengeLogicTrainTitle',
        prompt: 'challengeLogicTrainPrompt',
        question: 'challengeLogicTrainQuestion',
        hint: 'challengeLogicTrainHint',
        explanation: 'challengeLogicTrainExplanation',
      ),
      animationCues: [
        PuzzleAnimationCue.answerBounce,
        PuzzleAnimationCue.pathMove,
      ],
    ),
    PuzzleContent(
      id: 'content.sticker_sum.album_math',
      familyId: 'sticker-sum',
      contentType: PuzzleContentType.visualMathStory,
      world: PuzzleWorld.toyCity,
      character: PuzzleCharacter.leo,
      characterPose: CharacterPose.happy,
      ageBands: [AgeBandId.age6, AgeBandId.age7to8],
      difficultyTier: LessonDifficultyTier.growing,
      skillTags: [SkillTag.arithmetic],
      sceneAsset: '$puzzleAssetRoot/puzzle_card.svg',
      supportingAssets: [
        '$puzzleAssetRoot/sign_plus.svg',
        '$puzzleAssetRoot/sign_equals.svg',
        '$puzzleAssetRoot/sign_question.svg',
      ],
      requiredObjectIds: ['sticker', 'card'],
      requiredColorIds: ['yellow', 'teal'],
      requiredNumberSlots: 3,
      localizationKeys: PuzzleLocalizationKeys(
        title: 'challengeStickerSumTitle',
        prompt: 'challengeStickerSumPrompt',
        question: 'challengeStickerSumQuestion',
        hint: 'challengeStickerSumHint',
        explanation: 'challengeStickerSumExplanation',
      ),
      animationCues: [
        PuzzleAnimationCue.answerBounce,
        PuzzleAnimationCue.starsFly,
      ],
    ),
    PuzzleContent(
      id: 'content.memory_pairs.magic_pairs',
      familyId: 'memory-pairs',
      contentType: PuzzleContentType.pairMatching,
      world: PuzzleWorld.sea,
      character: PuzzleCharacter.owlCoach,
      characterPose: CharacterPose.hint,
      ageBands: [AgeBandId.age6, AgeBandId.age7to8],
      difficultyTier: LessonDifficultyTier.growing,
      skillTags: [SkillTag.memory, SkillTag.classification],
      sceneAsset: '$puzzleAssetRoot/key.svg',
      supportingAssets: [
        '$puzzleAssetRoot/lock.svg',
        '$puzzleAssetRoot/shoe.svg',
        '$puzzleAssetRoot/cloud.svg',
      ],
      requiredObjectIds: ['key', 'lock', 'shoe', 'cloud'],
      requiredColorIds: ['yellow', 'purple', 'blue'],
      requiredNumberSlots: 0,
      localizationKeys: PuzzleLocalizationKeys(
        title: 'challengeMemoryPairsTitle',
        prompt: 'challengeMemoryPairsPrompt',
        question: 'challengeMemoryPairsQuestion',
        hint: 'challengeMemoryPairsHint',
        explanation: 'challengeMemoryPairsExplanation',
      ),
      animationCues: [
        PuzzleAnimationCue.objectReveal,
        PuzzleAnimationCue.hintGlow,
      ],
    ),
    PuzzleContent(
      id: 'content.lock_key.magic_pair',
      familyId: 'lock-key',
      contentType: PuzzleContentType.pairMatching,
      world: PuzzleWorld.magicSchool,
      character: PuzzleCharacter.owlCoach,
      characterPose: CharacterPose.hint,
      ageBands: [AgeBandId.age6, AgeBandId.age7to8],
      difficultyTier: LessonDifficultyTier.confident,
      skillTags: [SkillTag.memory, SkillTag.reasoning],
      sceneAsset: '$puzzleAssetRoot/key.svg',
      supportingAssets: [
        '$puzzleAssetRoot/lock.svg',
        '$puzzleAssetRoot/shoe.svg',
        '$puzzleAssetRoot/cloud.svg',
      ],
      requiredObjectIds: ['key', 'lock', 'shoe', 'cloud'],
      requiredColorIds: ['yellow', 'purple', 'blue'],
      requiredNumberSlots: 0,
      localizationKeys: PuzzleLocalizationKeys(
        title: 'challengeLockKeyTitle',
        prompt: 'challengeLockKeyPrompt',
        question: 'challengeLockKeyQuestion',
        hint: 'challengeLockKeyHint',
        explanation: 'challengeLockKeyExplanation',
      ),
      animationCues: [
        PuzzleAnimationCue.objectReveal,
        PuzzleAnimationCue.answerBounce,
      ],
    ),
    PuzzleContent(
      id: 'content.shadow_match.space_shadow',
      familyId: 'shadow-match',
      contentType: PuzzleContentType.shadowMatch,
      world: PuzzleWorld.space,
      character: PuzzleCharacter.nickAstronaut,
      characterPose: CharacterPose.thinking,
      ageBands: [AgeBandId.age4to5, AgeBandId.age6, AgeBandId.age7to8],
      difficultyTier: LessonDifficultyTier.growing,
      skillTags: [SkillTag.spatial, SkillTag.attention],
      sceneAsset: '$puzzleAssetRoot/shadow_rocket.svg',
      supportingAssets: [
        '$puzzleAssetRoot/rocket.svg',
        '$puzzleAssetRoot/planet.svg',
        '$puzzleAssetRoot/shape_star.svg',
      ],
      requiredObjectIds: ['rocket', 'planet', 'star'],
      requiredColorIds: ['blue', 'red', 'yellow'],
      requiredNumberSlots: 0,
      localizationKeys: PuzzleLocalizationKeys(
        title: 'challengeShadowMatchTitle',
        prompt: 'challengeShadowMatchPrompt',
        question: 'challengeShadowMatchQuestion',
        hint: 'challengeShadowMatchHint',
        explanation: 'challengeShadowMatchExplanation',
      ),
      animationCues: [
        PuzzleAnimationCue.objectReveal,
        PuzzleAnimationCue.hintGlow,
      ],
    ),
    PuzzleContent(
      id: 'content.balance_scale.farm_scales',
      familyId: 'balance-scale',
      contentType: PuzzleContentType.comparison,
      world: PuzzleWorld.farm,
      character: PuzzleCharacter.leo,
      characterPose: CharacterPose.thinking,
      ageBands: [AgeBandId.age6, AgeBandId.age7to8],
      difficultyTier: LessonDifficultyTier.confident,
      skillTags: [SkillTag.arithmetic, SkillTag.reasoning],
      sceneAsset: '$puzzleAssetRoot/scale.svg',
      supportingAssets: [
        '$puzzleAssetRoot/apple.svg',
        '$puzzleAssetRoot/ball.svg',
        '$puzzleAssetRoot/shape_star.svg',
      ],
      requiredObjectIds: ['scale', 'apple', 'ball', 'star'],
      requiredColorIds: ['red', 'yellow', 'blue'],
      requiredNumberSlots: 3,
      localizationKeys: PuzzleLocalizationKeys(
        title: 'challengeBalanceScaleTitle',
        prompt: 'challengeBalanceScalePrompt',
        question: 'challengeBalanceScaleQuestion',
        hint: 'challengeBalanceScaleHint',
        explanation: 'challengeBalanceScaleExplanation',
      ),
      animationCues: [
        PuzzleAnimationCue.answerBounce,
        PuzzleAnimationCue.objectReveal,
      ],
    ),
    PuzzleContent(
      id: 'content.shape_rotation.lab_turntable',
      familyId: 'shape-rotation',
      contentType: PuzzleContentType.spatialRotation,
      world: PuzzleWorld.laboratory,
      character: PuzzleCharacter.robi,
      characterPose: CharacterPose.thinking,
      ageBands: [AgeBandId.age7to8],
      difficultyTier: LessonDifficultyTier.challenge,
      skillTags: [SkillTag.spatial, SkillTag.reasoning],
      sceneAsset: '$puzzleAssetRoot/shape_triangle.svg',
      supportingAssets: [
        '$puzzleAssetRoot/shape_circle.svg',
        '$puzzleAssetRoot/shape_square.svg',
        '$puzzleAssetRoot/sign_arrow.svg',
      ],
      requiredObjectIds: ['triangle', 'circle', 'square'],
      requiredColorIds: ['purple', 'teal', 'blue'],
      requiredNumberSlots: 0,
      localizationKeys: PuzzleLocalizationKeys(
        title: 'challengeShapeRotationTitle',
        prompt: 'challengeShapeRotationPrompt',
        question: 'challengeShapeRotationQuestion',
        hint: 'challengeShapeRotationHint',
        explanation: 'challengeShapeRotationExplanation',
      ),
      animationCues: [
        PuzzleAnimationCue.objectReveal,
        PuzzleAnimationCue.answerBounce,
      ],
    ),
    PuzzleContent(
      id: 'content.code_grid.lab_panel',
      familyId: 'code-grid',
      contentType: PuzzleContentType.symbolCode,
      world: PuzzleWorld.laboratory,
      character: PuzzleCharacter.robi,
      characterPose: CharacterPose.hint,
      ageBands: [AgeBandId.age7to8],
      difficultyTier: LessonDifficultyTier.challenge,
      skillTags: [SkillTag.reasoning, SkillTag.arithmetic],
      sceneAsset: '$puzzleAssetRoot/puzzle_card.svg',
      supportingAssets: [
        '$puzzleAssetRoot/sign_arrow.svg',
        '$puzzleAssetRoot/sign_question.svg',
      ],
      requiredObjectIds: ['number', 'grid', 'code'],
      requiredColorIds: ['blue', 'teal'],
      requiredNumberSlots: 7,
      localizationKeys: PuzzleLocalizationKeys(
        title: 'challengeCodeGridTitle',
        prompt: 'challengeCodeGridPrompt',
        question: 'challengeCodeGridQuestion',
        hint: 'challengeCodeGridHint',
        explanation: 'challengeCodeGridExplanation',
      ),
      animationCues: [
        PuzzleAnimationCue.hintGlow,
        PuzzleAnimationCue.answerBounce,
      ],
    ),
    PuzzleContent(
      id: 'content.number_bridge.space_bridge',
      familyId: 'number-bridge',
      contentType: PuzzleContentType.visualMathStory,
      world: PuzzleWorld.space,
      character: PuzzleCharacter.nickAstronaut,
      characterPose: CharacterPose.thinking,
      ageBands: [AgeBandId.age7to8],
      difficultyTier: LessonDifficultyTier.confident,
      skillTags: [SkillTag.arithmetic, SkillTag.reasoning],
      sceneAsset: '$puzzleAssetRoot/sign_plus.svg',
      supportingAssets: [
        '$puzzleAssetRoot/sign_equals.svg',
        '$puzzleAssetRoot/sign_question.svg',
      ],
      requiredObjectIds: ['number', 'bridge', 'plus'],
      requiredColorIds: ['yellow', 'blue'],
      requiredNumberSlots: 4,
      localizationKeys: PuzzleLocalizationKeys(
        title: 'challengeNumberBridgeTitle',
        prompt: 'challengeNumberBridgePrompt',
        question: 'challengeNumberBridgeQuestion',
        hint: 'challengeNumberBridgeHint',
        explanation: 'challengeNumberBridgeExplanation',
      ),
      animationCues: [
        PuzzleAnimationCue.pathMove,
        PuzzleAnimationCue.starsFly,
      ],
    ),
    PuzzleContent(
      id: 'content.detail_count.observation_map',
      familyId: 'detail-count',
      contentType: PuzzleContentType.comparison,
      world: PuzzleWorld.laboratory,
      character: PuzzleCharacter.owlCoach,
      characterPose: CharacterPose.thinking,
      ageBands: [AgeBandId.age7to8],
      difficultyTier: LessonDifficultyTier.challenge,
      skillTags: [SkillTag.attention, SkillTag.memory],
      sceneAsset: '$puzzleAssetRoot/puzzle_card.svg',
      supportingAssets: [
        '$puzzleAssetRoot/shape_circle.svg',
        '$puzzleAssetRoot/shape_square.svg',
        '$puzzleAssetRoot/shape_star.svg',
      ],
      requiredObjectIds: ['circle', 'square', 'star'],
      requiredColorIds: ['red', 'blue', 'green'],
      requiredNumberSlots: 3,
      localizationKeys: PuzzleLocalizationKeys(
        title: 'challengeDetailCountTitle',
        prompt: 'challengeDetailCountPrompt',
        question: 'challengeDetailCountQuestion',
        hint: 'challengeDetailCountHint',
        explanation: 'challengeDetailCountExplanation',
      ),
      animationCues: [
        PuzzleAnimationCue.objectReveal,
        PuzzleAnimationCue.answerBounce,
      ],
    ),
    PuzzleContent(
      id: 'content.space_sequence.planet_route',
      familyId: 'space-sequence',
      contentType: PuzzleContentType.patternSequence,
      world: PuzzleWorld.space,
      character: PuzzleCharacter.nickAstronaut,
      characterPose: CharacterPose.happy,
      ageBands: [AgeBandId.age7to8],
      difficultyTier: LessonDifficultyTier.growing,
      skillTags: [SkillTag.pattern, SkillTag.spatial],
      sceneAsset: '$puzzleAssetRoot/rocket.svg',
      supportingAssets: [
        '$puzzleAssetRoot/planet.svg',
        '$puzzleAssetRoot/shape_star.svg',
      ],
      requiredObjectIds: ['rocket', 'planet', 'star'],
      requiredColorIds: ['red', 'blue', 'yellow'],
      requiredNumberSlots: 0,
      localizationKeys: PuzzleLocalizationKeys(
        title: 'challengeSpaceSequenceTitle',
        prompt: 'challengeSpaceSequencePrompt',
        question: 'challengeSpaceSequenceQuestion',
        hint: 'challengeSpaceSequenceHint',
        explanation: 'challengeSpaceSequenceExplanation',
      ),
      animationCues: [
        PuzzleAnimationCue.pathMove,
        PuzzleAnimationCue.answerBounce,
      ],
    ),
    PuzzleContent(
      id: 'content.shape_stack.magic_tower',
      familyId: 'shape-stack',
      contentType: PuzzleContentType.patternSequence,
      world: PuzzleWorld.magicSchool,
      character: PuzzleCharacter.leo,
      characterPose: CharacterPose.thinking,
      ageBands: [AgeBandId.age7to8],
      difficultyTier: LessonDifficultyTier.growing,
      skillTags: [SkillTag.pattern, SkillTag.spatial],
      sceneAsset: '$puzzleAssetRoot/shape_square.svg',
      supportingAssets: [
        '$puzzleAssetRoot/shape_circle.svg',
        '$puzzleAssetRoot/shape_triangle.svg',
        '$puzzleAssetRoot/shape_star.svg',
      ],
      requiredObjectIds: ['square', 'circle', 'triangle', 'star'],
      requiredColorIds: ['blue', 'teal', 'purple', 'yellow'],
      requiredNumberSlots: 0,
      localizationKeys: PuzzleLocalizationKeys(
        title: 'challengeShapeStackTitle',
        prompt: 'challengeShapeStackPrompt',
        question: 'challengeShapeStackQuestion',
        hint: 'challengeShapeStackHint',
        explanation: 'challengeShapeStackExplanation',
      ),
      animationCues: [
        PuzzleAnimationCue.objectReveal,
        PuzzleAnimationCue.answerBounce,
      ],
    ),
    PuzzleContent(
      id: 'content.path_maze.space_path',
      familyId: 'path-maze',
      contentType: PuzzleContentType.pathLogic,
      world: PuzzleWorld.space,
      character: PuzzleCharacter.nickAstronaut,
      characterPose: CharacterPose.hint,
      ageBands: [AgeBandId.age7to8],
      difficultyTier: LessonDifficultyTier.challenge,
      skillTags: [SkillTag.spatial, SkillTag.reasoning],
      sceneAsset: '$puzzleAssetRoot/sign_arrow.svg',
      supportingAssets: [
        '$puzzleAssetRoot/rocket.svg',
        '$puzzleAssetRoot/planet.svg',
        '$puzzleAssetRoot/key.svg',
        '$puzzleAssetRoot/lock.svg',
        '$puzzleAssetRoot/shoe.svg',
        '$puzzleAssetRoot/cloud.svg',
      ],
      requiredObjectIds: ['rocket', 'planet', 'key', 'lock', 'shoe', 'cloud'],
      requiredColorIds: ['blue', 'red', 'yellow', 'purple'],
      requiredNumberSlots: 0,
      localizationKeys: PuzzleLocalizationKeys(
        title: 'challengePathMazeTitle',
        prompt: 'challengePathMazePrompt',
        question: 'challengePathMazeQuestion',
        hint: 'challengePathMazeHint',
        explanation: 'challengePathMazeExplanation',
      ),
      animationCues: [
        PuzzleAnimationCue.pathMove,
        PuzzleAnimationCue.answerBounce,
      ],
    ),
    PuzzleContent(
      id: 'content.memory_recall.hidden_cards',
      familyId: 'memory-recall',
      contentType: PuzzleContentType.memoryRecall,
      world: PuzzleWorld.magicSchool,
      character: PuzzleCharacter.owlCoach,
      characterPose: CharacterPose.thinking,
      ageBands: [AgeBandId.age6, AgeBandId.age7to8],
      difficultyTier: LessonDifficultyTier.growing,
      skillTags: [SkillTag.memory, SkillTag.attention],
      sceneAsset: '$puzzleAssetRoot/puzzle_card.svg',
      supportingAssets: [
        '$puzzleAssetRoot/rocket.svg',
        '$puzzleAssetRoot/planet.svg',
        '$puzzleAssetRoot/shape_star.svg',
        '$puzzleAssetRoot/key.svg',
        '$puzzleAssetRoot/banana.svg',
      ],
      requiredObjectIds: ['card', 'rocket', 'planet', 'star', 'key', 'banana'],
      requiredColorIds: ['blue', 'yellow', 'purple'],
      requiredNumberSlots: 0,
      localizationKeys: PuzzleLocalizationKeys(
        title: 'challengeMemoryRecallTitle',
        prompt: 'challengeMemoryRecallPrompt',
        question: 'challengeMemoryRecallQuestion',
        hint: 'challengeMemoryRecallHint',
        explanation: 'challengeMemoryRecallExplanation',
      ),
      animationCues: [
        PuzzleAnimationCue.objectReveal,
        PuzzleAnimationCue.hintGlow,
      ],
    ),
    PuzzleContent(
      id: 'content.sorting_rule.rule_box',
      familyId: 'sorting-rule',
      contentType: PuzzleContentType.sortingRule,
      world: PuzzleWorld.toyCity,
      character: PuzzleCharacter.robi,
      characterPose: CharacterPose.hint,
      ageBands: [AgeBandId.age6, AgeBandId.age7to8],
      difficultyTier: LessonDifficultyTier.confident,
      skillTags: [SkillTag.classification, SkillTag.reasoning],
      sceneAsset: '$puzzleAssetRoot/puzzle_card.svg',
      supportingAssets: [
        '$puzzleAssetRoot/apple.svg',
        '$puzzleAssetRoot/banana.svg',
        '$puzzleAssetRoot/pear.svg',
        '$puzzleAssetRoot/rocket.svg',
        '$puzzleAssetRoot/shape_star.svg',
        '$puzzleAssetRoot/lock.svg',
      ],
      requiredObjectIds: ['box', 'apple', 'banana', 'pear', 'rocket', 'lock'],
      requiredColorIds: ['red', 'yellow', 'green', 'blue'],
      requiredNumberSlots: 0,
      localizationKeys: PuzzleLocalizationKeys(
        title: 'challengeSortingRuleTitle',
        prompt: 'challengeSortingRulePrompt',
        question: 'challengeSortingRuleQuestion',
        hint: 'challengeSortingRuleHint',
        explanation: 'challengeSortingRuleExplanation',
      ),
      animationCues: [
        PuzzleAnimationCue.answerBounce,
        PuzzleAnimationCue.wrongShake,
      ],
    ),
    PuzzleContent(
      id: 'content.missing_piece.picture_patch',
      familyId: 'missing-piece',
      contentType: PuzzleContentType.missingPiece,
      world: PuzzleWorld.laboratory,
      character: PuzzleCharacter.robi,
      characterPose: CharacterPose.thinking,
      ageBands: [AgeBandId.age7to8],
      difficultyTier: LessonDifficultyTier.confident,
      skillTags: [SkillTag.spatial, SkillTag.attention],
      sceneAsset: '$puzzleAssetRoot/rocket.svg',
      supportingAssets: [
        '$puzzleAssetRoot/shape_circle.svg',
        '$puzzleAssetRoot/shape_square.svg',
        '$puzzleAssetRoot/shape_star.svg',
        '$puzzleAssetRoot/key.svg',
      ],
      requiredObjectIds: ['rocket', 'planet', 'circle', 'star', 'key'],
      requiredColorIds: ['teal', 'blue', 'yellow'],
      requiredNumberSlots: 0,
      localizationKeys: PuzzleLocalizationKeys(
        title: 'challengeMissingPieceTitle',
        prompt: 'challengeMissingPiecePrompt',
        question: 'challengeMissingPieceQuestion',
        hint: 'challengeMissingPieceHint',
        explanation: 'challengeMissingPieceExplanation',
      ),
      animationCues: [
        PuzzleAnimationCue.objectReveal,
        PuzzleAnimationCue.answerBounce,
      ],
    ),
    PuzzleContent(
      id: 'content.logic_deduction.two_clues',
      familyId: 'logic-deduction',
      contentType: PuzzleContentType.logicDeduction,
      world: PuzzleWorld.laboratory,
      character: PuzzleCharacter.owlCoach,
      characterPose: CharacterPose.hint,
      ageBands: [AgeBandId.age7to8],
      difficultyTier: LessonDifficultyTier.challenge,
      skillTags: [SkillTag.reasoning, SkillTag.classification],
      sceneAsset: '$puzzleAssetRoot/sign_question.svg',
      supportingAssets: [
        '$puzzleAssetRoot/rocket.svg',
        '$puzzleAssetRoot/apple.svg',
        '$puzzleAssetRoot/ball.svg',
        '$puzzleAssetRoot/key.svg',
        '$puzzleAssetRoot/cloud.svg',
        '$puzzleAssetRoot/banana.svg',
      ],
      requiredObjectIds: ['clue', 'rocket', 'key', 'banana'],
      requiredColorIds: ['yellow', 'teal', 'blue'],
      requiredNumberSlots: 0,
      localizationKeys: PuzzleLocalizationKeys(
        title: 'challengeLogicDeductionTitle',
        prompt: 'challengeLogicDeductionPrompt',
        question: 'challengeLogicDeductionQuestion',
        hint: 'challengeLogicDeductionHint',
        explanation: 'challengeLogicDeductionExplanation',
      ),
      animationCues: [
        PuzzleAnimationCue.hintGlow,
        PuzzleAnimationCue.answerBounce,
      ],
    ),
  ];

  static PuzzleContent? maybeByFamilyId(String familyId) {
    for (final content in contents) {
      if (content.familyId == familyId) {
        return content;
      }
    }
    return null;
  }

  static PuzzleContent byFamilyId(String familyId) {
    return maybeByFamilyId(familyId) ?? contents.first;
  }

  static PuzzleContent forPuzzle(PuzzleDefinition puzzle) {
    return byFamilyId(puzzle.payloadRef);
  }

  static PuzzleWorldTheme themeForWorld(PuzzleWorld world) {
    return worldThemes.firstWhere(
      (theme) => theme.world == world,
      orElse: () => worldThemes.first,
    );
  }

  static String characterAsset(PuzzleCharacter character) {
    return _characterAssets(character).first;
  }

  static List<String> assetsForChoice(String familyId, String choiceId) {
    if (int.tryParse(choiceId) case final value?) {
      return ['$puzzleAssetRoot/number_$value.svg'];
    }

    if (choiceId.contains('+')) {
      return [
        for (final token in choiceId.split('+'))
          if (int.tryParse(token) case final value?)
            '$puzzleAssetRoot/number_$value.svg',
        '$puzzleAssetRoot/sign_plus.svg',
      ];
    }

    final asset =
        _choiceAssets['$familyId:$choiceId'] ?? _choiceAssets[choiceId];
    if (asset == null) {
      return const [];
    }
    return [asset];
  }

  static List<String> assetsForContent(PuzzleContent content) {
    return [
      content.sceneAsset,
      ...content.supportingAssets,
      themeForWorld(content.world).ambientAsset,
      ..._characterAssets(content.character),
    ];
  }

  static List<String> _characterAssets(PuzzleCharacter character) {
    return switch (character) {
      PuzzleCharacter.leo => ['$generatedAssetRoot/lion.png'],
      PuzzleCharacter.nickAstronaut => ['$generatedAssetRoot/astronaut.png'],
      PuzzleCharacter.robi => ['$generatedAssetRoot/rocket.png'],
      PuzzleCharacter.owlCoach => ['$generatedAssetRoot/sticker.png'],
    };
  }

  static const _choiceAssets = <String, String>{
    'circle': '$puzzleAssetRoot/shape_circle.svg',
    'square': '$puzzleAssetRoot/shape_square.svg',
    'triangle': '$puzzleAssetRoot/shape_triangle.svg',
    'star': '$puzzleAssetRoot/shape_star.svg',
    'apple': '$puzzleAssetRoot/apple.svg',
    'banana': '$puzzleAssetRoot/banana.svg',
    'pear': '$puzzleAssetRoot/pear.svg',
    'ball': '$puzzleAssetRoot/ball.svg',
    'rocket': '$puzzleAssetRoot/rocket.svg',
    'planet': '$puzzleAssetRoot/planet.svg',
    'lock': '$puzzleAssetRoot/lock.svg',
    'key': '$puzzleAssetRoot/key.svg',
    'shoe': '$puzzleAssetRoot/shoe.svg',
    'cloud': '$puzzleAssetRoot/cloud.svg',
    'red': '$puzzleAssetRoot/train_red.svg',
    'blue': '$puzzleAssetRoot/train_blue.svg',
    'green': '$puzzleAssetRoot/train_green.svg',
    'same': '$puzzleAssetRoot/shape_triangle.svg',
    'left': '$puzzleAssetRoot/sign_arrow.svg',
    'right': '$puzzleAssetRoot/sign_arrow.svg',
    'up': '$puzzleAssetRoot/sign_arrow.svg',
    'down': '$puzzleAssetRoot/sign_arrow.svg',
    'blue-squares': '$puzzleAssetRoot/shape_square.svg',
    'red-circles': '$puzzleAssetRoot/shape_circle.svg',
    'green-stars': '$puzzleAssetRoot/shape_star.svg',
    'detail-count:blue-squares': '$puzzleAssetRoot/shape_square.svg',
    'detail-count:red-circles': '$puzzleAssetRoot/shape_circle.svg',
    'detail-count:green-stars': '$puzzleAssetRoot/shape_star.svg',
    'memory-recall:star': '$puzzleAssetRoot/shape_star.svg',
    'memory-recall:key': '$puzzleAssetRoot/key.svg',
    'memory-recall:banana': '$puzzleAssetRoot/banana.svg',
    'memory-recall:triangle': '$puzzleAssetRoot/shape_triangle.svg',
    'sorting-rule:pear': '$puzzleAssetRoot/pear.svg',
    'sorting-rule:star': '$puzzleAssetRoot/shape_star.svg',
    'sorting-rule:planet': '$puzzleAssetRoot/planet.svg',
    'sorting-rule:lock': '$puzzleAssetRoot/lock.svg',
    'missing-piece:circle': '$puzzleAssetRoot/shape_circle.svg',
    'missing-piece:star': '$puzzleAssetRoot/shape_star.svg',
    'missing-piece:key': '$puzzleAssetRoot/key.svg',
    'logic-deduction:rocket': '$puzzleAssetRoot/rocket.svg',
    'logic-deduction:key': '$puzzleAssetRoot/key.svg',
    'logic-deduction:banana': '$puzzleAssetRoot/banana.svg',
  };
}
