import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:logicloka/src/domain/daily_challenge.dart';
import 'package:logicloka/src/domain/family_profile.dart';
import 'package:logicloka/src/domain/puzzle_answer_rules.dart';
import 'package:logicloka/src/l10n/generated/app_localizations.dart';
import 'package:logicloka/src/l10n/localized_content.dart';

void main() {
  group('localized learning content', () {
    final puzzles = puzzleAreasForAge(ChildAge.six)
        .expand((area) => area.puzzles)
        .toList(growable: false);

    test('keeps all configured app locales available', () {
      expect(
        AppLocalizations.supportedLocales.map((locale) => locale.languageCode),
        AppLanguage.values.map((language) => language.code),
      );
    });

    test('localizes every puzzle title, prompt, skill, retry, and answer', () {
      for (final language in AppLanguage.values) {
        final l10n = lookupAppLocalizations(Locale(language.code));

        for (final puzzle in puzzles) {
          expect(l10n.puzzleTitle(puzzle), isNotEmpty, reason: puzzle.id);
          expect(l10n.puzzlePrompt(puzzle), isNotEmpty, reason: puzzle.id);
          expect(l10n.puzzleSkill(puzzle), isNotEmpty, reason: puzzle.id);

          final rule = answerRuleForPuzzle(puzzle);
          final retryText = l10n.retryTextForPuzzle(puzzle, rule.retryText);
          expect(retryText, isNotEmpty, reason: puzzle.id);

          for (final option in rule.options) {
            final label = l10n.answerLabel(option);
            expect(label, isNotEmpty, reason: '${puzzle.id}: $option');

            if (language != AppLanguage.ru && _containsCyrillic(option)) {
              expect(
                _containsCyrillic(label),
                isFalse,
                reason: '${language.code} answer leaked source text for '
                    '${puzzle.id}: $option -> $label',
              );
            }
          }

          if (language != AppLanguage.ru) {
            expect(
              _containsCyrillic(l10n.puzzleTitle(puzzle)),
              isFalse,
              reason: '${language.code} title leaked source text for '
                  '${puzzle.id}',
            );
            expect(
              _containsCyrillic(l10n.puzzlePrompt(puzzle)),
              isFalse,
              reason: '${language.code} prompt leaked source text for '
                  '${puzzle.id}',
            );
            expect(
              _containsCyrillic(l10n.puzzleSkill(puzzle)),
              isFalse,
              reason: '${language.code} skill leaked source text for '
                  '${puzzle.id}',
            );
            expect(
              _containsCyrillic(retryText),
              isFalse,
              reason: '${language.code} retry leaked source text for '
                  '${puzzle.id}',
            );
          }
        }
      }
    });
  });
}

bool _containsCyrillic(String value) {
  return value.runes.any(
    (rune) =>
        (rune >= 0x0400 && rune <= 0x04ff) ||
        (rune >= 0x0500 && rune <= 0x052f) ||
        (rune >= 0x2de0 && rune <= 0x2dff) ||
        (rune >= 0xa640 && rune <= 0xa69f),
  );
}
