import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logicloka/src/features/challenge/game_scenes/logic_mechanics_games.dart';

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

// round, clues, exact, misplaced, submit, socket, rune
const _secretCopy = <String, List<String>>{
  'ar': [
    'الجولة',
    'دلائل الرمز',
    'مكان صحيح',
    'رقم موجود',
    'جرّب الرمز',
    'فتحة الرمز',
    'رون'
  ],
  'de': [
    'Runde',
    'Code-Hinweise',
    'Richtige Stelle',
    'Falsche Stelle',
    'Code testen',
    'Codeplatz',
    'Rune'
  ],
  'en': [
    'Round',
    'Code clues',
    'Exact place',
    'Wrong place',
    'Try code',
    'Code socket',
    'Rune'
  ],
  'es': [
    'Ronda',
    'Pistas del código',
    'Lugar exacto',
    'Otro lugar',
    'Probar código',
    'Ranura de código',
    'Runa'
  ],
  'fr': [
    'Manche',
    'Indices du code',
    'Bonne place',
    'Autre place',
    'Tester le code',
    'Emplacement du code',
    'Rune'
  ],
  'hi': [
    'दौर',
    'कोड के संकेत',
    'सही जगह',
    'दूसरी जगह',
    'कोड आज़माएँ',
    'कोड स्थान',
    'रून'
  ],
  'it': [
    'Turno',
    'Indizi del codice',
    'Posto esatto',
    'Altro posto',
    'Prova codice',
    'Alloggiamento codice',
    'Runa'
  ],
  'ja': ['ラウンド', 'コードのヒント', '正しい位置', '別の位置', 'コードを試す', 'コードの枠', 'ルーン'],
  'ko': ['라운드', '암호 단서', '정확한 자리', '다른 자리', '암호 확인', '암호 칸', '룬'],
  'pt': [
    'Rodada',
    'Pistas do código',
    'Lugar certo',
    'Outro lugar',
    'Testar código',
    'Espaço do código',
    'Runa'
  ],
  'ru': [
    'Раунд',
    'Подсказки к коду',
    'Точное место',
    'Другое место',
    'Проверить код',
    'Ячейка кода',
    'Руна'
  ],
  'zh': ['回合', '密码线索', '位置正确', '位置不同', '尝试密码', '密码槽', '符文'],
};

// value, hint, increased value, decreased value
const _moonCopy = <String, List<String>>{
  'ar': [
    'الجولة 1 من 3, الوقت المطلوب 3:00, الدقائق الحالية 37 دقيقة',
    'اسحب لأعلى أو لأسفل لتحريك عقرب الدقائق خمس دقائق، ثم انقر مرتين للتحقق',
    'بعد خمس دقائق',
    'قبل خمس دقائق'
  ],
  'de': [
    'Runde 1 von 3, Zielzeit 3:00, aktuelle Minuten 37 Minuten',
    'Nach oben oder unten wischen, um den Minutenzeiger um fünf Minuten zu bewegen, dann doppeltippen zum Prüfen',
    'Fünf Minuten später',
    'Fünf Minuten früher'
  ],
  'en': [
    'Round 1 of 3, target time 3:00, current minutes 37 minutes',
    'Swipe up or down to move the minute hand by five minutes, then double tap to check',
    'Five minutes later',
    'Five minutes earlier'
  ],
  'es': [
    'Ronda 1 de 3, hora objetivo 3:00, minutos actuales 37 minutos',
    'Desliza arriba o abajo para mover el minutero cinco minutos y toca dos veces para comprobar',
    'Cinco minutos después',
    'Cinco minutos antes'
  ],
  'fr': [
    'Manche 1 sur 3, heure cible 3:00, minutes actuelles 37 minutes',
    'Balaye vers le haut ou le bas pour déplacer l’aiguille de cinq minutes, puis touche deux fois pour vérifier',
    'Cinq minutes plus tard',
    'Cinq minutes plus tôt'
  ],
  'hi': [
    'दौर 1 में से 3, लक्ष्य समय 3:00, अभी के मिनट 37 मिनट',
    'मिनट की सुई को पाँच मिनट चलाने के लिए ऊपर या नीचे स्वाइप करें, फिर जाँचने के लिए दो बार टैप करें',
    'पाँच मिनट बाद',
    'पाँच मिनट पहले'
  ],
  'it': [
    'Turno 1 di 3, ora obiettivo 3:00, minuti attuali 37 minuti',
    'Scorri in alto o in basso per spostare la lancetta di cinque minuti, poi tocca due volte per verificare',
    'Cinque minuti dopo',
    'Cinque minuti prima'
  ],
  'ja': [
    'ラウンド 1 / 3, 目標時刻 3:00, 現在の分 37 分',
    '上下にスワイプして分針を5分動かし、ダブルタップで確認します',
    '5分後',
    '5分前'
  ],
  'ko': [
    '라운드 1 / 3, 목표 시각 3:00, 현재 분 37 분',
    '위아래로 쓸어 분침을 5분씩 움직이고 두 번 탭하여 확인하세요',
    '5분 뒤',
    '5분 전'
  ],
  'pt': [
    'Rodada 1 de 3, hora-alvo 3:00, minutos atuais 37 minutos',
    'Deslize para cima ou para baixo para mover o ponteiro cinco minutos e toque duas vezes para verificar',
    'Cinco minutos depois',
    'Cinco minutos antes'
  ],
  'ru': [
    'Раунд 1 из 3, нужное время 3:00, текущие минуты 37 минут',
    'Смахивайте вверх или вниз, чтобы двигать минутную стрелку на пять минут, затем дважды нажмите для проверки',
    'На пять минут позже',
    'На пять минут раньше'
  ],
  'zh': [
    '回合 1 / 3, 目标时间 3:00, 当前分钟 37 分钟',
    '上下滑动让分针移动五分钟，双击检查',
    '五分钟后',
    '五分钟前'
  ],
};

Widget _harness(String languageCode, Widget child) => MaterialApp(
      home: Builder(
        builder: (context) => Localizations.override(
          context: context,
          locale: Locale(languageCode),
          child: Scaffold(body: SizedBox(width: 420, child: child)),
        ),
      ),
    );

List<String> _semanticLabels(WidgetTester tester) => tester
    .widgetList<Semantics>(find.byType(Semantics))
    .map((widget) => widget.properties.label)
    .whereType<String>()
    .toList();

String _table(String source, String type) {
  final classStart = source.indexOf('class $type');
  final tableStart = source.indexOf('static const _copies', classStart);
  final tableEnd = source.indexOf('\n  };', tableStart);
  expect(classStart, isNonNegative, reason: '$type class is missing');
  expect(tableStart, isNonNegative, reason: '$type locale table is missing');
  expect(tableEnd, isNonNegative, reason: '$type locale table is incomplete');
  return source.substring(tableStart, tableEnd);
}

void main() {
  test('logic mechanics locale tables are complete valid UTF-8', () {
    final bytes = File(
      'lib/src/features/challenge/game_scenes/logic_mechanics_games.dart',
    ).readAsBytesSync();
    final source = utf8.decode(bytes, allowMalformed: false);

    final suspiciousSequences = <String>[
      String.fromCharCodes([0x00c3]),
      String.fromCharCodes([0x00c2]),
      String.fromCharCodes([0x00d0]),
      String.fromCharCodes([0x00d1]),
      String.fromCharCodes([0x00e2, 0x20ac]),
      String.fromCharCodes([0x0420, 0x00b0]),
      String.fromCharCodes([0x0428, 0x00a7]),
      String.fromCharCodes([0x0430, 0x00a4]),
      String.fromCharCodes([0x0433, 0x0453]),
      String.fromCharCodes([0x043b, 0x045c]),
      String.fromCharCode(0xfffd),
    ];
    for (final sequence in suspiciousSequences) {
      expect(source, isNot(contains(sequence)));
    }

    final secretTable = _table(source, '_SecretCodeCopy');
    final moonTable = _table(source, '_MoonClockA11y');
    for (final locale in _locales) {
      expect(RegExp("'$locale': _SecretCodeCopy\\(").allMatches(secretTable),
          hasLength(1));
      expect(RegExp("'$locale': _MoonClockA11y\\(").allMatches(moonTable),
          hasLength(1));
    }
    for (final field in [
      'round',
      'clues',
      'exact',
      'misplaced',
      'tryCode',
      'socket',
      'runeName'
    ]) {
      expect(RegExp('\\b$field:').allMatches(secretTable), hasLength(12));
    }
    for (final field in [
      'round',
      'of',
      'target',
      'current',
      'minutes',
      'hint',
      'later',
      'earlier'
    ]) {
      expect(RegExp('\\b$field:').allMatches(moonTable), hasLength(12));
    }
  });

  for (final locale in _locales) {
    testWidgets('logic mechanics exposes complete $locale semantics',
        (tester) async {
      final secret = _secretCopy[locale]!;
      await tester.pumpWidget(
        _harness(
          locale,
          SecretCodeGameView(
            accent: Colors.teal,
            compact: true,
            correctAnswer: 'answer',
            semanticLabel: 'secret-code',
            onAnswerSelected: (_) {},
          ),
        ),
      );

      expect(find.text('${secret[0]} 1/3'), findsOneWidget);
      final secretLabels = _semanticLabels(tester);
      expect(secretLabels, contains(secret[1]));
      expect(secretLabels.any((label) => label.startsWith('${secret[2]}:')),
          isTrue);
      expect(secretLabels.any((label) => label.startsWith('${secret[3]}:')),
          isTrue);
      expect(secretLabels, contains(secret[4]));
      expect(secretLabels, contains('${secret[5]} 1'));
      expect(secretLabels, contains('${secret[6]} 3'));

      final moon = _moonCopy[locale]!;
      await tester.pumpWidget(
        _harness(
          locale,
          MoonClockGameView(
            accent: Colors.indigo,
            compact: true,
            correctAnswer: 'answer',
            semanticLabel: 'moon-clock',
            onAnswerSelected: (_) {},
          ),
        ),
      );

      final semantics = tester.widget<Semantics>(
        find.byKey(const ValueKey('moon-clock-semantics')),
      );
      expect(semantics.properties.value, moon[0]);
      expect(semantics.properties.hint, moon[1]);
      expect(semantics.properties.increasedValue, moon[2]);
      expect(semantics.properties.decreasedValue, moon[3]);
      expect(
          Directionality.of(
              tester.element(find.byKey(const ValueKey('moon-clock-face')))),
          locale == 'ar' ? TextDirection.rtl : TextDirection.ltr);
    });
  }
}
