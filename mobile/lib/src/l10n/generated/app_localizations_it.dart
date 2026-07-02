// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'LogicLoka';

  @override
  String get loadingMission => 'Preparare la missione...';

  @override
  String get navHome => 'Casa';

  @override
  String get navChallenge => 'Compito';

  @override
  String get navParent => 'Genitore';

  @override
  String get commonCancel => 'Cancellare';

  @override
  String get commonReset => 'Reset';

  @override
  String languageChanged(Object language) {
    return 'Lingua: $language';
  }

  @override
  String languageButtonSemantics(Object language) {
    return 'Cambia lingua. Corrente: $language';
  }

  @override
  String get onboardingSubmitSaving => 'Preparazione del percorso';

  @override
  String get onboardingSubmitCreateHero => 'Crea eroe';

  @override
  String get onboardingDefaultHero => 'Giovane eroe';

  @override
  String get onboardingTitle => 'Crea un eroe';

  @override
  String onboardingHeroSummary(Object age, Object name) {
    return '$name, $age';
  }

  @override
  String get onboardingSubtitle =>
      'Il leone mostrerà la missione quotidiana, quindi tuo figlio potrà scegliere l\'allenamento del cervello.';

  @override
  String get childNameLabel => 'Nome del bambino';

  @override
  String get childNameError => 'Inserisci il nome dell\'eroe';

  @override
  String get onboardingMissionPill => 'inizio missione';

  @override
  String get onboardingAgeTitle => 'L\'età dell\'eroe';

  @override
  String get unlockMission => 'Missione';

  @override
  String get unlockGames => 'Giochi';

  @override
  String get unlockPrizes => 'Premi';

  @override
  String ageYears(int years) {
    return '$years anni';
  }

  @override
  String homeGreeting(Object name) {
    return 'Ciao,\n$name';
  }

  @override
  String get homeStarsHint =>
      'Le stelle crescono dalle missioni e sbloccano nuovi premi.';

  @override
  String get homeLockedLevelHint => 'Questo livello si apre dopo nuove stelle.';

  @override
  String get homeStreakSavedHint =>
      'Serie salvata! Domani arriva una nuova missione.';

  @override
  String get homeStreakNeedMissionHint =>
      'Completa la missione giornaliera per salvare la serie di vittorie consecutive.';

  @override
  String get homeStreakTitle => 'Serie giornaliera';

  @override
  String homeStreakDays(int days) {
    return '$days giorni di fila!';
  }

  @override
  String get homeStreakWaiting => 'la missione sta aspettando';

  @override
  String get homeMissionDaily => 'Missione quotidiana';

  @override
  String get homeMissionFreePlay => 'Gioco libero';

  @override
  String get homeTrainingOpen => 'La formazione è aperta';

  @override
  String homeLevel(int level) {
    return 'Livello $level';
  }

  @override
  String get homeMissionStart => 'Inizio';

  @override
  String get homeMissionChoose => 'Scegliere';

  @override
  String get homeMissionTag => 'Missione principale';

  @override
  String get homeFreePlayTitle => 'Gioca a te stesso';

  @override
  String get homeFreePlaySubtitle => 'scegli un eroe e allena il tuo cervello';

  @override
  String get homeMiniGamesTitle => 'Minigiochi';

  @override
  String get homeMiniGamesSubtitle => 'allenamento rapido dopo i livelli';

  @override
  String get homeQuickPairs => 'Coppie';

  @override
  String get homeQuickPath => 'Sentiero';

  @override
  String get homeQuickCount => 'Contare';

  @override
  String get homeProgressTitle => 'I miei progressi';

  @override
  String homeProgressStars(int current, int total) {
    return 'Stelle $current / $total';
  }

  @override
  String get homeCollectionTitle => 'Collezione';

  @override
  String get homeCollectionStickers => 'adesivi';

  @override
  String get homeLevelsTitle => 'Livelli';

  @override
  String get homeLevelsSubtitle => '8 temi di formazione, non un calendario';

  @override
  String get homeNodeCompleted => 'Fatto';

  @override
  String get homeNodePlay => 'giocare';

  @override
  String get homeNodeSoon => 'Presto';

  @override
  String get homeMapStart => 'Inizio';

  @override
  String get homeMapShapes => 'Forme';

  @override
  String get homeMapPairs => 'Coppie';

  @override
  String get homeMapCount => 'Contare';

  @override
  String get homeMapPath => 'Sentiero';

  @override
  String get homeMapRhythm => 'Ritmo';

  @override
  String get homeMapCompare => 'Confrontare';

  @override
  String get homeMapFinal => 'Finale';

  @override
  String get parentTitle => 'Zona genitore';

  @override
  String get parentIntroTitle => 'Zona tranquilla per adulti';

  @override
  String get parentIntroBody =>
      'Profilo, progresso, lingua e futura iscrizione vivono separatamente dalla missione bambino.';

  @override
  String get parentProfileTitle => 'Profilo familiare';

  @override
  String get parentLocalBadge => 'locale';

  @override
  String get parentChildLabel => 'Bambino';

  @override
  String get parentAgeLabel => 'Età';

  @override
  String get parentCompletedTasksLabel => 'Attività completate';

  @override
  String get parentLanguageLabel => 'Lingua';

  @override
  String get settingsLanguage => 'Lingua dell\'app';

  @override
  String get parentSubscriptionTitle => 'Abbonamento familiare';

  @override
  String get parentSubscriptionSoon => 'Presto';

  @override
  String get parentSubscriptionBody =>
      'Tariffe di lancio: accesso Free, Premium Family mensile e Annual al prezzo iniziale.';

  @override
  String get parentFamilySeatsLabel => 'Sedili per famiglie';

  @override
  String get parentFamilySeatsValue => 'pianificato';

  @override
  String get parentPaymentLabel => 'Pagamento';

  @override
  String get parentPaymentValue => 'non connesso';

  @override
  String get parentSubscriptionLaunchBadge => 'prezzo iniziale';

  @override
  String get parentSubscriptionCurrentFree => 'Free';

  @override
  String get parentSubscriptionFreeTitle => 'Free';

  @override
  String get parentSubscriptionFreePrice => '\$0';

  @override
  String get parentSubscriptionFreeBody =>
      'Un inizio leggero per provare il ciclo quotidiano.';

  @override
  String get parentSubscriptionFeatureDaily => 'Missione quotidiana';

  @override
  String get parentSubscriptionFeatureStarter => 'Livelli iniziali';

  @override
  String get parentSubscriptionFeatureLocalProgress =>
      'Progressi locali su questo dispositivo';

  @override
  String get parentSubscriptionFreeCta => 'Accesso attuale';

  @override
  String get parentSubscriptionPremiumTitle => 'Premium Family';

  @override
  String get parentSubscriptionPremiumPrice => '\$5.99/mese';

  @override
  String get parentSubscriptionPremiumBadge => 'prezzo di lancio';

  @override
  String get parentSubscriptionPremiumBody =>
      'Accesso familiare completo mentre la libreria di contenuti cresce ancora.';

  @override
  String get parentSubscriptionFeatureAllLevels =>
      'Tutti i livelli attuali e nuovi';

  @override
  String get parentSubscriptionFeatureParentTips => 'Consigli per i genitori';

  @override
  String get parentSubscriptionFeaturePurchaseRestore =>
      'Preparato per ripristinare gli acquisti';

  @override
  String get parentSubscriptionPremiumCta => 'Scegli mensile';

  @override
  String get parentSubscriptionAnnualTitle => 'Annual';

  @override
  String get parentSubscriptionAnnualPrice => '\$39.99/anno';

  @override
  String get parentSubscriptionAnnualBadge => 'più conveniente';

  @override
  String get parentSubscriptionAnnualBody =>
      'Premium Family per un anno al prezzo annuale iniziale.';

  @override
  String get parentSubscriptionFeatureAnnualValue =>
      'Meno di 12 pagamenti mensili';

  @override
  String get parentSubscriptionFeatureYearAccess =>
      '12 mesi di accesso familiare';

  @override
  String get parentSubscriptionFeatureUpdatesIncluded =>
      'Nuovi livelli inclusi durante l\'anno';

  @override
  String get parentSubscriptionAnnualCta => 'Scegli annuale';

  @override
  String get parentSubscriptionFuturePriceNote =>
      'Più avanti, quando ci saranno molti livelli di qualità: \$7.99/mese e \$49.99/anno.';

  @override
  String get parentSubscriptionBillingSoonSnack =>
      'La fatturazione non è ancora collegata. Questi piani sono pronti per StoreKit e Google Play Billing.';

  @override
  String get parentResetProfile => 'Reimposta profilo';

  @override
  String get parentResetTitle => 'Reimpostare il profilo?';

  @override
  String get parentResetBody =>
      'L\'onboarding verrà riaperto e i progressi locali verranno cancellati.';

  @override
  String get challengeTitle => 'Giochi cerebrali';

  @override
  String get challengeDayDone => 'Giornata completata';

  @override
  String get challengeDailyMission => 'Missione quotidiana';

  @override
  String get challengeDayDoneBody =>
      'Premio ricevuto. Puoi ripetere o giocare liberamente.';

  @override
  String get challengeDailyBody =>
      'Completa 3 passaggi per salvare la serie e ritirare il premio.';

  @override
  String get challengePrize => 'premio';

  @override
  String get challengeMissionProgress => 'Avanzamento della missione';

  @override
  String countOfTotal(int count, int total) {
    return '$count di $total';
  }

  @override
  String get challengeRepeatMission => 'Ripeti la missione';

  @override
  String challengeStepsTraining(int steps) {
    return '$steps passi per l\'allenamento';
  }

  @override
  String challengeStepNumber(int step) {
    return 'Passo $step';
  }

  @override
  String get challengeAgain => 'Ancora';

  @override
  String minutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String get challengeBrainGymTitle => 'Palestra cerebrale';

  @override
  String challengeBrainGymSubtitle(int count) {
    return 'Aree $count, riproduci in qualsiasi ordine';
  }

  @override
  String challengeAreaLevels(int done, int total) {
    return 'Livelli $done/$total';
  }

  @override
  String challengeAreaCompleted(int done, int total) {
    return '$done di $total completo';
  }

  @override
  String get challengeStateCompleted => 'Fatto';

  @override
  String get challengeStateNext => 'Prossimo';

  @override
  String get challengeStatePlay => 'giocare';

  @override
  String challengeLevelNumber(int level) {
    return 'Livello $level';
  }

  @override
  String get challengeHideHint => 'Nascondi suggerimento';

  @override
  String get challengeShowHint => 'Mostra suggerimento';

  @override
  String get challengeDailyTaskTitle => 'Compito quotidiano';

  @override
  String get challengePuzzleTaskTitle => 'Puzzle';

  @override
  String get challengeDailyPath => 'Percorso quotidiano';

  @override
  String get challengeFreePlay => 'Gioco libero';

  @override
  String get challengeExcellent => 'Grande!';

  @override
  String get challengeFlyNext => 'Il prossimo volo';

  @override
  String get challengeAllDone => 'Tutto pronto';

  @override
  String get challengePlayMore => 'Gioca di più';

  @override
  String get challengeMyCollection => 'La mia collezione';

  @override
  String get challengeDailyCompleteTitle => 'Missione giornaliera completata!';

  @override
  String get challengeDailyCompleteBody =>
      'Hai completato tutti i passaggi. Ritira il premio e gioca liberamente.';

  @override
  String get challengeRewardStars => 'stelle';

  @override
  String get challengeRewardStreak => 'strisciante';

  @override
  String get challengeRewardSteps => 'passi';

  @override
  String get challengeWhatNextTitle => 'E dopo?';

  @override
  String get challengeWhatNextBody =>
      'Scegli un eroe: logica, memoria, attenzione, conteggio o percorso.';

  @override
  String challengeProgressStep(int current, int total) {
    return 'Passo $current di $total';
  }

  @override
  String get challengeChooseAnswer => 'Scegli una risposta';

  @override
  String challengeSelectedAnswer(Object answer) {
    return 'Risposta: $answer';
  }

  @override
  String get challengePickDifferentAnswer => 'Scegli un\'altra risposta';

  @override
  String get challengeCorrectAnswer => 'Corretto!';

  @override
  String get challengeChecking => 'Controllo';

  @override
  String get challengeCheck => 'Controllo';

  @override
  String get challengeCorrectFeedbackTitle => 'Grande!';

  @override
  String get challengeRetryFeedbackTitle => 'Ci siamo quasi';

  @override
  String get challengeCorrectFeedbackText =>
      'La risposta è corretta. Andiamo avanti!';

  @override
  String get hintLogic =>
      'La regola si ripete. Trova l\'inizio della ripetizione successiva e continua la riga.';

  @override
  String get hintMemory =>
      'Per prima cosa ricorda quali immagini sono state aperte. Quindi cerca la coppia corrispondente.';

  @override
  String get hintAttention =>
      'Confronta i dettagli uno per uno: colore, forma, dimensione e posizione.';

  @override
  String get hintMath =>
      'Contare in piccoli gruppi così è più facile non perdere il conto.';

  @override
  String get hintSpace =>
      'Segui il percorso dall\'inizio alla fine e dai un nome alla svolta successiva.';

  @override
  String get collectionTitle => 'La mia collezione';

  @override
  String get collectionDayPrize => 'Premio giornaliero';

  @override
  String get collectionCosmoPrizes => 'Premi spaziali';

  @override
  String collectionUnlocked(int total, int unlocked) {
    return '$unlocked di $total aperto';
  }

  @override
  String get collectionNewPrizeTitle => 'Premio del nuovo giorno';

  @override
  String get collectionNewPrizeBody => 'Astronauta aggiunto alla collezione.';

  @override
  String collectionSnackUnlocked(Object title) {
    return '$title è già nella collezione.';
  }

  @override
  String get collectionSnackLocked => 'Si apre dopo nuovi livelli.';

  @override
  String get collectionNewBadge => 'nuovo';

  @override
  String collectionLockedLevel(int level) {
    return '$level liv.';
  }

  @override
  String get parentOverviewTitle => 'Panoramica dei genitori';

  @override
  String parentOverviewBody(String name) {
    return 'Profilo $name, progressi, piano di oggi e suggerimenti per esercitarsi a casa.';
  }

  @override
  String parentStarsCount(int stars) {
    return '$stars stelle';
  }

  @override
  String get parentMissionClosed => 'missione compiuta';

  @override
  String get parentMissionWaiting => 'missione in attesa';

  @override
  String get parentProgressTitle => 'Progresso del bambino';

  @override
  String get parentOverviewBadge => 'panoramica';

  @override
  String get parentLevelsLabel => 'Livelli';

  @override
  String parentLevelsValue(int completed, int total) {
    return '$completed di $total';
  }

  @override
  String get parentTodayLabel => 'Oggi';

  @override
  String parentTodayValue(int done, int total) {
    return '$done di $total';
  }

  @override
  String get parentStarsLabel => 'Stelle';

  @override
  String get parentContentLabel => 'Contenuto';

  @override
  String parentContentValue(int done, int total) {
    return '$done di $total';
  }

  @override
  String get parentTodayPlanTitle => 'Il piano di oggi';

  @override
  String get parentTodayPlanBody =>
      'Una serie breve e senza pressioni: 2-3 tentativi tranquilli sono meglio di una sessione lunga e stanca.';

  @override
  String parentPuzzleMeta(String skill, int minutes) {
    return '$skill • $minutes min';
  }

  @override
  String get parentAreasTitle => 'Aree di sviluppo';

  @override
  String get parentBalanceBadge => 'bilancia';

  @override
  String get parentAreasBody =>
      'Questa è una mappa per adulti: i bambini dovrebbero vedere missioni ed eroi, non categorie aride.';

  @override
  String get parentRecommendationDone =>
      'La missione di oggi è compiuta. Questo è un buon momento per lodare lo sforzo, non la velocità.';

  @override
  String parentRecommendationRemaining(int remaining) {
    return 'Ci sono progressi oggi: compiti $remaining rimasti.';
  }

  @override
  String get parentRecommendationStart =>
      'Oggi inizia con una breve missione da 4-6 minuti.';

  @override
  String get parentRecommendationsTitle => 'Raccomandazioni';

  @override
  String get parentHomeBadge => 'a casa';

  @override
  String get parentPaceLabel => 'Ritmo';

  @override
  String get parentWeekFocusLabel => 'Focus settimanale';

  @override
  String parentFocusArea(String areaTitle, String areaSubtitle) {
    return 'L\'area che necessita di maggiore attenzione ora è \"$areaTitle\": $areaSubtitle.';
  }

  @override
  String get parentDiscussLabel => 'Come discutere';

  @override
  String get parentDiscussBody =>
      'Dopo un compito, chiedi: \"Come hai trovato la regola?\" Questo crea spiegazioni, non supposizioni.';

  @override
  String get parentFamilySecurityTitle => 'Famiglia e sicurezza';

  @override
  String get parentStorageLabel => 'Magazzinaggio';

  @override
  String get parentStorageLocal => 'sul dispositivo';

  @override
  String get notificationDailyTitle => 'Una nuova missione ti aspetta';

  @override
  String notificationDailyBody(String name) {
    return '$name, risolvi un piccolo rompicapo e tieni viva la serie di stelle.';
  }

  @override
  String get notificationEveningTitle => 'Un passo prima di dormire?';

  @override
  String notificationEveningBody(String name) {
    return 'Per $name resta una missione breve. Bastano 5 minuti tranquilli.';
  }

  @override
  String get parentRemindersTitle => 'Promemoria';

  @override
  String get parentReminderStatusOn => 'attivi';

  @override
  String get parentReminderStatusOff => 'disattivi';

  @override
  String get parentRemindersBody =>
      'Un promemoria quotidiano leggero aiuta a tornare alla missione senza pressione.';

  @override
  String get parentReminderDailyLabel => 'Missione del giorno';

  @override
  String get parentReminderDailyValue => '18:30 ogni giorno';

  @override
  String get parentReminderFollowUpLabel => 'Richiamo serale';

  @override
  String get parentReminderFollowUpValue => '20:15 se la missione è in attesa';

  @override
  String get parentReminderToggleLabel => 'Ricorda di tornare';

  @override
  String get parentReminderToggleOn =>
      'LogicLoka inviterà il bambino a una missione breve.';

  @override
  String get parentReminderToggleOff =>
      'I promemoria sono disattivati. L’app resterà silenziosa.';

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
