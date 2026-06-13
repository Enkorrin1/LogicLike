import 'adaptive_learning.dart';
import 'content_pack.dart';
import 'family_profile.dart';
import 'learning_foundation.dart';

class DailyChallenge {
  const DailyChallenge({
    required this.id,
    required this.title,
    required this.prompt,
    required this.question,
    required this.skill,
    required this.goal,
    required this.minutes,
    required this.choices,
    required this.correctChoiceId,
    required this.hint,
    required this.explanation,
    this.familyId = '',
    this.variantSeed = 0,
    this.tokens = const [],
    this.numbers = const [],
  });

  final String id;
  final String title;
  final String prompt;
  final String question;
  final String skill;
  final LearningGoal goal;
  final int minutes;
  final List<ChallengeChoice> choices;
  final String correctChoiceId;
  final String hint;
  final String explanation;
  final String familyId;
  final int variantSeed;
  final List<String> tokens;
  final List<int> numbers;

  String get visualId => familyId.isEmpty ? id : familyId;

  bool get isLessonVariant => familyId.isNotEmpty;

  bool isCorrectChoice(String choiceId) {
    return choiceId == correctChoiceId;
  }

  ChallengeChoice get correctChoice {
    return choices.firstWhere((choice) => choice.id == correctChoiceId);
  }
}

class ChallengeChoice {
  const ChallengeChoice({
    required this.id,
    required this.label,
  });

  final String id;
  final String label;
}

DailyChallenge dailyChallengeForDate(
  ChildAge age,
  DateTime date, {
  LearningGoal? goal,
}) {
  final challenges = dailyChallengesForAge(age, goal: goal);
  final day = DateTime.utc(date.year, date.month, date.day);
  final firstContentDay = DateTime.utc(2026, 1, 1);
  final daysSinceStart = day.difference(firstContentDay).inDays;

  return challenges[daysSinceStart % challenges.length];
}

List<DailyChallenge> dailyChallengesForAge(
  ChildAge age, {
  LearningGoal? goal,
}) {
  final challenges = _allChallengesForAge(age);
  if (goal == null) {
    return challenges;
  }

  final focusedChallenges = challenges
      .where((challenge) => challenge.goal == goal)
      .toList(growable: false);
  return focusedChallenges.isEmpty ? challenges : focusedChallenges;
}

DailyChallenge dailyChallengeById(String id, {required ChildAge age}) {
  final ageChallenges = _allChallengesForAge(age);
  final ageMatch = ageChallenges.where((challenge) => challenge.id == id);
  if (ageMatch.isNotEmpty) {
    return ageMatch.first;
  }

  for (final candidateAge in ChildAge.values) {
    final match = _allChallengesForAge(candidateAge)
        .where((challenge) => challenge.id == id);
    if (match.isNotEmpty) {
      return match.first;
    }
  }

  return ageChallenges.first;
}

List<DailyChallenge> dailyChallengesByIds(
  List<String> ids, {
  required ChildAge age,
}) {
  return [
    for (final id in ids) dailyChallengeById(id, age: age),
  ];
}

DailyChallenge dailyChallengeForLessonStep(
  LessonStep step,
  PuzzleDefinition puzzle, {
  required ChildAge age,
  AdaptiveLessonPlan adaptivePlan = const AdaptiveLessonPlan(
    mode: AdaptiveDifficultyMode.steady,
    reason: AdaptiveReason.steadyPractice,
    recentSessions: 0,
  ),
}) {
  final seed = _seedForStep(step);
  final familyId = puzzle.payloadRef;
  final goal = _goalForSkill(step.internalSkillTag);
  final minutes = 3 + (seed % 4);

  DailyChallenge build({
    required String correctChoiceId,
    required List<ChallengeChoice> choices,
    List<String> tokens = const [],
    List<int> numbers = const [],
  }) {
    return DailyChallenge(
      id: '${step.id}.$familyId',
      familyId: familyId,
      variantSeed: seed,
      title: familyId,
      prompt: familyId,
      question: familyId,
      skill: _skillForTag(step.internalSkillTag),
      goal: goal,
      minutes: minutes,
      choices: choices,
      correctChoiceId: correctChoiceId,
      hint: familyId,
      explanation: familyId,
      tokens: tokens,
      numbers: numbers,
    );
  }

  final packItem = ContentPackCatalog.phase13ItemForStep(
    step,
    familyId: familyId,
  );
  if (packItem != null) {
    return build(
      correctChoiceId: packItem.correctChoiceId,
      tokens: packItem.tokens,
      numbers: packItem.numbers,
      choices: packItem.choiceIds.toSetChoices(),
    );
  }

  switch (familyId) {
    case 'shape-path':
      final pairs = [
        ('circle', 'square'),
        ('triangle', 'star'),
        ('square', 'circle'),
        ('star', 'triangle'),
      ];
      final pair = pairs[seed % pairs.length];
      return build(
        correctChoiceId: pair.$1,
        tokens: [pair.$1, pair.$2],
        choices:
            _choices(['triangle', 'circle', 'square', 'star']).toSetChoices(),
      );
    case 'fruit-pattern':
      final pairs = [
        ('apple', 'banana'),
        ('banana', 'pear'),
        ('pear', 'apple'),
      ];
      final pair = pairs[seed % pairs.length];
      return build(
        correctChoiceId: pair.$1,
        tokens: [pair.$1, pair.$2],
        choices: _choices(['apple', 'banana', 'pear']).toSetChoices(),
      );
    case 'toy-count':
      final first = adaptivePlan.adaptSmallNumber(1 + (seed % 4));
      final second = adaptivePlan.adaptSmallNumber(1 + ((seed ~/ 3) % 3));
      final total = first + second;
      return build(
        correctChoiceId: '$total',
        numbers: [first, second, total],
        choices: _numericChoices(total),
      );
    case 'odd-card':
      final variants = [
        ('ball', ['apple', 'banana', 'pear', 'ball']),
        ('cloud', ['rocket', 'planet', 'star', 'cloud']),
        ('shoe', ['circle', 'square', 'triangle', 'shoe']),
      ];
      final variant = variants[seed % variants.length];
      return build(
        correctChoiceId: variant.$1,
        tokens: variant.$2,
        choices:
            _choices([variant.$2[0], variant.$1, variant.$2[1]]).toSetChoices(),
      );
    case 'logic-train':
      final pairs = [
        ('red', 'blue'),
        ('green', 'red'),
        ('blue', 'green'),
      ];
      final pair = pairs[seed % pairs.length];
      return build(
        correctChoiceId: pair.$1,
        tokens: [pair.$1, pair.$2],
        choices: _choices(['blue', 'red', 'green']).toSetChoices(),
      );
    case 'sticker-sum':
      final first = adaptivePlan.adaptSmallNumber(2 + (seed % 5));
      final second = adaptivePlan.adaptSmallNumber(1 + ((seed ~/ 2) % 4));
      final total = first + second;
      return build(
        correctChoiceId: '$total',
        numbers: [first, second, total],
        choices: _numericChoices(total),
      );
    case 'memory-pairs':
    case 'lock-key':
      final pairs = [
        ('key', 'lock', ['lock', 'shoe', 'cloud']),
        ('foot', 'shoe', ['shoe', 'cloud', 'lock']),
        ('rain', 'cloud', ['cloud', 'shoe', 'lock']),
      ];
      final pair = pairs[seed % pairs.length];
      return build(
        correctChoiceId: pair.$2,
        tokens: [pair.$1, pair.$2],
        choices: _choices(pair.$3).toSetChoices(),
      );
    case 'shadow-match':
      final variants = [
        ('rocket', ['rocket', 'planet', 'star']),
        ('planet', ['planet', 'rocket', 'star']),
        ('star', ['star', 'planet', 'rocket']),
      ];
      final variant = variants[seed % variants.length];
      return build(
        correctChoiceId: variant.$1,
        tokens: [variant.$1],
        choices: _choices(variant.$2).toSetChoices(),
      );
    case 'balance-scale':
      final known = adaptivePlan.adaptSmallNumber(1 + (seed % 3));
      final missing = adaptivePlan.adaptSmallNumber(1 + ((seed ~/ 2) % 3));
      final left = known + missing;
      return build(
        correctChoiceId: '$missing',
        numbers: [left, known, missing],
        choices: _numericChoices(missing),
        tokens: ['apple'],
      );
    case 'shape-rotation':
      final turns = ['right', 'left', 'half'];
      return build(
        correctChoiceId: 'same',
        tokens: [turns[seed % turns.length]],
        choices: _choices(['same', 'circle', 'square']).toSetChoices(),
      );
    case 'code-grid':
      final first = adaptivePlan.adaptSmallNumber(1 + (seed % 5));
      final stepSize = adaptivePlan.adaptStepSize(2 + (seed % 2));
      final second = first + 1;
      final missing = second + (stepSize * 2);
      return build(
        correctChoiceId: '$missing',
        numbers: [
          first,
          first + stepSize,
          first + stepSize * 2,
          second,
          second + stepSize,
          missing,
          stepSize
        ],
        choices: _numericChoices(missing),
      );
    case 'number-bridge':
      final a = adaptivePlan.adaptSmallNumber(2 + (seed % 5));
      final b = adaptivePlan.adaptSmallNumber(1 + ((seed ~/ 2) % 4));
      final c = adaptivePlan.adaptSmallNumber(1 + ((seed ~/ 4) % 3));
      final total = a + b + c;
      final correct = '$a+$b+$c';
      return build(
        correctChoiceId: correct,
        numbers: [a, b, c, total],
        choices: [
          ChallengeChoice(id: correct, label: '$a + $b + $c'),
          ChallengeChoice(id: '$a+$b', label: '$a + $b'),
          ChallengeChoice(id: '$b+$c', label: '$b + $c'),
        ],
      );
    case 'detail-count':
      final red = 1 + (seed % 4);
      final blue = 1 + ((seed + 1) % 4);
      final green = 1 + ((seed + 2) % 4);
      final counts = {
        'red-circles': red,
        'blue-squares': blue,
        'green-stars': green,
      };
      final maxEntry = counts.entries.reduce(
        (best, item) => item.value > best.value ? item : best,
      );
      return build(
        correctChoiceId: maxEntry.key,
        numbers: [red, blue, green],
        choices: _choices(['blue-squares', 'red-circles', 'green-stars'])
            .toSetChoices(),
      );
    case 'space-sequence':
      final pairs = [
        ('rocket', 'planet'),
        ('planet', 'star'),
        ('star', 'rocket'),
      ];
      final pair = pairs[seed % pairs.length];
      return build(
        correctChoiceId: pair.$1,
        tokens: [pair.$1, pair.$2],
        choices: _choices(['rocket', 'planet', 'star']).toSetChoices(),
      );
    case 'shape-stack':
      final pairs = [
        ('square', 'circle'),
        ('triangle', 'square'),
        ('circle', 'star'),
      ];
      final pair = pairs[seed % pairs.length];
      return build(
        correctChoiceId: pair.$1,
        tokens: [pair.$1, pair.$2],
        choices:
            _choices(['square', 'circle', 'triangle', 'star']).toSetChoices(),
      );
    case 'path-maze':
      final variants = [
        ('rocket', 'planet', 'right'),
        ('key', 'lock', 'up'),
        ('shoe', 'star', 'left'),
        ('apple', 'cloud', 'down'),
      ];
      final variant = variants[seed % variants.length];
      return build(
        correctChoiceId: variant.$3,
        tokens: [variant.$1, variant.$2, variant.$3],
        choices: _directionChoices(
          correctChoiceId: variant.$3,
          adaptivePlan: adaptivePlan,
        ),
      );
    case 'memory-recall':
      final variants = [
        ('star', ['rocket', 'planet', 'star']),
        ('key', ['lock', 'cloud', 'key']),
        ('banana', ['apple', 'pear', 'banana']),
        ('triangle', ['circle', 'square', 'triangle']),
      ];
      final variant = variants[seed % variants.length];
      return build(
        correctChoiceId: variant.$1,
        tokens: variant.$2,
        choices: _choices([
          variant.$1,
          variant.$2.first,
          variant.$2[1],
        ]).toSetChoices(),
      );
    case 'sorting-rule':
      final variants = [
        ('pear', ['apple', 'banana', 'pear', 'rocket']),
        ('star', ['circle', 'square', 'star', 'shoe']),
        ('planet', ['rocket', 'star', 'planet', 'apple']),
        ('lock', ['key', 'cloud', 'lock', 'banana']),
      ];
      final variant = variants[seed % variants.length];
      return build(
        correctChoiceId: variant.$1,
        tokens: variant.$2,
        choices: _choices([
          variant.$1,
          variant.$2.last,
          variant.$2.first,
        ]).toSetChoices(),
      );
    case 'missing-piece':
      final variants = [
        ('circle', ['rocket', 'circle', 'square', 'star']),
        ('star', ['planet', 'star', 'triangle', 'circle']),
        ('key', ['lock', 'key', 'cloud', 'shoe']),
      ];
      final variant = variants[seed % variants.length];
      return build(
        correctChoiceId: variant.$1,
        tokens: variant.$2,
        choices: _choices([
          variant.$1,
          variant.$2[2],
          variant.$2[3],
        ]).toSetChoices(),
      );
    case 'logic-deduction':
      final variants = [
        ('rocket', ['flies', 'not-fruit', 'rocket', 'apple', 'ball']),
        ('key', ['opens', 'not-cloud', 'key', 'cloud', 'shoe']),
        ('banana', ['fruit', 'yellow', 'banana', 'planet', 'lock']),
      ];
      final variant = variants[seed % variants.length];
      return build(
        correctChoiceId: variant.$1,
        tokens: variant.$2,
        choices: _choices([
          variant.$2[2],
          variant.$2[3],
          variant.$2[4],
        ]).toSetChoices(),
      );
  }

  return dailyChallengeById(familyId, age: age);
}

int _seedForStep(LessonStep step) {
  final parts = step.id.split('.');
  final lesson = parts.length > 1 ? int.tryParse(parts[1]) ?? 1 : 1;
  final order = parts.length > 2 ? int.tryParse(parts[2]) ?? 1 : 1;
  return lesson * 17 + order * 7;
}

LearningGoal _goalForSkill(SkillTag skillTag) {
  return switch (skillTag) {
    SkillTag.arithmetic => LearningGoal.math,
    SkillTag.attention || SkillTag.memory => LearningGoal.attention,
    SkillTag.pattern ||
    SkillTag.classification ||
    SkillTag.spatial ||
    SkillTag.reasoning =>
      LearningGoal.logic,
  };
}

String _skillForTag(SkillTag skillTag) {
  return switch (skillTag) {
    SkillTag.attention => 'Detail comparison',
    SkillTag.memory => 'Working memory',
    SkillTag.pattern => 'Patterns',
    SkillTag.classification => 'Comparison',
    SkillTag.arithmetic => 'Math thinking',
    SkillTag.spatial => 'Spatial reasoning',
    SkillTag.reasoning => 'Logic and deduction',
  };
}

List<String> _choices(List<String> ids) => ids;

List<ChallengeChoice> _directionChoices({
  required String correctChoiceId,
  required AdaptiveLessonPlan adaptivePlan,
}) {
  const directions = ['left', 'right', 'up', 'down'];
  if (!adaptivePlan.isWarmUp) {
    return directions.toSetChoices();
  }

  return [
    correctChoiceId,
    for (final direction in directions)
      if (direction != correctChoiceId) direction,
  ].take(3).toList().toSetChoices();
}

List<ChallengeChoice> _numericChoices(int correct) {
  final lower = correct > 1 ? correct - 1 : correct + 2;
  final higher = correct + 1;
  return _choices(['$lower', '$correct', '$higher']).toSetChoices();
}

extension _ChoiceIds on List<String> {
  List<ChallengeChoice> toSetChoices() {
    return toSet().map((id) => ChallengeChoice(id: id, label: id)).toList();
  }
}

List<DailyChallenge> _allChallengesForAge(ChildAge age) {
  switch (age) {
    case ChildAge.four:
    case ChildAge.five:
      return const [
        DailyChallenge(
          id: 'shape-path',
          title: 'Дорожка фигур',
          prompt: 'Посмотри на ряд и найди, что должно идти дальше.',
          question: 'Круг, квадрат, круг, квадрат. Что дальше?',
          skill: 'Закономерности',
          goal: LearningGoal.logic,
          minutes: 4,
          correctChoiceId: 'circle',
          hint: 'Фигуры чередуются: одна, потом другая, потом снова первая.',
          explanation:
              'После квадрата снова идет круг, потому что ряд повторяется через одну фигуру.',
          choices: [
            ChallengeChoice(id: 'triangle', label: 'Треугольник'),
            ChallengeChoice(id: 'circle', label: 'Круг'),
            ChallengeChoice(id: 'star', label: 'Звезда'),
          ],
        ),
        DailyChallenge(
          id: 'toy-count',
          title: 'Сколько игрушек',
          prompt: 'Посчитай предметы и выбери точный ответ.',
          question: 'На полке 2 кубика и 1 мяч. Сколько игрушек всего?',
          skill: 'Счет до пяти',
          goal: LearningGoal.math,
          minutes: 3,
          correctChoiceId: '3',
          hint: 'Сначала посчитай кубики, потом добавь мяч.',
          explanation: '2 кубика и 1 мяч дают 3 игрушки всего.',
          choices: [
            ChallengeChoice(id: '2', label: '2'),
            ChallengeChoice(id: '3', label: '3'),
            ChallengeChoice(id: '4', label: '4'),
          ],
        ),
        DailyChallenge(
          id: 'odd-card',
          title: 'Лишняя карточка',
          prompt: 'Найди предмет, который отличается от остальных.',
          question: 'Яблоко, груша, мяч, банан. Что лишнее?',
          skill: 'Сравнение',
          goal: LearningGoal.attention,
          minutes: 3,
          correctChoiceId: 'ball',
          hint: 'Три предмета можно съесть, а один нужен для игры.',
          explanation: 'Мяч лишний: яблоко, груша и банан - это фрукты.',
          choices: [
            ChallengeChoice(id: 'apple', label: 'Яблоко'),
            ChallengeChoice(id: 'ball', label: 'Мяч'),
            ChallengeChoice(id: 'banana', label: 'Банан'),
          ],
        ),
        DailyChallenge(
          id: 'fruit-pattern',
          title: 'Fruit row',
          prompt: 'Continue the fruit pattern.',
          question: 'Apple, banana, apple, banana. What comes next?',
          skill: 'Р—Р°РєРѕРЅРѕРјРµСЂРЅРѕСЃС‚Рё',
          goal: LearningGoal.logic,
          minutes: 4,
          correctChoiceId: 'apple',
          hint: 'The fruits repeat one by one: apple, then banana.',
          explanation:
              'After banana comes apple again, because the pattern repeats.',
          choices: [
            ChallengeChoice(id: 'apple', label: 'Apple'),
            ChallengeChoice(id: 'banana', label: 'Banana'),
            ChallengeChoice(id: 'pear', label: 'Pear'),
          ],
        ),
        DailyChallenge(
          id: 'shadow-match',
          title: 'Подбери тень',
          prompt: 'Найди предмет, который подходит к тени.',
          question: 'У тени высокий корпус и два маленьких крыла. Что это?',
          skill: 'Пространственное мышление',
          goal: LearningGoal.logic,
          minutes: 4,
          correctChoiceId: 'rocket',
          hint: 'Смотри на общий контур предмета.',
          explanation:
              'Ракета подходит к тени: у нее высокий корпус и два боковых крыла.',
          choices: [
            ChallengeChoice(id: 'rocket', label: 'Ракета'),
            ChallengeChoice(id: 'planet', label: 'Планета'),
            ChallengeChoice(id: 'star', label: 'Звезда'),
          ],
        ),
      ];
    case ChildAge.six:
      return const [
        DailyChallenge(
          id: 'logic-train',
          title: 'Логический поезд',
          prompt: 'Расставь вагоны по правилу.',
          question:
              'Красный, синий, синий, красный, синий, синий. Какой следующий?',
          skill: 'Последовательности',
          goal: LearningGoal.logic,
          minutes: 5,
          correctChoiceId: 'red',
          hint: 'Правило повторяется тройками: один красный и два синих.',
          explanation:
              'Следующий вагон красный: после двух синих начинается новая тройка.',
          choices: [
            ChallengeChoice(id: 'blue', label: 'Синий'),
            ChallengeChoice(id: 'red', label: 'Красный'),
            ChallengeChoice(id: 'green', label: 'Зеленый'),
          ],
        ),
        DailyChallenge(
          id: 'sticker-sum',
          title: 'Наклейки в альбоме',
          prompt: 'Сложи две маленькие группы предметов.',
          question: 'У Ники было 3 наклейки, потом дали еще 2. Сколько стало?',
          skill: 'Сложение до десяти',
          goal: LearningGoal.math,
          minutes: 4,
          correctChoiceId: '5',
          hint: 'Начни с трех и досчитай еще два шага.',
          explanation: '3 + 2 = 5, значит стало пять наклеек.',
          choices: [
            ChallengeChoice(id: '4', label: '4'),
            ChallengeChoice(id: '5', label: '5'),
            ChallengeChoice(id: '6', label: '6'),
          ],
        ),
        DailyChallenge(
          id: 'memory-pairs',
          title: 'Пары по памяти',
          prompt: 'Вспомни пару для каждого предмета.',
          question: 'Что подходит к ключу?',
          skill: 'Рабочая память',
          goal: LearningGoal.attention,
          minutes: 4,
          correctChoiceId: 'lock',
          hint: 'Ключ нужен, чтобы что-то открыть.',
          explanation:
              'К ключу подходит замок: вместе они образуют смысловую пару.',
          choices: [
            ChallengeChoice(id: 'lock', label: 'Замок'),
            ChallengeChoice(id: 'shoe', label: 'Ботинок'),
            ChallengeChoice(id: 'cloud', label: 'Облако'),
          ],
        ),
        DailyChallenge(
          id: 'lock-key',
          title: 'Magic pair',
          prompt: 'Choose the object that makes a pair.',
          question: 'A key opens something. What does it go with?',
          skill: 'Р Р°Р±РѕС‡Р°СЏ РїР°РјСЏС‚СЊ',
          goal: LearningGoal.attention,
          minutes: 4,
          correctChoiceId: 'lock',
          hint: 'Think about what a key is used for.',
          explanation: 'A key and a lock work together, so they form the pair.',
          choices: [
            ChallengeChoice(id: 'lock', label: 'Lock'),
            ChallengeChoice(id: 'shoe', label: 'Shoe'),
            ChallengeChoice(id: 'cloud', label: 'Cloud'),
          ],
        ),
        DailyChallenge(
          id: 'balance-scale',
          title: 'Весы',
          prompt: 'Сравни стороны и выбери, чего не хватает.',
          question: 'Слева 2 яблока. Справа 1 яблоко и ?. Что добавить?',
          skill: 'Сравнение',
          goal: LearningGoal.math,
          minutes: 5,
          correctChoiceId: 'apple',
          hint: 'На обеих сторонах должно быть одинаковое количество яблок.',
          explanation:
              'Еще одно яблоко делает правую сторону равной левой: 2 и 2.',
          choices: [
            ChallengeChoice(id: 'apple', label: 'Яблоко'),
            ChallengeChoice(id: 'star', label: 'Звезда'),
            ChallengeChoice(id: 'ball', label: 'Мяч'),
          ],
        ),
      ];
    case ChildAge.seven:
    case ChildAge.eight:
      return const [
        DailyChallenge(
          id: 'code-grid',
          title: 'Кодовая сетка',
          prompt: 'Разгадай правило и выбери правильную клетку.',
          question:
              'В первой строке 2, 4, 6. Во второй 3, 5, ?. Какое число пропущено?',
          skill: 'Логика и дедукция',
          goal: LearningGoal.logic,
          minutes: 6,
          correctChoiceId: '7',
          hint: 'Во второй строке числа тоже растут на 2.',
          explanation:
              'После 3 и 5 идет 7: каждый шаг увеличивает число на два.',
          choices: [
            ChallengeChoice(id: '6', label: '6'),
            ChallengeChoice(id: '7', label: '7'),
            ChallengeChoice(id: '8', label: '8'),
          ],
        ),
        DailyChallenge(
          id: 'number-bridge',
          title: 'Числовой мост',
          prompt: 'Соедини числа так, чтобы получить нужный маршрут.',
          question: 'У тебя есть 4, 2 и 1. Как получить 7?',
          skill: 'Математическое мышление',
          goal: LearningGoal.math,
          minutes: 5,
          correctChoiceId: '4+2+1',
          hint: 'Попробуй использовать все числа один раз.',
          explanation:
              '4 + 2 + 1 = 7, значит все три числа вместе дают нужный результат.',
          choices: [
            ChallengeChoice(id: '4+2+1', label: '4 + 2 + 1'),
            ChallengeChoice(id: '4+1', label: '4 + 1'),
            ChallengeChoice(id: '2+1', label: '2 + 1'),
          ],
        ),
        DailyChallenge(
          id: 'detail-count',
          title: 'Карта деталей',
          prompt: 'Удержи в голове несколько деталей и сравни их.',
          question:
              'Есть 3 красных круга, 2 синих квадрата и 1 зеленая звезда. Чего больше всего?',
          skill: 'Сравнение деталей',
          goal: LearningGoal.attention,
          minutes: 5,
          correctChoiceId: 'red-circles',
          hint: 'Сравни количества: 3, 2 и 1.',
          explanation: 'Больше всего красных кругов: их три.',
          choices: [
            ChallengeChoice(id: 'blue-squares', label: 'Синих квадратов'),
            ChallengeChoice(id: 'red-circles', label: 'Красных кругов'),
            ChallengeChoice(id: 'green-stars', label: 'Зеленых звезд'),
          ],
        ),
        DailyChallenge(
          id: 'shape-rotation',
          title: 'Поворот фигуры',
          prompt: 'Представь, как фигура поворачивается.',
          question:
              'Треугольник повернули вправо. Какая карточка показывает ту же фигуру?',
          skill: 'Пространственное мышление',
          goal: LearningGoal.logic,
          minutes: 6,
          correctChoiceId: 'same',
          hint: 'Поворот меняет направление, но не саму фигуру.',
          explanation:
              'Это тот же треугольник: он повернулся, но не стал другой фигурой.',
          choices: [
            ChallengeChoice(id: 'same', label: 'Тот же треугольник'),
            ChallengeChoice(id: 'circle', label: 'Круг'),
            ChallengeChoice(id: 'square', label: 'Квадрат'),
          ],
        ),
        DailyChallenge(
          id: 'space-sequence',
          title: 'Space route',
          prompt: 'Find the next space object.',
          question: 'Rocket, planet, rocket, planet. What comes next?',
          skill: 'РџРѕСЃР»РµРґРѕРІР°С‚РµР»СЊРЅРѕСЃС‚Рё',
          goal: LearningGoal.logic,
          minutes: 5,
          correctChoiceId: 'rocket',
          hint: 'The route repeats: rocket, then planet.',
          explanation: 'After the planet comes a rocket again.',
          choices: [
            ChallengeChoice(id: 'rocket', label: 'Rocket'),
            ChallengeChoice(id: 'planet', label: 'Planet'),
            ChallengeChoice(id: 'star', label: 'Star'),
          ],
        ),
        DailyChallenge(
          id: 'shape-stack',
          title: 'Shape tower',
          prompt: 'Continue the tower rule.',
          question: 'Square, circle, square, circle. Which shape is next?',
          skill: 'РџСЂРѕСЃС‚СЂР°РЅСЃС‚РІРµРЅРЅРѕРµ РјС‹С€Р»РµРЅРёРµ',
          goal: LearningGoal.logic,
          minutes: 5,
          correctChoiceId: 'square',
          hint: 'The tower alternates between two shapes.',
          explanation: 'After a circle comes a square again.',
          choices: [
            ChallengeChoice(id: 'square', label: 'Square'),
            ChallengeChoice(id: 'circle', label: 'Circle'),
            ChallengeChoice(id: 'triangle', label: 'Triangle'),
          ],
        ),
        DailyChallenge(
          id: 'path-maze',
          title: 'Path finder',
          prompt: 'Follow the road from start to finish.',
          question:
              'Help the rocket get to the planet. Which way should it go?',
          skill: 'Spatial reasoning',
          goal: LearningGoal.logic,
          minutes: 5,
          correctChoiceId: 'right',
          hint: 'Trace the road from the rocket to the planet.',
          explanation: 'The correct road goes right.',
          tokens: ['rocket', 'planet', 'right'],
          choices: [
            ChallengeChoice(id: 'left', label: 'Left'),
            ChallengeChoice(id: 'right', label: 'Right'),
            ChallengeChoice(id: 'up', label: 'Up'),
            ChallengeChoice(id: 'down', label: 'Down'),
          ],
        ),
      ];
  }
}
