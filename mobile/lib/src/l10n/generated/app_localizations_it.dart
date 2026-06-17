// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'LogicLike';

  @override
  String get homeTab => 'Casa';

  @override
  String get challengeTab => 'Ricerca';

  @override
  String get parentTab => 'Genitore';

  @override
  String homeGreeting(Object childName) {
    return 'Ciao,\n$childName';
  }

  @override
  String get dailyStreakTitle => 'Serie giornaliera';

  @override
  String get streakStart => 'Inizio!';

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count giorni',
      one: '$count giorno',
    );
    return '$_temp0';
  }

  @override
  String dayCountShort(Object count) {
    return '$count g';
  }

  @override
  String get missionOpenButton => 'Aprire';

  @override
  String get missionStartShortButton => 'Inizio';

  @override
  String get missionStartButton => 'Inizia la ricerca';

  @override
  String get homeMissionCompletedTitle => 'Missione\ncompleto!';

  @override
  String get homeMissionHelpTitle => 'Aiuta l\'astronauta\nraccogli le stelle!';

  @override
  String get dailyChallengeTag => 'Ricerca quotidiana';

  @override
  String get myProgressTitle => 'I miei progressi';

  @override
  String levelLabel(Object level) {
    return 'Livello $level';
  }

  @override
  String get myCollectionTitle => 'La mia collezione';

  @override
  String stickerCountLabel(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'adesivi',
      one: 'adesivo',
    );
    return '$_temp0';
  }

  @override
  String homeParentHint(Object ageLabel, Object goalLabel, num minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes min questa settimana',
      one: '$minutes min questa settimana',
    );
    return '$ageLabel ? $goalLabel ? $_temp0';
  }

  @override
  String ageYears(num years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years anni',
      one: '$years anno',
    );
    return '$_temp0';
  }

  @override
  String get goalLogicLabel => 'Logica';

  @override
  String get goalLogicDescription =>
      'Modelli, ragionamento e ricerca di regole.';

  @override
  String get goalMathLabel => 'Matematica';

  @override
  String get goalMathDescription => 'Numbers, counting, and careful solutions.';

  @override
  String get goalAttentionLabel => 'Messa a fuoco';

  @override
  String get goalAttentionDescription =>
      'Attenzione, memoria e confronto dei dettagli.';

  @override
  String get onboardingTitle => 'Configura LogicLike';

  @override
  String get onboardingSubtitle =>
      'Crea un profilo familiare in modo che le missioni giornaliere corrispondano all\'età e all\'obiettivo del bambino.';

  @override
  String get childNameLabel => 'Nome del bambino';

  @override
  String get childNameError => 'Inserisci un nome';

  @override
  String get ageSectionTitle => 'Età';

  @override
  String get learningGoalSectionTitle => 'Obiettivo di apprendimento';

  @override
  String get learningGoalShortTitle => 'Obiettivo';

  @override
  String get startButton => 'Inizio';

  @override
  String get savingButton => 'Risparmio';

  @override
  String get onboardingHeroTitle => 'Primo volo pronto';

  @override
  String get parentTag => 'Genitore';

  @override
  String get parentDashboardTitle => 'Centro familiare';

  @override
  String familyProfileSummary(
      Object ageLabel, Object childName, Object goalLabel) {
    return '$childName ? $ageLabel ? $goalLabel';
  }

  @override
  String get currentStreakMetric => 'strisciante';

  @override
  String get sessionsMetric => 'sessioni';

  @override
  String get minutesMetric => 'minuti';

  @override
  String get childrenProfilesTitle => 'Profili bambino';

  @override
  String get addChildButton => 'Aggiungi bambino';

  @override
  String childProgressChallengeCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sfide',
      one: '$count sfida',
    );
    return '$_temp0';
  }

  @override
  String ageGoalSummary(Object ageLabel, Object goalLabel) {
    return '$ageLabel ? $goalLabel';
  }

  @override
  String get newChildTitle => 'Nuovo bambino';

  @override
  String get cancelButton => 'Cancellare';

  @override
  String get addButton => 'Aggiungere';

  @override
  String get analyticsTitle => 'Esercitati nell\'analisi';

  @override
  String get streakMetricLabel => 'Strisciante';

  @override
  String get bestStreakLabel => 'Migliore';

  @override
  String get last7DaysLabel => 'Ultimi 7 giorni';

  @override
  String get weeklyMinutesLabel => 'Minuti';

  @override
  String sessionsCountShort(Object count) {
    return '$count sess.';
  }

  @override
  String minutesShort(Object count) {
    return '$count min';
  }

  @override
  String minutesNarrow(Object count) {
    return '$count m';
  }

  @override
  String get lastSkillLabel => 'Ultima abilità';

  @override
  String get lastSessionLabel => 'Ultima sessione';

  @override
  String get notAvailable => 'Non ancora';

  @override
  String get weeklyRhythmTitle => 'Ritmo settimanale';

  @override
  String get weeklyRhythmSubtitle =>
      'Esercitati giorni e minuti per ogni giorno.';

  @override
  String get subscriptionTitle => 'Abbonamento familiare';

  @override
  String get currentPlanLabel => 'Piano attuale';

  @override
  String get familySeatsLabel => 'Sedili per famiglie';

  @override
  String get updatedLabel => 'Aggiornato';

  @override
  String get recommendedLabel => 'Miglior valore';

  @override
  String get currentPlanButton => 'Piano attuale';

  @override
  String get chooseButton => 'Scegliere';

  @override
  String get resetProfilePanel =>
      'Reimpostare il profilo locale ed eseguire nuovamente l\'installazione';

  @override
  String get resetButton => 'Reset';

  @override
  String get resetDialogTitle => 'Reimpostare il profilo?';

  @override
  String get resetDialogBody =>
      'L\'onboarding verrà riaperto e i progressi locali verranno cancellati.';

  @override
  String get resetConfirmButton => 'Reset';

  @override
  String get limitPaidMessage => 'Tutti i posti famiglia sono già occupati.';

  @override
  String get limitStarterMessage =>
      'Ulteriori profili sono disponibili nel piano Famiglia.';

  @override
  String get planStarterLabel => 'Antipasto';

  @override
  String get planStarterPrice => '0 ₽';

  @override
  String get planStarterCapacity => '1 profilo bambino';

  @override
  String get planStarterDescription =>
      'Breve giro giornaliero e progresso locale.';

  @override
  String get planMonthlyLabel => 'Mensile familiare';

  @override
  String get planMonthlyPrice => '399 ₽/mese';

  @override
  String get planFamilyCapacity => 'fino a 3 profili figlio';

  @override
  String get planMonthlyDescription =>
      'Accesso completo, profili familiari e analisi dei genitori.';

  @override
  String get planAnnualLabel => 'Annuale familiare';

  @override
  String get planAnnualPrice => '2990 ₽/anno';

  @override
  String get planAnnualDescription =>
      'Lo stesso accesso, con un miglior rapporto qualità-prezzo per la fatturazione annuale.';

  @override
  String get planActiveStatus => 'Attivo';

  @override
  String get planInactiveStatus => 'Non attivo';

  @override
  String get missionCompletedTitle => 'Missione completata!';

  @override
  String childGoCta(Object childName) {
    return '$childName, andiamo!';
  }

  @override
  String get chooseAnswerTitle => 'Scegli una risposta';

  @override
  String get checkingButton => 'Risparmio';

  @override
  String get checkAnswerButton => 'Controllo';

  @override
  String answerCorrect(Object explanation) {
    return 'Giusto! $explanation';
  }

  @override
  String answerAlmost(Object hint) {
    return 'Quasi. $hint';
  }

  @override
  String get challengeCompletedToday => 'La missione di oggi è completa';

  @override
  String get weekdayMondayShort => 'Lun';

  @override
  String get weekdayTuesdayShort => 'Mar';

  @override
  String get weekdayWednesdayShort => 'Mercoledì';

  @override
  String get weekdayThursdayShort => 'Gio';

  @override
  String get weekdayFridayShort => 'Ven';

  @override
  String get weekdaySaturdayShort => 'Sab';

  @override
  String get weekdaySundayShort => 'Sole';

  @override
  String get skillPatterns => 'Modelli';

  @override
  String get skillCountingToFive => 'Contare fino a cinque';

  @override
  String get skillComparison => 'Confronto';

  @override
  String get skillSequences => 'Sequenze';

  @override
  String get skillAdditionToTen => 'Aggiunta a dieci';

  @override
  String get skillWorkingMemory => 'Memoria di lavoro';

  @override
  String get skillLogicDeduction => 'Logica e deduzione';

  @override
  String get skillMathThinking => 'Pensiero matematico';

  @override
  String get skillDetailComparison => 'Confronto dei dettagli';

  @override
  String get challengeShapePathTitle => 'Percorso della forma';

  @override
  String get challengeShapePathPrompt =>
      'Osserva la riga e scopri cosa viene dopo.';

  @override
  String get challengeShapePathQuestion =>
      'Cerchio, quadrato, cerchio, quadrato. Cosa verrà dopo?';

  @override
  String get challengeShapePathHint =>
      'Le forme si alternano: una forma, poi l\'altra, poi ancora la prima.';

  @override
  String get challengeShapePathExplanation =>
      'Dopo il quadrato c\'è di nuovo un cerchio, perché la riga si ripete ogni due forme.';

  @override
  String get challengeToyCountTitle => 'Conteggio dei giocattoli';

  @override
  String get challengeToyCountPrompt =>
      'Conta gli oggetti e scegli la risposta esatta.';

  @override
  String get challengeToyCountQuestion =>
      'Ci sono 2 blocchi e 1 palla sullo scaffale. Quanti giocattoli ci sono?';

  @override
  String get challengeToyCountHint =>
      'Conta prima i blocchi, poi aggiungi la palla.';

  @override
  String get challengeToyCountExplanation =>
      '2 blocchi e 1 palla compongono complessivamente 3 giocattoli.';

  @override
  String get challengeOddCardTitle => 'Strana carta estratta';

  @override
  String get challengeOddCardPrompt => 'Trova l\'oggetto diverso dagli altri.';

  @override
  String get challengeOddCardQuestion =>
      'Mela, pera, palla, banana. Quale non appartiene?';

  @override
  String get challengeOddCardHint =>
      'Tre oggetti possono essere mangiati e uno serve per giocare.';

  @override
  String get challengeOddCardExplanation =>
      'La palla non appartiene: mela, pera e banana sono frutti.';

  @override
  String get challengeLogicTrainTitle => 'Treno logico';

  @override
  String get challengeLogicTrainPrompt =>
      'Posiziona i vagoni del treno secondo la regola.';

  @override
  String get challengeLogicTrainQuestion =>
      'Rosso, blu, blu, rosso, blu, blu. Cosa verrà dopo?';

  @override
  String get challengeLogicTrainHint =>
      'La regola si ripete a gruppi di tre: uno rosso e due blu.';

  @override
  String get challengeLogicTrainExplanation =>
      'La macchina successiva è rossa: dopo le due macchine blu parte un nuovo gruppo.';

  @override
  String get challengeStickerSumTitle => 'Album di figurine';

  @override
  String get challengeStickerSumPrompt =>
      'Aggiungi due piccoli gruppi di oggetti.';

  @override
  String get challengeStickerSumQuestion =>
      'Nika aveva 3 adesivi, poi ne ha presi altri 2. Quanti ne ha adesso?';

  @override
  String get challengeStickerSumHint =>
      'Inizia con tre e conta altri due passaggi.';

  @override
  String get challengeStickerSumExplanation =>
      '3 + 2 = 5, quindi ha cinque adesivi.';

  @override
  String get challengeMemoryPairsTitle => 'Coppie di memoria';

  @override
  String get challengeMemoryPairsPrompt =>
      'Ricorda la coppia corrispondente per ogni articolo.';

  @override
  String get challengeMemoryPairsQuestion => 'Cosa va con una chiave?';

  @override
  String get challengeMemoryPairsHint =>
      'Una chiave serve per aprire qualcosa.';

  @override
  String get challengeMemoryPairsExplanation =>
      'Una chiave sta con una serratura: insieme formano una coppia significativa.';

  @override
  String get challengeCodeGridTitle => 'Griglia di codici';

  @override
  String get challengeCodeGridPrompt =>
      'Risolvi la regola e scegli la cella giusta.';

  @override
  String get challengeCodeGridQuestion =>
      'La prima riga è 2, 4, 6. La seconda è 3, 5, ?. Quale numero manca?';

  @override
  String get challengeCodeGridHint =>
      'Anche i numeri nella seconda riga crescono di 2.';

  @override
  String get challengeCodeGridExplanation =>
      'Dopo 3 e 5 arriva 7: ogni passaggio ne aggiunge due.';

  @override
  String get challengeNumberBridgeTitle => 'Ponte dei numeri';

  @override
  String get challengeNumberBridgePrompt =>
      'Collega i numeri per costruire il percorso giusto.';

  @override
  String get challengeNumberBridgeQuestion => 'Hai 4, 2 e 1. Come puoi fare 7?';

  @override
  String get challengeNumberBridgeHint =>
      'Prova a utilizzare tutti i numeri una volta.';

  @override
  String get challengeNumberBridgeExplanation =>
      '4 + 2 + 1 = 7, quindi tutti e tre i numeri insieme costituiscono il bersaglio.';

  @override
  String get challengeDetailCountTitle => 'Mappa dettagliata';

  @override
  String get challengeDetailCountPrompt =>
      'Tieni a mente diversi dettagli e confrontali.';

  @override
  String get challengeDetailCountQuestion =>
      'Ci sono 3 cerchi rossi, 2 quadrati blu e 1 stella verde. Quale gruppo ne ha di più?';

  @override
  String get challengeDetailCountHint => 'Confronta gli importi: 3, 2 e 1.';

  @override
  String get challengeDetailCountExplanation =>
      'I cerchi rossi sono i più: ce ne sono tre.';

  @override
  String get challengeMemoryRecallTitle => 'Ricorda le carte';

  @override
  String get challengeMemoryRecallPrompt =>
      'Guarda la riga e trova la carta nascosta.';

  @override
  String get challengeMemoryRecallQuestion => 'Quale carta è nascosta?';

  @override
  String get challengeMemoryRecallHint =>
      'Ricorda gli oggetti da sinistra a destra e controlla l\'ultimo.';

  @override
  String get challengeMemoryRecallExplanation =>
      'La carta nascosta era nella riga che dovevi ricordare.';

  @override
  String get challengeSortingRuleTitle => 'Regola della scatola';

  @override
  String get challengeSortingRulePrompt =>
      'Trova l\'oggetto che appartiene agli altri.';

  @override
  String get challengeSortingRuleQuestion => 'Cosa segue la stessa regola?';

  @override
  String get challengeSortingRuleHint =>
      'Per prima cosa scopri cosa hanno in comune gli oggetti nella scatola.';

  @override
  String get challengeSortingRuleExplanation =>
      'L\'oggetto corretto corrisponde alla regola della scatola.';

  @override
  String get challengeMissingPieceTitle => 'Pezzo mancante';

  @override
  String get challengeMissingPiecePrompt =>
      'Scegli la parte che completa l\'immagine.';

  @override
  String get challengeMissingPieceQuestion =>
      'Quale pezzo si adatta al posto vuoto?';

  @override
  String get challengeMissingPieceHint =>
      'Confronta la forma vuota con le scelte di risposta.';

  @override
  String get challengeMissingPieceExplanation =>
      'Questo pezzo completa l\'immagine senza angoli aggiuntivi.';

  @override
  String get challengeLogicDeductionTitle => 'Due indizi';

  @override
  String get challengeLogicDeductionPrompt =>
      'Usa entrambi gli indizi e rimuovi le scelte sbagliate.';

  @override
  String get challengeLogicDeductionQuestion =>
      'Cosa corrisponde a ogni indizio?';

  @override
  String get challengeLogicDeductionHint =>
      'Ogni indizio rimuove almeno una scelta sbagliata.';

  @override
  String get challengeLogicDeductionExplanation =>
      'La risposta corretta corrisponde a entrambi gli indizi.';

  @override
  String get choiceTriangle => 'Triangolo';

  @override
  String get choiceCircle => 'Cerchio';

  @override
  String get choiceStar => 'Stella';

  @override
  String get choiceApple => 'Mela';

  @override
  String get choiceBall => 'Palla';

  @override
  String get choiceBanana => 'Banana';

  @override
  String get choiceBlue => 'Blu';

  @override
  String get choiceRed => 'Rosso';

  @override
  String get choiceGreen => 'Verde';

  @override
  String get choiceKey => 'Chiave';

  @override
  String get choiceLock => 'Serratura';

  @override
  String get choiceShoe => 'Scarpa';

  @override
  String get choiceCloud => 'Nuvola';

  @override
  String get choiceBlueSquares => 'Quadrati blu';

  @override
  String get choiceRedCircles => 'Cerchi rossi';

  @override
  String get choiceGreenStars => 'Stelle verdi';

  @override
  String mapLessonTitle(Object lesson) {
    return 'Lezione $lesson';
  }

  @override
  String get mapLessonSubtitle =>
      'Logica, conteggio e concentrazione in una breve lezione';

  @override
  String get mapStartButton => 'Inizio';

  @override
  String get mapNodeStart => 'Inizio';

  @override
  String get mapNodeShapes => 'Forme';

  @override
  String get mapNodePairs => 'Coppie';

  @override
  String get mapNodeCounting => 'Conteggio';

  @override
  String get mapNodePath => 'Sentiero';

  @override
  String get mapNodeRhythm => 'Ritmo';

  @override
  String get mapNodeCompare => 'Confrontare';

  @override
  String get mapNodeFinal => 'Finale';

  @override
  String get mapNodeCompleted => 'Fatto';

  @override
  String get mapNodeCurrent => 'aprire';

  @override
  String get mapNodeLocked => 'bloccato';

  @override
  String mapPreviewTitle(Object lesson) {
    return 'Lezione $lesson';
  }

  @override
  String mapPreviewSteps(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count passi',
      one: '$count passo',
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
      other: '$count cuori',
      one: '$count cuore',
    );
    return '$_temp0';
  }

  @override
  String get mapPreviewBody =>
      'Una breve lezione con enigmi misti: logica, conteggio, confronto e concentrazione.';

  @override
  String get mapPreviewStart => 'Inizia lezione';

  @override
  String get mapPreviewClose => 'Dopo';

  @override
  String lessonProgress(Object current, Object total) {
    return 'Passo $current di $total';
  }

  @override
  String get lessonNextButton => 'Prossimo';

  @override
  String get lessonFinishButton => 'Finisci la lezione';

  @override
  String get lessonCompleteTitle => 'Lezione completata!';

  @override
  String get lessonCompleteBody =>
      'Hai sbloccato il passaggio successivo sulla mappa.';

  @override
  String get lessonRewardStars => '+1 stella';

  @override
  String lessonRewardXp(Object xp) {
    return '+$xp XP';
  }

  @override
  String get lessonBackToMap => 'Ritorno a casa';

  @override
  String get courseCatalogTitle => 'Percorsi ed enigmi';

  @override
  String get courseLogicTitle => 'Logica';

  @override
  String get courseLogicSubtitle => 'Regole, disparità e ragionamento';

  @override
  String get courseMathTitle => 'Matematica';

  @override
  String get courseMathSubtitle => 'Conteggi, somme e confronti';

  @override
  String get courseSpatialTitle => 'Forme';

  @override
  String get courseSpatialSubtitle => 'Forma, percorsi e spazio';

  @override
  String get courseAttentionTitle => 'Messa a fuoco';

  @override
  String get courseAttentionSubtitle => 'Dettagli, memoria e attenzione';

  @override
  String get courseRebusTitle => 'Rifiuti';

  @override
  String get courseRebusSubtitle => 'Immagini, parole e indovinelli';

  @override
  String get courseMixedTitle => 'Miscela quotidiana';

  @override
  String get courseMixedSubtitle => 'Diversi puzzle di fila';

  @override
  String progressCardBody(Object level, Object stars) {
    return 'Livello $level ? $stars stelle';
  }

  @override
  String collectionCardBody(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count adesivi',
      one: '$count adesivo',
    );
    return '$_temp0';
  }

  @override
  String get dailyMissionBody =>
      'Una breve serie di puzzle di logica, conteggio e concentrazione.';

  @override
  String get openCourseButton => 'Aprire';

  @override
  String courseProgress(Object completed, Object total) {
    return '$completed lezioni su $total completate';
  }

  @override
  String courseLessonTitle(Object lesson) {
    return 'Lezione $lesson';
  }

  @override
  String courseLessonMeta(num steps, Object xp) {
    String _temp0 = intl.Intl.pluralLogic(
      steps,
      locale: localeName,
      other: '$steps passi',
      one: '$steps passo',
    );
    return '$_temp0 ? +$xp XP';
  }

  @override
  String get courseStartLessonButton => 'Inizio';

  @override
  String get courseRepeatButton => 'Ripetere';

  @override
  String get showHintButton => 'Suggerimento';

  @override
  String get hideHintButton => 'Nascondi suggerimento';

  @override
  String get lessonStickerUnlockedTitle => 'Nuovo adesivo!';

  @override
  String get lessonStickerUnlockedBody =>
      'La tua collezione è cresciuta dopo la lezione.';

  @override
  String get lessonRewardCollection => '+1 adesivo';

  @override
  String get lessonRewardStreak => 'La striscia cresce';

  @override
  String get challengeShadowMatchTitle => 'Partita d\'ombra';

  @override
  String get challengeShadowMatchPrompt =>
      'Trova l\'oggetto che si adatta all\'ombra.';

  @override
  String get challengeShadowMatchQuestion =>
      'L\'ombra ha un corpo alto e due piccole ali. Che cos\'è?';

  @override
  String get challengeShadowMatchHint =>
      'Osserva l\'intero contorno dell\'oggetto.';

  @override
  String get challengeShadowMatchExplanation =>
      'Il razzo corrisponde all\'ombra: ha un corpo alto e due ali laterali.';

  @override
  String get challengeBalanceScaleTitle => 'Scala dell\'equilibrio';

  @override
  String get challengeBalanceScalePrompt =>
      'Confronta i lati e scegli cosa manca.';

  @override
  String get challengeBalanceScaleQuestion =>
      'Il lato sinistro ha 2 mele. Il lato destro ha 1 mela e ?. Cosa dovresti aggiungere?';

  @override
  String get challengeBalanceScaleHint =>
      'Entrambe le parti hanno bisogno dello stesso numero di mele.';

  @override
  String get challengeBalanceScaleExplanation =>
      'Un\'altra mela rende il lato destro uguale a quello sinistro: 2 e 2.';

  @override
  String get challengeShapeRotationTitle => 'Turno di forma';

  @override
  String get challengeShapeRotationPrompt => 'Immagina la forma che si gira.';

  @override
  String get challengeShapeRotationQuestion =>
      'Un triangolo gira a destra. Quale carta mostra la stessa forma?';

  @override
  String get challengeShapeRotationHint =>
      'La svolta cambia la direzione, ma non la forma stessa.';

  @override
  String get challengeShapeRotationExplanation =>
      'È lo stesso triangolo: si è girato, ma non ha assunto una forma diversa.';

  @override
  String get choiceRocket => 'Razzo';

  @override
  String get choicePlanet => 'Pianeta';

  @override
  String get choiceSameTriangle => 'Stesso triangolo';

  @override
  String get choiceSquare => 'Piazza';

  @override
  String get skillInsightsTitle => 'Competenze e raccomandazioni';

  @override
  String get strongestAreaLabel => 'Zona forte';

  @override
  String get practiceFocusLabel => 'Area di messa a fuoco';

  @override
  String get recommendedPracticeLabel => 'Esercitati dopo';

  @override
  String get noSkillDataLabel => 'Dati non ancora sufficienti';

  @override
  String get recommendationKeepGoing =>
      'Continua a fare lezioni brevi: le raccomandazioni diventano più precise dopo alcune sessioni.';

  @override
  String get recommendationPracticeFocus =>
      'Aggiungi 1-2 lezioni brevi per quest\'area durante la settimana.';

  @override
  String get courseNextMetricLabel => 'Prossimo';

  @override
  String get courseStarsMetricLabel => 'Stelle';

  @override
  String get courseXpMetricLabel => 'XP';

  @override
  String get courseCompletedState => 'Fatto';

  @override
  String get courseOpenState => 'aprire';

  @override
  String get courseLockedState => 'bloccato';

  @override
  String get collectionScreenTitle => 'Collezione di adesivi';

  @override
  String get collectionScreenSubtitle =>
      'Raccogli ricompense completando le lezioni e continuando la pratica.';

  @override
  String collectionUnlockedCount(Object total, Object unlocked) {
    return '$unlocked di $total sbloccati';
  }

  @override
  String get collectionNextReward => 'Prossima ricompensa';

  @override
  String get collectionAllRewardsUnlocked => 'Tutti i premi sbloccati';

  @override
  String get collectionBackHome => 'Ritorno a casa';

  @override
  String collectionLockedHint(Object stars) {
    return 'Si sblocca dopo $stars stelle';
  }

  @override
  String get rewardAstronautTitle => 'Aiutante stellare';

  @override
  String get rewardAstronautBody => 'Per aver terminato la prima missione.';

  @override
  String get rewardRocketTitle => 'Razzo coraggioso';

  @override
  String get rewardRocketBody => 'Per aprire un corso di apprendimento.';

  @override
  String get rewardPlanetTitle => 'Piccolo pianeta';

  @override
  String get rewardPlanetBody => 'Per aver completato due lezioni.';

  @override
  String get rewardLionTitle => 'Leone logico';

  @override
  String get rewardLionBody => 'Per costruire una serie di allenamenti.';

  @override
  String get rewardPuzzleTitle => 'Distintivo di puzzle';

  @override
  String get rewardPuzzleBody => 'Per risolvere enigmi misti.';

  @override
  String get rewardChampionTitle => 'Campione dello spazio';

  @override
  String get rewardChampionBody => 'Per una pratica settimanale costante.';

  @override
  String get accuracyMetricLabel => 'Precisione';

  @override
  String get hintsMetricLabel => 'Suggerimenti';

  @override
  String recommendationImproveAccuracy(Object skill) {
    return 'Esercitate $skill con calma questa settimana: la precisione ? il segnale principale.';
  }

  @override
  String recommendationReduceHints(Object skill) {
    return 'Ripeti $skill con meno suggerimenti: fermati prima di aprire l?aiuto.';
  }

  @override
  String recommendationRepeatAttempts(Object skill) {
    return 'Dedica a $skill una breve sessione extra per ridurre gli errori.';
  }

  @override
  String get homeRecommendedLessonTitle => 'Prossima lezione';

  @override
  String get homeRecommendedLessonSubtitle =>
      'Prossima breve lezione sul percorso di apprendimento.';

  @override
  String get homeRecommendedLessonButton => 'Continuare';

  @override
  String get homeRecommendedLessonCompleted => 'Percorso completato';

  @override
  String get lessonReviewTitle => 'Riepilogo della lezione';

  @override
  String get lessonReviewPerfectBody =>
      'Ottima concentrazione: nessun suggerimento o errore.';

  @override
  String get lessonReviewSupportBody =>
      'Buone rifiniture. La prossima volta prova un passaggio con meno aiuto.';

  @override
  String get lessonReviewQuestionsLabel => 'Domande';

  @override
  String get lessonReviewHintsLabel => 'Suggerimenti';

  @override
  String get lessonReviewMistakesLabel => 'Errori';

  @override
  String get lessonNextRecommendedButton => 'Prossima lezione';

  @override
  String get practiceHistoryTitle => 'Pratica la storia';

  @override
  String get practiceHistorySubtitle =>
      'Lezioni recenti con accuratezza, suggerimenti ed errori.';

  @override
  String get practiceHistoryEmpty => 'Nessuna lezione ancora completata.';

  @override
  String practiceHistorySessionMeta(Object date, Object minutes) {
    return '$date - $minutes min';
  }

  @override
  String get practiceHistoryMistakesLabel => 'Errori';

  @override
  String get lessonTryAgainButton => 'Riprova';

  @override
  String get lessonHintTitle => 'Pensa passo dopo passo';

  @override
  String get lessonRetryFeedback =>
      'Buon tentativo. Leggi il suggerimento, quindi scegli di nuovo.';

  @override
  String get languageSettingsTitle => 'Lingua dell\'app';

  @override
  String get languageSettingsSubtitle =>
      'Scegli la lingua per le schermate dei bambini e dei genitori.';

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
  String get choicePear => 'Pera';

  @override
  String get challengeFruitPatternTitle => 'Fila di frutta';

  @override
  String get challengeFruitPatternPrompt => 'Continua il motivo con la frutta.';

  @override
  String get challengeFruitPatternQuestion =>
      'Mela, banana, mela, banana. Cosa verrà dopo?';

  @override
  String get challengeFruitPatternHint =>
      'I frutti si ripetono uno per uno: mela, poi banana.';

  @override
  String get challengeFruitPatternExplanation =>
      'Dopo la banana arriva di nuovo la mela, perché lo schema si ripete.';

  @override
  String get challengeLockKeyTitle => 'Coppia magica';

  @override
  String get challengeLockKeyPrompt => 'Scegli l\'oggetto che forma la coppia.';

  @override
  String get challengeLockKeyQuestion =>
      'Una chiave apre qualcosa. Con cosa va?';

  @override
  String get challengeLockKeyHint => 'Pensa a cosa serve una chiave.';

  @override
  String get challengeLockKeyExplanation =>
      'Una chiave e un lucchetto funzionano insieme, quindi formano la coppia.';

  @override
  String get challengeSpaceSequenceTitle => 'Rotta spaziale';

  @override
  String get challengeSpaceSequencePrompt =>
      'Trova il prossimo oggetto spaziale.';

  @override
  String get challengeSpaceSequenceQuestion =>
      'Razzo, pianeta, razzo, pianeta. Cosa verrà dopo?';

  @override
  String get challengeSpaceSequenceHint =>
      'Il percorso si ripete: razzo, poi pianeta.';

  @override
  String get challengeSpaceSequenceExplanation =>
      'Dopo il pianeta arriva di nuovo un razzo.';

  @override
  String get challengeShapeStackTitle => 'Torre di forma';

  @override
  String get challengeShapeStackPrompt => 'Continua la regola della torre.';

  @override
  String get challengeShapeStackQuestion =>
      'Quadrato, cerchio, quadrato, cerchio. Quale sarà la prossima forma?';

  @override
  String get challengeShapeStackHint => 'La torre alterna due forme.';

  @override
  String get challengeShapeStackExplanation =>
      'Dopo un cerchio c\'è di nuovo un quadrato.';

  @override
  String get challengePathMazeTitle => 'Cercatore di percorsi';

  @override
  String get challengePathMazePrompt =>
      'Segui la strada dall\'inizio alla fine.';

  @override
  String get challengePathMazeQuestion =>
      'Aiuta l\'eroe a raggiungere l\'obiettivo. In che direzione dovrebbe andare?';

  @override
  String get challengePathMazeHint =>
      'Traccia la strada dall\'inizio alla fine e scegli la direzione al bivio.';

  @override
  String get challengePathMazeExplanation =>
      'La strada giusta segue il sentiero aperto verso la meta.';

  @override
  String get lesson_001_title => 'Percorso della forma';

  @override
  String get lesson_002_title => 'Conteggio dei giocattoli';

  @override
  String get lesson_003_title => 'Strana carta estratta';

  @override
  String get lesson_004_title => 'Treno logico';

  @override
  String get lesson_005_title => 'Somme e righe';

  @override
  String get lesson_006_title => 'Memoria e codici';

  @override
  String get lesson_007_title => 'Ponte dei numeri';

  @override
  String get lesson_008_title => 'Mappa dettagliata';

  @override
  String get lesson_009_title => 'Ombre ed equilibrio';

  @override
  String get lesson_010_title => 'Aggiunta e confronto';

  @override
  String get lesson_011_title => 'Turni e percorsi';

  @override
  String get lesson_012_title => 'Memoria e concentrazione';

  @override
  String get lesson_013_title => 'Modello di frutta';

  @override
  String get lesson_014_title => 'Scaffale per la matematica';

  @override
  String get lesson_015_title => 'Torre di forma';

  @override
  String get lesson_016_title => 'Serrature e dettagli';

  @override
  String get lesson_017_title => 'Codice e numeri';

  @override
  String get lesson_018_title => 'Sequenza spaziale';

  @override
  String get lesson_019_title => 'Concentrarsi sulle differenze';

  @override
  String get lesson_020_title => 'Ponte delle soluzioni';

  @override
  String get lesson_021_title => 'Regole di fila';

  @override
  String get lesson_022_title => 'Forme nello spazio';

  @override
  String get lesson_023_title => 'Memoria e conteggio';

  @override
  String get lesson_024_title => 'Miscela finale';

  @override
  String get lesson_025_title => 'Detective dei dettagli';

  @override
  String get lesson_026_title => 'Scale e numeri';

  @override
  String get lesson_027_title => 'Quelli dispari e le coppie';

  @override
  String get lesson_028_title => 'Forme spaziali';

  @override
  String get lesson_029_title => 'Somme attente';

  @override
  String get lesson_030_title => 'Regola e codice';

  @override
  String get lesson_031_title => 'Ombre, forme, memoria';

  @override
  String get lesson_032_title => 'Numeri e dettagli';

  @override
  String get lesson_033_title => 'Catena di regole';

  @override
  String get lesson_034_title => 'Lo spazio gira';

  @override
  String get lesson_035_title => 'Itinerario dai grandi numeri';

  @override
  String get lesson_036_title => 'Finale dell\'Osservatore';

  @override
  String get lesson_037_title => 'Giri e memoria';

  @override
  String get lesson_038_title => 'Conteggio dello sprint';

  @override
  String get lesson_039_title => 'Regola e accoppia';

  @override
  String get lesson_040_title => 'Torre spaziale';

  @override
  String get lesson_041_title => 'Scale e concentrazione';

  @override
  String get lesson_042_title => 'Treno in codice';

  @override
  String get lesson_043_title => 'Ombre e serrature';

  @override
  String get lesson_044_title => 'Numeri e memoria';

  @override
  String get lesson_045_title => 'Catena lunga';

  @override
  String get lesson_046_title => 'Percorso spaziale';

  @override
  String get lesson_047_title => 'Somme e dettagli';

  @override
  String get lesson_048_title => 'Focus logico';

  @override
  String get lesson_049_title => 'Le forme da vicino';

  @override
  String get lesson_050_title => 'Aritmetica attenta';

  @override
  String get lesson_051_title => 'Maestro del modello';

  @override
  String get lesson_052_title => 'Ombre nello spazio';

  @override
  String get lesson_053_title => 'Enigma dei numeri';

  @override
  String get lesson_054_title => 'Codice osservatore';

  @override
  String get lesson_055_title => 'Torre e chiave';

  @override
  String get lesson_056_title => 'Dettagli e scale';

  @override
  String get lesson_057_title => 'Regole più dure';

  @override
  String get lesson_058_title => 'Finale di forma';

  @override
  String get lesson_059_title => 'Compito di grandi numeri';

  @override
  String get lesson_060_title => 'Supermix logico';
}
