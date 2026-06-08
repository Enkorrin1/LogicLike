import 'family_profile.dart';

class DailyChallenge {
  const DailyChallenge({
    required this.id,
    required this.title,
    required this.prompt,
    required this.question,
    required this.skill,
    required this.minutes,
    required this.choices,
    required this.correctChoiceId,
    required this.hint,
    required this.explanation,
  });

  final String id;
  final String title;
  final String prompt;
  final String question;
  final String skill;
  final int minutes;
  final List<ChallengeChoice> choices;
  final String correctChoiceId;
  final String hint;
  final String explanation;

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

DailyChallenge dailyChallengeForDate(ChildAge age, DateTime date) {
  final challenges = dailyChallengesForAge(age);
  final day = DateTime.utc(date.year, date.month, date.day);
  final firstContentDay = DateTime.utc(2026, 1, 1);
  final daysSinceStart = day.difference(firstContentDay).inDays;

  return challenges[daysSinceStart % challenges.length];
}

List<DailyChallenge> dailyChallengesForAge(ChildAge age) {
  switch (age) {
    case ChildAge.four:
    case ChildAge.five:
      return const [
        DailyChallenge(
          id: 'shape-path',
          title: 'Дорожка фигур',
          prompt: 'Посмотри на ряд и найди, что должно идти дальше.',
          question: 'Круг, квадрат, круг, квадрат. Что дальше?',
          skill: 'Внимание и закономерности',
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
          id: 'odd-card',
          title: 'Лишняя карточка',
          prompt: 'Найди предмет, который отличается от остальных.',
          question: 'Яблоко, груша, мяч, банан. Что лишнее?',
          skill: 'Сравнение',
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
          id: 'memory-pairs',
          title: 'Пары по памяти',
          prompt: 'Вспомни пару для каждого предмета.',
          question: 'Что подходит к ключу?',
          skill: 'Рабочая память',
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
      ];
  }
}
