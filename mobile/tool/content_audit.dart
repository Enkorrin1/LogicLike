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

  final audit = {
    'generatedAt': DateTime.now().toIso8601String(),
    'summary': {
      'courses': FoundationCatalog.starterCourses.length,
      'lessons': FoundationCatalog.starterLessons.length,
      'steps': rows.length,
      'uniqueFamilies': familyCounts.length,
      'issues': issues.length,
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
    'Generated ${outputFile.path} with ${rows.length} steps and '
    '${issues.length} issues.',
  );
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
