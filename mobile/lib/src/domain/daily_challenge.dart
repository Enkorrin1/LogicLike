import 'family_profile.dart';

class DailyChallenge {
  const DailyChallenge({
    required this.id,
    required this.title,
    required this.prompt,
    required this.skill,
    required this.minutes,
  });

  final String id;
  final String title;
  final String prompt;
  final String skill;
  final int minutes;
}

List<DailyChallenge> dailyChallengesForAge(ChildAge age) {
  switch (age) {
    case ChildAge.four:
    case ChildAge.five:
      return const [
        DailyChallenge(
          id: 'shape-path',
          title: 'Дорожка фигур',
          prompt: 'Найди, какая фигура должна продолжить ряд.',
          skill: 'Внимание и закономерности',
          minutes: 4,
        ),
        DailyChallenge(
          id: 'odd-card',
          title: 'Лишняя карточка',
          prompt: 'Выбери картинку, которая отличается от остальных.',
          skill: 'Сравнение',
          minutes: 3,
        ),
      ];
    case ChildAge.six:
      return const [
        DailyChallenge(
          id: 'logic-train',
          title: 'Логический поезд',
          prompt: 'Расставь вагоны так, чтобы правило не нарушилось.',
          skill: 'Последовательности',
          minutes: 5,
        ),
        DailyChallenge(
          id: 'memory-pairs',
          title: 'Пары по памяти',
          prompt: 'Запомни карточки и найди подходящие пары.',
          skill: 'Рабочая память',
          minutes: 4,
        ),
      ];
    case ChildAge.seven:
    case ChildAge.eight:
      return const [
        DailyChallenge(
          id: 'code-grid',
          title: 'Кодовая сетка',
          prompt: 'Разгадай правило и выбери правильную клетку.',
          skill: 'Логика и дедукция',
          minutes: 6,
        ),
        DailyChallenge(
          id: 'number-bridge',
          title: 'Числовой мост',
          prompt: 'Соедини числа так, чтобы получить нужный маршрут.',
          skill: 'Математическое мышление',
          minutes: 5,
        ),
      ];
  }
}
