import 'learning_foundation.dart';

class ContentPackItem {
  const ContentPackItem({
    required this.id,
    required this.category,
    required this.familyId,
    required this.correctChoiceId,
    required this.choiceIds,
    this.difficultyBand = 'foundation',
    this.bossLessonId,
    this.tokens = const [],
    this.numbers = const [],
  });

  final String id;
  final String category;
  final String familyId;
  final String correctChoiceId;
  final List<String> choiceIds;
  final String difficultyBand;
  final String? bossLessonId;
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

class BossLessonDefinition {
  const BossLessonDefinition({
    required this.id,
    required this.titleKey,
    required this.itemIds,
  });

  final String id;
  final String titleKey;
  final List<String> itemIds;
}

class ContentPackCatalog {
  const ContentPackCatalog._();

  static const phase14DifficultyTargets = {
    'easy': 60,
    'medium': 120,
    'hard': 80,
    'mixed-review': 40,
  };

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

  static final List<ContentPackItem> phase14Items = _buildPhase14Items();

  static final List<BossLessonDefinition> phase14BossLessons = [
    for (var index = 0; index < 8; index += 1)
      BossLessonDefinition(
        id: 'phase14.boss.${index + 1}',
        titleKey: 'boss_${(index + 1).toString().padLeft(2, '0')}',
        itemIds: [
          for (final item in phase14Items)
            if (item.bossLessonId == 'phase14.boss.${index + 1}') item.id,
        ],
      ),
  ];

  static ContentPackItem? itemForStep(
    LessonStep step, {
    required String familyId,
  }) {
    if (step.lessonId == 'lesson.001') {
      return null;
    }

    final matchingItems = [
      for (final item in phase14Items)
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

  static Map<String, int> phase14DifficultyCounts() {
    final counts = <String, int>{};
    for (final item in phase14Items) {
      counts[item.difficultyBand] = (counts[item.difficultyBand] ?? 0) + 1;
    }
    return counts;
  }

  static List<ContentPackItem> _buildPhase14Items() {
    return [
      ..._phase14BandItems(
        difficultyBand: 'easy',
        count: phase14DifficultyTargets['easy']!,
        families: const [
          'shape-path',
          'fruit-pattern',
          'toy-count',
          'odd-card',
          'memory-pairs',
          'shadow-match',
        ],
      ),
      ..._phase14BandItems(
        difficultyBand: 'medium',
        count: phase14DifficultyTargets['medium']!,
        families: const [
          'logic-train',
          'sticker-sum',
          'lock-key',
          'space-sequence',
          'shape-stack',
          'sorting-rule',
          'path-maze',
        ],
      ),
      ..._phase14BandItems(
        difficultyBand: 'hard',
        count: phase14DifficultyTargets['hard']!,
        families: const [
          'balance-scale',
          'shape-rotation',
          'code-grid',
          'number-bridge',
          'detail-count',
          'missing-piece',
          'logic-deduction',
        ],
      ),
      ..._phase14ReviewItems(),
    ];
  }

  static List<ContentPackItem> _phase14BandItems({
    required String difficultyBand,
    required int count,
    required List<String> families,
  }) {
    return [
      for (var index = 0; index < count; index += 1)
        _phase14ItemForFamily(
          id: 'phase14.$difficultyBand.${index + 1}',
          difficultyBand: difficultyBand,
          familyId: families[index % families.length],
          variant: index,
        ),
    ];
  }

  static List<ContentPackItem> _phase14ReviewItems() {
    const families = [
      'shape-path',
      'odd-card',
      'toy-count',
      'logic-train',
      'memory-pairs',
      'shadow-match',
      'balance-scale',
      'code-grid',
      'number-bridge',
      'path-maze',
      'memory-recall',
      'sorting-rule',
      'missing-piece',
      'logic-deduction',
    ];
    return [
      for (var index = 0;
          index < phase14DifficultyTargets['mixed-review']!;
          index += 1)
        _phase14ItemForFamily(
          id: 'phase14.review.${index + 1}',
          difficultyBand: 'mixed-review',
          familyId: families[index % families.length],
          variant: index + 100,
          bossLessonId: 'phase14.boss.${(index ~/ 5) + 1}',
        ),
    ];
  }

  static ContentPackItem _phase14ItemForFamily({
    required String id,
    required String difficultyBand,
    required String familyId,
    required int variant,
    String? bossLessonId,
  }) {
    ContentPackItem item({
      required String category,
      required String correctChoiceId,
      required List<String> choiceIds,
      List<String> tokens = const [],
      List<int> numbers = const [],
    }) {
      return ContentPackItem(
        id: id,
        category: category,
        familyId: familyId,
        correctChoiceId: correctChoiceId,
        choiceIds: choiceIds,
        difficultyBand: difficultyBand,
        bossLessonId: bossLessonId,
        tokens: tokens,
        numbers: numbers,
      );
    }

    switch (familyId) {
      case 'shape-path':
        const pairs = [
          ('circle', 'square'),
          ('triangle', 'star'),
          ('square', 'circle'),
          ('star', 'triangle'),
          ('circle', 'triangle'),
          ('square', 'star'),
        ];
        final pair = pairs[variant % pairs.length];
        return item(
          category: 'pattern',
          correctChoiceId: pair.$1,
          tokens: [pair.$1, pair.$2],
          choiceIds: const ['triangle', 'circle', 'square', 'star'],
        );
      case 'fruit-pattern':
        const pairs = [
          ('apple', 'banana'),
          ('banana', 'pear'),
          ('pear', 'apple'),
          ('apple', 'pear'),
          ('banana', 'apple'),
        ];
        final pair = pairs[variant % pairs.length];
        return item(
          category: 'pattern',
          correctChoiceId: pair.$1,
          tokens: [pair.$1, pair.$2],
          choiceIds: const ['apple', 'banana', 'pear'],
        );
      case 'logic-train':
        const pairs = [
          ('red', 'blue'),
          ('green', 'red'),
          ('blue', 'green'),
          ('red', 'green'),
          ('blue', 'red'),
        ];
        final pair = pairs[variant % pairs.length];
        return item(
          category: 'pattern',
          correctChoiceId: pair.$1,
          tokens: [pair.$1, pair.$2],
          choiceIds: const ['blue', 'red', 'green'],
        );
      case 'space-sequence':
        const pairs = [
          ('rocket', 'planet'),
          ('planet', 'star'),
          ('star', 'rocket'),
          ('rocket', 'star'),
          ('planet', 'rocket'),
        ];
        final pair = pairs[variant % pairs.length];
        return item(
          category: 'pattern',
          correctChoiceId: pair.$1,
          tokens: [pair.$1, pair.$2],
          choiceIds: const ['rocket', 'planet', 'star'],
        );
      case 'shape-stack':
        const pairs = [
          ('square', 'circle'),
          ('triangle', 'square'),
          ('circle', 'star'),
          ('star', 'square'),
          ('triangle', 'circle'),
        ];
        final pair = pairs[variant % pairs.length];
        return item(
          category: 'pattern',
          correctChoiceId: pair.$1,
          tokens: [pair.$1, pair.$2],
          choiceIds: const ['square', 'circle', 'triangle', 'star'],
        );
      case 'toy-count':
        final first = 1 + (variant % 5);
        final second = 1 + ((variant ~/ 2) % 4);
        final total = first + second;
        return item(
          category: 'counting',
          correctChoiceId: '$total',
          numbers: [first, second, total],
          choiceIds: _numericChoiceIds(total),
        );
      case 'sticker-sum':
        final first = 2 + (variant % 7);
        final second = 1 + ((variant ~/ 3) % 5);
        final total = first + second;
        return item(
          category: 'counting',
          correctChoiceId: '$total',
          numbers: [first, second, total],
          choiceIds: _numericChoiceIds(total),
        );
      case 'odd-card':
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
        ];
        final row = rows[variant % rows.length];
        return item(
          category: 'odd-one-out',
          correctChoiceId: row.$1,
          tokens: row.$2,
          choiceIds: [row.$2[0], row.$1, row.$2[1]],
        );
      case 'memory-pairs':
      case 'lock-key':
        const rows = [
          ('key', 'lock', ['lock', 'shoe', 'cloud']),
          ('foot', 'shoe', ['shoe', 'cloud', 'lock']),
          ('rain', 'cloud', ['cloud', 'shoe', 'lock']),
          ('rocket', 'planet', ['planet', 'lock', 'shoe']),
          ('apple', 'banana', ['banana', 'cloud', 'key']),
        ];
        final row = rows[variant % rows.length];
        return item(
          category: 'pair-matching',
          correctChoiceId: row.$2,
          tokens: [row.$1, row.$2],
          choiceIds: row.$3,
        );
      case 'shadow-match':
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
        final token = tokens[variant % tokens.length];
        return item(
          category: 'shadow-matching',
          correctChoiceId: token,
          tokens: [token],
          choiceIds: [
            token,
            tokens[(variant + 3) % tokens.length],
            tokens[(variant + 6) % tokens.length],
          ],
        );
      case 'balance-scale':
        final known = 1 + (variant % 5);
        final missing = 1 + ((variant ~/ 2) % 5);
        final left = known + missing;
        return item(
          category: 'comparison',
          correctChoiceId: '$missing',
          tokens: const ['apple'],
          numbers: [left, known, missing],
          choiceIds: _numericChoiceIds(missing),
        );
      case 'detail-count':
        final red = 1 + (variant % 5);
        final blue = 1 + ((variant + 2) % 5);
        final green = 1 + ((variant + 4) % 5);
        final counts = {
          'red-circles': red,
          'blue-squares': blue,
          'green-stars': green,
        };
        final correct = counts.entries
            .reduce((best, next) => next.value > best.value ? next : best)
            .key;
        return item(
          category: 'comparison',
          correctChoiceId: correct,
          numbers: [red, blue, green],
          choiceIds: const ['blue-squares', 'red-circles', 'green-stars'],
        );
      case 'shape-rotation':
        const turns = ['right', 'left', 'half'];
        return item(
          category: 'spatial-rotation',
          correctChoiceId: 'same',
          tokens: [turns[variant % turns.length]],
          choiceIds: const ['same', 'circle', 'square'],
        );
      case 'code-grid':
        final first = 1 + (variant % 6);
        final stepSize = 2 + ((variant ~/ 2) % 3);
        final second = first + 1;
        final missing = second + stepSize * 2;
        return item(
          category: 'logic-grid',
          correctChoiceId: '$missing',
          numbers: [
            first,
            first + stepSize,
            first + stepSize * 2,
            second,
            second + stepSize,
            missing,
            stepSize,
          ],
          choiceIds: _numericChoiceIds(missing),
        );
      case 'number-bridge':
        final a = 2 + (variant % 6);
        final b = 1 + ((variant ~/ 2) % 5);
        final c = 1 + ((variant ~/ 3) % 4);
        final total = a + b + c;
        final correct = '$a+$b+$c';
        return item(
          category: 'visual-math',
          correctChoiceId: correct,
          numbers: [a, b, c, total],
          choiceIds: [correct, '$a+$b', '$b+$c'],
        );
      case 'path-maze':
        const rows = [
          ('rocket', 'planet', 'right'),
          ('key', 'lock', 'up'),
          ('shoe', 'star', 'left'),
          ('apple', 'cloud', 'down'),
          ('banana', 'pear', 'right'),
          ('planet', 'rocket', 'left'),
          ('lock', 'key', 'down'),
          ('ball', 'star', 'up'),
        ];
        final row = rows[variant % rows.length];
        return item(
          category: 'path-logic',
          correctChoiceId: row.$3,
          tokens: [row.$1, row.$2, row.$3],
          choiceIds: const ['left', 'right', 'up', 'down'],
        );
      case 'memory-recall':
        const rows = [
          ('star', ['rocket', 'planet', 'star']),
          ('key', ['lock', 'cloud', 'key']),
          ('banana', ['apple', 'pear', 'banana']),
          ('triangle', ['circle', 'square', 'triangle']),
        ];
        final row = rows[variant % rows.length];
        return item(
          category: 'memory-detail',
          correctChoiceId: row.$1,
          tokens: row.$2,
          choiceIds: [row.$1, row.$2.first, row.$2[1]],
        );
      case 'sorting-rule':
        const rows = [
          ('pear', ['apple', 'banana', 'pear', 'rocket']),
          ('star', ['circle', 'square', 'star', 'shoe']),
          ('planet', ['rocket', 'star', 'planet', 'apple']),
          ('lock', ['key', 'cloud', 'lock', 'banana']),
        ];
        final row = rows[variant % rows.length];
        return item(
          category: 'memory-detail',
          correctChoiceId: row.$1,
          tokens: row.$2,
          choiceIds: [row.$1, row.$2.last, row.$2.first],
        );
      case 'missing-piece':
        const rows = [
          ('circle', ['rocket', 'circle', 'square', 'star']),
          ('star', ['planet', 'star', 'triangle', 'circle']),
          ('key', ['lock', 'key', 'cloud', 'shoe']),
        ];
        final row = rows[variant % rows.length];
        return item(
          category: 'memory-detail',
          correctChoiceId: row.$1,
          tokens: row.$2,
          choiceIds: [row.$1, row.$2[2], row.$2[3]],
        );
      case 'logic-deduction':
        const rows = [
          ('rocket', ['flies', 'not-fruit', 'rocket', 'apple', 'ball']),
          ('key', ['opens', 'not-cloud', 'key', 'cloud', 'shoe']),
          ('banana', ['fruit', 'yellow', 'banana', 'planet', 'lock']),
        ];
        final row = rows[variant % rows.length];
        return item(
          category: 'memory-detail',
          correctChoiceId: row.$1,
          tokens: row.$2,
          choiceIds: [row.$2[2], row.$2[3], row.$2[4]],
        );
    }

    return item(
      category: 'pattern',
      correctChoiceId: 'circle',
      tokens: const ['circle', 'square'],
      choiceIds: const ['triangle', 'circle', 'square'],
    );
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
