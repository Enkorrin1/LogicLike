import 'daily_challenge.dart';

class PuzzleAnswerRule {
  const PuzzleAnswerRule({
    required this.options,
    required this.correctAnswer,
    required this.retryText,
  });

  final List<String> options;
  final String correctAnswer;
  final String retryText;
}

PuzzleAnswerRule answerRuleForPuzzle(DailyChallenge puzzle) {
  return _rulesByPuzzleId[puzzle.id] ?? _fallbackRuleForArea(puzzle.areaId);
}

bool isCorrectAnswerForPuzzle(DailyChallenge puzzle, String answer) {
  return answer == answerRuleForPuzzle(puzzle).correctAnswer;
}

bool hasConfiguredAnswerRuleForPuzzle(DailyChallenge puzzle) {
  return _rulesByPuzzleId.containsKey(puzzle.id);
}

const _rulesByPuzzleId = <String, PuzzleAnswerRule>{
  'logic-train': PuzzleAnswerRule(
    options: ['Треугольник', 'Круг', 'Квадрат'],
    correctAnswer: 'Круг',
    retryText: 'Ряд повторяется: круг, квадрат, круг, квадрат.',
  ),
  'shape-path': PuzzleAnswerRule(
    options: ['Круг', 'Квадрат', 'Треугольник'],
    correctAnswer: 'Круг',
    retryText: 'После квадрата начинается новый повтор с круга.',
  ),
  'tower-rule': PuzzleAnswerRule(
    options: ['Такая же', 'Выше', 'Ниже'],
    correctAnswer: 'Такая же',
    retryText: 'Сравни не высоту, а правило чередования блоков.',
  ),
  'home-clues': PuzzleAnswerRule(
    options: ['Синий дом', 'Желтый дом', 'Зеленый дом'],
    correctAnswer: 'Зеленый дом',
    retryText: 'Проверь подсказки по одной и убери неподходящие домики.',
  ),
  'odd-step': PuzzleAnswerRule(
    options: ['Первый шаг', 'Средний шаг', 'Последний шаг'],
    correctAnswer: 'Средний шаг',
    retryText: 'Ищи действие, после которого цепочка перестает работать.',
  ),
  'secret-code': PuzzleAnswerRule(
    options: ['Звезда', 'Ключ', 'Молния'],
    correctAnswer: 'Ключ',
    retryText: 'Код повторяет пару: знак, ключ, знак, ключ.',
  ),
  'why-chain': PuzzleAnswerRule(
    options: ['Причина', 'Следствие', 'Лишнее'],
    correctAnswer: 'Причина',
    retryText: 'Начинай с того, что случилось раньше всего.',
  ),
  'space-proof': PuzzleAnswerRule(
    options: ['Треугольник', 'Круг', 'Квадрат'],
    correctAnswer: 'Круг',
    retryText: 'Обе подсказки оставляют только один вариант.',
  ),
  'memory-pairs': PuzzleAnswerRule(
    options: ['Звезда', 'Облако', 'Сердце'],
    correctAnswer: 'Сердце',
    retryText: 'Вспомни закрытую карточку и сравни ее с уже открытыми.',
  ),
  'sound-order': PuzzleAnswerRule(
    options: ['Бип-бип-бум', 'Бум-бип-бип', 'Бип-бум-бип'],
    correctAnswer: 'Бип-бум-бип',
    retryText: 'Повтори звуки в том порядке, в котором их услышал.',
  ),
  'route-memory': PuzzleAnswerRule(
    options: ['Вверх', 'Вправо', 'Вниз'],
    correctAnswer: 'Вправо',
    retryText: 'Вспомни последний поворот маршрута героя.',
  ),
  'hidden-cards': PuzzleAnswerRule(
    options: ['Ракета', 'Планета', 'Звезда'],
    correctAnswer: 'Планета',
    retryText: 'Представь, где лежала закрытая карточка.',
  ),
  'color-rhythm': PuzzleAnswerRule(
    options: ['Красный', 'Синий', 'Желтый'],
    correctAnswer: 'Синий',
    retryText: 'Повторяй цвета слева направо без пропуска.',
  ),
  'what-changed': PuzzleAnswerRule(
    options: ['Цвет', 'Форма', 'Место'],
    correctAnswer: 'Место',
    retryText: 'Сравни, что поменяло позицию, а не цвет.',
  ),
  'star-list': PuzzleAnswerRule(
    options: ['Звезда', 'Луна', 'Ракета'],
    correctAnswer: 'Звезда',
    retryText: 'Выбирай предмет, который точно был в списке.',
  ),
  'captain-command': PuzzleAnswerRule(
    options: ['Прыжок', 'Поворот', 'Стоп'],
    correctAnswer: 'Поворот',
    retryText: 'Команды надо вспоминать по порядку.',
  ),
  'odd-card': PuzzleAnswerRule(
    options: ['Картинка 1', 'Картинка 2', 'Картинка 3'],
    correctAnswer: 'Картинка 2',
    retryText: 'Сравни карточки по номерам. Вторая отличается значком внутри.',
  ),
  'tiny-detail': PuzzleAnswerRule(
    options: ['Сверху', 'В центре', 'Снизу'],
    correctAnswer: 'Сверху',
    retryText: 'Маленькая деталь спряталась ближе к верхнему краю.',
  ),
  'shadow-match': PuzzleAnswerRule(
    options: ['След 1', 'След 2', 'След 3'],
    correctAnswer: 'След 2',
    retryText: 'Герою подходит след с лапкой, а не лист или звезда.',
  ),
  'fast-eyes': PuzzleAnswerRule(
    options: ['Картинка 1', 'Картинка 2', 'Картинка 3'],
    correctAnswer: 'Картинка 2',
    retryText:
        'Сначала найди образец, потом выбери карточку с таким же знаком.',
  ),
  'hidden-star': PuzzleAnswerRule(
    options: ['Планета', 'Звезда', 'Облако'],
    correctAnswer: 'Звезда',
    retryText: 'Звезда маленькая, но у нее острые лучи.',
  ),
  'two-differences': PuzzleAnswerRule(
    options: ['1 отличие', '2 отличия', '3 отличия'],
    correctAnswer: '2 отличия',
    retryText: 'Сравни картинки по частям: верх, центр и низ.',
  ),
  'clean-row': PuzzleAnswerRule(
    options: ['Круг', 'Кубик', 'Звезда'],
    correctAnswer: 'Звезда',
    retryText: 'Оставь предметы одного правила, лишний не похож на ряд.',
  ),
  'beacon-signal': PuzzleAnswerRule(
    options: ['Сейчас', 'Рано', 'Поздно'],
    correctAnswer: 'Сейчас',
    retryText: 'Жми, когда сигнал совпал с нужным цветом.',
  ),
  'number-bridge': PuzzleAnswerRule(
    options: ['4', '5', '6'],
    correctAnswer: '5',
    retryText: 'Посчитай путь по шагам и не пропускай клетку.',
  ),
  'star-balance': PuzzleAnswerRule(
    options: ['3', '4', '5'],
    correctAnswer: '4',
    retryText: 'На весах должно стать поровну с обеих сторон.',
  ),
  'count-rockets': PuzzleAnswerRule(
    options: ['5', '6', '7'],
    correctAnswer: '6',
    retryText: 'Считай ракеты по одной и отмечай уже посчитанные.',
  ),
  'number-neighbors': PuzzleAnswerRule(
    options: ['6', '7', '8'],
    correctAnswer: '7',
    retryText: 'Нужен сосед числа в числовом ряду.',
  ),
  'cube-groups': PuzzleAnswerRule(
    options: ['2 и 2', '3 и 1', '4 и 0'],
    correctAnswer: '2 и 2',
    retryText: 'Раздели кубики на две равные группы.',
  ),
  'more-less': PuzzleAnswerRule(
    options: ['Слева', 'Поровну', 'Справа'],
    correctAnswer: 'Слева',
    retryText: 'Сравни группы парами, где остался лишний предмет?',
  ),
  'planet-sum': PuzzleAnswerRule(
    options: ['5', '6', '7'],
    correctAnswer: '5',
    retryText: 'Сложи первую группу со второй: 3 плюс 2.',
  ),
  'sticker-shop': PuzzleAnswerRule(
    options: ['2 наклейки', '3 наклейки', '4 наклейки'],
    correctAnswer: '3 наклейки',
    retryText: 'Выбирай столько, чтобы звезд хватило без остатка.',
  ),
  'code-grid': PuzzleAnswerRule(
    options: ['Клетка A', 'Клетка B', 'Клетка C'],
    correctAnswer: 'Клетка B',
    retryText: 'Правило ведет на среднюю клетку.',
  ),
  'rocket-route': PuzzleAnswerRule(
    options: ['Вверх', 'Вперёд', 'Вниз'],
    correctAnswer: 'Вниз',
    retryText: 'После поворота ракета смотрит вниз.',
  ),
  'shape-turn': PuzzleAnswerRule(
    options: ['Влево', 'Вправо', 'Не меняется'],
    correctAnswer: 'Вправо',
    retryText: 'Представь, что фигура повернулась по часовой стрелке.',
  ),
  'silhouette-build': PuzzleAnswerRule(
    options: ['Детали 1', 'Детали 2', 'Детали 3'],
    correctAnswer: 'Детали 2',
    retryText: 'Сравни общий силуэт, а не цвет деталей.',
  ),
  'mirror-path': PuzzleAnswerRule(
    options: ['Слева', 'Справа', 'Прямо'],
    correctAnswer: 'Слева',
    retryText: 'В зеркале правый поворот становится левым.',
  ),
  'arrow-maze': PuzzleAnswerRule(
    options: ['Финиш A', 'Финиш B', 'Финиш C'],
    correctAnswer: 'Финиш C',
    retryText: 'Следуй стрелкам по очереди до последней клетки.',
  ),
  'shape-tower': PuzzleAnswerRule(
    options: ['Круг сверху', 'Квадрат сверху', 'Треугольник сверху'],
    correctAnswer: 'Треугольник сверху',
    retryText: 'Сравни башню с образцом сверху вниз.',
  ),
  'final-orbit': PuzzleAnswerRule(
    options: ['Орбита A', 'Орбита B', 'Орбита C'],
    correctAnswer: 'Орбита B',
    retryText: 'Соедини форму, стрелку и поворот в один путь.',
  ),
};

PuzzleAnswerRule _fallbackRuleForArea(String areaId) {
  return switch (areaId) {
    'memory' => _rulesByPuzzleId['memory-pairs']!,
    'attention' => _rulesByPuzzleId['odd-card']!,
    'math' => _rulesByPuzzleId['planet-sum']!,
    'space' => _rulesByPuzzleId['rocket-route']!,
    _ => _rulesByPuzzleId['logic-train']!,
  };
}
