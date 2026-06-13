import 'dart:convert';
import 'dart:io';

const _localeFiles = {
  'ru': 'lib/l10n/app_ru.arb',
  'en': 'lib/l10n/app_en.arb',
};

const _mojibakePatterns = ['Ð', 'Ñ', 'Ã', 'Â', 'â', 'вЂ', '\uFFFD'];

void main() {
  final localeMaps = <String, Map<String, Object?>>{};
  final issues = <Map<String, Object?>>[];

  for (final entry in _localeFiles.entries) {
    final file = File(entry.value);
    if (!file.existsSync()) {
      issues.add({
        'type': 'missing_file',
        'locale': entry.key,
        'path': entry.value,
      });
      continue;
    }

    localeMaps[entry.key] =
        jsonDecode(file.readAsStringSync()) as Map<String, Object?>;
  }

  if (localeMaps.length == _localeFiles.length) {
    _auditKeys(localeMaps, issues);
    _auditPlaceholders(localeMaps, issues);
    _auditMojibake(localeMaps, issues);
  }

  final report = {
    'locales': _localeFiles.keys.toList(),
    'generatedAt': DateTime.now().toUtc().toIso8601String(),
    'summary': {
      'localeCount': localeMaps.length,
      'issueCount': issues.length,
      'status': issues.isEmpty ? 'passed' : 'failed',
    },
    'issues': issues,
  };

  final output = File('../LOCALIZATION_AUDIT.json');
  output.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(report));

  stdout.writeln(
    'Generated ../LOCALIZATION_AUDIT.json with ${issues.length} issues.',
  );

  if (issues.isNotEmpty) {
    exitCode = 1;
  }
}

void _auditKeys(
  Map<String, Map<String, Object?>> localeMaps,
  List<Map<String, Object?>> issues,
) {
  final allKeys = <String>{};
  for (final localeMap in localeMaps.values) {
    allKeys.addAll(_visibleKeys(localeMap));
  }

  for (final localeEntry in localeMaps.entries) {
    final localeKeys = _visibleKeys(localeEntry.value);
    final missingKeys = allKeys.difference(localeKeys).toList()..sort();
    for (final key in missingKeys) {
      issues.add({
        'type': 'missing_key',
        'locale': localeEntry.key,
        'key': key,
      });
    }
  }
}

void _auditPlaceholders(
  Map<String, Map<String, Object?>> localeMaps,
  List<Map<String, Object?>> issues,
) {
  final locales = localeMaps.keys.toList();
  if (locales.length < 2) {
    return;
  }

  final baseLocale = locales.first;
  final baseMap = localeMaps[baseLocale]!;
  final sharedKeys = _visibleKeys(baseMap);
  for (final localeMap in localeMaps.values.skip(1)) {
    sharedKeys.removeWhere((key) => !localeMap.containsKey(key));
  }

  for (final key in sharedKeys) {
    final basePlaceholders = _placeholders(baseMap[key]);
    for (final locale in locales.skip(1)) {
      final targetPlaceholders = _placeholders(localeMaps[locale]![key]);
      if (!_setsEqual(basePlaceholders, targetPlaceholders)) {
        issues.add({
          'type': 'placeholder_mismatch',
          'key': key,
          'baseLocale': baseLocale,
          'targetLocale': locale,
          'basePlaceholders': basePlaceholders.toList()..sort(),
          'targetPlaceholders': targetPlaceholders.toList()..sort(),
        });
      }
    }
  }
}

void _auditMojibake(
  Map<String, Map<String, Object?>> localeMaps,
  List<Map<String, Object?>> issues,
) {
  for (final localeEntry in localeMaps.entries) {
    for (final valueEntry in localeEntry.value.entries) {
      final key = valueEntry.key;
      final value = valueEntry.value;
      if (key.startsWith('@') || value is! String) {
        continue;
      }

      final matches = _mojibakePatterns.where(value.contains).toSet().toList()
        ..sort();
      if (matches.isEmpty) {
        continue;
      }

      issues.add({
        'type': 'suspected_mojibake',
        'locale': localeEntry.key,
        'key': key,
        'patterns': matches,
      });
    }
  }
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
