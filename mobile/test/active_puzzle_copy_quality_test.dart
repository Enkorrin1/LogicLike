import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:logicloka/src/domain/daily_challenge.dart';
import 'package:logicloka/src/domain/family_profile.dart';
import 'package:logicloka/src/domain/puzzle_interaction_catalog.dart';
import 'package:logicloka/src/l10n/generated/app_localizations.dart';
import 'package:logicloka/src/l10n/localized_content.dart';

void main() {
  final puzzlesById = {
    for (final area in puzzleAreasForAge(ChildAge.six))
      for (final puzzle in area.puzzles) puzzle.id: puzzle,
  };

  test('all 62 active puzzles have direct copy in every locale', () {
    expect(sceneDrivenPuzzleIds, hasLength(62));
    expect(puzzlesById.keys, containsAll(sceneDrivenPuzzleIds));

    for (final language in AppLanguage.values) {
      for (final puzzleId in sceneDrivenPuzzleIds) {
        expect(
          hasLocalizedPuzzleCopy(language.code, puzzleId),
          isTrue,
          reason: '${language.code} must define $puzzleId without fallback',
        );
      }
    }
  });

  test('deep puzzle prompts describe the current multi-step mechanics', () {
    const expectedEnglish = {
      'camp-story':
          'Restore the three missing camp items in the right order. Ignore the decoy.',
      'word-grid':
          'Find three crossing words. Trace each path without reusing a cell.',
      'odd-card':
          'Gather the clues, choose the rule, then sort all four cards.',
      'secret-code': 'Use the clues and feedback to crack three number codes.',
      'code-grid':
          'Trace three number chains, then enter the code they reveal.',
      'shadow-match':
          'Match the hero to the correct shadow in all three rounds.',
      'what-changed':
          'Remember each scene and fix the changed object in all three rounds.',
      'moon-clock':
          'Move the minute hand to the shown time in all three rounds.',
      'constellation-route':
          'Follow each branch rule and trace all three constellations.',
      'mirror-path':
          'Turn all three mirrors, launch the beam, then trace it to the goal.',
      'code-lock':
          'Apply each number rule to the dials and open all three locks.',
    };
    const staleEnglish = {
      'Remember what the heroes praised at the cozy camp.',
      'Find the hidden word in the letter grid.',
      'Choose the picture that differs from the others.',
      'Crack the code rule and choose the missing sign.',
      'Find the rule and choose the correct cell.',
      'Choose the track the hero could have left.',
      'Remember the picture and find what became different.',
      'Look at the hands and choose the correct time.',
      'Follow the glowing path and choose the final star.',
      'Reflect the route like in a mirror and find the end.',
      'Use the panel clues to choose the lock code.',
    };

    final english = lookupAppLocalizations(const Locale('en'));
    for (final entry in expectedEnglish.entries) {
      final puzzle = puzzlesById[entry.key]!;
      expect(english.puzzlePrompt(puzzle), entry.value, reason: entry.key);
    }

    for (final language in AppLanguage.values) {
      final l10n = lookupAppLocalizations(Locale(language.code));
      for (final puzzleId in expectedEnglish.keys) {
        final prompt = l10n.puzzlePrompt(puzzlesById[puzzleId]!);
        expect(prompt.trim(), isNotEmpty, reason: '${language.code}:$puzzleId');
        expect(staleEnglish, isNot(contains(prompt)),
            reason: '${language.code}:$puzzleId uses obsolete copy');
        if (language != AppLanguage.en) {
          expect(prompt, isNot(expectedEnglish[puzzleId]),
              reason: '${language.code}:$puzzleId fell back to English');
        }
      }
    }
  });

  test('previous fallback gaps contain native title, prompt, and skill', () {
    const gaps = {
      'ar': ['planet-sum', 'sticker-shop', 'two-differences'],
      'es': ['planet-sum'],
      'hi': ['logic-train', 'tower-rule', 'planet-sum', 'code-grid'],
      'ko': [
        'number-neighbors',
        'two-differences',
        'captain-command',
        'silhouette-build',
      ],
    };
    final english = lookupAppLocalizations(const Locale('en'));

    for (final localeEntry in gaps.entries) {
      final localized = lookupAppLocalizations(Locale(localeEntry.key));
      for (final puzzleId in localeEntry.value) {
        final puzzle = puzzlesById[puzzleId]!;
        expect(
            localized.puzzleTitle(puzzle), isNot(english.puzzleTitle(puzzle)),
            reason: '${localeEntry.key}:$puzzleId title');
        expect(
            localized.puzzlePrompt(puzzle), isNot(english.puzzlePrompt(puzzle)),
            reason: '${localeEntry.key}:$puzzleId prompt');
        expect(
            localized.puzzleSkill(puzzle), isNot(english.puzzleSkill(puzzle)),
            reason: '${localeEntry.key}:$puzzleId skill');
      }
    }
  });

  test('active puzzle copy contains no replacement characters or mojibake', () {
    final suspicious =
        RegExp(r'\uFFFD|Ã.|Â.|â€|Ð.|Ñ.|Ø.|Ù.|à¤|æ—|ì[\u0080-\u00BF]');

    for (final language in AppLanguage.values) {
      final l10n = lookupAppLocalizations(Locale(language.code));
      for (final puzzleId in sceneDrivenPuzzleIds) {
        final puzzle = puzzlesById[puzzleId]!;
        for (final value in [
          l10n.puzzleTitle(puzzle),
          l10n.puzzlePrompt(puzzle),
          l10n.puzzleSkill(puzzle),
        ]) {
          expect(suspicious.hasMatch(value), isFalse,
              reason: '${language.code}:$puzzleId -> $value');
        }
      }
    }
  });
}
