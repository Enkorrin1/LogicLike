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
  'code-lock': PuzzleAnswerRule(
    options: ['246', '248', '268'],
    correctAnswer: '248',
    retryText:
        'Код 248: первая цифра 2, середина на 2 больше, последняя вдвое больше средней.',
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
  'bridge-order': PuzzleAnswerRule(
    options: ['A', 'B', 'C'],
    correctAnswer: 'B',
    retryText: 'Доски растут по длине, поэтому нужна средняя доска B.',
  ),
  'mini-sudoku': PuzzleAnswerRule(
    options: ['shape_star', 'shape_moon', 'shape_rocket'],
    correctAnswer: 'shape_rocket',
    retryText:
        'В строке уже есть звезда и луна, а в столбце не хватает ракеты.',
  ),
  'logic-houses': PuzzleAnswerRule(
    options: ['house_blue', 'house_green', 'house_yellow'],
    correctAnswer: 'house_green',
    retryText:
        'Звезда не в синем доме и стоит правее желтого, значит она в зеленом.',
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
  'camp-story': PuzzleAnswerRule(
    options: ['Костер', 'Палатка', 'Подушка'],
    correctAnswer: 'Костер',
    retryText: 'В истории герои радовались теплому костру в лагере.',
  ),
  'story-order': PuzzleAnswerRule(
    options: ['1-2-3', '2-1-3', '3-1-2'],
    correctAnswer: '1-2-3',
    retryText: 'Сначала карта, потом полет, затем найденная звезда.',
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
  'word-grid': PuzzleAnswerRule(
    options: ['STAR', 'MARCH', 'ARM'],
    correctAnswer: 'STAR',
    retryText: 'Слово STAR читается слева направо в нижней части сетки.',
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
  'animal-word': PuzzleAnswerRule(
    options: ['DOG', 'CAT', 'FOX'],
    correctAnswer: 'DOG',
    retryText: 'На полянке уже видны буквы D и O, им нужна буква G.',
  ),
  'balloon-order': PuzzleAnswerRule(
    options: ['1', '2', '3'],
    correctAnswer: '1',
    retryText: 'После сортировки по числам первым будет шарик с 1.',
  ),
  'word-builder': PuzzleAnswerRule(
    options: ['word_star', 'word_moon', 'word_sun'],
    correctAnswer: 'word_star',
    retryText:
        'Используй буквы большой карточки, чтобы собрать слово “звезда”.',
  ),
  'letter-field': PuzzleAnswerRule(
    options: ['word_star', 'word_moon', 'word_sun'],
    correctAnswer: 'word_moon',
    retryText: 'Слово “луна” спрятано одной непрерывной дорожкой.',
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
  'camp-differences': PuzzleAnswerRule(
    options: ['1', '2', '3'],
    correctAnswer: '2',
    retryText: 'Отличаются флажок на палатке и маленькая звезда возле костра.',
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
  'fruit-fizz': PuzzleAnswerRule(
    options: ['1', '2', '3'],
    correctAnswer: '3',
    retryText: 'В рецепте уже есть 3 лайма и 2 ягоды: до 8 не хватает 3.',
  ),
  'moon-clock': PuzzleAnswerRule(
    options: ['3:00', '6:00', '12:15'],
    correctAnswer: '3:00',
    retryText: 'Минутная стрелка смотрит на 12, часовая — на 3.',
  ),
  'notebook-sum': PuzzleAnswerRule(
    options: ['25', '35', '45'],
    correctAnswer: '35',
    retryText: '15 плюс 20 равно 35: десятки складываются отдельно.',
  ),
  'cookie-share': PuzzleAnswerRule(
    options: ['1', '2', '3'],
    correctAnswer: '2',
    retryText: 'Шесть печений делятся на трех друзей: каждому достанется 2.',
  ),
  'math-crossword': PuzzleAnswerRule(
    options: ['7', '8', '9'],
    correctAnswer: '8',
    retryText: 'В пересечении стоит 8: 3 + 5 = 8 и 8 - 2 = 6.',
  ),
  'sticker-shop': PuzzleAnswerRule(
    options: ['2 наклейки', '3 наклейки', '4 наклейки'],
    correctAnswer: '3 наклейки',
    retryText: 'Выбирай столько, чтобы звезд хватило без остатка.',
  ),
  'market-change': PuzzleAnswerRule(
    options: ['1', '2', '3'],
    correctAnswer: '2',
    retryText: 'У героя 5 звезд, ракета стоит 3, значит останется 2.',
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
  'route-maze': PuzzleAnswerRule(
    options: ['path_A', 'path_B', 'path_C'],
    correctAnswer: 'path_B',
    retryText: 'Путь B ведет вправо, вверх и снова вправо прямо к звезде.',
  ),
  'shape-tower': PuzzleAnswerRule(
    options: ['Круг сверху', 'Квадрат сверху', 'Треугольник сверху'],
    correctAnswer: 'Треугольник сверху',
    retryText: 'Сравни башню с образцом сверху вниз.',
  ),
  'picture-puzzle': PuzzleAnswerRule(
    options: ['A', 'B', 'C'],
    correctAnswer: 'B',
    retryText: 'Кусочек B закрывает середину ракеты и совпадает с линиями.',
  ),
  'shape-tangram': PuzzleAnswerRule(
    options: ['piece_triangle', 'piece_square', 'piece_circle'],
    correctAnswer: 'piece_triangle',
    retryText:
        'Нос ракеты собирается из треугольника, а не из круга или квадрата.',
  ),
  'final-orbit': PuzzleAnswerRule(
    options: ['Орбита A', 'Орбита B', 'Орбита C'],
    correctAnswer: 'Орбита B',
    retryText: 'Соедини форму, стрелку и поворот в один путь.',
  ),
  'constellation-route': PuzzleAnswerRule(
    options: ['A', 'B', 'C'],
    correctAnswer: 'B',
    retryText: 'Сияющая линия заканчивается у звезды B.',
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
