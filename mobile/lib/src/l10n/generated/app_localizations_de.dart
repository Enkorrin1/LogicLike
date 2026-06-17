// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'LogicLike';

  @override
  String get homeTab => 'Heim';

  @override
  String get challengeTab => 'Suche';

  @override
  String get parentTab => 'Elternteil';

  @override
  String homeGreeting(Object childName) {
    return 'Hallo,\n$childName';
  }

  @override
  String get dailyStreakTitle => 'Täglicher Streak';

  @override
  String get streakStart => 'Start!';

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tage',
      one: '$count Tag',
    );
    return '$_temp0';
  }

  @override
  String dayCountShort(Object count) {
    return '$count T';
  }

  @override
  String get missionOpenButton => 'Offen';

  @override
  String get missionStartShortButton => 'Start';

  @override
  String get missionStartButton => 'Quest starten';

  @override
  String get homeMissionCompletedTitle => 'Mission\nkomplett!';

  @override
  String get homeMissionHelpTitle =>
      'Helfen Sie dem Astronauten\nSammle Sterne!';

  @override
  String get dailyChallengeTag => 'Tägliche Quest';

  @override
  String get myProgressTitle => 'Mein Fortschritt';

  @override
  String levelLabel(Object level) {
    return 'Level $level';
  }

  @override
  String get myCollectionTitle => 'Meine Sammlung';

  @override
  String stickerCountLabel(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sticker',
      one: 'Sticker',
    );
    return '$_temp0';
  }

  @override
  String homeParentHint(Object ageLabel, Object goalLabel, num minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes Min. diese Woche',
      one: '$minutes Min. diese Woche',
    );
    return '$ageLabel ? $goalLabel ? $_temp0';
  }

  @override
  String ageYears(num years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years Jahre',
      one: '$years Jahr',
    );
    return '$_temp0';
  }

  @override
  String get goalLogicLabel => 'Logik';

  @override
  String get goalLogicDescription =>
      'Muster, Argumentation und Finden von Regeln.';

  @override
  String get goalMathLabel => 'Mathe';

  @override
  String get goalMathDescription => 'Zahlen, Zählen und sorgfältige Lösungen.';

  @override
  String get goalAttentionLabel => 'Fokus';

  @override
  String get goalAttentionDescription =>
      'Aufmerksamkeit, Gedächtnis und Vergleich von Details.';

  @override
  String get onboardingTitle => 'Richten Sie LogicLike ein';

  @override
  String get onboardingSubtitle =>
      'Erstellen Sie ein Familienprofil, damit die täglichen Aufgaben dem Alter und den Zielen des Kindes entsprechen.';

  @override
  String get childNameLabel => 'Name des Kindes';

  @override
  String get childNameError => 'Geben Sie einen Namen ein';

  @override
  String get ageSectionTitle => 'Alter';

  @override
  String get learningGoalSectionTitle => 'Lernziel';

  @override
  String get learningGoalShortTitle => 'Ziel';

  @override
  String get startButton => 'Start';

  @override
  String get savingButton => 'Sparen';

  @override
  String get onboardingHeroTitle => 'Erstflug bereit';

  @override
  String get parentTag => 'Elternteil';

  @override
  String get parentDashboardTitle => 'Familienzentrum';

  @override
  String familyProfileSummary(
      Object ageLabel, Object childName, Object goalLabel) {
    return '$childName ? $ageLabel ? $goalLabel';
  }

  @override
  String get currentStreakMetric => 'Strähne';

  @override
  String get sessionsMetric => 'Sitzungen';

  @override
  String get minutesMetric => 'Minuten';

  @override
  String get childrenProfilesTitle => 'Kinderprofile';

  @override
  String get addChildButton => 'Kind hinzufügen';

  @override
  String childProgressChallengeCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Aufgaben',
      one: '$count Aufgabe',
    );
    return '$_temp0';
  }

  @override
  String ageGoalSummary(Object ageLabel, Object goalLabel) {
    return '$ageLabel ? $goalLabel';
  }

  @override
  String get newChildTitle => 'Neues Kind';

  @override
  String get cancelButton => 'Stornieren';

  @override
  String get addButton => 'Hinzufügen';

  @override
  String get analyticsTitle => 'Üben Sie Analytik';

  @override
  String get streakMetricLabel => 'Strähne';

  @override
  String get bestStreakLabel => 'Am besten';

  @override
  String get last7DaysLabel => 'Letzte 7 Tage';

  @override
  String get weeklyMinutesLabel => 'Minuten';

  @override
  String sessionsCountShort(Object count) {
    return '$count Sitz.';
  }

  @override
  String minutesShort(Object count) {
    return '$count Min.';
  }

  @override
  String minutesNarrow(Object count) {
    return '$count m';
  }

  @override
  String get lastSkillLabel => 'Letzte Fähigkeit';

  @override
  String get lastSessionLabel => 'Letzte Sitzung';

  @override
  String get notAvailable => 'Noch nicht';

  @override
  String get weeklyRhythmTitle => 'Wochenrhythmus';

  @override
  String get weeklyRhythmSubtitle => 'Übe Tage und Minuten für jeden Tag.';

  @override
  String get subscriptionTitle => 'Familienabonnement';

  @override
  String get currentPlanLabel => 'Aktueller Plan';

  @override
  String get familySeatsLabel => 'Familiensitze';

  @override
  String get updatedLabel => 'Aktualisiert';

  @override
  String get recommendedLabel => 'Bester Wert';

  @override
  String get currentPlanButton => 'Aktueller Plan';

  @override
  String get chooseButton => 'Wählen';

  @override
  String get resetProfilePanel =>
      'Setzen Sie das lokale Profil zurück und führen Sie das Setup erneut aus';

  @override
  String get resetButton => 'Zurücksetzen';

  @override
  String get resetDialogTitle => 'Profil zurücksetzen?';

  @override
  String get resetDialogBody =>
      'Das Onboarding wird wieder geöffnet und der lokale Fortschritt wird gelöscht.';

  @override
  String get resetConfirmButton => 'Zurücksetzen';

  @override
  String get limitPaidMessage => 'Alle Familiensitze sind bereits belegt.';

  @override
  String get limitStarterMessage =>
      'Weitere Profile sind im Familienplan verfügbar.';

  @override
  String get planStarterLabel => 'Anlasser';

  @override
  String get planStarterPrice => '0 ₽';

  @override
  String get planStarterCapacity => '1 Kinderprofil';

  @override
  String get planStarterDescription =>
      'Kurze Tagesrunde und lokaler Fortschritt.';

  @override
  String get planMonthlyLabel => 'Familie monatlich';

  @override
  String get planMonthlyPrice => '399 ₽/Monat';

  @override
  String get planFamilyCapacity => 'bis zu 3 Kinderprofile';

  @override
  String get planMonthlyDescription =>
      'Voller Zugriff, Familienprofile und Elternanalysen.';

  @override
  String get planAnnualLabel => 'Familienjahrbuch';

  @override
  String get planAnnualPrice => '2990 ₽/Jahr';

  @override
  String get planAnnualDescription =>
      'Gleicher Zugang, mit besserem Preis-Leistungs-Verhältnis bei jährlicher Abrechnung.';

  @override
  String get planActiveStatus => 'Aktiv';

  @override
  String get planInactiveStatus => 'Nicht aktiv';

  @override
  String get missionCompletedTitle => 'Mission abgeschlossen!';

  @override
  String childGoCta(Object childName) {
    return '$childName, los geht\'s!';
  }

  @override
  String get chooseAnswerTitle => 'Wählen Sie eine Antwort';

  @override
  String get checkingButton => 'Sparen';

  @override
  String get checkAnswerButton => 'Überprüfen';

  @override
  String answerCorrect(Object explanation) {
    return 'Richtig! $explanation';
  }

  @override
  String answerAlmost(Object hint) {
    return 'Fast. $hint';
  }

  @override
  String get challengeCompletedToday => 'Die heutige Quest ist abgeschlossen';

  @override
  String get weekdayMondayShort => 'Mo';

  @override
  String get weekdayTuesdayShort => 'Di';

  @override
  String get weekdayWednesdayShort => 'Heiraten';

  @override
  String get weekdayThursdayShort => 'Do';

  @override
  String get weekdayFridayShort => 'Fr';

  @override
  String get weekdaySaturdayShort => 'Sa';

  @override
  String get weekdaySundayShort => 'Sonne';

  @override
  String get skillPatterns => 'Muster';

  @override
  String get skillCountingToFive => 'Bis fünf zählen';

  @override
  String get skillComparison => 'Vergleich';

  @override
  String get skillSequences => 'Sequenzen';

  @override
  String get skillAdditionToTen => 'Ergänzung zu zehn';

  @override
  String get skillWorkingMemory => 'Arbeitsgedächtnis';

  @override
  String get skillLogicDeduction => 'Logik und Deduktion';

  @override
  String get skillMathThinking => 'Mathematisches Denken';

  @override
  String get skillDetailComparison => 'Detailvergleich';

  @override
  String get challengeShapePathTitle => 'Formpfad';

  @override
  String get challengeShapePathPrompt =>
      'Schauen Sie sich die Reihe an und finden Sie heraus, was als nächstes kommt.';

  @override
  String get challengeShapePathQuestion =>
      'Kreis, Quadrat, Kreis, Quadrat. Was kommt als nächstes?';

  @override
  String get challengeShapePathHint =>
      'Die Formen wechseln sich ab: eine Form, dann die andere, dann wieder die erste.';

  @override
  String get challengeShapePathExplanation =>
      'Nach dem Quadrat kommt wieder ein Kreis, denn die Reihe wiederholt sich alle zwei Formen.';

  @override
  String get challengeToyCountTitle => 'Anzahl der Spielzeuge';

  @override
  String get challengeToyCountPrompt =>
      'Zählen Sie die Objekte und wählen Sie die genaue Antwort.';

  @override
  String get challengeToyCountQuestion =>
      'Auf dem Regal liegen 2 Blöcke und 1 Ball. Wie viele Spielsachen gibt es?';

  @override
  String get challengeToyCountHint =>
      'Zählen Sie zuerst die Blöcke und fügen Sie dann die Kugel hinzu.';

  @override
  String get challengeToyCountExplanation =>
      '2 Blöcke und 1 Ball ergeben insgesamt 3 Spielzeuge.';

  @override
  String get challengeOddCardTitle => 'Seltsame Karte raus';

  @override
  String get challengeOddCardPrompt =>
      'Finden Sie den Artikel, der sich von den anderen unterscheidet.';

  @override
  String get challengeOddCardQuestion =>
      'Apfel, Birne, Kugel, Banane. Welches gehört nicht dazu?';

  @override
  String get challengeOddCardHint =>
      'Drei Gegenstände können gegessen werden, einer dient zum Spielen.';

  @override
  String get challengeOddCardExplanation =>
      'Die Kugel gehört nicht dazu: Apfel, Birne und Banane sind Früchte.';

  @override
  String get challengeLogicTrainTitle => 'Logikzug';

  @override
  String get challengeLogicTrainPrompt =>
      'Platzieren Sie die Waggons entsprechend der Regel.';

  @override
  String get challengeLogicTrainQuestion =>
      'Rot, Blau, Blau, Rot, Blau, Blau. Was kommt als nächstes?';

  @override
  String get challengeLogicTrainHint =>
      'Die Regel wiederholt sich in Dreiergruppen: ein roter und zwei blaue.';

  @override
  String get challengeLogicTrainExplanation =>
      'Das nächste Auto ist rot: Nach zwei blauen Autos startet eine neue Gruppe.';

  @override
  String get challengeStickerSumTitle => 'Stickeralbum';

  @override
  String get challengeStickerSumPrompt =>
      'Fügen Sie zwei kleine Gruppen von Objekten hinzu.';

  @override
  String get challengeStickerSumQuestion =>
      'Nika hatte 3 Aufkleber, dann bekam sie noch 2 weitere. Wie viele hat sie jetzt?';

  @override
  String get challengeStickerSumHint =>
      'Beginnen Sie mit drei und zählen Sie zwei weitere Schritte.';

  @override
  String get challengeStickerSumExplanation =>
      '3 + 2 = 5, also hat sie fünf Aufkleber.';

  @override
  String get challengeMemoryPairsTitle => 'Speicherpaare';

  @override
  String get challengeMemoryPairsPrompt =>
      'Merken Sie sich das passende Paar für jeden Artikel.';

  @override
  String get challengeMemoryPairsQuestion => 'Was gehört zu einem Schlüssel?';

  @override
  String get challengeMemoryPairsHint =>
      'Mit einem Schlüssel wird etwas geöffnet.';

  @override
  String get challengeMemoryPairsExplanation =>
      'Ein Schlüssel gehört zu einem Schloss: Zusammen ergeben sie ein sinnvolles Paar.';

  @override
  String get challengeCodeGridTitle => 'Coderaster';

  @override
  String get challengeCodeGridPrompt =>
      'Lösen Sie die Regel und wählen Sie die richtige Zelle aus.';

  @override
  String get challengeCodeGridQuestion =>
      'Die erste Reihe ist 2, 4, 6. Die zweite ist 3, 5, ?. Welche Zahl fehlt?';

  @override
  String get challengeCodeGridHint =>
      'Auch die Zahlen in der zweiten Reihe wachsen um 2.';

  @override
  String get challengeCodeGridExplanation =>
      'Nach 3 und 5 kommt 7: Jeder Schritt fügt zwei hinzu.';

  @override
  String get challengeNumberBridgeTitle => 'Zahlenbrücke';

  @override
  String get challengeNumberBridgePrompt =>
      'Verbinde die Zahlen, um die richtige Route zu erstellen.';

  @override
  String get challengeNumberBridgeQuestion =>
      'Sie haben 4, 2 und 1. Wie können Sie 7 machen?';

  @override
  String get challengeNumberBridgeHint =>
      'Versuchen Sie, alle Zahlen einmal zu verwenden.';

  @override
  String get challengeNumberBridgeExplanation =>
      '4 + 2 + 1 = 7, also ergeben alle drei Zahlen zusammen das Ziel.';

  @override
  String get challengeDetailCountTitle => 'Detailkarte';

  @override
  String get challengeDetailCountPrompt =>
      'Behalten Sie mehrere Details im Hinterkopf und vergleichen Sie sie.';

  @override
  String get challengeDetailCountQuestion =>
      'Es gibt 3 rote Kreise, 2 blaue Quadrate und 1 grünen Stern. Welche Gruppe hat die meisten?';

  @override
  String get challengeDetailCountHint =>
      'Vergleichen Sie die Beträge: 3, 2 und 1.';

  @override
  String get challengeDetailCountExplanation =>
      'Die roten Kreise sind am häufigsten: Es gibt drei davon.';

  @override
  String get challengeMemoryRecallTitle => 'Denken Sie an die Karten';

  @override
  String get challengeMemoryRecallPrompt =>
      'Schauen Sie sich die Reihe an und finden Sie die versteckte Karte.';

  @override
  String get challengeMemoryRecallQuestion => 'Welche Karte ist versteckt?';

  @override
  String get challengeMemoryRecallHint =>
      'Merken Sie sich die Objekte von links nach rechts und überprüfen Sie das letzte.';

  @override
  String get challengeMemoryRecallExplanation =>
      'Die versteckte Karte befand sich in der Reihe, die Sie sich merken mussten.';

  @override
  String get challengeSortingRuleTitle => 'Box-Regel';

  @override
  String get challengeSortingRulePrompt =>
      'Finden Sie den Gegenstand, der zu den anderen gehört.';

  @override
  String get challengeSortingRuleQuestion => 'Was folgt der gleichen Regel?';

  @override
  String get challengeSortingRuleHint =>
      'Finden Sie zunächst heraus, was die Objekte in der Box gemeinsam haben.';

  @override
  String get challengeSortingRuleExplanation =>
      'Das richtige Objekt entspricht der Box-Regel.';

  @override
  String get challengeMissingPieceTitle => 'Fehlendes Stück';

  @override
  String get challengeMissingPiecePrompt =>
      'Wählen Sie den Teil aus, der das Bild vervollständigt.';

  @override
  String get challengeMissingPieceQuestion =>
      'Welches Stück passt in die leere Stelle?';

  @override
  String get challengeMissingPieceHint =>
      'Vergleichen Sie die leere Form mit den Antwortmöglichkeiten.';

  @override
  String get challengeMissingPieceExplanation =>
      'Dieses Stück vervollständigt das Bild ohne zusätzliche Ecken.';

  @override
  String get challengeLogicDeductionTitle => 'Zwei Hinweise';

  @override
  String get challengeLogicDeductionPrompt =>
      'Verwenden Sie beide Hinweise und entfernen Sie die falschen Entscheidungen.';

  @override
  String get challengeLogicDeductionQuestion => 'Was passt zu jedem Hinweis?';

  @override
  String get challengeLogicDeductionHint =>
      'Jeder Hinweis entfernt mindestens eine falsche Wahl.';

  @override
  String get challengeLogicDeductionExplanation =>
      'Die richtige Antwort entspricht beiden Hinweisen.';

  @override
  String get choiceTriangle => 'Dreieck';

  @override
  String get choiceCircle => 'Kreis';

  @override
  String get choiceStar => 'Stern';

  @override
  String get choiceApple => 'Apfel';

  @override
  String get choiceBall => 'Ball';

  @override
  String get choiceBanana => 'Banane';

  @override
  String get choiceBlue => 'Blau';

  @override
  String get choiceRed => 'Rot';

  @override
  String get choiceGreen => 'Grün';

  @override
  String get choiceKey => 'Schlüssel';

  @override
  String get choiceLock => 'Sperren';

  @override
  String get choiceShoe => 'Schuh';

  @override
  String get choiceCloud => 'Wolke';

  @override
  String get choiceBlueSquares => 'Blaue Quadrate';

  @override
  String get choiceRedCircles => 'Rote Kreise';

  @override
  String get choiceGreenStars => 'Grüne Sterne';

  @override
  String mapLessonTitle(Object lesson) {
    return 'Lektion $lesson';
  }

  @override
  String get mapLessonSubtitle =>
      'Logik, Zählen und Konzentration in einer kurzen Lektion';

  @override
  String get mapStartButton => 'Start';

  @override
  String get mapNodeStart => 'Start';

  @override
  String get mapNodeShapes => 'Formen';

  @override
  String get mapNodePairs => 'Paare';

  @override
  String get mapNodeCounting => 'Zählen';

  @override
  String get mapNodePath => 'Weg';

  @override
  String get mapNodeRhythm => 'Rhythmus';

  @override
  String get mapNodeCompare => 'Vergleichen';

  @override
  String get mapNodeFinal => 'Finale';

  @override
  String get mapNodeCompleted => 'Erledigt';

  @override
  String get mapNodeCurrent => 'offen';

  @override
  String get mapNodeLocked => 'gesperrt';

  @override
  String mapPreviewTitle(Object lesson) {
    return 'Lektion $lesson';
  }

  @override
  String mapPreviewSteps(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Schritte',
      one: '$count Schritt',
    );
    return '$_temp0';
  }

  @override
  String mapPreviewReward(Object xp) {
    return '+$xp XP';
  }

  @override
  String mapPreviewHearts(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Herzen',
      one: '$count Herz',
    );
    return '$_temp0';
  }

  @override
  String get mapPreviewBody =>
      'Eine kurze Lektion mit gemischten Rätseln: Logik, Zählen, Vergleichen und Fokus.';

  @override
  String get mapPreviewStart => 'Unterricht beginnen';

  @override
  String get mapPreviewClose => 'Später';

  @override
  String lessonProgress(Object current, Object total) {
    return 'Schritt $current von $total';
  }

  @override
  String get lessonNextButton => 'Nächste';

  @override
  String get lessonFinishButton => 'Beenden Sie die Lektion';

  @override
  String get lessonCompleteTitle => 'Lektion abgeschlossen!';

  @override
  String get lessonCompleteBody =>
      'Du hast den nächsten Schritt auf der Karte freigeschaltet.';

  @override
  String get lessonRewardStars => '+1 Stern';

  @override
  String lessonRewardXp(Object xp) {
    return '+$xp XP';
  }

  @override
  String get lessonBackToMap => 'Zurück zu Hause';

  @override
  String get courseCatalogTitle => 'Kurse und Rätsel';

  @override
  String get courseLogicTitle => 'Logik';

  @override
  String get courseLogicSubtitle => 'Regeln, Ausreißer und Argumentation';

  @override
  String get courseMathTitle => 'Mathe';

  @override
  String get courseMathSubtitle => 'Zählen, Summen und Vergleichen';

  @override
  String get courseSpatialTitle => 'Formen';

  @override
  String get courseSpatialSubtitle => 'Form, Wege und Raum';

  @override
  String get courseAttentionTitle => 'Fokus';

  @override
  String get courseAttentionSubtitle =>
      'Details, Erinnerung und Aufmerksamkeit';

  @override
  String get courseRebusTitle => 'Rätsel';

  @override
  String get courseRebusSubtitle => 'Bilder, Worte und Rätsel';

  @override
  String get courseMixedTitle => 'Täglicher Mix';

  @override
  String get courseMixedSubtitle => 'Verschiedene Rätsel hintereinander';

  @override
  String progressCardBody(Object level, Object stars) {
    return 'Level $level ? $stars Sterne';
  }

  @override
  String collectionCardBody(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Sticker',
      one: '$count Sticker',
    );
    return '$_temp0';
  }

  @override
  String get dailyMissionBody =>
      'Eine kurze Reihe von Logik-, Zähl- und Fokusrätseln.';

  @override
  String get openCourseButton => 'Offen';

  @override
  String courseProgress(Object completed, Object total) {
    return '$completed von $total Lektionen abgeschlossen';
  }

  @override
  String courseLessonTitle(Object lesson) {
    return 'Lektion $lesson';
  }

  @override
  String courseLessonMeta(num steps, Object xp) {
    String _temp0 = intl.Intl.pluralLogic(
      steps,
      locale: localeName,
      other: '$steps Schritte',
      one: '$steps Schritt',
    );
    return '$_temp0 ? +$xp XP';
  }

  @override
  String get courseStartLessonButton => 'Start';

  @override
  String get courseRepeatButton => 'Wiederholen';

  @override
  String get showHintButton => 'Hinweis';

  @override
  String get hideHintButton => 'Hinweis ausblenden';

  @override
  String get lessonStickerUnlockedTitle => 'Neuer Aufkleber!';

  @override
  String get lessonStickerUnlockedBody =>
      'Ihre Sammlung ist nach der Lektion gewachsen.';

  @override
  String get lessonRewardCollection => '+1 Aufkleber';

  @override
  String get lessonRewardStreak => 'Streak wächst';

  @override
  String get challengeShadowMatchTitle => 'Schattenspiel';

  @override
  String get challengeShadowMatchPrompt =>
      'Finden Sie das Objekt, das zum Schatten passt.';

  @override
  String get challengeShadowMatchQuestion =>
      'Der Schatten hat einen großen Körper und zwei kleine Flügel. Was ist das?';

  @override
  String get challengeShadowMatchHint =>
      'Schauen Sie sich den gesamten Umriss des Objekts an.';

  @override
  String get challengeShadowMatchExplanation =>
      'Die Rakete passt zum Schatten: Sie hat einen hohen Körper und zwei Seitenflügel.';

  @override
  String get challengeBalanceScaleTitle => 'Waage';

  @override
  String get challengeBalanceScalePrompt =>
      'Vergleichen Sie die Seiten und wählen Sie aus, was fehlt.';

  @override
  String get challengeBalanceScaleQuestion =>
      'Auf der linken Seite befinden sich 2 Äpfel. Auf der rechten Seite befindet sich 1 Apfel und ?. Was sollten Sie hinzufügen?';

  @override
  String get challengeBalanceScaleHint =>
      'Beide Seiten benötigen die gleiche Anzahl Äpfel.';

  @override
  String get challengeBalanceScaleExplanation =>
      'Ein weiterer Apfel macht die rechte Seite gleich der linken: 2 und 2.';

  @override
  String get challengeShapeRotationTitle => 'Formdrehung';

  @override
  String get challengeShapeRotationPrompt =>
      'Stellen Sie sich vor, wie sich die Form umdreht.';

  @override
  String get challengeShapeRotationQuestion =>
      'Ein Dreieck dreht sich nach rechts. Welche Karte zeigt die gleiche Form?';

  @override
  String get challengeShapeRotationHint =>
      'Durch Drehen ändert sich die Richtung, nicht aber die Form selbst.';

  @override
  String get challengeShapeRotationExplanation =>
      'Es ist das gleiche Dreieck: Es drehte sich, nahm aber keine andere Form an.';

  @override
  String get choiceRocket => 'Rakete';

  @override
  String get choicePlanet => 'Planet';

  @override
  String get choiceSameTriangle => 'Gleiches Dreieck';

  @override
  String get choiceSquare => 'Quadrat';

  @override
  String get skillInsightsTitle => 'Fähigkeiten und Empfehlungen';

  @override
  String get strongestAreaLabel => 'Starker Bereich';

  @override
  String get practiceFocusLabel => 'Fokusbereich';

  @override
  String get recommendedPracticeLabel => 'Übe als nächstes';

  @override
  String get noSkillDataLabel => 'Noch nicht genügend Daten';

  @override
  String get recommendationKeepGoing =>
      'Machen Sie weiterhin kurze Lektionen: Die Empfehlungen werden nach ein paar Sitzungen schärfer.';

  @override
  String get recommendationPracticeFocus =>
      'Fügen Sie im Laufe der Woche 1-2 kurze Lektionen für diesen Bereich hinzu.';

  @override
  String get courseNextMetricLabel => 'Nächste';

  @override
  String get courseStarsMetricLabel => 'Sterne';

  @override
  String get courseXpMetricLabel => 'XP';

  @override
  String get courseCompletedState => 'Erledigt';

  @override
  String get courseOpenState => 'offen';

  @override
  String get courseLockedState => 'gesperrt';

  @override
  String get collectionScreenTitle => 'Aufklebersammlung';

  @override
  String get collectionScreenSubtitle =>
      'Sammeln Sie Belohnungen, indem Sie Lektionen abschließen und weiter üben.';

  @override
  String collectionUnlockedCount(Object total, Object unlocked) {
    return '$unlocked von $total freigeschaltet';
  }

  @override
  String get collectionNextReward => 'Nächste Belohnung';

  @override
  String get collectionAllRewardsUnlocked => 'Alle Belohnungen freigeschaltet';

  @override
  String get collectionBackHome => 'Zurück zu Hause';

  @override
  String collectionLockedHint(Object stars) {
    return 'Wird nach $stars Sternen freigeschaltet';
  }

  @override
  String get rewardAstronautTitle => 'Sternenhelfer';

  @override
  String get rewardAstronautBody => 'Für den Abschluss der ersten Mission.';

  @override
  String get rewardRocketTitle => 'Mutige Rakete';

  @override
  String get rewardRocketBody => 'Zum Öffnen eines Lernkurses.';

  @override
  String get rewardPlanetTitle => 'Winziger Planet';

  @override
  String get rewardPlanetBody => 'Für den Abschluss von zwei Lektionen.';

  @override
  String get rewardLionTitle => 'Logischer Löwe';

  @override
  String get rewardLionBody => 'Zum Aufbau einer Übungssträhne.';

  @override
  String get rewardPuzzleTitle => 'Puzzle-Abzeichen';

  @override
  String get rewardPuzzleBody => 'Zum Lösen gemischter Rätsel.';

  @override
  String get rewardChampionTitle => 'Weltraummeister';

  @override
  String get rewardChampionBody => 'Für regelmäßiges wöchentliches Üben.';

  @override
  String get accuracyMetricLabel => 'Genauigkeit';

  @override
  String get hintsMetricLabel => 'Hinweise';

  @override
  String recommendationImproveAccuracy(Object skill) {
    return '?be $skill diese Woche langsam: Genauigkeit ist das wichtigste Signal.';
  }

  @override
  String recommendationReduceHints(Object skill) {
    return 'Wiederhole $skill mit weniger Hinweisen: warte kurz, bevor du Hilfe ?ffnest.';
  }

  @override
  String recommendationRepeatAttempts(Object skill) {
    return 'Gib $skill eine kurze Wiederholung, um Fehler zu reduzieren.';
  }

  @override
  String get homeRecommendedLessonTitle => 'Nächste Lektion';

  @override
  String get homeRecommendedLessonSubtitle =>
      'Nächste kurze Lektion auf dem Lernweg.';

  @override
  String get homeRecommendedLessonButton => 'Weitermachen';

  @override
  String get homeRecommendedLessonCompleted => 'Route abgeschlossen';

  @override
  String get lessonReviewTitle => 'Zusammenfassung der Lektion';

  @override
  String get lessonReviewPerfectBody =>
      'Großer Fokus: keine Hinweise oder Fehler.';

  @override
  String get lessonReviewSupportBody =>
      'Guter Abschluss. Versuchen Sie es beim nächsten Mal mit einem Schritt mit weniger Hilfe.';

  @override
  String get lessonReviewQuestionsLabel => 'Fragen';

  @override
  String get lessonReviewHintsLabel => 'Hinweise';

  @override
  String get lessonReviewMistakesLabel => 'Fehler';

  @override
  String get lessonNextRecommendedButton => 'Nächste Lektion';

  @override
  String get practiceHistoryTitle => 'Praxisgeschichte';

  @override
  String get practiceHistorySubtitle =>
      'Aktuelle Lektionen mit Genauigkeit, Hinweisen und Fehlern.';

  @override
  String get practiceHistoryEmpty => 'Noch keine abgeschlossenen Lektionen.';

  @override
  String practiceHistorySessionMeta(Object date, Object minutes) {
    return '$date - $minutes Min.';
  }

  @override
  String get practiceHistoryMistakesLabel => 'Fehler';

  @override
  String get lessonTryAgainButton => 'Versuchen Sie es erneut';

  @override
  String get lessonHintTitle => 'Denken Sie Schritt für Schritt';

  @override
  String get lessonRetryFeedback =>
      'Guter Versuch. Lesen Sie den Hinweis und wählen Sie dann erneut aus.';

  @override
  String get languageSettingsTitle => 'App-Sprache';

  @override
  String get languageSettingsSubtitle =>
      'Wählen Sie die Sprache für die untergeordneten und übergeordneten Bildschirme.';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get languageItalian => 'Italiano';

  @override
  String get languageJapanese => '日本語';

  @override
  String get languageKorean => '한국어';

  @override
  String get languagePortuguese => 'Português';

  @override
  String get languageChinese => '中文';

  @override
  String get choicePear => 'Birne';

  @override
  String get challengeFruitPatternTitle => 'Obstreihe';

  @override
  String get challengeFruitPatternPrompt => 'Setzen Sie das Fruchtmuster fort.';

  @override
  String get challengeFruitPatternQuestion =>
      'Apfel, Banane, Apfel, Banane. Was kommt als nächstes?';

  @override
  String get challengeFruitPatternHint =>
      'Die Früchte wiederholen sich nacheinander: Apfel, dann Banane.';

  @override
  String get challengeFruitPatternExplanation =>
      'Nach der Banane kommt wieder der Apfel, denn das Muster wiederholt sich.';

  @override
  String get challengeLockKeyTitle => 'Magisches Paar';

  @override
  String get challengeLockKeyPrompt =>
      'Wählen Sie das Objekt aus, das ein Paar bildet.';

  @override
  String get challengeLockKeyQuestion =>
      'Ein Schlüssel öffnet etwas. Was gehört dazu?';

  @override
  String get challengeLockKeyHint =>
      'Überlegen Sie, wofür ein Schlüssel verwendet wird.';

  @override
  String get challengeLockKeyExplanation =>
      'Ein Schlüssel und ein Schloss arbeiten zusammen, sie bilden also das Paar.';

  @override
  String get challengeSpaceSequenceTitle => 'Weltraumroute';

  @override
  String get challengeSpaceSequencePrompt =>
      'Finden Sie das nächste Weltraumobjekt.';

  @override
  String get challengeSpaceSequenceQuestion =>
      'Rakete, Planet, Rakete, Planet. Was kommt als nächstes?';

  @override
  String get challengeSpaceSequenceHint =>
      'Die Route wiederholt sich: Rakete, dann Planet.';

  @override
  String get challengeSpaceSequenceExplanation =>
      'Nach dem Planeten kommt wieder eine Rakete.';

  @override
  String get challengeShapeStackTitle => 'Formturm';

  @override
  String get challengeShapeStackPrompt => 'Setzen Sie die Turmregel fort.';

  @override
  String get challengeShapeStackQuestion =>
      'Quadrat, Kreis, Quadrat, Kreis. Welche Form kommt als nächstes?';

  @override
  String get challengeShapeStackHint =>
      'Der Turm wechselt zwischen zwei Formen.';

  @override
  String get challengeShapeStackExplanation =>
      'Nach einem Kreis kommt wieder ein Quadrat.';

  @override
  String get challengePathMazeTitle => 'Wegfinder';

  @override
  String get challengePathMazePrompt =>
      'Folgen Sie der Straße von Anfang bis Ende.';

  @override
  String get challengePathMazeQuestion =>
      'Helfen Sie dem Helden, das Ziel zu erreichen. In welche Richtung soll es gehen?';

  @override
  String get challengePathMazeHint =>
      'Verfolgen Sie die Straße vom Anfang bis zum Ende und wählen Sie an der Gabelung die Richtung.';

  @override
  String get challengePathMazeExplanation =>
      'Der richtige Weg folgt dem offenen Weg zum Ziel.';

  @override
  String get lesson_001_title => 'Formpfad';

  @override
  String get lesson_002_title => 'Spielzeugzählen';

  @override
  String get lesson_003_title => 'Seltsame Karte raus';

  @override
  String get lesson_004_title => 'Logikzug';

  @override
  String get lesson_005_title => 'Summen und Zeilen';

  @override
  String get lesson_006_title => 'Erinnerung und Codes';

  @override
  String get lesson_007_title => 'Zahlenbrücke';

  @override
  String get lesson_008_title => 'Detailkarte';

  @override
  String get lesson_009_title => 'Schatten und Gleichgewicht';

  @override
  String get lesson_010_title => 'Addieren und vergleichen';

  @override
  String get lesson_011_title => 'Kurven und Wege';

  @override
  String get lesson_012_title => 'Gedächtnis und Konzentration';

  @override
  String get lesson_013_title => 'Fruchtmuster';

  @override
  String get lesson_014_title => 'Mathe-Regal';

  @override
  String get lesson_015_title => 'Formturm';

  @override
  String get lesson_016_title => 'Schlösser und Details';

  @override
  String get lesson_017_title => 'Code und Zahlen';

  @override
  String get lesson_018_title => 'Raumsequenz';

  @override
  String get lesson_019_title => 'Konzentrieren Sie sich auf Unterschiede';

  @override
  String get lesson_020_title => 'Lösungsbrücke';

  @override
  String get lesson_021_title => 'Regeln hintereinander';

  @override
  String get lesson_022_title => 'Formen im Raum';

  @override
  String get lesson_023_title => 'Gedächtnis und Zählen';

  @override
  String get lesson_024_title => 'Endgültige Mischung';

  @override
  String get lesson_025_title => 'Detaildetektiv';

  @override
  String get lesson_026_title => 'Skalen und Zahlen';

  @override
  String get lesson_027_title => 'Ungerade und Paare';

  @override
  String get lesson_028_title => 'Raumformen';

  @override
  String get lesson_029_title => 'Sorgfältige Summen';

  @override
  String get lesson_030_title => 'Regel und Code';

  @override
  String get lesson_031_title => 'Schatten, Formen, Erinnerung';

  @override
  String get lesson_032_title => 'Zahlen und Details';

  @override
  String get lesson_033_title => 'Regelkette';

  @override
  String get lesson_034_title => 'Der Raum dreht sich';

  @override
  String get lesson_035_title => 'Große Zahlenroute';

  @override
  String get lesson_036_title => 'Beobachterfinale';

  @override
  String get lesson_037_title => 'Wendungen und Erinnerung';

  @override
  String get lesson_038_title => 'Sprint zählen';

  @override
  String get lesson_039_title => 'Regel und Paar';

  @override
  String get lesson_040_title => 'Weltraumturm';

  @override
  String get lesson_041_title => 'Skalen und Fokus';

  @override
  String get lesson_042_title => 'Codezug';

  @override
  String get lesson_043_title => 'Schatten und Schlösser';

  @override
  String get lesson_044_title => 'Zahlen und Gedächtnis';

  @override
  String get lesson_045_title => 'Lange Kette';

  @override
  String get lesson_046_title => 'Räumliche Route';

  @override
  String get lesson_047_title => 'Summen und Details';

  @override
  String get lesson_048_title => 'Logikfokus';

  @override
  String get lesson_049_title => 'Formen aus nächster Nähe';

  @override
  String get lesson_050_title => 'Sorgfältiges Rechnen';

  @override
  String get lesson_051_title => 'Mustermeister';

  @override
  String get lesson_052_title => 'Schatten im Weltraum';

  @override
  String get lesson_053_title => 'Zahlenrätsel';

  @override
  String get lesson_054_title => 'Beobachtercode';

  @override
  String get lesson_055_title => 'Turm und Schlüssel';

  @override
  String get lesson_056_title => 'Details und Maßstäbe';

  @override
  String get lesson_057_title => 'Härtere Regeln';

  @override
  String get lesson_058_title => 'Formfinale';

  @override
  String get lesson_059_title => 'Große Zahlenaufgabe';

  @override
  String get lesson_060_title => 'Logik-Supermix';
}
