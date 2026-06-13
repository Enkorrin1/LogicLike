import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:logic_like/src/domain/learning_foundation.dart';
import 'package:logic_like/src/domain/puzzle_content.dart';

void main() {
  group('PuzzleContentCatalog', () {
    test('covers every starter puzzle family', () {
      final missingFamilies = [
        for (final puzzle in FoundationCatalog.starterPuzzles)
          if (PuzzleContentCatalog.maybeByFamilyId(puzzle.payloadRef) == null)
            puzzle.payloadRef,
      ];

      expect(missingFamilies, isEmpty);
    });

    test('declares scene, localization, character, and animation metadata', () {
      for (final content in PuzzleContentCatalog.contents) {
        expect(content.id, startsWith('content.'));
        expect(content.familyId, isNotEmpty);
        expect(content.ageBands, isNotEmpty);
        expect(content.skillTags, isNotEmpty);
        expect(content.sceneAsset, isNotEmpty);
        expect(content.requiredObjectIds, isNotEmpty);
        expect(content.localizationKeys.all.toSet(), hasLength(5));
        expect(content.animationCues, isNotEmpty);
      }
    });

    test('defines six reusable characters with six poses each', () {
      expect(PuzzleContentCatalog.characterProfiles, hasLength(6));
      expect(
        PuzzleContentCatalog.characterProfiles
            .map((profile) => profile.character)
            .toSet(),
        PuzzleCharacter.values.toSet(),
      );
      expect(CharacterPose.values, hasLength(6));
      expect(
        PuzzleContentCatalog.characterPoseAssets,
        hasLength(PuzzleCharacter.values.length * CharacterPose.values.length),
      );
    });

    test('starter content uses every character and every pose', () {
      final usedCharacters = {
        for (final content in PuzzleContentCatalog.contents) content.character,
      };
      final usedPoses = {
        for (final content in PuzzleContentCatalog.contents)
          content.characterPose,
      };

      expect(usedCharacters, PuzzleCharacter.values.toSet());
      expect(usedPoses, CharacterPose.values.toSet());
    });

    test('references only asset files that exist', () {
      final missingAssets = <String>[];
      for (final content in PuzzleContentCatalog.contents) {
        for (final asset in PuzzleContentCatalog.assetsForContent(content)) {
          if (!File(asset).existsSync()) {
            missingAssets.add('${content.familyId}: $asset');
          }
        }
      }

      expect(missingAssets, isEmpty);
    });

    test('references only existing character pose assets', () {
      final missingAssets = <String>[];
      for (final poseAsset in PuzzleContentCatalog.characterPoseAssets) {
        for (final asset in [poseAsset.baseAsset, poseAsset.propAsset]) {
          if (!File(asset).existsSync()) {
            missingAssets.add(
              '${poseAsset.character.name}/${poseAsset.pose.name}: $asset',
            );
          }
        }
      }

      expect(missingAssets, isEmpty);
    });

    test('defines a visual theme and content coverage for every world', () {
      final themedWorlds = {
        for (final theme in PuzzleContentCatalog.worldThemes) theme.world,
      };
      final contentWorlds = {
        for (final content in PuzzleContentCatalog.contents) content.world,
      };

      expect(themedWorlds, PuzzleWorld.values.toSet());
      expect(contentWorlds, PuzzleWorld.values.toSet());
    });

    test('references only existing theme ambient assets', () {
      final missingAssets = <String>[];
      for (final theme in PuzzleContentCatalog.worldThemes) {
        if (!File(theme.ambientAsset).existsSync()) {
          missingAssets.add('${theme.world.name}: ${theme.ambientAsset}');
        }
      }

      expect(missingAssets, isEmpty);
    });

    test('resolves visuals for representative answer choices', () {
      final cases = {
        'shape-path': ['circle', 'square', 'triangle'],
        'toy-count': ['2', '3', '4'],
        'number-bridge': ['4+2+1'],
        'detail-count': ['red-circles', 'blue-squares', 'green-stars'],
        'path-maze': ['left', 'right', 'up', 'down'],
        'memory-recall': ['star', 'key', 'banana'],
        'sorting-rule': ['pear', 'star', 'planet', 'lock'],
        'missing-piece': ['circle', 'star', 'key'],
        'logic-deduction': ['rocket', 'key', 'banana'],
      };
      final missingAssets = <String>[];

      for (final entry in cases.entries) {
        for (final choiceId in entry.value) {
          final assets = PuzzleContentCatalog.assetsForChoice(
            entry.key,
            choiceId,
          );
          if (assets.isEmpty) {
            missingAssets.add('${entry.key}:$choiceId has no asset');
          }
          for (final asset in assets) {
            if (!File(asset).existsSync()) {
              missingAssets.add('${entry.key}:$choiceId -> $asset');
            }
          }
        }
      }

      expect(missingAssets, isEmpty);
    });
  });
}
