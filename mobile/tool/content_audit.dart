import 'dart:convert';
import 'dart:io';

import 'package:logic_like/src/domain/daily_challenge.dart';
import 'package:logic_like/src/domain/family_profile.dart';
import 'package:logic_like/src/domain/learning_foundation.dart';
import 'package:logic_like/src/domain/content_pack.dart';
import 'package:logic_like/src/domain/puzzle_content.dart';

const _supportedVisualFamilies = {
  'shape-path',
  'fruit-pattern',
  'toy-count',
  'odd-card',
  'logic-train',
  'sticker-sum',
  'memory-pairs',
  'lock-key',
  'shadow-match',
  'balance-scale',
  'shape-rotation',
  'code-grid',
  'number-bridge',
  'detail-count',
  'space-sequence',
  'shape-stack',
  'path-maze',
  'memory-recall',
  'sorting-rule',
  'missing-piece',
  'logic-deduction',
};

const _mojibakePatterns = ['Гђ', 'Г‘', 'Гѓ', 'Г‚', 'Гў', 'РІР‚', '\uFFFD'];
const _phase14DifficultyOrder = {
  'easy': 0,
  'medium': 1,
  'hard': 2,
  'mixed-review': 3,
};

void main() {
  final enArb = _readArb('lib/l10n/app_en.arb');
  final ruArb = _readArb('lib/l10n/app_ru.arb');
  final rows = <Map<String, Object?>>[];
  final issues = <Map<String, Object?>>[];
  final phase13Rows = <Map<String, Object?>>[];
  final phase13Issues = <Map<String, Object?>>[];
  final phase14Rows = <Map<String, Object?>>[];
  final phase14Issues = <Map<String, Object?>>[];

  for (final lesson in FoundationCatalog.starterLessons) {
    final lessonNumber = _numberFromId(lesson.id);
    final steps = FoundationCatalog.stepsForLesson(lesson);

    for (final step in steps) {
      final puzzle = FoundationCatalog.puzzleForStep(step);
      final content = PuzzleContentCatalog.maybeByFamilyId(puzzle.payloadRef);
      final challenge = dailyChallengeForLessonStep(
        step,
        puzzle,
        age: ChildAge.six,
      );
      final rowIssues = _issuesFor(
        challenge,
        lesson,
        puzzle,
        content,
        enArb,
        ruArb,
      );
      final row = {
        'lessonId': lesson.id,
        'lessonNumber': lessonNumber,
        'lessonTitleKey': lesson.titleKey,
        'lessonTitleEn': enArb[lesson.titleKey],
        'lessonTitleRu': ruArb[lesson.titleKey],
        'stepId': step.id,
        'stepOrder': step.order,
        'stepRole': FoundationCatalog.roleForStep(step).name,
        'puzzleId': puzzle.id,
        'family': challenge.visualId,
        'contentId': content?.id,
        'contentType': content?.contentType.name,
        'world': content?.world.name,
        'character': content?.character.name,
        'characterPose': content?.characterPose.name,
        'sceneAsset': content?.sceneAsset,
        'requiredObjectIds': content?.requiredObjectIds ?? const [],
        'requiredColorIds': content?.requiredColorIds ?? const [],
        'requiredNumberSlots': content?.requiredNumberSlots,
        'animationCues': [
          for (final cue
              in content?.animationCues ?? const <PuzzleAnimationCue>[])
            cue.name,
        ],
        'skillTag': step.internalSkillTag.name,
        'lessonDifficulty': FoundationCatalog.difficultyForLesson(lesson).name,
        'puzzleDifficulty': _difficultyFor(challenge),
        'questionKey': challenge.question,
        'hintKey': challenge.hint,
        'explanationKey': challenge.explanation,
        'correctChoiceId': challenge.correctChoiceId,
        'choices': [
          for (final choice in challenge.choices)
            {
              'id': choice.id,
              'rawLabel': choice.label,
            },
        ],
        'tokens': challenge.tokens,
        'numbers': challenge.numbers,
        'issues': rowIssues,
      };

      rows.add(row);

      for (final issue in rowIssues) {
        issues.add({
          'lessonId': lesson.id,
          'stepId': step.id,
          'family': challenge.visualId,
          'issue': issue,
        });
      }
    }
  }

  for (final item in ContentPackCatalog.phase13Items) {
    final content = PuzzleContentCatalog.maybeByFamilyId(item.familyId);
    final itemIssues = _issuesForContentPackItem(item, content);
    phase13Rows.add({
      'id': item.id,
      'category': item.category,
      'family': item.familyId,
      'contentId': content?.id,
      'contentType': content?.contentType.name,
      'world': content?.world.name,
      'character': content?.character.name,
      'correctChoiceId': item.correctChoiceId,
      'choices': item.choiceIds,
      'tokens': item.tokens,
      'numbers': item.numbers,
      'signature': item.signature,
      'issues': itemIssues,
    });
    for (final issue in itemIssues) {
      phase13Issues.add({
        'id': item.id,
        'family': item.familyId,
        'issue': issue,
      });
    }
  }

  for (final item in ContentPackCatalog.phase14Items) {
    final content = PuzzleContentCatalog.maybeByFamilyId(item.familyId);
    final itemIssues = _issuesForContentPackItem(item, content);
    phase14Rows.add({
      'id': item.id,
      'category': item.category,
      'difficultyBand': item.difficultyBand,
      'bossLessonId': item.bossLessonId,
      'family': item.familyId,
      'contentId': content?.id,
      'contentType': content?.contentType.name,
      'world': content?.world.name,
      'character': content?.character.name,
      'correctChoiceId': item.correctChoiceId,
      'choices': item.choiceIds,
      'tokens': item.tokens,
      'numbers': item.numbers,
      'signature': item.signature,
      'issues': itemIssues,
    });
    for (final issue in itemIssues) {
      phase14Issues.add({
        'id': item.id,
        'family': item.familyId,
        'issue': issue,
      });
    }
  }

  final familyCounts = <String, int>{};
  final difficultyCounts = <String, int>{};
  final worldCounts = <String, int>{};
  final characterCounts = <String, int>{};
  final characterPoseCounts = <String, int>{};
  final phase13FamilyCounts = <String, int>{};
  final phase13CategoryCounts = <String, int>{};
  final phase14FamilyCounts = <String, int>{};
  final phase14CategoryCounts = <String, int>{};
  final phase14DifficultyCounts = <String, int>{};
  final phase14BossCounts = <String, int>{};
  for (final row in rows) {
    final family = row['family']! as String;
    final difficulty = row['lessonDifficulty']! as String;
    final world = row['world'] as String?;
    final character = row['character'] as String?;
    final characterPose = row['characterPose'] as String?;
    familyCounts[family] = (familyCounts[family] ?? 0) + 1;
    difficultyCounts[difficulty] = (difficultyCounts[difficulty] ?? 0) + 1;
    if (world != null) {
      worldCounts[world] = (worldCounts[world] ?? 0) + 1;
    }
    if (character != null) {
      characterCounts[character] = (characterCounts[character] ?? 0) + 1;
    }
    if (characterPose != null) {
      characterPoseCounts[characterPose] =
          (characterPoseCounts[characterPose] ?? 0) + 1;
    }
  }
  for (final row in phase13Rows) {
    final family = row['family']! as String;
    final category = row['category']! as String;
    phase13FamilyCounts[family] = (phase13FamilyCounts[family] ?? 0) + 1;
    phase13CategoryCounts[category] =
        (phase13CategoryCounts[category] ?? 0) + 1;
  }
  for (final row in phase14Rows) {
    final family = row['family']! as String;
    final category = row['category']! as String;
    final difficulty = row['difficultyBand']! as String;
    final bossLessonId = row['bossLessonId'] as String?;
    phase14FamilyCounts[family] = (phase14FamilyCounts[family] ?? 0) + 1;
    phase14CategoryCounts[category] =
        (phase14CategoryCounts[category] ?? 0) + 1;
    phase14DifficultyCounts[difficulty] =
        (phase14DifficultyCounts[difficulty] ?? 0) + 1;
    if (bossLessonId != null) {
      phase14BossCounts[bossLessonId] =
          (phase14BossCounts[bossLessonId] ?? 0) + 1;
    }
  }

  final releaseGateIssues = [
    ..._releaseGateIssues(
      rows: rows,
      phase13Rows: phase13Rows,
      phase14Rows: phase14Rows,
      rowIssues: issues,
      phase13Issues: phase13Issues,
      phase14Issues: phase14Issues,
      enArb: enArb,
      ruArb: ruArb,
    ),
  ];
  final releaseGatePassed = releaseGateIssues.isEmpty;

  final audit = {
    'generatedAt': DateTime.now().toIso8601String(),
    'summary': {
      'courses': FoundationCatalog.starterCourses.length,
      'lessons': FoundationCatalog.starterLessons.length,
      'steps': rows.length,
      'uniqueFamilies': familyCounts.length,
      'issues': issues.length,
      'releaseGatePassed': releaseGatePassed,
      'releaseGateIssues': releaseGateIssues.length,
      'familyCounts': _sortedMap(familyCounts),
      'difficultyCounts': _sortedMap(difficultyCounts),
      'worldCounts': _sortedMap(worldCounts),
      'characterCounts': _sortedMap(characterCounts),
      'characterPoseCounts': _sortedMap(characterPoseCounts),
      'characterProfiles': [
        for (final profile in PuzzleContentCatalog.characterProfiles)
          {
            'character': profile.character.name,
            'asset': profile.asset,
            'homeWorld': profile.homeWorld.name,
          },
      ],
      'characterPoseAssets': PuzzleContentCatalog.characterPoseAssets.length,
      'phase13ContentPackItems': ContentPackCatalog.phase13Items.length,
      'phase13UniqueSignatures': {
        for (final item in ContentPackCatalog.phase13Items) item.signature,
      }.length,
      'phase13Issues': phase13Issues.length,
      'phase13CategoryCounts': _sortedMap(phase13CategoryCounts),
      'phase13FamilyCounts': _sortedMap(phase13FamilyCounts),
      'phase14ContentPackItems': ContentPackCatalog.phase14Items.length,
      'phase14UniqueSignatures': {
        for (final item in ContentPackCatalog.phase14Items) item.signature,
      }.length,
      'phase14Issues': phase14Issues.length,
      'phase14DifficultyTargets': ContentPackCatalog.phase14DifficultyTargets,
      'phase14DifficultyCounts': _sortedMap(phase14DifficultyCounts),
      'phase14CategoryCounts': _sortedMap(phase14CategoryCounts),
      'phase14FamilyCounts': _sortedMap(phase14FamilyCounts),
      'phase14BossLessons': ContentPackCatalog.phase14BossLessons.length,
      'phase14BossCounts': _sortedMap(phase14BossCounts),
    },
    'releaseGate': {
      'passed': releaseGatePassed,
      'issues': releaseGateIssues,
      'checks': [
        'starter rows have no row-level issues',
        'phase 13 and phase 14 pack rows have no row-level issues',
        'all visible RU/EN strings are present and readable',
        'choice and content art resolves to local SVG assets',
        'correct answers are included among choices',
        'generated rows carry visual data',
        'detail-count text, numbers, colors, and SVG choice ids agree',
        'nearby starter steps do not repeat exact puzzle signatures',
        'course lesson difficulty does not regress',
        'phase 14 content is ordered by planned difficulty bands',
      ],
    },
    'issues': issues,
    'phase13Issues': phase13Issues,
    'phase13ContentPack': phase13Rows,
    'phase14Issues': phase14Issues,
    'phase14ContentPack': phase14Rows,
    'steps': rows,
  };

  final outputFile = File('../CONTENT_AUDIT.json');
  outputFile.writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert(audit),
  );

  stdout.writeln(
    'Generated ${outputFile.path} with ${rows.length} steps, '
    '${issues.length} row issues, and '
    '${releaseGateIssues.length} release-gate issues.',
  );

  if (!releaseGatePassed) {
    exitCode = 1;
  }
}

List<String> _issuesForContentPackItem(
  ContentPackItem item,
  PuzzleContent? content,
) {
  final issues = <String>[];
  final choiceIds = item.choiceIds.toSet();

  if (content == null) {
    issues.add('missing_puzzle_content');
  }
  if (item.choiceIds.length < 3) {
    issues.add('too_few_choices');
  }
  if (!choiceIds.contains(item.correctChoiceId)) {
    issues.add('correct_choice_missing');
  }
  if (item.signature.trim().isEmpty) {
    issues.add('empty_signature');
  }
  if (item.tokens.isEmpty && item.numbers.isEmpty) {
    issues.add('missing_visual_data');
  }

  for (final choiceId in item.choiceIds) {
    final assets = PuzzleContentCatalog.assetsForChoice(
      item.familyId,
      choiceId,
    );
    if (assets.isEmpty) {
      issues.add('missing_choice_visual:$choiceId');
    }
    for (final asset in assets) {
      if (!File(asset).existsSync()) {
        issues.add('missing_choice_asset:$choiceId:$asset');
      }
    }
  }

  return issues;
}

List<Map<String, Object?>> _releaseGateIssues({
  required List<Map<String, Object?>> rows,
  required List<Map<String, Object?>> phase13Rows,
  required List<Map<String, Object?>> phase14Rows,
  required List<Map<String, Object?>> rowIssues,
  required List<Map<String, Object?>> phase13Issues,
  required List<Map<String, Object?>> phase14Issues,
  required Map<String, Object?> enArb,
  required Map<String, Object?> ruArb,
}) {
  final issues = <Map<String, Object?>>[];

  void add(String code, String scope, String detail) {
    issues.add({
      'code': code,
      'scope': scope,
      'detail': detail,
    });
  }

  for (final issue in rowIssues) {
    add(
      'starter_row_issue',
      '${issue['lessonId']}/${issue['stepId']}',
      '${issue['family']}: ${issue['issue']}',
    );
  }
  for (final issue in phase13Issues) {
    add(
      'phase13_row_issue',
      '${issue['id']}',
      '${issue['family']}: ${issue['issue']}',
    );
  }
  for (final issue in phase14Issues) {
    add(
      'phase14_row_issue',
      '${issue['id']}',
      '${issue['family']}: ${issue['issue']}',
    );
  }

  for (final locale in {'en': enArb, 'ru': ruArb}.entries) {
    for (final entry in locale.value.entries) {
      if (entry.key.startsWith('@') || entry.value is! String) {
        continue;
      }
      final value = entry.value! as String;
      if (value.trim().isEmpty) {
        add('empty_localized_string', locale.key, entry.key);
      }
      final matches = _mojibakePatterns.where(value.contains).toList();
      if (matches.isNotEmpty) {
        add(
          'mojibake_localized_string',
          '${locale.key}.${entry.key}',
          matches.join(','),
        );
      }
    }
  }

  for (final content in PuzzleContentCatalog.contents) {
    for (final key in content.localizationKeys.all) {
      if (!enArb.containsKey(key) || !ruArb.containsKey(key)) {
        add('missing_content_localization', content.familyId, key);
      }
    }
    for (final asset in PuzzleContentCatalog.assetsForContent(content)) {
      if (!File(asset).existsSync()) {
        add('missing_content_asset', content.familyId, asset);
      }
      if (!_isAllowedPuzzleArtAsset(asset)) {
        add('unsupported_puzzle_art_asset', content.familyId, asset);
      }
    }
  }

  for (final row in rows) {
    final scope = '${row['lessonId']}/${row['stepId']}';
    final choiceIds = [
      for (final choice in row['choices']! as List<Object?>)
        (choice! as Map<String, Object?>)['id']! as String,
    ];
    if (!choiceIds.contains(row['correctChoiceId'])) {
      add('correct_choice_missing', scope, '${row['correctChoiceId']}');
    }
    if ((row['tokens']! as List<Object?>).isEmpty &&
        (row['numbers']! as List<Object?>).isEmpty) {
      add('missing_visual_data', scope, '${row['family']}');
    }
    for (final choiceId in choiceIds) {
      final assets = PuzzleContentCatalog.assetsForChoice(
        row['family']! as String,
        choiceId,
      );
      if (assets.isEmpty) {
        add('missing_choice_visual', scope, choiceId);
      }
      for (final asset in assets) {
        if (!File(asset).existsSync()) {
          add('missing_choice_asset', scope, '$choiceId:$asset');
        }
        if (!_isAllowedPuzzleArtAsset(asset)) {
          add('unsupported_choice_art_asset', scope, '$choiceId:$asset');
        }
      }
    }
    if (row['family'] == 'detail-count') {
      for (final detailIssue in _detailCountIssues(row, enArb, ruArb)) {
        add('detail_count_metadata_mismatch', scope, detailIssue);
      }
    }
  }

  for (final row in [...phase13Rows, ...phase14Rows]) {
    final choiceIds = row['choices']! as List<Object?>;
    if (!choiceIds.contains(row['correctChoiceId'])) {
      add('pack_correct_choice_missing', '${row['id']}', '${row['family']}');
    }
    if ((row['tokens']! as List<Object?>).isEmpty &&
        (row['numbers']! as List<Object?>).isEmpty) {
      add('pack_missing_visual_data', '${row['id']}', '${row['family']}');
    }
  }

  final lastSeenBySignature = <String, int>{};
  for (var index = 0; index < rows.length; index += 1) {
    final row = rows[index];
    final signature = [
      row['family'],
      row['correctChoiceId'],
      (row['tokens']! as List<Object?>).join(','),
      (row['numbers']! as List<Object?>).join(','),
    ].join('|');
    final previous = lastSeenBySignature[signature];
    if (previous != null && index - previous <= 8) {
      add(
        'duplicate_puzzle_too_close',
        '${row['lessonId']}/${row['stepId']}',
        'same as row ${previous + 1}',
      );
    }
    lastSeenBySignature[signature] = index;
  }

  for (final course in FoundationCatalog.starterCourses) {
    var previousTier = -1;
    for (final lessonId in course.lessonIds) {
      final lesson = FoundationCatalog.lessonForId(lessonId);
      final tier = FoundationCatalog.difficultyForCourseLesson(course, lesson);
      final order = tier.index;
      if (order < previousTier) {
        add('course_difficulty_regression', course.id, lessonId);
      }
      previousTier = order;
    }
  }

  var previousBandOrder = -1;
  for (final row in phase14Rows) {
    final band = row['difficultyBand']! as String;
    final order = _phase14DifficultyOrder[band] ?? -1;
    if (order < previousBandOrder && band != 'mixed-review') {
      add('phase14_difficulty_regression', '${row['id']}', band);
    }
    previousBandOrder = order;
  }

  return issues;
}

bool _isAllowedPuzzleArtAsset(String asset) {
  if (!asset.startsWith('assets/images/')) {
    return false;
  }
  if (!asset.endsWith('.svg')) {
    return false;
  }
  return asset.startsWith('assets/images/puzzles/') ||
      asset.startsWith('assets/images/characters/');
}

List<String> _detailCountIssues(
  Map<String, Object?> row,
  Map<String, Object?> enArb,
  Map<String, Object?> ruArb,
) {
  final issues = <String>[];
  final numbers = [for (final value in row['numbers']! as List<Object?>) value];
  final choices = [
    for (final choice in row['choices']! as List<Object?>)
      (choice! as Map<String, Object?>)['id']! as String,
  ];
  const requiredChoices = ['red-circles', 'blue-squares', 'green-stars'];
  const requiredText = {
    'en': ['red circle', 'blue square', 'green star'],
    'ru': ['красн', 'син', 'зелен', 'круг', 'квадрат', 'звезд'],
  };
  final hasStaticLocalizedText = enArb.containsKey(row['questionKey']) &&
      ruArb.containsKey(row['questionKey']);
  final enText =
      hasStaticLocalizedText ? _localizedRowText(row, enArb).toLowerCase() : '';
  final ruText =
      hasStaticLocalizedText ? _localizedRowText(row, ruArb).toLowerCase() : '';

  if (numbers.length < 3) {
    issues.add('expected_three_counts');
  }
  for (final choice in requiredChoices) {
    if (!choices.contains(choice)) {
      issues.add('missing_choice:$choice');
    }
  }
  if (hasStaticLocalizedText) {
    for (final needle in requiredText['en']!) {
      if (!enText.contains(needle)) {
        issues.add('missing_en_text:$needle');
      }
    }
    for (final needle in requiredText['ru']!) {
      if (!ruText.contains(needle)) {
        issues.add('missing_ru_text:$needle');
      }
    }
    for (final value in numbers) {
      if (!enText.contains('$value') || !ruText.contains('$value')) {
        issues.add('count_not_in_text:$value');
      }
    }
  }

  return issues;
}

String _localizedRowText(
  Map<String, Object?> row,
  Map<String, Object?> arb,
) {
  return [
    row['lessonTitleKey'],
    row['questionKey'],
    row['hintKey'],
    row['explanationKey'],
  ].map((key) => arb[key] ?? '').join(' ');
}

List<String> _issuesFor(
  DailyChallenge challenge,
  Lesson lesson,
  PuzzleDefinition puzzle,
  PuzzleContent? content,
  Map<String, Object?> enArb,
  Map<String, Object?> ruArb,
) {
  final issues = <String>[];
  final choiceIds = challenge.choices.map((choice) => choice.id).toSet();

  if (challenge.choices.length < 3) {
    issues.add('too_few_choices');
  }
  if (!choiceIds.contains(challenge.correctChoiceId)) {
    issues.add('correct_choice_missing');
  }
  if (!_supportedVisualFamilies.contains(challenge.visualId)) {
    issues.add('unsupported_visual_family');
  }
  if (content == null) {
    issues.add('missing_puzzle_content');
  } else {
    if (content.contentType !=
        _contentTypeFor(puzzle.type, challenge.visualId)) {
      issues.add('content_type_mismatch');
    }
    if (content.skillTags.isEmpty) {
      issues.add('missing_content_skill_tags');
    }
    if (content.ageBands.isEmpty) {
      issues.add('missing_content_age_bands');
    }
    if (content.requiredObjectIds.isEmpty) {
      issues.add('missing_required_objects');
    }
    if (content.animationCues.isEmpty) {
      issues.add('missing_animation_cues');
    }
    if (!PuzzleContentCatalog.worldThemes.any(
      (theme) => theme.world == content.world,
    )) {
      issues.add('missing_world_theme:${content.world.name}');
    }
    for (final asset in PuzzleContentCatalog.assetsForContent(content)) {
      if (!File(asset).existsSync()) {
        issues.add('missing_content_asset:$asset');
      }
    }
    for (final key in content.localizationKeys.all) {
      if (!enArb.containsKey(key)) {
        issues.add('missing_en_content_key:$key');
      }
      if (!ruArb.containsKey(key)) {
        issues.add('missing_ru_content_key:$key');
      }
    }
  }
  for (final choice in challenge.choices) {
    final assets = PuzzleContentCatalog.assetsForChoice(
      challenge.visualId,
      choice.id,
    );
    if (assets.isEmpty) {
      issues.add('missing_choice_visual:${choice.id}');
    }
    for (final asset in assets) {
      if (!File(asset).existsSync()) {
        issues.add('missing_choice_asset:${choice.id}:$asset');
      }
    }
  }
  if (challenge.isLessonVariant &&
      challenge.tokens.isEmpty &&
      challenge.numbers.isEmpty) {
    issues.add('variant_without_generated_data');
  }
  if (!enArb.containsKey(lesson.titleKey)) {
    issues.add('missing_en_lesson_title');
  }
  if (!ruArb.containsKey(lesson.titleKey)) {
    issues.add('missing_ru_lesson_title');
  }

  return issues;
}

PuzzleContentType _contentTypeFor(PuzzleType type, String familyId) {
  if (familyId == 'shadow-match') {
    return PuzzleContentType.shadowMatch;
  }
  if (familyId == 'shape-rotation') {
    return PuzzleContentType.spatialRotation;
  }
  if (familyId == 'detail-count' || familyId == 'balance-scale') {
    return PuzzleContentType.comparison;
  }
  if (familyId == 'number-bridge' || familyId == 'sticker-sum') {
    return PuzzleContentType.visualMathStory;
  }
  if (familyId == 'code-grid') {
    return PuzzleContentType.symbolCode;
  }
  if (familyId == 'memory-recall') {
    return PuzzleContentType.memoryRecall;
  }
  if (familyId == 'sorting-rule') {
    return PuzzleContentType.sortingRule;
  }
  if (familyId == 'missing-piece') {
    return PuzzleContentType.missingPiece;
  }
  if (familyId == 'logic-deduction') {
    return PuzzleContentType.logicDeduction;
  }

  return switch (type) {
    PuzzleType.oddOneOut => PuzzleContentType.oddOneOut,
    PuzzleType.sequenceComplete => PuzzleContentType.patternSequence,
    PuzzleType.pairMatch => PuzzleContentType.pairMatching,
    PuzzleType.categorySort => PuzzleContentType.comparison,
    PuzzleType.pathPuzzle => PuzzleContentType.pathLogic,
    PuzzleType.countBridge => PuzzleContentType.counting,
    PuzzleType.visualCompare => PuzzleContentType.comparison,
    PuzzleType.analogy => PuzzleContentType.logicDeduction,
    PuzzleType.memoryRecall => PuzzleContentType.memoryRecall,
    PuzzleType.sortingRule => PuzzleContentType.sortingRule,
    PuzzleType.missingPiece => PuzzleContentType.missingPiece,
    PuzzleType.logicDeduction => PuzzleContentType.logicDeduction,
  };
}

String _difficultyFor(DailyChallenge challenge) {
  return switch (challenge.visualId) {
    'shape-path' || 'fruit-pattern' || 'toy-count' || 'memory-pairs' => 'easy',
    'odd-card' ||
    'logic-train' ||
    'sticker-sum' ||
    'shadow-match' ||
    'space-sequence' ||
    'shape-stack' ||
    'path-maze' =>
      'medium',
    'balance-scale' ||
    'shape-rotation' ||
    'code-grid' ||
    'number-bridge' ||
    'detail-count' ||
    'lock-key' ||
    'memory-recall' ||
    'sorting-rule' ||
    'missing-piece' =>
      'hard',
    'logic-deduction' => 'challenge',
    _ => 'unknown',
  };
}

int _numberFromId(String id) {
  return int.tryParse(id.split('.').last) ?? 1;
}

Map<String, int> _sortedMap(Map<String, int> source) {
  final entries = source.entries.toList()
    ..sort((left, right) => left.key.compareTo(right.key));
  return {
    for (final entry in entries) entry.key: entry.value,
  };
}

Map<String, Object?> _readArb(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    return {};
  }

  return (jsonDecode(file.readAsStringSync()) as Map<String, dynamic>)
      .cast<String, Object?>();
}
