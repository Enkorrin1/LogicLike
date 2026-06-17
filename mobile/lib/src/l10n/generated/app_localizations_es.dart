// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'LogicLike';

  @override
  String get homeTab => 'Hogar';

  @override
  String get challengeTab => 'Búsqueda';

  @override
  String get parentTab => 'Padre';

  @override
  String homeGreeting(Object childName) {
    return 'Hola,\n$childName';
  }

  @override
  String get dailyStreakTitle => 'Racha diaria';

  @override
  String get streakStart => '¡Comenzar!';

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count d?as',
      one: '$count d?a',
    );
    return '$_temp0';
  }

  @override
  String dayCountShort(Object count) {
    return '$count d';
  }

  @override
  String get missionOpenButton => 'Abierto';

  @override
  String get missionStartShortButton => 'Comenzar';

  @override
  String get missionStartButton => 'Iniciar misión';

  @override
  String get homeMissionCompletedTitle => 'Misión\ncompleto!';

  @override
  String get homeMissionHelpTitle => 'Ayuda al astronauta\n¡Recoge estrellas!';

  @override
  String get dailyChallengeTag => 'Misión diaria';

  @override
  String get myProgressTitle => 'mi progreso';

  @override
  String levelLabel(Object level) {
    return 'Nivel $level';
  }

  @override
  String get myCollectionTitle => 'mi coleccion';

  @override
  String stickerCountLabel(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'pegatinas',
      one: 'pegatina',
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
      other: '$years a?os',
      one: '$years a?o',
    );
    return '$_temp0';
  }

  @override
  String get goalLogicLabel => 'Lógica';

  @override
  String get goalLogicDescription =>
      'Patrones, razonamiento y búsqueda de reglas.';

  @override
  String get goalMathLabel => 'Matemáticas';

  @override
  String get goalMathDescription => 'Números, conteo y soluciones cuidadosas.';

  @override
  String get goalAttentionLabel => 'Enfocar';

  @override
  String get goalAttentionDescription =>
      'Atención, memoria y comparación de detalles.';

  @override
  String get onboardingTitle => 'Configurar LogicLike';

  @override
  String get onboardingSubtitle =>
      'Cree un perfil familiar para que las misiones diarias coincidan con la edad y el objetivo del niño.';

  @override
  String get childNameLabel => 'nombre del niño';

  @override
  String get childNameError => 'Introduce un nombre';

  @override
  String get ageSectionTitle => 'Edad';

  @override
  String get learningGoalSectionTitle => 'Objetivo de aprendizaje';

  @override
  String get learningGoalShortTitle => 'Meta';

  @override
  String get startButton => 'Comenzar';

  @override
  String get savingButton => 'Ahorro';

  @override
  String get onboardingHeroTitle => 'Primer vuelo listo';

  @override
  String get parentTag => 'Padre';

  @override
  String get parentDashboardTitle => 'Centro familiar';

  @override
  String familyProfileSummary(
      Object ageLabel, Object childName, Object goalLabel) {
    return '$childName ? $ageLabel ? $goalLabel';
  }

  @override
  String get currentStreakMetric => 'racha';

  @override
  String get sessionsMetric => 'sesiones';

  @override
  String get minutesMetric => 'minutos';

  @override
  String get childrenProfilesTitle => 'Perfiles infantiles';

  @override
  String get addChildButton => 'Agregar niño';

  @override
  String childProgressChallengeCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count retos',
      one: '$count reto',
    );
    return '$_temp0';
  }

  @override
  String ageGoalSummary(Object ageLabel, Object goalLabel) {
    return '$ageLabel ? $goalLabel';
  }

  @override
  String get newChildTitle => 'Nuevo niño';

  @override
  String get cancelButton => 'Cancelar';

  @override
  String get addButton => 'Agregar';

  @override
  String get analyticsTitle => 'Practicar análisis';

  @override
  String get streakMetricLabel => 'Racha';

  @override
  String get bestStreakLabel => 'Mejor';

  @override
  String get last7DaysLabel => 'últimos 7 días';

  @override
  String get weeklyMinutesLabel => 'Minutos';

  @override
  String sessionsCountShort(Object count) {
    return '$count ses.';
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
  String get lastSkillLabel => 'última habilidad';

  @override
  String get lastSessionLabel => 'Última sesión';

  @override
  String get notAvailable => 'Aún no';

  @override
  String get weeklyRhythmTitle => 'Ritmo semanal';

  @override
  String get weeklyRhythmSubtitle => 'Practica días y minutos para cada día.';

  @override
  String get subscriptionTitle => 'Suscripción familiar';

  @override
  String get currentPlanLabel => 'Plan actual';

  @override
  String get familySeatsLabel => 'Asientos familiares';

  @override
  String get updatedLabel => 'Actualizado';

  @override
  String get recommendedLabel => 'Mejor valor';

  @override
  String get currentPlanButton => 'Plan actual';

  @override
  String get chooseButton => 'Elegir';

  @override
  String get resetProfilePanel =>
      'Restablezca el perfil local y ejecute la configuración nuevamente';

  @override
  String get resetButton => 'Reiniciar';

  @override
  String get resetDialogTitle => '¿Restablecer perfil?';

  @override
  String get resetDialogBody =>
      'La incorporación se abrirá nuevamente y se borrará el progreso local.';

  @override
  String get resetConfirmButton => 'Reiniciar';

  @override
  String get limitPaidMessage =>
      'Todos los asientos familiares ya están en uso.';

  @override
  String get limitStarterMessage =>
      'Hay más perfiles disponibles en el plan familiar.';

  @override
  String get planStarterLabel => 'Motor de arranque';

  @override
  String get planStarterPrice => '0 ₽';

  @override
  String get planStarterCapacity => '1 perfil infantil';

  @override
  String get planStarterDescription => 'Bucle diario corto y progreso local.';

  @override
  String get planMonthlyLabel => 'familia mensual';

  @override
  String get planMonthlyPrice => '399 ₽/mes';

  @override
  String get planFamilyCapacity => 'hasta 3 perfiles infantiles';

  @override
  String get planMonthlyDescription =>
      'Acceso completo, perfiles familiares y análisis de padres.';

  @override
  String get planAnnualLabel => 'Anual familiar';

  @override
  String get planAnnualPrice => '2990 ₽/año';

  @override
  String get planAnnualDescription =>
      'El mismo acceso, con mejor valor de facturación anual.';

  @override
  String get planActiveStatus => 'Activo';

  @override
  String get planInactiveStatus => 'No activo';

  @override
  String get missionCompletedTitle => '¡Misión completa!';

  @override
  String childGoCta(Object childName) {
    return '?$childName, vamos!';
  }

  @override
  String get chooseAnswerTitle => 'Elige una respuesta';

  @override
  String get checkingButton => 'Ahorro';

  @override
  String get checkAnswerButton => 'Controlar';

  @override
  String answerCorrect(Object explanation) {
    return '?Correcto! $explanation';
  }

  @override
  String answerAlmost(Object hint) {
    return 'Casi. $hint';
  }

  @override
  String get challengeCompletedToday => 'La misión de hoy está completa.';

  @override
  String get weekdayMondayShort => 'Lun';

  @override
  String get weekdayTuesdayShort => 'Mar';

  @override
  String get weekdayWednesdayShort => 'Casarse';

  @override
  String get weekdayThursdayShort => 'Jue';

  @override
  String get weekdayFridayShort => 'Vie';

  @override
  String get weekdaySaturdayShort => 'Se sentó';

  @override
  String get weekdaySundayShort => 'Sol';

  @override
  String get skillPatterns => 'Patrones';

  @override
  String get skillCountingToFive => 'contando hasta cinco';

  @override
  String get skillComparison => 'Comparación';

  @override
  String get skillSequences => 'Secuencias';

  @override
  String get skillAdditionToTen => 'Suma a diez';

  @override
  String get skillWorkingMemory => 'memoria de trabajo';

  @override
  String get skillLogicDeduction => 'Lógica y deducción';

  @override
  String get skillMathThinking => 'pensamiento matemático';

  @override
  String get skillDetailComparison => 'Comparación detallada';

  @override
  String get challengeShapePathTitle => 'Camino de forma';

  @override
  String get challengeShapePathPrompt =>
      'Mira la fila y encuentra lo que viene a continuación.';

  @override
  String get challengeShapePathQuestion =>
      'Círculo, cuadrado, círculo, cuadrado. ¿Qué viene después?';

  @override
  String get challengeShapePathHint =>
      'Las formas se alternan: una forma, luego la otra, luego otra vez la primera.';

  @override
  String get challengeShapePathExplanation =>
      'Después del cuadrado vuelve a aparecer un círculo, porque la fila se repite cada dos formas.';

  @override
  String get challengeToyCountTitle => 'recuento de juguetes';

  @override
  String get challengeToyCountPrompt =>
      'Cuenta los objetos y elige la respuesta exacta.';

  @override
  String get challengeToyCountQuestion =>
      'Hay 2 bloques y 1 bola en el estante. ¿Cuantos juguetes hay?';

  @override
  String get challengeToyCountHint =>
      'Primero cuenta los bloques y luego agrega la pelota.';

  @override
  String get challengeToyCountExplanation =>
      '2 bloques y 1 pelota forman 3 juguetes en total.';

  @override
  String get challengeOddCardTitle => 'Tarjeta impar';

  @override
  String get challengeOddCardPrompt =>
      'Encuentra el artículo que es diferente de los demás.';

  @override
  String get challengeOddCardQuestion =>
      'Manzana, pera, pelota, plátano. ¿Cuál no pertenece?';

  @override
  String get challengeOddCardHint =>
      'Se pueden comer tres artículos y uno es para jugar.';

  @override
  String get challengeOddCardExplanation =>
      'La pelota no pertenece: la manzana, la pera y el plátano son frutas.';

  @override
  String get challengeLogicTrainTitle => 'tren logico';

  @override
  String get challengeLogicTrainPrompt =>
      'Coloca los vagones del tren según la regla.';

  @override
  String get challengeLogicTrainQuestion =>
      'Rojo, azul, azul, rojo, azul, azul. ¿Qué viene después?';

  @override
  String get challengeLogicTrainHint =>
      'La regla se repite en grupos de tres: uno rojo y dos azules.';

  @override
  String get challengeLogicTrainExplanation =>
      'El siguiente coche es rojo: después de dos coches azules, comienza un nuevo grupo.';

  @override
  String get challengeStickerSumTitle => 'Álbum de pegatinas';

  @override
  String get challengeStickerSumPrompt =>
      'Agrega dos pequeños grupos de objetos.';

  @override
  String get challengeStickerSumQuestion =>
      'Nika tenía 3 pegatinas y luego recibió 2 más. ¿Cuantos tiene ella ahora?';

  @override
  String get challengeStickerSumHint =>
      'Comienza con tres y cuenta dos pasos más.';

  @override
  String get challengeStickerSumExplanation =>
      '3 + 2 = 5, entonces tiene cinco pegatinas.';

  @override
  String get challengeMemoryPairsTitle => 'Pares de memoria';

  @override
  String get challengeMemoryPairsPrompt =>
      'Recuerde el par correspondiente para cada artículo.';

  @override
  String get challengeMemoryPairsQuestion => '¿Qué va con una llave?';

  @override
  String get challengeMemoryPairsHint =>
      'Una llave se utiliza para abrir algo.';

  @override
  String get challengeMemoryPairsExplanation =>
      'Una llave va con una cerradura: juntas forman una pareja significativa.';

  @override
  String get challengeCodeGridTitle => 'Cuadrícula de código';

  @override
  String get challengeCodeGridPrompt =>
      'Resuelve la regla y elige la celda correcta.';

  @override
  String get challengeCodeGridQuestion =>
      'La primera fila es 2, 4, 6. La segunda es 3, 5, ?. ¿Qué número falta?';

  @override
  String get challengeCodeGridHint =>
      'Los números de la segunda fila también crecen en 2.';

  @override
  String get challengeCodeGridExplanation =>
      'Después del 3 y el 5 viene el 7: cada paso suma dos.';

  @override
  String get challengeNumberBridgeTitle => 'Puente numérico';

  @override
  String get challengeNumberBridgePrompt =>
      'Conecta los números para construir la ruta correcta.';

  @override
  String get challengeNumberBridgeQuestion =>
      'Tienes 4, 2 y 1. ¿Cómo puedes formar 7?';

  @override
  String get challengeNumberBridgeHint =>
      'Intenta usar todos los números una vez.';

  @override
  String get challengeNumberBridgeExplanation =>
      '4 + 2 + 1 = 7, por lo que los tres números juntos forman el objetivo.';

  @override
  String get challengeDetailCountTitle => 'Mapa detallado';

  @override
  String get challengeDetailCountPrompt =>
      'Tenga en cuenta varios detalles y compárelos.';

  @override
  String get challengeDetailCountQuestion =>
      'Hay 3 círculos rojos, 2 cuadrados azules y 1 estrella verde. ¿Qué grupo tiene más?';

  @override
  String get challengeDetailCountHint => 'Compara las cantidades: 3, 2 y 1.';

  @override
  String get challengeDetailCountExplanation =>
      'Los círculos rojos son los más: hay tres.';

  @override
  String get challengeMemoryRecallTitle => 'recuerda las cartas';

  @override
  String get challengeMemoryRecallPrompt =>
      'Mira la fila y encuentra la carta oculta.';

  @override
  String get challengeMemoryRecallQuestion => '¿Qué tarjeta está oculta?';

  @override
  String get challengeMemoryRecallHint =>
      'Recuerda los objetos de izquierda a derecha y marca el último.';

  @override
  String get challengeMemoryRecallExplanation =>
      'La carta oculta estaba en la fila que debías recordar.';

  @override
  String get challengeSortingRuleTitle => 'regla de caja';

  @override
  String get challengeSortingRulePrompt =>
      'Encuentra el objeto que pertenece a los demás.';

  @override
  String get challengeSortingRuleQuestion => '¿Qué sigue la misma regla?';

  @override
  String get challengeSortingRuleHint =>
      'Primero encuentra qué tienen en común los objetos de la caja.';

  @override
  String get challengeSortingRuleExplanation =>
      'El objeto correcto coincide con la regla de la caja.';

  @override
  String get challengeMissingPieceTitle => 'pieza faltante';

  @override
  String get challengeMissingPiecePrompt =>
      'Elige la parte que completa el cuadro.';

  @override
  String get challengeMissingPieceQuestion =>
      '¿Qué pieza encaja en el lugar vacío?';

  @override
  String get challengeMissingPieceHint =>
      'Compara la forma vacía con las opciones de respuesta.';

  @override
  String get challengeMissingPieceExplanation =>
      'Esta pieza completa el cuadro sin esquinas adicionales.';

  @override
  String get challengeLogicDeductionTitle => 'Dos pistas';

  @override
  String get challengeLogicDeductionPrompt =>
      'Utilice ambas pistas y elimine las opciones incorrectas.';

  @override
  String get challengeLogicDeductionQuestion => '¿Qué coincide con cada pista?';

  @override
  String get challengeLogicDeductionHint =>
      'Cada pista elimina al menos una elección incorrecta.';

  @override
  String get challengeLogicDeductionExplanation =>
      'La respuesta correcta coincide con ambas pistas.';

  @override
  String get choiceTriangle => 'Triángulo';

  @override
  String get choiceCircle => 'Círculo';

  @override
  String get choiceStar => 'Estrella';

  @override
  String get choiceApple => 'Manzana';

  @override
  String get choiceBall => 'Pelota';

  @override
  String get choiceBanana => 'Banana';

  @override
  String get choiceBlue => 'Azul';

  @override
  String get choiceRed => 'Rojo';

  @override
  String get choiceGreen => 'Verde';

  @override
  String get choiceKey => 'Llave';

  @override
  String get choiceLock => 'Cerrar';

  @override
  String get choiceShoe => 'Zapato';

  @override
  String get choiceCloud => 'Nube';

  @override
  String get choiceBlueSquares => 'Cuadrados azules';

  @override
  String get choiceRedCircles => 'circulos rojos';

  @override
  String get choiceGreenStars => 'estrellas verdes';

  @override
  String mapLessonTitle(Object lesson) {
    return 'Lecci?n $lesson';
  }

  @override
  String get mapLessonSubtitle =>
      'Lógica, conteo y concentración en una breve lección';

  @override
  String get mapStartButton => 'Comenzar';

  @override
  String get mapNodeStart => 'Comenzar';

  @override
  String get mapNodeShapes => 'formas';

  @override
  String get mapNodePairs => 'Pares';

  @override
  String get mapNodeCounting => 'Cálculo';

  @override
  String get mapNodePath => 'Camino';

  @override
  String get mapNodeRhythm => 'Ritmo';

  @override
  String get mapNodeCompare => 'Comparar';

  @override
  String get mapNodeFinal => 'Final';

  @override
  String get mapNodeCompleted => 'hecho';

  @override
  String get mapNodeCurrent => 'abierto';

  @override
  String get mapNodeLocked => 'bloqueado';

  @override
  String mapPreviewTitle(Object lesson) {
    return 'Lecci?n $lesson';
  }

  @override
  String mapPreviewSteps(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pasos',
      one: '$count paso',
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
      other: '$count corazones',
      one: '$count coraz?n',
    );
    return '$_temp0';
  }

  @override
  String get mapPreviewBody =>
      'Una breve lección con acertijos mixtos: lógica, conteo, comparación y concentración.';

  @override
  String get mapPreviewStart => 'Iniciar lección';

  @override
  String get mapPreviewClose => 'Más tarde';

  @override
  String lessonProgress(Object current, Object total) {
    return 'Paso $current de $total';
  }

  @override
  String get lessonNextButton => 'Próximo';

  @override
  String get lessonFinishButton => 'terminar la lección';

  @override
  String get lessonCompleteTitle => '¡Lección completa!';

  @override
  String get lessonCompleteBody =>
      'Desbloqueaste el siguiente paso en el mapa.';

  @override
  String get lessonRewardStars => '+1 estrella';

  @override
  String lessonRewardXp(Object xp) {
    return '+$xp XP';
  }

  @override
  String get lessonBackToMap => 'De vuelta a casa';

  @override
  String get courseCatalogTitle => 'Cursos y rompecabezas';

  @override
  String get courseLogicTitle => 'Lógica';

  @override
  String get courseLogicSubtitle => 'Reglas, extraños y razonamiento';

  @override
  String get courseMathTitle => 'Matemáticas';

  @override
  String get courseMathSubtitle => 'Contar, sumas y comparación.';

  @override
  String get courseSpatialTitle => 'formas';

  @override
  String get courseSpatialSubtitle => 'Forma, caminos y espacio.';

  @override
  String get courseAttentionTitle => 'Enfocar';

  @override
  String get courseAttentionSubtitle => 'Detalles, memoria y atención.';

  @override
  String get courseRebusTitle => 'Rebuses';

  @override
  String get courseRebusSubtitle => 'Imágenes, palabras y acertijos.';

  @override
  String get courseMixedTitle => 'Mezcla diaria';

  @override
  String get courseMixedSubtitle => 'Diferentes rompecabezas seguidos';

  @override
  String progressCardBody(Object level, Object stars) {
    return 'Nivel $level ? $stars estrellas';
  }

  @override
  String collectionCardBody(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pegatinas',
      one: '$count pegatina',
    );
    return '$_temp0';
  }

  @override
  String get dailyMissionBody =>
      'Un breve conjunto de acertijos de lógica, conteo y concentración.';

  @override
  String get openCourseButton => 'Abierto';

  @override
  String courseProgress(Object completed, Object total) {
    return '$completed de $total lecciones completadas';
  }

  @override
  String courseLessonTitle(Object lesson) {
    return 'Lecci?n $lesson';
  }

  @override
  String courseLessonMeta(num steps, Object xp) {
    String _temp0 = intl.Intl.pluralLogic(
      steps,
      locale: localeName,
      other: '$steps pasos',
      one: '$steps paso',
    );
    return '$_temp0 ? +$xp XP';
  }

  @override
  String get courseStartLessonButton => 'Comenzar';

  @override
  String get courseRepeatButton => 'Repetir';

  @override
  String get showHintButton => 'Pista';

  @override
  String get hideHintButton => 'Ocultar pista';

  @override
  String get lessonStickerUnlockedTitle => '¡Nueva pegatina!';

  @override
  String get lessonStickerUnlockedBody =>
      'Tu colección creció después de la lección.';

  @override
  String get lessonRewardCollection => '+1 pegatina';

  @override
  String get lessonRewardStreak => 'La racha crece';

  @override
  String get challengeShadowMatchTitle => 'Partido de sombras';

  @override
  String get challengeShadowMatchPrompt =>
      'Encuentra el objeto que se ajuste a la sombra.';

  @override
  String get challengeShadowMatchQuestion =>
      'La sombra tiene un cuerpo alto y dos alas pequeñas. ¿Qué es?';

  @override
  String get challengeShadowMatchHint => 'Mire todo el contorno del objeto.';

  @override
  String get challengeShadowMatchExplanation =>
      'El cohete hace juego con la sombra: tiene un cuerpo alto y dos alas laterales.';

  @override
  String get challengeBalanceScaleTitle => 'balanza';

  @override
  String get challengeBalanceScalePrompt =>
      'Compara los lados y elige lo que falta.';

  @override
  String get challengeBalanceScaleQuestion =>
      'El lado izquierdo tiene 2 manzanas. El lado derecho tiene 1 manzana y ?. ¿Qué deberías agregar?';

  @override
  String get challengeBalanceScaleHint =>
      'Ambos lados necesitan la misma cantidad de manzanas.';

  @override
  String get challengeBalanceScaleExplanation =>
      'Una manzana más iguala el lado derecho al izquierdo: 2 y 2.';

  @override
  String get challengeShapeRotationTitle => 'Giro de forma';

  @override
  String get challengeShapeRotationPrompt => 'Imagina la forma dando vueltas.';

  @override
  String get challengeShapeRotationQuestion =>
      'Un triángulo gira hacia la derecha. ¿Qué carta muestra la misma forma?';

  @override
  String get challengeShapeRotationHint =>
      'Al girar se cambia de dirección, pero no de forma misma.';

  @override
  String get challengeShapeRotationExplanation =>
      'Es el mismo triángulo: giró, pero no adquirió otra forma.';

  @override
  String get choiceRocket => 'Cohete';

  @override
  String get choicePlanet => 'Planeta';

  @override
  String get choiceSameTriangle => 'Mismo triangulo';

  @override
  String get choiceSquare => 'Cuadrado';

  @override
  String get skillInsightsTitle => 'Habilidades y recomendaciones.';

  @override
  String get strongestAreaLabel => 'zona fuerte';

  @override
  String get practiceFocusLabel => 'Área de enfoque';

  @override
  String get recommendedPracticeLabel => 'Practica a continuación';

  @override
  String get noSkillDataLabel => 'Aún no hay suficientes datos';

  @override
  String get recommendationKeepGoing =>
      'Continúe impartiendo lecciones breves: las recomendaciones se vuelven más precisas después de algunas sesiones.';

  @override
  String get recommendationPracticeFocus =>
      'Agregue 1 o 2 lecciones breves para esta área durante la semana.';

  @override
  String get courseNextMetricLabel => 'Próximo';

  @override
  String get courseStarsMetricLabel => 'estrellas';

  @override
  String get courseXpMetricLabel => 'experiencia';

  @override
  String get courseCompletedState => 'hecho';

  @override
  String get courseOpenState => 'abierto';

  @override
  String get courseLockedState => 'bloqueado';

  @override
  String get collectionScreenTitle => 'Colección de pegatinas';

  @override
  String get collectionScreenSubtitle =>
      'Obtenga recompensas completando lecciones y manteniendo la práctica.';

  @override
  String collectionUnlockedCount(Object total, Object unlocked) {
    return '$unlocked de $total desbloqueados';
  }

  @override
  String get collectionNextReward => 'Próxima recompensa';

  @override
  String get collectionAllRewardsUnlocked =>
      'Todas las recompensas desbloqueadas';

  @override
  String get collectionBackHome => 'De vuelta a casa';

  @override
  String collectionLockedHint(Object stars) {
    return 'Se desbloquea tras $stars estrellas';
  }

  @override
  String get rewardAstronautTitle => 'Ayudante estrella';

  @override
  String get rewardAstronautBody => 'Por terminar la primera misión.';

  @override
  String get rewardRocketTitle => 'Cohete valiente';

  @override
  String get rewardRocketBody => 'Por abrir un curso de aprendizaje.';

  @override
  String get rewardPlanetTitle => 'Pequeño planeta';

  @override
  String get rewardPlanetBody => 'Por completar dos lecciones.';

  @override
  String get rewardLionTitle => 'león lógico';

  @override
  String get rewardLionBody => 'Por construir una racha de práctica.';

  @override
  String get rewardPuzzleTitle => 'Insignia de rompecabezas';

  @override
  String get rewardPuzzleBody => 'Para resolver acertijos mixtos.';

  @override
  String get rewardChampionTitle => 'Campeón espacial';

  @override
  String get rewardChampionBody => 'Para una práctica semanal constante.';

  @override
  String get accuracyMetricLabel => 'Exactitud';

  @override
  String get hintsMetricLabel => 'Consejos';

  @override
  String recommendationImproveAccuracy(Object skill) {
    return 'Practica $skill despacio esta semana: la precisi?n es la se?al principal.';
  }

  @override
  String recommendationReduceHints(Object skill) {
    return 'Repite $skill con menos pistas: pausa antes de abrir la ayuda.';
  }

  @override
  String recommendationRepeatAttempts(Object skill) {
    return 'Dale a $skill una sesi?n corta m?s para reducir errores.';
  }

  @override
  String get homeRecommendedLessonTitle => 'Próxima lección';

  @override
  String get homeRecommendedLessonSubtitle =>
      'Próxima lección breve sobre la ruta de aprendizaje.';

  @override
  String get homeRecommendedLessonButton => 'Continuar';

  @override
  String get homeRecommendedLessonCompleted => 'Ruta completa';

  @override
  String get lessonReviewTitle => 'Resumen de la lección';

  @override
  String get lessonReviewPerfectBody => 'Gran enfoque: sin pistas ni errores.';

  @override
  String get lessonReviewSupportBody =>
      'Buen acabado. La próxima vez intente un paso con menos ayuda.';

  @override
  String get lessonReviewQuestionsLabel => 'Preguntas';

  @override
  String get lessonReviewHintsLabel => 'Consejos';

  @override
  String get lessonReviewMistakesLabel => 'Errores';

  @override
  String get lessonNextRecommendedButton => 'Próxima lección';

  @override
  String get practiceHistoryTitle => 'Historia de la practica';

  @override
  String get practiceHistorySubtitle =>
      'Lecciones recientes con precisión, sugerencias y errores.';

  @override
  String get practiceHistoryEmpty => 'Aún no hay lecciones completadas.';

  @override
  String practiceHistorySessionMeta(Object date, Object minutes) {
    return '$date - $minutes min';
  }

  @override
  String get practiceHistoryMistakesLabel => 'Errores';

  @override
  String get lessonTryAgainButton => 'Intentar otra vez';

  @override
  String get lessonHintTitle => 'Piensa paso a paso';

  @override
  String get lessonRetryFeedback =>
      'Buen intento. Lea la pista y luego elija nuevamente.';

  @override
  String get languageSettingsTitle => 'Idioma de la aplicación';

  @override
  String get languageSettingsSubtitle =>
      'Elija el idioma para las pantallas infantiles y parentales.';

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
  String get challengeFruitPatternTitle => 'fila de frutas';

  @override
  String get challengeFruitPatternPrompt => 'Continúe el patrón de frutas.';

  @override
  String get challengeFruitPatternQuestion =>
      'Manzana, plátano, manzana, plátano. ¿Qué viene después?';

  @override
  String get challengeFruitPatternHint =>
      'Las frutas se repiten una a una: manzana, luego plátano.';

  @override
  String get challengeFruitPatternExplanation =>
      'Después del plátano viene nuevamente la manzana, porque el patrón se repite.';

  @override
  String get challengeLockKeyTitle => 'par magico';

  @override
  String get challengeLockKeyPrompt => 'Elige el objeto que forma un par.';

  @override
  String get challengeLockKeyQuestion => 'Una llave abre algo. ¿Con qué va?';

  @override
  String get challengeLockKeyHint => 'Piense en para qué se utiliza una clave.';

  @override
  String get challengeLockKeyExplanation =>
      'Una llave y una cerradura funcionan juntas, por lo que forman la pareja.';

  @override
  String get challengeSpaceSequenceTitle => 'Ruta espacial';

  @override
  String get challengeSpaceSequencePrompt =>
      'Encuentra el siguiente objeto espacial.';

  @override
  String get challengeSpaceSequenceQuestion =>
      'Cohete, planeta, cohete, planeta. ¿Qué viene después?';

  @override
  String get challengeSpaceSequenceHint =>
      'La ruta se repite: cohete, luego planeta.';

  @override
  String get challengeSpaceSequenceExplanation =>
      'Después del planeta vuelve a aparecer un cohete.';

  @override
  String get challengeShapeStackTitle => 'Torre de forma';

  @override
  String get challengeShapeStackPrompt => 'Continúa la regla de la torre.';

  @override
  String get challengeShapeStackQuestion =>
      'Cuadrado, círculo, cuadrado, círculo. ¿Qué forma es la siguiente?';

  @override
  String get challengeShapeStackHint => 'La torre alterna entre dos formas.';

  @override
  String get challengeShapeStackExplanation =>
      'Después de un círculo viene nuevamente un cuadrado.';

  @override
  String get challengePathMazeTitle => 'Buscador de camino';

  @override
  String get challengePathMazePrompt => 'Sigue el camino de principio a fin.';

  @override
  String get challengePathMazeQuestion =>
      'Ayuda al héroe a alcanzar la meta. ¿Hacia dónde debería ir?';

  @override
  String get challengePathMazeHint =>
      'Traza el camino de principio a fin y elige la dirección en la bifurcación.';

  @override
  String get challengePathMazeExplanation =>
      'El camino correcto sigue el camino abierto hacia la meta.';

  @override
  String get lesson_001_title => 'Camino de forma';

  @override
  String get lesson_002_title => 'conteo de juguetes';

  @override
  String get lesson_003_title => 'Tarjeta impar';

  @override
  String get lesson_004_title => 'tren logico';

  @override
  String get lesson_005_title => 'Sumas y filas';

  @override
  String get lesson_006_title => 'Memoria y códigos';

  @override
  String get lesson_007_title => 'Puente numérico';

  @override
  String get lesson_008_title => 'Mapa detallado';

  @override
  String get lesson_009_title => 'Sombras y equilibrio';

  @override
  String get lesson_010_title => 'Sumar y comparar';

  @override
  String get lesson_011_title => 'Giros y caminos';

  @override
  String get lesson_012_title => 'Memoria y concentración';

  @override
  String get lesson_013_title => 'Patrón de frutas';

  @override
  String get lesson_014_title => 'estante de matemáticas';

  @override
  String get lesson_015_title => 'Torre de forma';

  @override
  String get lesson_016_title => 'Cerraduras y detalles';

  @override
  String get lesson_017_title => 'Código y números';

  @override
  String get lesson_018_title => 'secuencia espacial';

  @override
  String get lesson_019_title => 'Centrarse en las diferencias';

  @override
  String get lesson_020_title => 'Puente de solución';

  @override
  String get lesson_021_title => 'Reglas seguidas';

  @override
  String get lesson_022_title => 'Formas en el espacio';

  @override
  String get lesson_023_title => 'Memoria y conteo';

  @override
  String get lesson_024_title => 'mezcla final';

  @override
  String get lesson_025_title => 'Detective de detalle';

  @override
  String get lesson_026_title => 'Escalas y números';

  @override
  String get lesson_027_title => 'Los impares y los pares';

  @override
  String get lesson_028_title => 'Formas espaciales';

  @override
  String get lesson_029_title => 'sumas cuidadosas';

  @override
  String get lesson_030_title => 'Regla y código';

  @override
  String get lesson_031_title => 'Sombras, formas, memoria.';

  @override
  String get lesson_032_title => 'Números y detalles';

  @override
  String get lesson_033_title => 'Cadena de reglas';

  @override
  String get lesson_034_title => 'El espacio gira';

  @override
  String get lesson_035_title => 'Ruta de los grandes números';

  @override
  String get lesson_036_title => 'Final del observador';

  @override
  String get lesson_037_title => 'Turnos y memoria';

  @override
  String get lesson_038_title => 'sprint de conteo';

  @override
  String get lesson_039_title => 'Regla y pareja';

  @override
  String get lesson_040_title => 'torre espacial';

  @override
  String get lesson_041_title => 'Escalas y enfoque';

  @override
  String get lesson_042_title => 'tren de código';

  @override
  String get lesson_043_title => 'Sombras y cerraduras';

  @override
  String get lesson_044_title => 'Números y memoria';

  @override
  String get lesson_045_title => 'cadena larga';

  @override
  String get lesson_046_title => 'Ruta espacial';

  @override
  String get lesson_047_title => 'Sumas y detalles';

  @override
  String get lesson_048_title => 'Enfoque lógico';

  @override
  String get lesson_049_title => 'Formas de cerca';

  @override
  String get lesson_050_title => 'Aritmética cuidadosa';

  @override
  String get lesson_051_title => 'Maestro de patrones';

  @override
  String get lesson_052_title => 'Sombras en el espacio';

  @override
  String get lesson_053_title => 'acertijo numérico';

  @override
  String get lesson_054_title => 'código de observador';

  @override
  String get lesson_055_title => 'Torre y llave';

  @override
  String get lesson_056_title => 'Detalles y escalas';

  @override
  String get lesson_057_title => 'Reglas más duras';

  @override
  String get lesson_058_title => 'Final de forma';

  @override
  String get lesson_059_title => 'Tarea de números grandes';

  @override
  String get lesson_060_title => 'supermezcla lógica';
}
