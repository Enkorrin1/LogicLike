import 'package:flutter_test/flutter_test.dart';
import 'package:logicloka/src/domain/daily_challenge.dart';
import 'package:logicloka/src/domain/family_profile.dart';
import 'package:logicloka/src/domain/puzzle_interaction_catalog.dart';
import 'package:logicloka/src/features/challenge/game_scenes/animal_word_game.dart';
import 'package:logicloka/src/features/challenge/game_scenes/letter_field_game.dart';
import 'package:logicloka/src/features/challenge/game_scenes/word_grid_game.dart';
import 'package:logicloka/src/features/challenge/game_scenes/word_builder_game.dart';

void main() {
  test('every catalog puzzle is scene-driven and no unknown id is listed', () {
    final puzzleIds = puzzleAreasForAge(ChildAge.six)
        .expand((area) => area.puzzles)
        .map((puzzle) => puzzle.id)
        .toSet();

    expect(sceneDrivenPuzzleIds, puzzleIds);
  });

  test('game-quality conversions stay scene-driven', () {
    expect(
      sceneDrivenPuzzleIds,
      containsAll(<String>{
        'memory-pairs',
        'sound-order',
        'beacon-signal',
        'odd-card',
        'code-grid',
        'route-maze',
        'story-order',
        'shape-tangram',
        'final-orbit',
        'constellation-route',
        'two-differences',
        'what-changed',
        'captain-command',
        'shape-turn',
        'arrow-maze',
        'shadow-match',
        'balloon-order',
        'clean-row',
        'word-grid',
        'space-proof',
        'rocket-route',
        'mirror-path',
        'animal-word',
        'camp-story',
        'color-rhythm',
        'shape-tower',
        'fast-eyes',
        'hidden-star',
        'route-memory',
        'why-chain',
        'silhouette-build',
        'star-list',
        'tiny-detail',
        'cube-groups',
        'more-less',
        'sticker-shop',
      }),
    );
  });

  test('word grid has board data for every supported locale', () {
    expect(
      wordGridSupportedLanguageCodes,
      AppLanguage.values.map((language) => language.code).toSet(),
    );
  });

  test('animal word has content for every supported locale', () {
    expect(
      animalWordSupportedLanguageCodes,
      AppLanguage.values.map((language) => language.code).toSet(),
    );
  });

  test('word builder has content for every supported locale', () {
    expect(
      wordBuilderSupportedLanguageCodes,
      AppLanguage.values.map((language) => language.code).toSet(),
    );
  });

  test('letter field has content for every supported locale', () {
    expect(
      letterFieldSupportedLanguageCodes,
      AppLanguage.values.map((language) => language.code).toSet(),
    );
  });
}
