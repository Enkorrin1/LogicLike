import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:logic_like/src/domain/learning_foundation.dart';
import 'package:logic_like/src/domain/motivation_plan.dart';
import 'package:logic_like/src/domain/parent_weekly_report.dart';
import 'package:logic_like/src/l10n/generated/app_localizations_en.dart';
import 'package:logic_like/src/l10n/generated/app_localizations_ru.dart';
import 'package:logic_like/src/l10n/localized_models.dart';

const _mojibakePatterns = ['Ð', 'Ñ', 'Ã', 'Â', 'â', 'вЂ', '\uFFFD'];

void main() {
  late Map<String, Object?> ru;
  late Map<String, Object?> en;

  setUpAll(() {
    ru = _loadArb('lib/l10n/app_ru.arb');
    en = _loadArb('lib/l10n/app_en.arb');
  });

  test('Russian and English ARB files expose the same visible keys', () {
    expect(_visibleKeys(ru), _visibleKeys(en));
  });

  test('localized placeholders stay aligned across locales', () {
    final mismatches = <String>[];
    for (final key in _visibleKeys(ru)) {
      final ruPlaceholders = _placeholders(ru[key]);
      final enPlaceholders = _placeholders(en[key]);
      if (!_setsEqual(ruPlaceholders, enPlaceholders)) {
        mismatches.add(
          '$key: ru=$ruPlaceholders, en=$enPlaceholders',
        );
      }
    }

    expect(mismatches, isEmpty);
  });

  test('visible ARB strings do not contain suspicious mojibake patterns', () {
    final issues = <String>[];
    for (final localeEntry in {'ru': ru, 'en': en}.entries) {
      for (final valueEntry in localeEntry.value.entries) {
        if (valueEntry.key.startsWith('@') || valueEntry.value is! String) {
          continue;
        }

        final value = valueEntry.value! as String;
        final matches = _mojibakePatterns.where(value.contains).toList();
        if (matches.isNotEmpty) {
          issues.add('${localeEntry.key}.${valueEntry.key}: $matches');
        }
      }
    }

    expect(issues, isEmpty);
  });

  test('model localization helpers return readable RU and EN copy', () {
    final ruL10n = AppLocalizationsRu();
    final enL10n = AppLocalizationsEn();
    const motivationPlan = MotivationPlan(
      dailyGoalSessions: 2,
      completedTodaySessions: 1,
      currentStreak: 4,
      nextStreakMilestone: 5,
      stars: 8,
      nextRewardStars: 10,
    );
    const weeklyReport = ParentWeeklyReport(
      sessionsCount: 3,
      minutes: 18,
      correctAnswers: 9,
      totalQuestions: 11,
      usedHints: 2,
      wrongAttempts: 1,
      status: ParentWeeklyStatus.steady,
    );

    expect(ruL10n.motivationTitle(motivationPlan), 'Бонус дня');
    expect(enL10n.motivationTitle(motivationPlan), 'Daily bonus');
    expect(ruL10n.parentWeeklyReportTitle(), 'План на неделю');
    expect(enL10n.parentWeeklyReportTitle(), 'Weekly action plan');
    expect(
      ruL10n.lessonDifficultyLabel(LessonDifficultyTier.challenge),
      'Вызов',
    );
    expect(
      enL10n.lessonDifficultyLabel(LessonDifficultyTier.challenge),
      'Challenge',
    );

    final samples = [
      ruL10n.motivationBody(motivationPlan),
      ruL10n.parentWeeklySummary(weeklyReport),
      ruL10n.parentWeeklyActions(weeklyReport).join(' '),
      enL10n.motivationBody(motivationPlan),
      enL10n.parentWeeklySummary(weeklyReport),
      enL10n.parentWeeklyActions(weeklyReport).join(' '),
    ];

    for (final sample in samples) {
      expect(_containsMojibake(sample), isFalse, reason: sample);
    }
  });
}

Map<String, Object?> _loadArb(String path) {
  return jsonDecode(File(path).readAsStringSync()) as Map<String, Object?>;
}

Set<String> _visibleKeys(Map<String, Object?> localeMap) {
  return localeMap.keys.where((key) => !key.startsWith('@')).toSet();
}

Set<String> _placeholders(Object? value) {
  if (value is! String) {
    return const {};
  }

  final placeholders = <String>{};
  final identifier = RegExp(r'[A-Za-z_][A-Za-z0-9_]*');
  for (var index = 0; index < value.length; index += 1) {
    if (value.codeUnitAt(index) != 123) {
      continue;
    }

    if (index > 0 && RegExp(r'[A-Za-z0-9_]').hasMatch(value[index - 1])) {
      continue;
    }

    final match = identifier.matchAsPrefix(value, index + 1);
    if (match != null) {
      placeholders.add(match.group(0)!);
    }
  }

  return placeholders;
}

bool _setsEqual(Set<String> left, Set<String> right) {
  return left.length == right.length && left.containsAll(right);
}

bool _containsMojibake(String value) {
  return _mojibakePatterns.any(value.contains);
}
