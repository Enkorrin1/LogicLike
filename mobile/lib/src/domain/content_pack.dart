import 'learning_foundation.dart';

class ContentPackItem {
  const ContentPackItem({
    required this.id,
    required this.category,
    required this.familyId,
    required this.correctChoiceId,
    required this.choiceIds,
    this.tokens = const [],
    this.numbers = const [],
  });

  final String id;
  final String category;
  final String familyId;
  final String correctChoiceId;
  final List<String> choiceIds;
  final List<String> tokens;
  final List<int> numbers;

  String get signature {
    return [
      familyId,
      correctChoiceId,
      tokens.join(','),
      numbers.join(','),
      choiceIds.join(','),
    ].join('|');
  }
}

class ContentPackCatalog {
  const ContentPackCatalog._();

  static final List<ContentPackItem> phase13Items = [
    ..._patternItems(),
    ..._oddOneOutItems(),
    ..._countingItems(),
    ..._comparisonItems(),
    ..._pairMatchingItems(),
    ..._shadowMatchingItems(),
    ..._pathLogicItems(),
    ..._memoryDetailItems(),
  ];

  static ContentPackItem? phase13ItemForStep(
    LessonStep step, {
    required String familyId,
  }) {
    if (step.lessonId == 'lesson.001') {
      return null;
    }

    final matchingItems = [
      for (final item in phase13Items)
        if (item.familyId == familyId) item,
    ];
    if (matchingItems.isEmpty) {
      return null;
    }

    var occurrence = 0;
    for (final candidate in FoundationCatalog.starterLessonSteps) {
      final candidateFamily =
          FoundationCatalog.puzzleForStep(candidate).payloadRef;
      if (candidateFamily == familyId) {
        if (candidate.id == step.id) {
          return matchingItems[occurrence % matchingItems.length];
        }
        occurrence += 1;
      }
    }
    return matchingItems.first;
  }

  static Map<String, int> phase13CategoryCounts() {
    final counts = <String, int>{};
    for (final item in phase13Items) {
      counts[item.category] = (counts[item.category] ?? 0) + 1;
    }
    return counts;
  }

  static List<ContentPackItem> _patternItems() {
    const rows = [
      (
        'shape-path',
        'circle',
        ['circle', 'square'],
        ['triangle', 'circle', 'square', 'star']
      ),
      (
        'shape-path',
        'triangle',
        ['triangle', 'star'],
        ['triangle', 'circle', 'square', 'star']
      ),
      (
        'shape-path',
        'square',
        ['square', 'circle'],
        ['triangle', 'circle', 'square', 'star']
      ),
      (
        'shape-path',
        'star',
        ['star', 'triangle'],
        ['triangle', 'circle', 'square', 'star']
      ),
      (
        'fruit-pattern',
        'apple',
        ['apple', 'banana'],
        ['apple', 'banana', 'pear']
      ),
      (
        'fruit-pattern',
        'banana',
        ['banana', 'pear'],
        ['apple', 'banana', 'pear']
      ),
      ('fruit-pattern', 'pear', ['pear', 'apple'], ['apple', 'banana', 'pear']),
      (
        'fruit-pattern',
        'apple',
        ['apple', 'pear'],
        ['apple', 'banana', 'pear']
      ),
      ('logic-train', 'red', ['red', 'blue'], ['blue', 'red', 'green']),
      ('logic-train', 'green', ['green', 'red'], ['blue', 'red', 'green']),
      ('logic-train', 'blue', ['blue', 'green'], ['blue', 'red', 'green']),
      ('logic-train', 'red', ['red', 'green'], ['blue', 'red', 'green']),
      (
        'space-sequence',
        'rocket',
        ['rocket', 'planet'],
        ['rocket', 'planet', 'star']
      ),
      (
        'space-sequence',
        'planet',
        ['planet', 'star'],
        ['rocket', 'planet', 'star']
      ),
      (
        'space-sequence',
        'star',
        ['star', 'rocket'],
        ['rocket', 'planet', 'star']
      ),
      (
        'space-sequence',
        'rocket',
        ['rocket', 'star'],
        ['rocket', 'planet', 'star']
      ),
      (
        'shape-stack',
        'square',
        ['square', 'circle'],
        ['square', 'circle', 'triangle', 'star']
      ),
      (
        'shape-stack',
        'triangle',
        ['triangle', 'square'],
        ['square', 'circle', 'triangle', 'star']
      ),
      (
        'shape-stack',
        'circle',
        ['circle', 'star'],
        ['square', 'circle', 'triangle', 'star']
      ),
      (
        'shape-stack',
        'star',
        ['star', 'square'],
        ['square', 'circle', 'triangle', 'star']
      ),
    ];
    return [
      for (var index = 0; index < rows.length; index += 1)
        ContentPackItem(
          id: 'phase13.pattern.${index + 1}',
          category: 'pattern',
          familyId: rows[index].$1,
          correctChoiceId: rows[index].$2,
          tokens: rows[index].$3,
          choiceIds: rows[index].$4,
        ),
    ];
  }

  static List<ContentPackItem> _oddOneOutItems() {
    const rows = [
      ('ball', ['apple', 'banana', 'pear', 'ball']),
      ('cloud', ['rocket', 'planet', 'star', 'cloud']),
      ('shoe', ['circle', 'square', 'triangle', 'shoe']),
      ('rocket', ['apple', 'banana', 'pear', 'rocket']),
      ('apple', ['rocket', 'planet', 'star', 'apple']),
      ('key', ['circle', 'square', 'triangle', 'key']),
      ('banana', ['lock', 'key', 'shoe', 'banana']),
      ('planet', ['apple', 'banana', 'pear', 'planet']),
      ('star', ['key', 'lock', 'shoe', 'star']),
      ('pear', ['rocket', 'planet', 'cloud', 'pear']),
      ('lock', ['circle', 'square', 'triangle', 'lock']),
      ('cloud', ['apple', 'banana', 'pear', 'cloud']),
      ('shoe', ['rocket', 'planet', 'star', 'shoe']),
      ('ball', ['key', 'lock', 'cloud', 'ball']),
      ('triangle', ['apple', 'banana', 'pear', 'triangle']),
    ];
    return [
      for (var index = 0; index < rows.length; index += 1)
        ContentPackItem(
          id: 'phase13.odd.${index + 1}',
          category: 'odd-one-out',
          familyId: 'odd-card',
          correctChoiceId: rows[index].$1,
          tokens: rows[index].$2,
          choiceIds: [
            rows[index].$2[0],
            rows[index].$1,
            rows[index].$2[1],
          ],
        ),
    ];
  }

  static List<ContentPackItem> _countingItems() {
    final items = <ContentPackItem>[];
    for (var index = 0; index < 7; index += 1) {
      final cubes = 1 + (index % 4);
      final balls = 1 + ((index + 1) % 3);
      final total = cubes + balls;
      items.add(
        ContentPackItem(
          id: 'phase13.count.toys.${index + 1}',
          category: 'counting',
          familyId: 'toy-count',
          correctChoiceId: '$total',
          numbers: [cubes, balls, total],
          choiceIds: _numericChoiceIds(total),
        ),
      );
    }
    for (var index = 0; index < 8; index += 1) {
      final first = 2 + (index % 5);
      final second = 1 + ((index + 2) % 4);
      final total = first + second;
      items.add(
        ContentPackItem(
          id: 'phase13.count.stickers.${index + 1}',
          category: 'counting',
          familyId: 'sticker-sum',
          correctChoiceId: '$total',
          numbers: [first, second, total],
          choiceIds: _numericChoiceIds(total),
        ),
      );
    }
    return items;
  }

  static List<ContentPackItem> _comparisonItems() {
    final items = <ContentPackItem>[];
    const scaleRows = [
      (2, 1, 1),
      (4, 1, 3),
      (5, 2, 3),
      (5, 4, 1),
      (6, 2, 4),
    ];
    for (var index = 0; index < scaleRows.length; index += 1) {
      final left = scaleRows[index].$1;
      final known = scaleRows[index].$2;
      final missing = scaleRows[index].$3;
      items.add(
        ContentPackItem(
          id: 'phase13.compare.scale.${index + 1}',
          category: 'comparison',
          familyId: 'balance-scale',
          correctChoiceId: '$missing',
          tokens: const ['apple'],
          numbers: [left, known, missing],
          choiceIds: _numericChoiceIds(missing),
        ),
      );
    }

    const countRows = [
      ('red-circles', [3, 2, 1]),
      ('blue-squares', [1, 4, 2]),
      ('green-stars', [2, 1, 5]),
      ('red-circles', [4, 3, 2]),
      ('blue-squares', [2, 5, 3]),
    ];
    for (var index = 0; index < countRows.length; index += 1) {
      items.add(
        ContentPackItem(
          id: 'phase13.compare.details.${index + 1}',
          category: 'comparison',
          familyId: 'detail-count',
          correctChoiceId: countRows[index].$1,
          numbers: countRows[index].$2,
          choiceIds: const ['blue-squares', 'red-circles', 'green-stars'],
        ),
      );
    }
    return items;
  }

  static List<ContentPackItem> _pairMatchingItems() {
    const rows = [
      ('memory-pairs', 'key', 'lock', ['lock', 'shoe', 'cloud']),
      ('memory-pairs', 'foot', 'shoe', ['shoe', 'cloud', 'lock']),
      ('memory-pairs', 'rain', 'cloud', ['cloud', 'shoe', 'lock']),
      ('memory-pairs', 'rocket', 'planet', ['planet', 'lock', 'shoe']),
      ('memory-pairs', 'apple', 'banana', ['banana', 'cloud', 'key']),
      ('lock-key', 'key', 'lock', ['lock', 'shoe', 'cloud']),
      ('lock-key', 'foot', 'shoe', ['shoe', 'cloud', 'lock']),
      ('lock-key', 'rain', 'cloud', ['cloud', 'shoe', 'lock']),
      ('lock-key', 'rocket', 'planet', ['planet', 'shoe', 'lock']),
      ('lock-key', 'apple', 'banana', ['banana', 'key', 'cloud']),
    ];
    return [
      for (var index = 0; index < rows.length; index += 1)
        ContentPackItem(
          id: 'phase13.pair.${index + 1}',
          category: 'pair-matching',
          familyId: rows[index].$1,
          correctChoiceId: rows[index].$3,
          tokens: [rows[index].$2, rows[index].$3],
          choiceIds: rows[index].$4,
        ),
    ];
  }

  static List<ContentPackItem> _shadowMatchingItems() {
    const tokens = [
      'rocket',
      'planet',
      'star',
      'apple',
      'banana',
      'pear',
      'ball',
      'key',
      'lock',
      'shoe',
    ];
    return [
      for (var index = 0; index < tokens.length; index += 1)
        ContentPackItem(
          id: 'phase13.shadow.${index + 1}',
          category: 'shadow-matching',
          familyId: 'shadow-match',
          correctChoiceId: tokens[index],
          tokens: [tokens[index]],
          choiceIds: [
            tokens[index],
            tokens[(index + 3) % tokens.length],
            tokens[(index + 6) % tokens.length],
          ],
        ),
    ];
  }

  static List<ContentPackItem> _pathLogicItems() {
    const rows = [
      ('rocket', 'planet', 'right'),
      ('key', 'lock', 'up'),
      ('shoe', 'star', 'left'),
      ('apple', 'cloud', 'down'),
      ('banana', 'pear', 'right'),
      ('planet', 'rocket', 'left'),
      ('lock', 'key', 'down'),
      ('ball', 'star', 'up'),
      ('circle', 'square', 'right'),
      ('triangle', 'circle', 'left'),
    ];
    return [
      for (var index = 0; index < rows.length; index += 1)
        ContentPackItem(
          id: 'phase13.path.${index + 1}',
          category: 'path-logic',
          familyId: 'path-maze',
          correctChoiceId: rows[index].$3,
          tokens: [rows[index].$1, rows[index].$2, rows[index].$3],
          choiceIds: const ['left', 'right', 'up', 'down'],
        ),
    ];
  }

  static List<ContentPackItem> _memoryDetailItems() {
    const rows = [
      (
        'memory-recall',
        'star',
        ['rocket', 'planet', 'star'],
        ['star', 'rocket', 'planet']
      ),
      (
        'memory-recall',
        'key',
        ['lock', 'cloud', 'key'],
        ['key', 'lock', 'cloud']
      ),
      (
        'memory-recall',
        'banana',
        ['apple', 'pear', 'banana'],
        ['banana', 'apple', 'pear']
      ),
      (
        'sorting-rule',
        'pear',
        ['apple', 'banana', 'pear', 'rocket'],
        ['pear', 'rocket', 'apple']
      ),
      (
        'sorting-rule',
        'star',
        ['circle', 'square', 'star', 'shoe'],
        ['star', 'shoe', 'circle']
      ),
      (
        'sorting-rule',
        'lock',
        ['key', 'cloud', 'lock', 'banana'],
        ['lock', 'banana', 'key']
      ),
      (
        'missing-piece',
        'circle',
        ['rocket', 'circle', 'square', 'star'],
        ['circle', 'square', 'star']
      ),
      (
        'missing-piece',
        'key',
        ['lock', 'key', 'cloud', 'shoe'],
        ['key', 'cloud', 'shoe']
      ),
      (
        'logic-deduction',
        'rocket',
        ['flies', 'not-fruit', 'rocket', 'apple', 'ball'],
        ['rocket', 'apple', 'ball']
      ),
      (
        'logic-deduction',
        'banana',
        ['fruit', 'yellow', 'banana', 'planet', 'lock'],
        ['banana', 'planet', 'lock']
      ),
    ];
    return [
      for (var index = 0; index < rows.length; index += 1)
        ContentPackItem(
          id: 'phase13.memory.${index + 1}',
          category: 'memory-detail',
          familyId: rows[index].$1,
          correctChoiceId: rows[index].$2,
          tokens: rows[index].$3,
          choiceIds: rows[index].$4,
        ),
    ];
  }

  static List<String> _numericChoiceIds(int correct) {
    final lower = correct > 1 ? correct - 1 : correct + 2;
    final higher = correct + 1;
    return ['$lower', '$correct', '$higher'];
  }
}
