import 'family_profile.dart';

class LearningPuzzle {
  const LearningPuzzle({
    required this.id,
    required this.title,
    required this.prompt,
    required this.skill,
    required this.minutes,
    required this.areaId,
  });

  final String id;
  final String title;
  final String prompt;
  final String skill;
  final int minutes;
  final String areaId;
}

class BrainArea {
  const BrainArea({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.puzzles,
  });

  final String id;
  final String title;
  final String subtitle;
  final List<LearningPuzzle> puzzles;
}

typedef DailyChallenge = LearningPuzzle;

List<DailyChallenge> dailyChallengesForAge(ChildAge age) {
  final areas = puzzleAreasForAge(age);
  final dayOffset = DateTime.now().day - 1;

  return [
    _dailyFromArea(areas, 'logic', dayOffset),
    _dailyFromArea(areas, 'memory', dayOffset + 2),
    _dailyFromArea(areas, 'attention', dayOffset + 4),
  ];
}

LearningPuzzle _dailyFromArea(List<BrainArea> areas, String id, int offset) {
  final area = areas.firstWhere((area) => area.id == id);
  return area.puzzles[offset % area.puzzles.length];
}

List<BrainArea> puzzleAreasForAge(ChildAge age) {
  return const [
    BrainArea(
      id: 'logic',
      title: 'Логика',
      subtitle: 'Правила, выводы и цепочки',
      puzzles: [
        LearningPuzzle(
          id: 'logic-train',
          title: 'Логический поезд',
          prompt: 'Расставь вагоны так, чтобы правило не нарушилось.',
          skill: 'Последовательности',
          minutes: 5,
          areaId: 'logic',
        ),
        LearningPuzzle(
          id: 'shape-path',
          title: 'Дорожка фигур',
          prompt: 'Круг, квадрат, круг, квадрат. Что должно идти дальше?',
          skill: 'Закономерности',
          minutes: 4,
          areaId: 'logic',
        ),
        LearningPuzzle(
          id: 'tower-rule',
          title: 'Правило башен',
          prompt: 'Найди, какая башня построена по тому же правилу.',
          skill: 'Сравнение правил',
          minutes: 5,
          areaId: 'logic',
        ),
        LearningPuzzle(
          id: 'home-clues',
          title: 'Кто где живет',
          prompt: 'Используй подсказки и найди домик для каждого героя.',
          skill: 'Вывод по условиям',
          minutes: 6,
          areaId: 'logic',
        ),
        LearningPuzzle(
          id: 'odd-step',
          title: 'Лишний ход',
          prompt: 'Выбери шаг, который ломает всю цепочку действий.',
          skill: 'Причина и следствие',
          minutes: 4,
          areaId: 'logic',
        ),
        LearningPuzzle(
          id: 'secret-code',
          title: 'Секретный код',
          prompt: 'Разгадай правило кода и выбери недостающий знак.',
          skill: 'Логический код',
          minutes: 5,
          areaId: 'logic',
        ),
        LearningPuzzle(
          id: 'why-chain',
          title: 'Цепочка причин',
          prompt: 'Собери события в правильном порядке от причины к ответу.',
          skill: 'Рассуждение',
          minutes: 6,
          areaId: 'logic',
        ),
        LearningPuzzle(
          id: 'space-proof',
          title: 'Космический вывод',
          prompt: 'По двум подсказкам выбери единственный правильный ответ.',
          skill: 'Дедукция',
          minutes: 6,
          areaId: 'logic',
        ),
      ],
    ),
    BrainArea(
      id: 'memory',
      title: 'Память',
      subtitle: 'Карточки, порядок и повторение',
      puzzles: [
        LearningPuzzle(
          id: 'memory-pairs',
          title: 'Пары по памяти',
          prompt: 'Запомни карточки и найди подходящие пары.',
          skill: 'Рабочая память',
          minutes: 4,
          areaId: 'memory',
        ),
        LearningPuzzle(
          id: 'sound-order',
          title: 'Эхо робота',
          prompt: 'Повтори порядок сигналов без ошибки.',
          skill: 'Слуховая память',
          minutes: 3,
          areaId: 'memory',
        ),
        LearningPuzzle(
          id: 'route-memory',
          title: 'Запомни маршрут',
          prompt: 'Посмотри на путь героя и повтори его по памяти.',
          skill: 'Зрительная память',
          minutes: 5,
          areaId: 'memory',
        ),
        LearningPuzzle(
          id: 'hidden-cards',
          title: 'Секретные карточки',
          prompt: 'Запомни, где лежали предметы, пока они не исчезли.',
          skill: 'Память мест',
          minutes: 4,
          areaId: 'memory',
        ),
        LearningPuzzle(
          id: 'color-rhythm',
          title: 'Цветовой ритм',
          prompt: 'Повтори ряд цветов в том же порядке.',
          skill: 'Последовательная память',
          minutes: 4,
          areaId: 'memory',
        ),
        LearningPuzzle(
          id: 'what-changed',
          title: 'Что изменилось',
          prompt: 'Запомни картинку и найди, что стало другим.',
          skill: 'Сравнение по памяти',
          minutes: 5,
          areaId: 'memory',
        ),
        LearningPuzzle(
          id: 'star-list',
          title: 'Звездный список',
          prompt: 'Запомни предметы и выбери их среди новых карточек.',
          skill: 'Объем памяти',
          minutes: 5,
          areaId: 'memory',
        ),
        LearningPuzzle(
          id: 'captain-command',
          title: 'Команда капитана',
          prompt: 'Запомни три команды и выполни их в правильном порядке.',
          skill: 'Инструкция по памяти',
          minutes: 6,
          areaId: 'memory',
        ),
      ],
    ),
    BrainArea(
      id: 'attention',
      title: 'Внимание',
      subtitle: 'Фокус, детали и отличия',
      puzzles: [
        LearningPuzzle(
          id: 'odd-card',
          title: 'Лишняя карточка',
          prompt: 'Выбери картинку, которая отличается от остальных.',
          skill: 'Сравнение',
          minutes: 3,
          areaId: 'attention',
        ),
        LearningPuzzle(
          id: 'tiny-detail',
          title: 'Маленькая деталь',
          prompt: 'Найди предмет, который спрятался среди похожих.',
          skill: 'Зрительное внимание',
          minutes: 4,
          areaId: 'attention',
        ),
        LearningPuzzle(
          id: 'shadow-match',
          title: 'Найди тень',
          prompt: 'Подбери тень, которая точно подходит герою.',
          skill: 'Точное сравнение',
          minutes: 4,
          areaId: 'attention',
        ),
        LearningPuzzle(
          id: 'fast-eyes',
          title: 'Быстрые глаза',
          prompt: 'Найди все одинаковые знаки до конца времени.',
          skill: 'Скорость внимания',
          minutes: 3,
          areaId: 'attention',
        ),
        LearningPuzzle(
          id: 'hidden-star',
          title: 'Спрятанная звезда',
          prompt: 'Отыщи звезду среди планет, облаков и ракет.',
          skill: 'Поиск объекта',
          minutes: 4,
          areaId: 'attention',
        ),
        LearningPuzzle(
          id: 'two-differences',
          title: 'Два отличия',
          prompt: 'Сравни две картинки и найди два отличия.',
          skill: 'Устойчивость внимания',
          minutes: 5,
          areaId: 'attention',
        ),
        LearningPuzzle(
          id: 'clean-row',
          title: 'Чистый ряд',
          prompt: 'Убери предметы, которые не подходят к правилу ряда.',
          skill: 'Избирательность',
          minutes: 4,
          areaId: 'attention',
        ),
        LearningPuzzle(
          id: 'beacon-signal',
          title: 'Сигнал маяка',
          prompt: 'Следи за сигналом и нажми только в нужный момент.',
          skill: 'Контроль импульса',
          minutes: 5,
          areaId: 'attention',
        ),
      ],
    ),
    BrainArea(
      id: 'math',
      title: 'Счет',
      subtitle: 'Числа, сравнение и равенство',
      puzzles: [
        LearningPuzzle(
          id: 'number-bridge',
          title: 'Числовой мост',
          prompt: 'Соедини числа так, чтобы получить нужный маршрут.',
          skill: 'Математическое мышление',
          minutes: 5,
          areaId: 'math',
        ),
        LearningPuzzle(
          id: 'star-balance',
          title: 'Весы со звездами',
          prompt: 'Подбери число, чтобы весы стали ровными.',
          skill: 'Счет и равенство',
          minutes: 4,
          areaId: 'math',
        ),
        LearningPuzzle(
          id: 'count-rockets',
          title: 'Сколько ракет',
          prompt: 'Посчитай ракеты и выбери правильное число.',
          skill: 'Счет предметов',
          minutes: 3,
          areaId: 'math',
        ),
        LearningPuzzle(
          id: 'number-neighbors',
          title: 'Соседи числа',
          prompt: 'Найди число, которое стоит до или после указанного.',
          skill: 'Числовой ряд',
          minutes: 4,
          areaId: 'math',
        ),
        LearningPuzzle(
          id: 'cube-groups',
          title: 'Разложи кубики',
          prompt: 'Раздели кубики на группы так, чтобы их стало поровну.',
          skill: 'Группировка',
          minutes: 5,
          areaId: 'math',
        ),
        LearningPuzzle(
          id: 'more-less',
          title: 'Больше или меньше',
          prompt: 'Сравни две группы и выбери, где предметов больше.',
          skill: 'Сравнение количеств',
          minutes: 3,
          areaId: 'math',
        ),
        LearningPuzzle(
          id: 'planet-sum',
          title: 'Сумма планет',
          prompt: 'Сложи две группы планет и найди общий ответ.',
          skill: 'Сложение',
          minutes: 5,
          areaId: 'math',
        ),
        LearningPuzzle(
          id: 'sticker-shop',
          title: 'Магазин наклеек',
          prompt: 'Выбери наклейки так, чтобы хватило всех звезд.',
          skill: 'Практический счет',
          minutes: 6,
          areaId: 'math',
        ),
      ],
    ),
    BrainArea(
      id: 'space',
      title: 'Фигуры',
      subtitle: 'Форма, поворот и маршрут',
      puzzles: [
        LearningPuzzle(
          id: 'code-grid',
          title: 'Кодовая сетка',
          prompt: 'Разгадай правило и выбери правильную клетку.',
          skill: 'Пространственная логика',
          minutes: 6,
          areaId: 'space',
        ),
        LearningPuzzle(
          id: 'rocket-route',
          title: 'Маршрут ракеты',
          prompt: 'Поверни путь так, чтобы ракета долетела до звезды.',
          skill: 'Ориентация',
          minutes: 5,
          areaId: 'space',
        ),
        LearningPuzzle(
          id: 'shape-turn',
          title: 'Поворот фигур',
          prompt: 'Представь, как фигура повернется, и выбери ответ.',
          skill: 'Мысленный поворот',
          minutes: 5,
          areaId: 'space',
        ),
        LearningPuzzle(
          id: 'silhouette-build',
          title: 'Собери силуэт',
          prompt: 'Выбери детали, из которых получится нужная тень.',
          skill: 'Составление формы',
          minutes: 6,
          areaId: 'space',
        ),
        LearningPuzzle(
          id: 'mirror-path',
          title: 'Зеркальный путь',
          prompt: 'Отрази маршрут как в зеркале и найди конец пути.',
          skill: 'Зеркальное мышление',
          minutes: 5,
          areaId: 'space',
        ),
        LearningPuzzle(
          id: 'arrow-maze',
          title: 'Лабиринт стрелок',
          prompt: 'Следуй стрелкам и найди, куда придет герой.',
          skill: 'Навигация',
          minutes: 5,
          areaId: 'space',
        ),
        LearningPuzzle(
          id: 'shape-tower',
          title: 'Башня форм',
          prompt: 'Поставь формы так, чтобы башня совпала с образцом.',
          skill: 'Конструирование',
          minutes: 6,
          areaId: 'space',
        ),
        LearningPuzzle(
          id: 'final-orbit',
          title: 'Финальная орбита',
          prompt: 'Соедини фигуры, стрелки и повороты в один маршрут.',
          skill: 'Комбинирование',
          minutes: 7,
          areaId: 'space',
        ),
      ],
    ),
  ];
}
