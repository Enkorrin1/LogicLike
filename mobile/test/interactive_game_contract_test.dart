import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logicloka/src/features/challenge/game_scenes/deduction_games.dart';
import 'package:logicloka/src/features/challenge/game_scenes/deduction_board_games.dart';
import 'package:logicloka/src/features/challenge/game_scenes/letter_field_game.dart';
import 'package:logicloka/src/features/challenge/game_scenes/logic_mechanics_games.dart';
import 'package:logicloka/src/features/challenge/game_scenes/math_reasoning_games.dart';
import 'package:logicloka/src/features/challenge/game_scenes/math_workshop_games.dart';
import 'package:logicloka/src/features/challenge/game_scenes/sequence_workshop_games.dart';
import 'package:logicloka/src/features/challenge/game_scenes/word_builder_game.dart';

typedef _GameBuilder = Widget Function(ValueChanged<String> onAnswerSelected);
typedef _SizedGameBuilder = Widget Function(
  bool compact,
  ValueChanged<String> onAnswerSelected,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpGame(
    WidgetTester tester,
    Widget game, {
    Locale locale = const Locale('ru'),
  }) async {
    await tester.binding.setSurfaceSize(const Size(500, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        locale: locale,
        supportedLocales: const <Locale>[
          Locale('ar'),
          Locale('ru'),
        ],
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: game,
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
  }

  group('localized game scenes', () {
    for (final locale in const <Locale>[Locale('ru'), Locale('ar')]) {
      testWidgets(
        'word builder renders in ${locale.languageCode} without completing',
        (tester) async {
          final answers = <String>[];
          await pumpGame(
            tester,
            LocaleWordBuilderGameView(
              accent: const Color(0xFF28B8A9),
              compact: true,
              correctAnswer: 'word-answer',
              semanticLabel: 'word builder',
              onAnswerSelected: answers.add,
            ),
            locale: locale,
          );

          expect(find.byType(LocaleWordBuilderGameView), findsOneWidget);
          expect(answers, isEmpty);
          expect(tester.takeException(), isNull);
        },
      );

      testWidgets(
        'letter field renders in ${locale.languageCode} without completing',
        (tester) async {
          final answers = <String>[];
          await pumpGame(
            tester,
            LocaleLetterFieldGameView(
              accent: const Color(0xFF7B67E8),
              compact: true,
              correctAnswer: 'field-answer',
              semanticLabel: 'letter field',
              onAnswerSelected: answers.add,
            ),
            locale: locale,
          );

          expect(find.byType(LocaleLetterFieldGameView), findsOneWidget);
          expect(answers, isEmpty);
          expect(tester.takeException(), isNull);
        },
      );
    }
  });

  final contractGames = <String, _GameBuilder>{
    'number bridge': (callback) => NumberBridgeReasoningGameView(
          accent: const Color(0xFF28B8A9),
          compact: true,
          correctAnswer: 'bridge-answer',
          semanticLabel: 'number bridge',
          onAnswerSelected: callback,
        ),
    'star balance': (callback) => StarBalanceReasoningGameView(
          accent: const Color(0xFFFFB84D),
          compact: true,
          correctAnswer: 'balance-answer',
          semanticLabel: 'star balance',
          onAnswerSelected: callback,
        ),
    'number neighbors': (callback) => NumberNeighborsReasoningGameView(
          accent: const Color(0xFF7B67E8),
          compact: true,
          correctAnswer: 'neighbors-answer',
          semanticLabel: 'number neighbors',
          onAnswerSelected: callback,
        ),
    'bridge order': (callback) => BridgeOrderGameView(
          accent: const Color(0xFF28B8A9),
          compact: true,
          correctAnswer: 'order-answer',
          semanticLabel: 'bridge order',
          onAnswerSelected: callback,
        ),
    'tower rule': (callback) => TowerRuleGameView(
          accent: const Color(0xFFFF6F75),
          compact: true,
          correctAnswer: 'tower-answer',
          semanticLabel: 'tower rule',
          onAnswerSelected: callback,
        ),
    'home clues': (callback) => HomeCluesGameView(
          accent: const Color(0xFF58BCE8),
          compact: false,
          correctAnswer: 'home-answer',
          semanticLabel: 'home clues',
          onAnswerSelected: callback,
        ),
    'odd step': (callback) => OddStepGameView(
          accent: const Color(0xFFFF6F75),
          compact: true,
          correctAnswer: 'step-answer',
          semanticLabel: 'odd step',
          onAnswerSelected: callback,
        ),
    'secret code': (callback) => SecretCodeGameView(
          accent: const Color(0xFF7B67E8),
          compact: true,
          correctAnswer: 'code-answer',
          semanticLabel: 'secret code',
          onAnswerSelected: callback,
        ),
    'moon clock': (callback) => MoonClockGameView(
          accent: const Color(0xFF58BCE8),
          compact: true,
          correctAnswer: 'clock-answer',
          semanticLabel: 'moon clock',
          onAnswerSelected: callback,
        ),
  };

  group('interactive game contract', () {
    for (final entry in contractGames.entries) {
      testWidgets('${entry.key} renders and waits for a solution', (
        tester,
      ) async {
        final answers = <String>[];
        final game = entry.value(answers.add);

        await pumpGame(tester, game);

        expect(find.byWidget(game), findsOneWidget);
        expect(answers, isEmpty);
        expect(tester.takeException(), isNull);
      });
    }
  });

  final workshopGames = <String, _SizedGameBuilder>{
    'mini sudoku': (compact, callback) => MiniSudokuBoardGameView(
          accent: const Color(0xFF7B67E8),
          compact: compact,
          correctAnswer: 'sudoku-answer',
          semanticLabel: 'mini sudoku',
          onAnswerSelected: callback,
        ),
    'logic houses': (compact, callback) => LogicHousesDeductionGameView(
          accent: const Color(0xFF28B8A9),
          compact: compact,
          correctAnswer: 'houses-answer',
          semanticLabel: 'logic houses',
          onAnswerSelected: callback,
        ),
    'notebook sum': (compact, callback) => NotebookSumWorkshopGameView(
          accent: const Color(0xFFFFB84D),
          compact: compact,
          correctAnswer: 'sum-answer',
          semanticLabel: 'notebook sum',
          onAnswerSelected: callback,
        ),
    'math crossword': (compact, callback) => MathCrosswordWorkshopGameView(
          accent: const Color(0xFF58BCE8),
          compact: compact,
          correctAnswer: 'crossword-answer',
          semanticLabel: 'math crossword',
          onAnswerSelected: callback,
        ),
    'market change': (compact, callback) => MarketChangeWorkshopGameView(
          accent: const Color(0xFFFF6F75),
          compact: compact,
          correctAnswer: 'change-answer',
          semanticLabel: 'market change',
          onAnswerSelected: callback,
        ),
    'odd card investigation': (compact, callback) =>
        OddCardInvestigationGameView(
          accent: const Color(0xFFFF6F75),
          compact: compact,
          correctAnswer: 'odd-card-answer',
          semanticLabel: 'odd card investigation',
          onAnswerSelected: callback,
        ),
    'pattern train workshop': (compact, callback) =>
        PatternTrainWorkshopGameView(
          accent: const Color(0xFF28B8A9),
          compact: compact,
          correctAnswer: 'train-answer',
          semanticLabel: 'pattern train workshop',
          onAnswerSelected: callback,
          variant: PatternWorkshopVariant.train,
        ),
    'pattern path workshop': (compact, callback) =>
        PatternTrainWorkshopGameView(
          accent: const Color(0xFF7B67E8),
          compact: compact,
          correctAnswer: 'path-answer',
          semanticLabel: 'pattern path workshop',
          onAnswerSelected: callback,
          variant: PatternWorkshopVariant.path,
        ),
    'rocket assembly workshop': (compact, callback) =>
        RocketAssemblyWorkshopGameView(
          accent: const Color(0xFF58BCE8),
          compact: compact,
          correctAnswer: 'rocket-answer',
          semanticLabel: 'rocket assembly workshop',
          onAnswerSelected: callback,
        ),
  };

  group('workshop game contract', () {
    for (final entry in workshopGames.entries) {
      for (final compact in const <bool>[true, false]) {
        testWidgets(
          '${entry.key} renders in ${compact ? 'compact' : 'full'} mode '
          'and waits for a solution',
          (tester) async {
            final answers = <String>[];
            final game = entry.value(compact, answers.add);

            await pumpGame(tester, game);

            expect(find.byWidget(game), findsOneWidget);
            expect(answers, isEmpty);
            expect(tester.takeException(), isNull);
          },
        );
      }
    }
  });
}
