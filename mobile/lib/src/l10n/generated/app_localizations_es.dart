// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'LogicUpX';

  @override
  String get loadingMission => 'Preparando la misión...';

  @override
  String get navHome => 'Hogar';

  @override
  String get navChallenge => 'Tarea';

  @override
  String get navParent => 'Padre';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonReset => 'Reiniciar';

  @override
  String languageChanged(Object language) {
    return 'Idioma: $language';
  }

  @override
  String languageButtonSemantics(Object language) {
    return 'Cambiar idioma. Actual: $language';
  }

  @override
  String get onboardingSubmitSaving => 'Preparando ruta';

  @override
  String get onboardingSubmitCreateHero => 'Crear héroe';

  @override
  String get onboardingDefaultHero => 'joven héroe';

  @override
  String get onboardingTitle => 'crear un héroe';

  @override
  String onboardingHeroSummary(Object age, Object name) {
    return '$name, $age';
  }

  @override
  String get onboardingSubtitle =>
      'El león mostrará la misión diaria y luego su hijo podrá elegir el entrenamiento cerebral.';

  @override
  String get childNameLabel => 'nombre del niño';

  @override
  String get childNameError => 'Introduce el nombre del héroe';

  @override
  String get onboardingMissionPill => 'inicio de la misión';

  @override
  String get onboardingAgeTitle => 'Edad del héroe';

  @override
  String get unlockMission => 'Misión';

  @override
  String get unlockGames => 'Juegos';

  @override
  String get unlockPrizes => 'Premios';

  @override
  String ageYears(int years) {
    return '$years años';
  }

  @override
  String homeGreeting(Object name) {
    return 'Hola,\n$name';
  }

  @override
  String get homeStarsHint =>
      'Las estrellas crecen a partir de misiones y desbloquean nuevos premios.';

  @override
  String get homeLockedLevelHint =>
      'Este nivel se abre después de nuevas estrellas.';

  @override
  String get homeStreakSavedHint =>
      '¡Racha salvada! Mañana llega una nueva misión.';

  @override
  String get homeStreakNeedMissionHint =>
      'Completa la misión diaria para salvar la racha.';

  @override
  String get homeStreakTitle => 'Racha diaria';

  @override
  String homeStreakDays(int days) {
    return '¡$days días seguidos!';
  }

  @override
  String get homeStreakWaiting => 'la misión está esperando';

  @override
  String get homeMissionDaily => 'Misión diaria';

  @override
  String get homeMissionFreePlay => 'juego libre';

  @override
  String get homeTrainingOpen => 'La formación está abierta.';

  @override
  String homeLevel(int level) {
    return 'Nivel $level';
  }

  @override
  String get homeMissionStart => 'Comenzar';

  @override
  String get homeMissionChoose => 'Elegir';

  @override
  String get homeMissionTag => 'Misión principal';

  @override
  String get homeFreePlayTitle => 'Juega tú mismo';

  @override
  String get homeFreePlaySubtitle => 'elige un héroe y entrena tu cerebro';

  @override
  String get homeMiniGamesTitle => 'Minijuegos';

  @override
  String get homeMiniGamesSubtitle => 'entrenamiento rápido después de niveles';

  @override
  String get homeQuickPairs => 'Pares';

  @override
  String get homeQuickPath => 'Camino';

  @override
  String get homeQuickCount => 'Contar';

  @override
  String get homeProgressTitle => 'mi progreso';

  @override
  String homeProgressStars(int current, int total) {
    return 'Estrellas $current / $total';
  }

  @override
  String get homeCollectionTitle => 'Recopilación';

  @override
  String get homeCollectionStickers => 'pegatinas';

  @override
  String get homeLevelsTitle => 'Niveles';

  @override
  String get homeLevelsSubtitle => '8 temas de formación, no un calendario';

  @override
  String get homeNodeCompleted => 'hecho';

  @override
  String get homeNodePlay => 'jugar';

  @override
  String get homeNodeSoon => 'pronto';

  @override
  String get homeMapStart => 'Comenzar';

  @override
  String get homeMapShapes => 'formas';

  @override
  String get homeMapPairs => 'Pares';

  @override
  String get homeMapCount => 'Contar';

  @override
  String get homeMapPath => 'Camino';

  @override
  String get homeMapRhythm => 'Ritmo';

  @override
  String get homeMapCompare => 'Comparar';

  @override
  String get homeMapFinal => 'Final';

  @override
  String get parentTitle => 'Área de padres';

  @override
  String get parentIntroTitle => 'Zona tranquila para adultos.';

  @override
  String get parentIntroBody =>
      'El perfil, el progreso, el idioma y la suscripción futura se encuentran separados de la misión infantil.';

  @override
  String get parentProfileTitle => 'Perfil familiar';

  @override
  String get parentLocalBadge => 'local';

  @override
  String get parentChildLabel => 'Niño';

  @override
  String get parentAgeLabel => 'Edad';

  @override
  String get parentCompletedTasksLabel => 'Tareas completadas';

  @override
  String get parentLanguageLabel => 'Idioma';

  @override
  String get settingsLanguage => 'Idioma de la aplicación';

  @override
  String get parentSubscriptionTitle => 'Suscripción familiar';

  @override
  String get parentSubscriptionSoon => 'pronto';

  @override
  String get parentSubscriptionBody =>
      'Aquí aparecerán el estado de pago, los asientos familiares y la gestión del plan.';

  @override
  String get parentFamilySeatsLabel => 'Asientos familiares';

  @override
  String get parentFamilySeatsValue => 'planificado';

  @override
  String get parentPaymentLabel => 'Pago';

  @override
  String get parentPaymentValue => 'no conectado';

  @override
  String get parentResetProfile => 'Restablecer perfil';

  @override
  String get parentResetTitle => '¿Restablecer perfil?';

  @override
  String get parentResetBody =>
      'La incorporación se abrirá nuevamente y se borrará el progreso local.';

  @override
  String get challengeTitle => 'juegos mentales';

  @override
  String get challengeDayDone => 'dia completo';

  @override
  String get challengeDailyMission => 'Misión diaria';

  @override
  String get challengeDayDoneBody =>
      'Recompensa recibida. Puedes repetir o jugar libremente.';

  @override
  String get challengeDailyBody =>
      'Completa 3 pasos para salvar la racha y recoger el premio.';

  @override
  String get challengePrize => 'premio';

  @override
  String get challengeMissionProgress => 'Progreso de la misión';

  @override
  String countOfTotal(int count, int total) {
    return '$count de $total';
  }

  @override
  String get challengeRepeatMission => 'Repetir misión';

  @override
  String challengeStepsTraining(int steps) {
    return 'Pasos $steps para el entrenamiento.';
  }

  @override
  String challengeStepNumber(int step) {
    return 'Paso $step';
  }

  @override
  String get challengeAgain => 'de nuevo';

  @override
  String minutesShort(int minutes) {
    return '$minutes mín.';
  }

  @override
  String get challengeBrainGymTitle => 'gimnasio cerebral';

  @override
  String challengeBrainGymSubtitle(int count) {
    return 'Zonas $count, juega en cualquier orden.';
  }

  @override
  String challengeAreaLevels(int done, int total) {
    return 'Niveles $done/$total';
  }

  @override
  String challengeAreaCompleted(int done, int total) {
    return '$done de $total completo';
  }

  @override
  String get challengeStateCompleted => 'hecho';

  @override
  String get challengeStateNext => 'próximo';

  @override
  String get challengeStatePlay => 'jugar';

  @override
  String challengeLevelNumber(int level) {
    return 'Nivel $level';
  }

  @override
  String get challengeHideHint => 'Ocultar pista';

  @override
  String get challengeShowHint => 'Mostrar pista';

  @override
  String get challengeDailyTaskTitle => 'Tarea diaria';

  @override
  String get challengePuzzleTaskTitle => 'Rompecabezas';

  @override
  String get challengeDailyPath => 'Camino diario';

  @override
  String get challengeFreePlay => 'juego libre';

  @override
  String get challengeExcellent => '¡Excelente!';

  @override
  String get challengeFlyNext => 'Volando a continuación';

  @override
  String get challengeAllDone => 'Listo';

  @override
  String get challengePlayMore => 'Juega más';

  @override
  String get challengeMyCollection => 'mi coleccion';

  @override
  String get challengeDailyCompleteTitle => '¡Misión diaria completada!';

  @override
  String get challengeDailyCompleteBody =>
      'Terminaste todos los pasos. Recoge el premio y juega libremente.';

  @override
  String get challengeRewardStars => 'estrellas';

  @override
  String get challengeRewardStreak => 'racha';

  @override
  String get challengeRewardSteps => 'pasos';

  @override
  String get challengeWhatNextTitle => '¿Qué sigue?';

  @override
  String get challengeWhatNextBody =>
      'Elige un héroe: lógica, memoria, atención, conteo o camino.';

  @override
  String challengeProgressStep(int current, int total) {
    return 'Paso $current de $total';
  }

  @override
  String get challengeChooseAnswer => 'Elige una respuesta';

  @override
  String challengeSelectedAnswer(Object answer) {
    return 'Respuesta: $answer';
  }

  @override
  String get challengePickDifferentAnswer => 'Elige otra respuesta';

  @override
  String get challengeCorrectAnswer => '¡Correcto!';

  @override
  String get challengeChecking => 'De cheques';

  @override
  String get challengeCheck => 'Controlar';

  @override
  String get challengeCorrectFeedbackTitle => '¡Excelente!';

  @override
  String get challengeRetryFeedbackTitle => 'Casi llegamos';

  @override
  String get challengeCorrectFeedbackText =>
      'La respuesta es correcta. ¡Adelante!';

  @override
  String get hintLogic =>
      'La regla se repite. Encuentra el comienzo de la siguiente repetición y continúa la fila.';

  @override
  String get hintMemory =>
      'Primero recuerde qué imágenes se abrieron. Luego busque el par correspondiente.';

  @override
  String get hintAttention =>
      'Compara los detalles uno por uno: color, forma, tamaño y lugar.';

  @override
  String get hintMath =>
      'Cuente en grupos pequeños para que sea más fácil no perder la pista.';

  @override
  String get hintSpace =>
      'Sigue el camino de principio a fin y nombra el siguiente giro.';

  @override
  String get collectionTitle => 'mi coleccion';

  @override
  String get collectionDayPrize => 'premio del día';

  @override
  String get collectionCosmoPrizes => 'Premios espaciales';

  @override
  String collectionUnlocked(int total, int unlocked) {
    return '$unlocked de $total abierto';
  }

  @override
  String get collectionNewPrizeTitle => 'premio nuevo dia';

  @override
  String get collectionNewPrizeBody => 'Astronauta añadido a la colección.';

  @override
  String collectionSnackUnlocked(Object title) {
    return '$title ya está en la colección.';
  }

  @override
  String get collectionSnackLocked => 'Se abre después de nuevos niveles.';

  @override
  String get collectionNewBadge => 'nuevo';

  @override
  String collectionLockedLevel(int level) {
    return '$level nivel.';
  }

  @override
  String get parentOverviewTitle => 'Descripción general para padres';

  @override
  String parentOverviewBody(String name) {
    return 'Perfil $name, avances, plan de hoy y consejos para practicar en casa.';
  }

  @override
  String parentStarsCount(int stars) {
    return 'Estrellas $stars';
  }

  @override
  String get parentMissionClosed => 'misión cumplida';

  @override
  String get parentMissionWaiting => 'misión esperando';

  @override
  String get parentProgressTitle => 'Progreso infantil';

  @override
  String get parentOverviewBadge => 'descripción general';

  @override
  String get parentLevelsLabel => 'Niveles';

  @override
  String parentLevelsValue(int completed, int total) {
    return '$completed de $total';
  }

  @override
  String get parentTodayLabel => 'Hoy';

  @override
  String parentTodayValue(int done, int total) {
    return '$done de $total';
  }

  @override
  String get parentStarsLabel => 'estrellas';

  @override
  String get parentContentLabel => 'Contenido';

  @override
  String parentContentValue(int done, int total) {
    return '$done de $total';
  }

  @override
  String get parentTodayPlanTitle => 'El plan de hoy';

  @override
  String get parentTodayPlanBody =>
      'Una serie corta sin presión: 2-3 intentos tranquilos son mejores que una sesión larga y cansada.';

  @override
  String parentPuzzleMeta(String skill, int minutes) {
    return '$skill • $minutes mín.';
  }

  @override
  String get parentAreasTitle => 'Áreas de desarrollo';

  @override
  String get parentBalanceBadge => 'balance';

  @override
  String get parentAreasBody =>
      'Este es un mapa para adultos: los niños deberían ver misiones y héroes, no categorías secas.';

  @override
  String get parentRecommendationDone =>
      'La misión de hoy está cumplida. Este es un buen momento para elogiar el esfuerzo, no la velocidad.';

  @override
  String parentRecommendationRemaining(int remaining) {
    return 'Hoy hay avances: quedan tareas de $remaining.';
  }

  @override
  String get parentRecommendationStart =>
      'Hoy, comienza con una misión corta de 4 a 6 minutos.';

  @override
  String get parentRecommendationsTitle => 'Recomendaciones';

  @override
  String get parentHomeBadge => 'en casa';

  @override
  String get parentPaceLabel => 'Paso';

  @override
  String get parentWeekFocusLabel => 'Enfoque semanal';

  @override
  String parentFocusArea(String areaTitle, String areaSubtitle) {
    return 'El área que necesita más atención ahora es \"$areaTitle\": $areaSubtitle.';
  }

  @override
  String get parentDiscussLabel => 'como discutir';

  @override
  String get parentDiscussBody =>
      'Después de una tarea, pregunte: \"¿Cómo encontraste la regla?\" Esto genera explicaciones, no conjeturas.';

  @override
  String get parentFamilySecurityTitle => 'Familia y seguridad';

  @override
  String get parentStorageLabel => 'Almacenamiento';

  @override
  String get parentStorageLocal => 'en el dispositivo';

  @override
  String get notificationDailyTitle => 'Hay una nueva misión';

  @override
  String notificationDailyBody(String name) {
    return '$name, resuelve un pequeño acertijo y mantén encendida la racha de estrellas.';
  }

  @override
  String get notificationEveningTitle => '¿Un paso antes de dormir?';

  @override
  String notificationEveningBody(String name) {
    return 'A $name le queda una misión corta. Bastan 5 minutos tranquilos.';
  }

  @override
  String get parentRemindersTitle => 'Recordatorios';

  @override
  String get parentReminderStatusOn => 'activos';

  @override
  String get parentReminderStatusOff => 'inactivos';

  @override
  String get parentRemindersBody =>
      'Un aviso diario suave ayuda a volver a la misión sin presión.';

  @override
  String get parentReminderDailyLabel => 'Misión diaria';

  @override
  String get parentReminderDailyValue => '18:30 cada día';

  @override
  String get parentReminderFollowUpLabel => 'Seguimiento de la tarde';

  @override
  String get parentReminderFollowUpValue => '20:15 si la misión está esperando';

  @override
  String get parentReminderToggleLabel => 'Recordar volver';

  @override
  String get parentReminderToggleOn =>
      'LogicUpX invitará al niño a una misión corta.';

  @override
  String get parentReminderToggleOff =>
      'Los recordatorios están desactivados. La app quedará en silencio.';

  @override
  String get parentAccountTitle => 'Account';

  @override
  String get parentAccountBody =>
      'Sign in to sync progress, unlock subscriptions and restore purchases on another device.';

  @override
  String get parentAccountStatusGuest => 'guest';

  @override
  String get parentAccountAction => 'Sign in';

  @override
  String get accountTitle => 'Account sign in';

  @override
  String get accountHeroTitle => 'Keep the family profile close';

  @override
  String get accountHeroBody =>
      'Use Google, Apple or email to prepare cloud sync, purchases and safe parent access.';

  @override
  String get accountStatusGuest => 'guest mode';

  @override
  String get accountAppleButton => 'Continue with Apple';

  @override
  String get accountGoogleButton => 'Continue with Google';

  @override
  String get accountAuthLoading => 'Checking...';

  @override
  String get accountProviderGoogle => 'Google';

  @override
  String get accountProviderApple => 'Apple';

  @override
  String get accountProviderEmail => 'Email';

  @override
  String get accountSignedInTitle => 'Signed in';

  @override
  String get accountSignOut => 'Sign out';

  @override
  String get accountGoogleSuccessSnack => 'Signed in with Google.';

  @override
  String get accountGoogleCanceledSnack => 'Google sign-in was canceled.';

  @override
  String get accountGoogleUnsupportedSnack =>
      'Google sign-in is not supported on this platform yet.';

  @override
  String get accountGoogleConfigSnack =>
      'Google sign-in needs OAuth client configuration for this app.';

  @override
  String accountGoogleErrorSnack(Object error) {
    return 'Google sign-in failed: $error';
  }

  @override
  String get accountBenefitGoogleTitle => 'Google sign-in';

  @override
  String get accountBenefitGoogleBody =>
      'Use a Google account for quick parent access once OAuth is configured.';

  @override
  String get accountEmailTitle => 'Email access';

  @override
  String get accountSignInTab => 'Sign in';

  @override
  String get accountCreateTab => 'Create';

  @override
  String get accountEmailLabel => 'Email';

  @override
  String get accountPasswordLabel => 'Password';

  @override
  String get accountConfirmPasswordLabel => 'Confirm password';

  @override
  String get accountRememberDevice => 'Remember this device';

  @override
  String get accountSubmitSignIn => 'Sign in';

  @override
  String get accountSubmitCreate => 'Create account';

  @override
  String get accountForgotPassword => 'Forgot password';

  @override
  String get accountRestorePurchases => 'Restore purchases';

  @override
  String get accountPrivacyNote =>
      'Children keep playing locally until account services are connected.';

  @override
  String get accountBenefitSyncTitle => 'Progress sync';

  @override
  String get accountBenefitSyncBody =>
      'A signed-in profile can later move stars and practice history between devices.';

  @override
  String get accountBenefitAppleTitle => 'Apple sign-in ready';

  @override
  String get accountBenefitAppleBody =>
      'The button is in place for Sign in with Apple credentials.';

  @override
  String get accountBenefitPurchaseTitle => 'Purchases and subscriptions';

  @override
  String get accountBenefitPurchaseBody =>
      'Restore access after reinstalling or changing devices.';

  @override
  String get accountEmailError => 'Enter a valid email';

  @override
  String get accountPasswordError => 'Use at least 6 characters';

  @override
  String get accountPasswordMismatch => 'Passwords do not match';

  @override
  String get accountDemoSnack =>
      'Signed in with email locally. Connect a backend to verify passwords on the server.';

  @override
  String get accountAppleSnack =>
      'Apple sign-in UI is ready for the native auth handler.';

  @override
  String get accountRestoreSnack =>
      'Purchase restore UI is ready for StoreKit.';

  @override
  String get accountResetDialogTitle => 'Reset password';

  @override
  String get accountResetDialogBody =>
      'Password reset emails will be sent after account backend is connected.';

  @override
  String get accountResetDialogAction => 'Got it';
}
