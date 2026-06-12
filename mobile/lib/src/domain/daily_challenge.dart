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
  final puzzles =
      puzzleAreasForAge(age).expand((area) => area.puzzles).toList();
  return puzzles.take(3).toList(growable: false);
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
          prompt: 'Круг, квадрат, круг, квадрат. Что дальше?',
          skill: 'Закономерности',
          minutes: 4,
          areaId: 'logic',
        ),
      ],
    ),
    BrainArea(
      id: 'memory',
      title: 'Память',
      subtitle: 'Запоминание и пары',
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
      ],
    ),
    BrainArea(
      id: 'attention',
      title: 'Внимание',
      subtitle: 'Фокус и поиск отличий',
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
      ],
    ),
    BrainArea(
      id: 'math',
      title: 'Счет',
      subtitle: 'Числа и аккуратные решения',
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
      ],
    ),
  ];
}
