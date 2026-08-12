import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logicloka/src/features/challenge/game_scenes/captain_command_game.dart';
import 'package:logicloka/src/features/challenge/game_scenes/silhouette_build_game.dart';

const _locales = <String>[
  'ar',
  'de',
  'en',
  'es',
  'fr',
  'hi',
  'it',
  'ja',
  'ko',
  'pt',
  'ru',
  'zh',
];

const _captainSalute = <String, String>{
  'ar': 'أمر التحية',
  'de': 'Grußbefehl',
  'en': 'Salute command',
  'es': 'Orden de saludo',
  'fr': 'Commande salut',
  'hi': 'सलामी आदेश',
  'it': 'Comando saluto',
  'ja': '敬礼の指令',
  'ko': '경례 명령',
  'pt': 'Comando saudar',
  'ru': 'Команда честь',
  'zh': '敬礼指令',
};

const _silhouetteInstruction = <String, String>{
  'ar': 'اسحب الأجزاء الأربعة',
  'de': 'Ziehe die vier Teile',
  'en': 'Drag the four parts',
  'es': 'Arrastra las cuatro piezas',
  'fr': 'Fais glisser les quatre pièces',
  'hi': 'चारों हिस्सों को प्राणी पर खींचें',
  'it': 'Trascina i quattro pezzi',
  'ja': '4つのパーツを生き物の上へ動かします',
  'ko': '네 개의 조각을 캐릭터 위로 옮기세요',
  'pt': 'Arraste as quatro peças',
  'ru': 'Перетащите четыре детали',
  'zh': '把四个部件拖到小动物身上',
};

Widget _localizedHarness(Locale locale, Widget child) {
  return MaterialApp(
    home: Builder(
      builder: (context) => Localizations.override(
        context: context,
        locale: locale,
        child: Scaffold(body: SizedBox(width: 420, child: child)),
      ),
    ),
  );
}

void main() {
  for (final languageCode in _locales) {
    testWidgets('captain command exposes $languageCode command semantics', (
      tester,
    ) async {
      await tester.pumpWidget(
        _localizedHarness(
          Locale(languageCode),
          CaptainCommandGameView(
            accent: Colors.teal,
            compact: true,
            correctAnswer: 'answer',
            semanticLabel: 'captain',
            onAnswerSelected: (_) {},
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == _captainSalute[languageCode],
        ),
        findsOneWidget,
      );
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 500));
    });

    testWidgets('silhouette exposes $languageCode instructions', (
      tester,
    ) async {
      await tester.pumpWidget(
        _localizedHarness(
          Locale(languageCode),
          SilhouetteBuildGameView(
            accent: Colors.orange,
            compact: true,
            correctAnswer: 'answer',
            semanticLabel: 'silhouette',
            onAnswerSelected: (_) {},
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              (widget.properties.label ?? '').contains(
                _silhouetteInstruction[languageCode]!,
              ),
        ),
        findsOneWidget,
      );
    });
  }
}
