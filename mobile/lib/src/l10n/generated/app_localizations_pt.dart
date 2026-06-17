// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'LogicLike';

  @override
  String get homeTab => 'Lar';

  @override
  String get challengeTab => 'Busca';

  @override
  String get parentTab => 'Pai';

  @override
  String homeGreeting(Object childName) {
    return 'Ol?,\n$childName';
  }

  @override
  String get dailyStreakTitle => 'Sequência diária';

  @override
  String get streakStart => 'Começar!';

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dias',
      one: '$count dia',
    );
    return '$_temp0';
  }

  @override
  String dayCountShort(Object count) {
    return '$count d';
  }

  @override
  String get missionOpenButton => 'Abrir';

  @override
  String get missionStartShortButton => 'Começar';

  @override
  String get missionStartButton => 'Iniciar missão';

  @override
  String get homeMissionCompletedTitle => 'Missão\ncompleto!';

  @override
  String get homeMissionHelpTitle => 'Ajude o astronauta\ncolete estrelas!';

  @override
  String get dailyChallengeTag => 'Missão diária';

  @override
  String get myProgressTitle => 'Meu progresso';

  @override
  String levelLabel(Object level) {
    return 'N?vel $level';
  }

  @override
  String get myCollectionTitle => 'Minha coleção';

  @override
  String stickerCountLabel(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'adesivos',
      one: 'adesivo',
    );
    return '$_temp0';
  }

  @override
  String homeParentHint(Object ageLabel, Object goalLabel, num minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes min esta semana',
      one: '$minutes min esta semana',
    );
    return '$ageLabel ? $goalLabel ? $_temp0';
  }

  @override
  String ageYears(num years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years anos',
      one: '$years ano',
    );
    return '$_temp0';
  }

  @override
  String get goalLogicLabel => 'Lógica';

  @override
  String get goalLogicDescription =>
      'Padrões, raciocínio e descoberta de regras.';

  @override
  String get goalMathLabel => 'Matemática';

  @override
  String get goalMathDescription => 'Números, contagem e soluções cuidadosas.';

  @override
  String get goalAttentionLabel => 'Foco';

  @override
  String get goalAttentionDescription =>
      'Atenção, memória e comparação de detalhes.';

  @override
  String get onboardingTitle => 'Configurar o LogicLike';

  @override
  String get onboardingSubtitle =>
      'Crie um perfil familiar para que as missões diárias correspondam à idade e ao objetivo da criança.';

  @override
  String get childNameLabel => 'Nome da criança';

  @override
  String get childNameError => 'Digite um nome';

  @override
  String get ageSectionTitle => 'Idade';

  @override
  String get learningGoalSectionTitle => 'Objetivo de aprendizagem';

  @override
  String get learningGoalShortTitle => 'Meta';

  @override
  String get startButton => 'Começar';

  @override
  String get savingButton => 'Salvando';

  @override
  String get onboardingHeroTitle => 'Primeiro voo pronto';

  @override
  String get parentTag => 'Pai';

  @override
  String get parentDashboardTitle => 'Centro familiar';

  @override
  String familyProfileSummary(
      Object ageLabel, Object childName, Object goalLabel) {
    return '$childName ? $ageLabel ? $goalLabel';
  }

  @override
  String get currentStreakMetric => 'onda';

  @override
  String get sessionsMetric => 'sessões';

  @override
  String get minutesMetric => 'minutos';

  @override
  String get childrenProfilesTitle => 'Perfis infantis';

  @override
  String get addChildButton => 'Adicionar filho';

  @override
  String childProgressChallengeCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count desafios',
      one: '$count desafio',
    );
    return '$_temp0';
  }

  @override
  String ageGoalSummary(Object ageLabel, Object goalLabel) {
    return '$ageLabel ? $goalLabel';
  }

  @override
  String get newChildTitle => 'Nova criança';

  @override
  String get cancelButton => 'Cancelar';

  @override
  String get addButton => 'Adicionar';

  @override
  String get analyticsTitle => 'Pratique análises';

  @override
  String get streakMetricLabel => 'Onda';

  @override
  String get bestStreakLabel => 'Melhor';

  @override
  String get last7DaysLabel => 'Últimos 7 dias';

  @override
  String get weeklyMinutesLabel => 'Minutos';

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
  String get lastSkillLabel => 'Última habilidade';

  @override
  String get lastSessionLabel => 'Última sessão';

  @override
  String get notAvailable => 'Ainda não';

  @override
  String get weeklyRhythmTitle => 'Ritmo semanal';

  @override
  String get weeklyRhythmSubtitle => 'Pratique dias e minutos para cada dia.';

  @override
  String get subscriptionTitle => 'Assinatura familiar';

  @override
  String get currentPlanLabel => 'Plano atual';

  @override
  String get familySeatsLabel => 'Assentos familiares';

  @override
  String get updatedLabel => 'Atualizado';

  @override
  String get recommendedLabel => 'Melhor valor';

  @override
  String get currentPlanButton => 'Plano atual';

  @override
  String get chooseButton => 'Escolher';

  @override
  String get resetProfilePanel =>
      'Redefina o perfil local e execute a configuração novamente';

  @override
  String get resetButton => 'Reiniciar';

  @override
  String get resetDialogTitle => 'Redefinir perfil?';

  @override
  String get resetDialogBody =>
      'A integração será aberta novamente e o progresso local será apagado.';

  @override
  String get resetConfirmButton => 'Reiniciar';

  @override
  String get limitPaidMessage =>
      'Todos os assentos familiares já estão utilizados.';

  @override
  String get limitStarterMessage =>
      'Mais perfis estão disponíveis no plano familiar.';

  @override
  String get planStarterLabel => 'Iniciante';

  @override
  String get planStarterPrice => '0₽';

  @override
  String get planStarterCapacity => '1 perfil infantil';

  @override
  String get planStarterDescription => 'Loop diário curto e progresso local.';

  @override
  String get planMonthlyLabel => 'Família mensalmente';

  @override
  String get planMonthlyPrice => '399 ₽/mês';

  @override
  String get planFamilyCapacity => 'até 3 perfis infantis';

  @override
  String get planMonthlyDescription =>
      'Acesso total, perfis familiares e análises dos pais.';

  @override
  String get planAnnualLabel => 'Família anual';

  @override
  String get planAnnualPrice => '2.990 ₽/ano';

  @override
  String get planAnnualDescription =>
      'O mesmo acesso, com melhor valor para faturação anual.';

  @override
  String get planActiveStatus => 'Ativo';

  @override
  String get planInactiveStatus => 'Não ativo';

  @override
  String get missionCompletedTitle => 'Missão concluída!';

  @override
  String childGoCta(Object childName) {
    return '$childName, vamos l?!';
  }

  @override
  String get chooseAnswerTitle => 'Escolha uma resposta';

  @override
  String get checkingButton => 'Salvando';

  @override
  String get checkAnswerButton => 'Verificar';

  @override
  String answerCorrect(Object explanation) {
    return 'Correto! $explanation';
  }

  @override
  String answerAlmost(Object hint) {
    return 'Quase. $hint';
  }

  @override
  String get challengeCompletedToday => 'A missão de hoje está completa';

  @override
  String get weekdayMondayShort => 'seg';

  @override
  String get weekdayTuesdayShort => 'ter';

  @override
  String get weekdayWednesdayShort => 'qua';

  @override
  String get weekdayThursdayShort => 'qui';

  @override
  String get weekdayFridayShort => 'sex';

  @override
  String get weekdaySaturdayShort => 'Sentado';

  @override
  String get weekdaySundayShort => 'Sol';

  @override
  String get skillPatterns => 'Padrões';

  @override
  String get skillCountingToFive => 'Contando até cinco';

  @override
  String get skillComparison => 'Comparação';

  @override
  String get skillSequences => 'Sequências';

  @override
  String get skillAdditionToTen => 'Adição a dez';

  @override
  String get skillWorkingMemory => 'Memória de trabalho';

  @override
  String get skillLogicDeduction => 'Lógica e dedução';

  @override
  String get skillMathThinking => 'Pensamento matemático';

  @override
  String get skillDetailComparison => 'Comparação detalhada';

  @override
  String get challengeShapePathTitle => 'Caminho de forma';

  @override
  String get challengeShapePathPrompt =>
      'Olhe para a linha e descubra o que vem a seguir.';

  @override
  String get challengeShapePathQuestion =>
      'Círculo, quadrado, círculo, quadrado. O que vem a seguir?';

  @override
  String get challengeShapePathHint =>
      'As formas se alternam: uma forma, depois a outra, depois a primeira novamente.';

  @override
  String get challengeShapePathExplanation =>
      'Depois do quadrado vem um círculo novamente, pois a linha se repete a cada duas formas.';

  @override
  String get challengeToyCountTitle => 'Contagem de brinquedos';

  @override
  String get challengeToyCountPrompt =>
      'Conte os objetos e escolha a resposta exata.';

  @override
  String get challengeToyCountQuestion =>
      'Existem 2 blocos e 1 bola na prateleira. Quantos brinquedos existem?';

  @override
  String get challengeToyCountHint =>
      'Conte os blocos primeiro e depois adicione a bola.';

  @override
  String get challengeToyCountExplanation =>
      '2 blocos e 1 bola perfazem 3 brinquedos no total.';

  @override
  String get challengeOddCardTitle => 'Saída de carta estranha';

  @override
  String get challengeOddCardPrompt =>
      'Encontre o item que é diferente dos outros.';

  @override
  String get challengeOddCardQuestion =>
      'Maçã, pêra, bola, banana. Qual deles não pertence?';

  @override
  String get challengeOddCardHint =>
      'Três itens podem ser consumidos e um é para brincar.';

  @override
  String get challengeOddCardExplanation =>
      'A bola não pertence: maçã, pêra e banana são frutas.';

  @override
  String get challengeLogicTrainTitle => 'Trem lógico';

  @override
  String get challengeLogicTrainPrompt =>
      'Coloque os vagões de acordo com a regra.';

  @override
  String get challengeLogicTrainQuestion =>
      'Vermelho, azul, azul, vermelho, azul, azul. O que vem a seguir?';

  @override
  String get challengeLogicTrainHint =>
      'A regra se repete em grupos de três: um vermelho e dois azuis.';

  @override
  String get challengeLogicTrainExplanation =>
      'O próximo carro é vermelho: depois de dois carros azuis, começa um novo grupo.';

  @override
  String get challengeStickerSumTitle => 'Álbum de figurinhas';

  @override
  String get challengeStickerSumPrompt =>
      'Adicione dois pequenos grupos de objetos.';

  @override
  String get challengeStickerSumQuestion =>
      'Nika tinha 3 adesivos e depois ganhou mais 2. Quantos ela tem agora?';

  @override
  String get challengeStickerSumHint =>
      'Comece com três e conte mais dois passos.';

  @override
  String get challengeStickerSumExplanation =>
      '3 + 2 = 5, então ela tem cinco adesivos.';

  @override
  String get challengeMemoryPairsTitle => 'Pares de memória';

  @override
  String get challengeMemoryPairsPrompt =>
      'Lembre-se do par correspondente para cada item.';

  @override
  String get challengeMemoryPairsQuestion => 'O que se passa com uma chave?';

  @override
  String get challengeMemoryPairsHint => 'Uma chave é usada para abrir algo.';

  @override
  String get challengeMemoryPairsExplanation =>
      'Uma chave acompanha uma fechadura: juntas elas formam um par significativo.';

  @override
  String get challengeCodeGridTitle => 'Grade de código';

  @override
  String get challengeCodeGridPrompt =>
      'Resolva a regra e escolha a célula certa.';

  @override
  String get challengeCodeGridQuestion =>
      'A primeira linha é 2, 4, 6. A segunda é 3, 5,?. Qual número está faltando?';

  @override
  String get challengeCodeGridHint =>
      'Os números na segunda linha também aumentam 2.';

  @override
  String get challengeCodeGridExplanation =>
      'Depois de 3 e 5 vem 7: cada etapa soma dois.';

  @override
  String get challengeNumberBridgeTitle => 'Ponte numérica';

  @override
  String get challengeNumberBridgePrompt =>
      'Conecte os números para construir a rota certa.';

  @override
  String get challengeNumberBridgeQuestion =>
      'Você tem 4, 2 e 1. Como você pode fazer 7?';

  @override
  String get challengeNumberBridgeHint =>
      'Tente usar todos os números de uma vez.';

  @override
  String get challengeNumberBridgeExplanation =>
      '4 + 2 + 1 = 7, então todos os três números juntos formam o alvo.';

  @override
  String get challengeDetailCountTitle => 'Mapa detalhado';

  @override
  String get challengeDetailCountPrompt =>
      'Tenha vários detalhes em mente e compare-os.';

  @override
  String get challengeDetailCountQuestion =>
      'Existem 3 círculos vermelhos, 2 quadrados azuis e 1 estrela verde. Qual grupo tem mais?';

  @override
  String get challengeDetailCountHint => 'Compare os valores: 3, 2 e 1.';

  @override
  String get challengeDetailCountExplanation =>
      'Os círculos vermelhos são os mais: são três.';

  @override
  String get challengeMemoryRecallTitle => 'Lembre-se das cartas';

  @override
  String get challengeMemoryRecallPrompt =>
      'Olhe para a linha e encontre a carta escondida.';

  @override
  String get challengeMemoryRecallQuestion => 'Qual cartão está oculto?';

  @override
  String get challengeMemoryRecallHint =>
      'Lembre-se dos objetos da esquerda para a direita e verifique o último.';

  @override
  String get challengeMemoryRecallExplanation =>
      'A carta oculta estava na linha que você precisava lembrar.';

  @override
  String get challengeSortingRuleTitle => 'Regra da caixa';

  @override
  String get challengeSortingRulePrompt =>
      'Encontre o objeto que pertence aos outros.';

  @override
  String get challengeSortingRuleQuestion => 'O que segue a mesma regra?';

  @override
  String get challengeSortingRuleHint =>
      'Primeiro descubra o que os objetos da caixa têm em comum.';

  @override
  String get challengeSortingRuleExplanation =>
      'O objeto correto corresponde à regra da caixa.';

  @override
  String get challengeMissingPieceTitle => 'Peça faltando';

  @override
  String get challengeMissingPiecePrompt =>
      'Escolha a parte que completa a imagem.';

  @override
  String get challengeMissingPieceQuestion => 'Qual peça cabe no lugar vazio?';

  @override
  String get challengeMissingPieceHint =>
      'Compare a forma vazia com as opções de resposta.';

  @override
  String get challengeMissingPieceExplanation =>
      'Esta peça completa a imagem sem cantos extras.';

  @override
  String get challengeLogicDeductionTitle => 'Duas pistas';

  @override
  String get challengeLogicDeductionPrompt =>
      'Use as duas pistas e remova as escolhas erradas.';

  @override
  String get challengeLogicDeductionQuestion =>
      'O que corresponde a cada pista?';

  @override
  String get challengeLogicDeductionHint =>
      'Cada pista remove pelo menos uma escolha errada.';

  @override
  String get challengeLogicDeductionExplanation =>
      'A resposta correta corresponde às duas pistas.';

  @override
  String get choiceTriangle => 'Triângulo';

  @override
  String get choiceCircle => 'Círculo';

  @override
  String get choiceStar => 'Estrela';

  @override
  String get choiceApple => 'Maçã';

  @override
  String get choiceBall => 'Bola';

  @override
  String get choiceBanana => 'Banana';

  @override
  String get choiceBlue => 'Azul';

  @override
  String get choiceRed => 'Vermelho';

  @override
  String get choiceGreen => 'Verde';

  @override
  String get choiceKey => 'Chave';

  @override
  String get choiceLock => 'Trancar';

  @override
  String get choiceShoe => 'Sapato';

  @override
  String get choiceCloud => 'Nuvem';

  @override
  String get choiceBlueSquares => 'Quadrados azuis';

  @override
  String get choiceRedCircles => 'Círculos vermelhos';

  @override
  String get choiceGreenStars => 'Estrelas verdes';

  @override
  String mapLessonTitle(Object lesson) {
    return 'Li??o $lesson';
  }

  @override
  String get mapLessonSubtitle => 'Lógica, contagem e foco em uma curta lição';

  @override
  String get mapStartButton => 'Começar';

  @override
  String get mapNodeStart => 'Começar';

  @override
  String get mapNodeShapes => 'Formas';

  @override
  String get mapNodePairs => 'Pares';

  @override
  String get mapNodeCounting => 'Contando';

  @override
  String get mapNodePath => 'Caminho';

  @override
  String get mapNodeRhythm => 'Ritmo';

  @override
  String get mapNodeCompare => 'Comparar';

  @override
  String get mapNodeFinal => 'Final';

  @override
  String get mapNodeCompleted => 'feito';

  @override
  String get mapNodeCurrent => 'abrir';

  @override
  String get mapNodeLocked => 'bloqueado';

  @override
  String mapPreviewTitle(Object lesson) {
    return 'Li??o $lesson';
  }

  @override
  String mapPreviewSteps(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count passos',
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
      other: '$count cora??es',
      one: '$count cora??o',
    );
    return '$_temp0';
  }

  @override
  String get mapPreviewBody =>
      'Uma pequena lição com quebra-cabeças mistos: lógica, contagem, comparação e foco.';

  @override
  String get mapPreviewStart => 'Iniciar aula';

  @override
  String get mapPreviewClose => 'Mais tarde';

  @override
  String lessonProgress(Object current, Object total) {
    return 'Passo $current de $total';
  }

  @override
  String get lessonNextButton => 'Próximo';

  @override
  String get lessonFinishButton => 'Concluir lição';

  @override
  String get lessonCompleteTitle => 'Lição concluída!';

  @override
  String get lessonCompleteBody => 'Você desbloqueou a próxima etapa no mapa.';

  @override
  String get lessonRewardStars => '+1 estrela';

  @override
  String lessonRewardXp(Object xp) {
    return '+$xp XP';
  }

  @override
  String get lessonBackToMap => 'De volta para casa';

  @override
  String get courseCatalogTitle => 'Cursos e quebra-cabeças';

  @override
  String get courseLogicTitle => 'Lógica';

  @override
  String get courseLogicSubtitle => 'Regras, algo estranho e raciocínio';

  @override
  String get courseMathTitle => 'Matemática';

  @override
  String get courseMathSubtitle => 'Contagem, somas e comparação';

  @override
  String get courseSpatialTitle => 'Formas';

  @override
  String get courseSpatialSubtitle => 'Forma, caminhos e espaço';

  @override
  String get courseAttentionTitle => 'Foco';

  @override
  String get courseAttentionSubtitle => 'Detalhes, memória e atenção';

  @override
  String get courseRebusTitle => 'Rebusos';

  @override
  String get courseRebusSubtitle => 'Imagens, palavras e enigmas';

  @override
  String get courseMixedTitle => 'Mistura diária';

  @override
  String get courseMixedSubtitle => 'Diferentes quebra-cabeças seguidos';

  @override
  String progressCardBody(Object level, Object stars) {
    return 'N?vel $level ? $stars estrelas';
  }

  @override
  String collectionCardBody(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count adesivos',
      one: '$count adesivo',
    );
    return '$_temp0';
  }

  @override
  String get dailyMissionBody =>
      'Um pequeno conjunto de quebra-cabeças de lógica, contagem e foco.';

  @override
  String get openCourseButton => 'Abrir';

  @override
  String courseProgress(Object completed, Object total) {
    return '$completed de $total li??es conclu?das';
  }

  @override
  String courseLessonTitle(Object lesson) {
    return 'Li??o $lesson';
  }

  @override
  String courseLessonMeta(num steps, Object xp) {
    String _temp0 = intl.Intl.pluralLogic(
      steps,
      locale: localeName,
      other: '$steps passos',
      one: '$steps passo',
    );
    return '$_temp0 ? +$xp XP';
  }

  @override
  String get courseStartLessonButton => 'Começar';

  @override
  String get courseRepeatButton => 'Repita';

  @override
  String get showHintButton => 'Dica';

  @override
  String get hideHintButton => 'Ocultar dica';

  @override
  String get lessonStickerUnlockedTitle => 'Novo adesivo!';

  @override
  String get lessonStickerUnlockedBody => 'Sua coleção cresceu após a aula.';

  @override
  String get lessonRewardCollection => '+1 adesivo';

  @override
  String get lessonRewardStreak => 'A sequência cresce';

  @override
  String get challengeShadowMatchTitle => 'Partida de sombra';

  @override
  String get challengeShadowMatchPrompt =>
      'Encontre o objeto que se ajusta à sombra.';

  @override
  String get challengeShadowMatchQuestion =>
      'A sombra tem um corpo alto e duas asas pequenas. O que é?';

  @override
  String get challengeShadowMatchHint => 'Observe todo o contorno do objeto.';

  @override
  String get challengeShadowMatchExplanation =>
      'O foguete combina com a sombra: tem corpo alto e duas asas laterais.';

  @override
  String get challengeBalanceScaleTitle => 'Escala de equilíbrio';

  @override
  String get challengeBalanceScalePrompt =>
      'Compare os lados e escolha o que está faltando.';

  @override
  String get challengeBalanceScaleQuestion =>
      'O lado esquerdo tem 2 maçãs. O lado direito tem 1 maçã e?. O que você deve adicionar?';

  @override
  String get challengeBalanceScaleHint =>
      'Ambos os lados precisam do mesmo número de maçãs.';

  @override
  String get challengeBalanceScaleExplanation =>
      'Mais uma maçã torna o lado direito igual ao esquerdo: 2 e 2.';

  @override
  String get challengeShapeRotationTitle => 'Virar forma';

  @override
  String get challengeShapeRotationPrompt => 'Imagine a forma girando.';

  @override
  String get challengeShapeRotationQuestion =>
      'Um triângulo gira para a direita. Qual cartão mostra a mesma forma?';

  @override
  String get challengeShapeRotationHint =>
      'Virar muda de direção, mas não a forma em si.';

  @override
  String get challengeShapeRotationExplanation =>
      'É o mesmo triângulo: girou, mas não adquiriu uma forma diferente.';

  @override
  String get choiceRocket => 'Foguete';

  @override
  String get choicePlanet => 'Planeta';

  @override
  String get choiceSameTriangle => 'Mesmo triângulo';

  @override
  String get choiceSquare => 'Quadrado';

  @override
  String get skillInsightsTitle => 'Habilidades e recomendações';

  @override
  String get strongestAreaLabel => 'Área forte';

  @override
  String get practiceFocusLabel => 'Área de foco';

  @override
  String get recommendedPracticeLabel => 'Pratique a seguir';

  @override
  String get noSkillDataLabel => 'Ainda não há dados suficientes';

  @override
  String get recommendationKeepGoing =>
      'Continue fazendo lições curtas: as recomendações ficam mais nítidas depois de algumas sessões.';

  @override
  String get recommendationPracticeFocus =>
      'Adicione 1-2 aulas curtas para esta área durante a semana.';

  @override
  String get courseNextMetricLabel => 'Próximo';

  @override
  String get courseStarsMetricLabel => 'Estrelas';

  @override
  String get courseXpMetricLabel => 'EXP';

  @override
  String get courseCompletedState => 'feito';

  @override
  String get courseOpenState => 'abrir';

  @override
  String get courseLockedState => 'bloqueado';

  @override
  String get collectionScreenTitle => 'Coleção de adesivos';

  @override
  String get collectionScreenSubtitle =>
      'Colete recompensas concluindo lições e mantendo a prática.';

  @override
  String collectionUnlockedCount(Object total, Object unlocked) {
    return '$unlocked de $total desbloqueados';
  }

  @override
  String get collectionNextReward => 'Próxima recompensa';

  @override
  String get collectionAllRewardsUnlocked =>
      'Todas as recompensas desbloqueadas';

  @override
  String get collectionBackHome => 'De volta para casa';

  @override
  String collectionLockedHint(Object stars) {
    return 'Desbloqueia ap?s $stars estrelas';
  }

  @override
  String get rewardAstronautTitle => 'Ajudante estrela';

  @override
  String get rewardAstronautBody => 'Por terminar a primeira missão.';

  @override
  String get rewardRocketTitle => 'Foguete corajoso';

  @override
  String get rewardRocketBody => 'Para abrir um curso de aprendizagem.';

  @override
  String get rewardPlanetTitle => 'Pequeno planeta';

  @override
  String get rewardPlanetBody => 'Por completar duas lições.';

  @override
  String get rewardLionTitle => 'Leão lógico';

  @override
  String get rewardLionBody => 'Para construir uma sequência de treinos.';

  @override
  String get rewardPuzzleTitle => 'Distintivo de quebra-cabeça';

  @override
  String get rewardPuzzleBody => 'Para resolver quebra-cabeças mistos.';

  @override
  String get rewardChampionTitle => 'Campeão espacial';

  @override
  String get rewardChampionBody => 'Para prática semanal constante.';

  @override
  String get accuracyMetricLabel => 'Precisão';

  @override
  String get hintsMetricLabel => 'Dicas';

  @override
  String recommendationImproveAccuracy(Object skill) {
    return 'Pratique $skill devagar esta semana: a precis?o ? o sinal principal.';
  }

  @override
  String recommendationReduceHints(Object skill) {
    return 'Repita $skill com menos dicas: pare antes de abrir a ajuda.';
  }

  @override
  String recommendationRepeatAttempts(Object skill) {
    return 'Fa?a uma sess?o curta de $skill para reduzir erros.';
  }

  @override
  String get homeRecommendedLessonTitle => 'Próxima lição';

  @override
  String get homeRecommendedLessonSubtitle =>
      'Próxima pequena lição sobre a rota de aprendizagem.';

  @override
  String get homeRecommendedLessonButton => 'Continuar';

  @override
  String get homeRecommendedLessonCompleted => 'Rota concluída';

  @override
  String get lessonReviewTitle => 'Resumo da lição';

  @override
  String get lessonReviewPerfectBody => 'Ótimo foco: sem dicas ou erros.';

  @override
  String get lessonReviewSupportBody =>
      'Bom acabamento. Da próxima vez, tente uma etapa com menos ajuda.';

  @override
  String get lessonReviewQuestionsLabel => 'Questões';

  @override
  String get lessonReviewHintsLabel => 'Dicas';

  @override
  String get lessonReviewMistakesLabel => 'Erros';

  @override
  String get lessonNextRecommendedButton => 'Próxima lição';

  @override
  String get practiceHistoryTitle => 'Histórico de prática';

  @override
  String get practiceHistorySubtitle =>
      'Lições recentes com precisão, dicas e erros.';

  @override
  String get practiceHistoryEmpty => 'Nenhuma lição concluída ainda.';

  @override
  String practiceHistorySessionMeta(Object date, Object minutes) {
    return '$date - $minutes min';
  }

  @override
  String get practiceHistoryMistakesLabel => 'Erros';

  @override
  String get lessonTryAgainButton => 'Tente novamente';

  @override
  String get lessonHintTitle => 'Pense passo a passo';

  @override
  String get lessonRetryFeedback =>
      'Boa tentativa. Leia a dica e escolha novamente.';

  @override
  String get languageSettingsTitle => 'Idioma do aplicativo';

  @override
  String get languageSettingsSubtitle =>
      'Escolha o idioma para as telas filho e pai.';

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
  String get challengeFruitPatternTitle => 'Fileira de frutas';

  @override
  String get challengeFruitPatternPrompt => 'Continue o padrão de fruta.';

  @override
  String get challengeFruitPatternQuestion =>
      'Maçã, banana, maçã, banana. O que vem a seguir?';

  @override
  String get challengeFruitPatternHint =>
      'As frutas se repetem uma a uma: maçã, depois banana.';

  @override
  String get challengeFruitPatternExplanation =>
      'Depois da banana vem a maçã novamente, porque o padrão se repete.';

  @override
  String get challengeLockKeyTitle => 'Par mágico';

  @override
  String get challengeLockKeyPrompt => 'Escolha o objeto que forma um par.';

  @override
  String get challengeLockKeyQuestion =>
      'Uma chave abre alguma coisa. O que isso acompanha?';

  @override
  String get challengeLockKeyHint => 'Pense na finalidade de uma chave.';

  @override
  String get challengeLockKeyExplanation =>
      'Uma chave e uma fechadura funcionam juntas, formando um par.';

  @override
  String get challengeSpaceSequenceTitle => 'Rota espacial';

  @override
  String get challengeSpaceSequencePrompt =>
      'Encontre o próximo objeto espacial.';

  @override
  String get challengeSpaceSequenceQuestion =>
      'Foguete, planeta, foguete, planeta. O que vem a seguir?';

  @override
  String get challengeSpaceSequenceHint =>
      'A rota se repete: foguete, depois planeta.';

  @override
  String get challengeSpaceSequenceExplanation =>
      'Depois do planeta vem um foguete novamente.';

  @override
  String get challengeShapeStackTitle => 'Torre de forma';

  @override
  String get challengeShapeStackPrompt => 'Continue a regra da torre.';

  @override
  String get challengeShapeStackQuestion =>
      'Quadrado, círculo, quadrado, círculo. Qual forma é a próxima?';

  @override
  String get challengeShapeStackHint => 'A torre alterna entre duas formas.';

  @override
  String get challengeShapeStackExplanation =>
      'Depois de um círculo vem um quadrado novamente.';

  @override
  String get challengePathMazeTitle => 'Localizador de caminho';

  @override
  String get challengePathMazePrompt => 'Siga a estrada do início ao fim.';

  @override
  String get challengePathMazeQuestion =>
      'Ajude o herói a alcançar o objetivo. Qual caminho deveria seguir?';

  @override
  String get challengePathMazeHint =>
      'Trace a estrada do início ao fim e escolha a direção na bifurcação.';

  @override
  String get challengePathMazeExplanation =>
      'A estrada correta segue o caminho aberto até a meta.';

  @override
  String get lesson_001_title => 'Caminho de forma';

  @override
  String get lesson_002_title => 'Contagem de brinquedos';

  @override
  String get lesson_003_title => 'Saída de carta estranha';

  @override
  String get lesson_004_title => 'Trem lógico';

  @override
  String get lesson_005_title => 'Somas e linhas';

  @override
  String get lesson_006_title => 'Memória e códigos';

  @override
  String get lesson_007_title => 'Ponte numérica';

  @override
  String get lesson_008_title => 'Mapa detalhado';

  @override
  String get lesson_009_title => 'Sombras e equilíbrio';

  @override
  String get lesson_010_title => 'Adicionando e comparando';

  @override
  String get lesson_011_title => 'Curvas e caminhos';

  @override
  String get lesson_012_title => 'Memória e foco';

  @override
  String get lesson_013_title => 'Padrão de frutas';

  @override
  String get lesson_014_title => 'Estante de matemática';

  @override
  String get lesson_015_title => 'Torre de forma';

  @override
  String get lesson_016_title => 'Fechaduras e detalhes';

  @override
  String get lesson_017_title => 'Código e números';

  @override
  String get lesson_018_title => 'Sequência espacial';

  @override
  String get lesson_019_title => 'Concentre-se nas diferenças';

  @override
  String get lesson_020_title => 'Ponte de solução';

  @override
  String get lesson_021_title => 'Regras seguidas';

  @override
  String get lesson_022_title => 'Formas no espaço';

  @override
  String get lesson_023_title => 'Memória e contagem';

  @override
  String get lesson_024_title => 'Mistura final';

  @override
  String get lesson_025_title => 'Detetive de detalhes';

  @override
  String get lesson_026_title => 'Escalas e números';

  @override
  String get lesson_027_title => 'Uns e pares ímpares';

  @override
  String get lesson_028_title => 'Formas espaciais';

  @override
  String get lesson_029_title => 'Somas cuidadosas';

  @override
  String get lesson_030_title => 'Regra e código';

  @override
  String get lesson_031_title => 'Sombras, formas, memória';

  @override
  String get lesson_032_title => 'Números e detalhes';

  @override
  String get lesson_033_title => 'Cadeia de regras';

  @override
  String get lesson_034_title => 'O espaço gira';

  @override
  String get lesson_035_title => 'Rota de números grandes';

  @override
  String get lesson_036_title => 'Final do observador';

  @override
  String get lesson_037_title => 'Voltas e memória';

  @override
  String get lesson_038_title => 'Contando sprint';

  @override
  String get lesson_039_title => 'Regra e par';

  @override
  String get lesson_040_title => 'Torre espacial';

  @override
  String get lesson_041_title => 'Escalas e foco';

  @override
  String get lesson_042_title => 'Trem de código';

  @override
  String get lesson_043_title => 'Sombras e fechaduras';

  @override
  String get lesson_044_title => 'Números e memória';

  @override
  String get lesson_045_title => 'Corrente longa';

  @override
  String get lesson_046_title => 'Rota espacial';

  @override
  String get lesson_047_title => 'Somas e detalhes';

  @override
  String get lesson_048_title => 'Foco lógico';

  @override
  String get lesson_049_title => 'Formas de perto';

  @override
  String get lesson_050_title => 'Aritmética cuidadosa';

  @override
  String get lesson_051_title => 'Mestre de padrões';

  @override
  String get lesson_052_title => 'Sombras no espaço';

  @override
  String get lesson_053_title => 'Enigma numérico';

  @override
  String get lesson_054_title => 'Código do observador';

  @override
  String get lesson_055_title => 'Torre e chave';

  @override
  String get lesson_056_title => 'Detalhes e escalas';

  @override
  String get lesson_057_title => 'Regras mais difíceis';

  @override
  String get lesson_058_title => 'Final de forma';

  @override
  String get lesson_059_title => 'Tarefa de grande número';

  @override
  String get lesson_060_title => 'Supermix lógico';
}
