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

    test('resolves visuals for representative answer choices', () {
      final cases = {
        'shape-path': ['circle', 'square', 'triangle'],
        'toy-count': ['2', '3', '4'],
        'number-bridge': ['4+2+1'],
        'detail-count': ['red-circles', 'blue-squares', 'green-stars'],
        'path-maze': ['left', 'right', 'up', 'down'],
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
