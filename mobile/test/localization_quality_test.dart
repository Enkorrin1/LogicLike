import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const _localeCodes = [
  'ar',
  'de',
  'en',
  'es',
  'fr',
  'hi',
  'it',
  'ja',
  'ko',
  'pt',
  'ru',
  'zh',
];

const _mojibakePatterns = ['Ð', 'Ñ', 'Ã', 'вЂ', '???', '\uFFFD'];

void main() {
  late Map<String, Map<String, Object?>> locales;

  setUpAll(() {
    locales = {
      for (final code in _localeCodes) code: _loadArb('lib/l10n/app_$code.arb'),
    };
  });

  test('all ARB files expose the same visible keys', () {
    final sourceKeys = _visibleKeys(locales['ru']!);
    final issues = <String>[];

    for (final entry in locales.entries) {
      final keys = _visibleKeys(entry.value);
      if (!_setsEqual(sourceKeys, keys)) {
        issues.add(
          '${entry.key}: missing=${sourceKeys.difference(keys)} '
          'extra=${keys.difference(sourceKeys)}',
        );
      }
    }

    expect(issues, isEmpty);
  });

  test('localized placeholders stay aligned across locales', () {
    final source = locales['ru']!;
    final issues = <String>[];

    for (final key in _visibleKeys(source)) {
      final sourcePlaceholders = _placeholders(source[key]);
      for (final entry in locales.entries) {
        final localePlaceholders = _placeholders(entry.value[key]);
        if (!_setsEqual(sourcePlaceholders, localePlaceholders)) {
          issues.add(
            '$key: ru=$sourcePlaceholders '
            '${entry.key}=$localePlaceholders',
          );
        }
      }
    }

    expect(issues, isEmpty);
  });

  test('visible ARB strings do not contain suspicious mojibake patterns', () {
    final issues = <String>[];

    for (final localeEntry in locales.entries) {
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
