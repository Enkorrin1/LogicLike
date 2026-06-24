// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'LogicUpX';

  @override
  String get loadingMission => 'Vorbereitung der Mission...';

  @override
  String get navHome => 'Heim';

  @override
  String get navChallenge => 'Aufgabe';

  @override
  String get navParent => 'Elternteil';

  @override
  String get commonCancel => 'Stornieren';

  @override
  String get commonReset => 'Zurücksetzen';

  @override
  String languageChanged(Object language) {
    return 'Sprache: $language';
  }

  @override
  String languageButtonSemantics(Object language) {
    return 'Sprache ändern. Aktuell: $language';
  }

  @override
  String get onboardingSubmitSaving => 'Route vorbereiten';

  @override
  String get onboardingSubmitCreateHero => 'Erstelle einen Helden';

  @override
  String get onboardingDefaultHero => 'Junger Held';

  @override
  String get onboardingTitle => 'Erstelle einen Helden';

  @override
  String onboardingHeroSummary(Object age, Object name) {
    return '$name, $age';
  }

  @override
  String get onboardingSubtitle =>
      'Der Löwe zeigt die tägliche Mission, dann kann Ihr Kind Gehirntraining wählen.';

  @override
  String get childNameLabel => 'Kindername';

  @override
  String get childNameError => 'Geben Sie den Namen des Helden ein';

  @override
  String get onboardingMissionPill => 'Missionsstart';

  @override
  String get onboardingAgeTitle => 'Heldenalter';

  @override
  String get unlockMission => 'Mission';

  @override
  String get unlockGames => 'Spiele';

  @override
  String get unlockPrizes => 'Preise';

  @override
  String ageYears(int years) {
    return '$years Jahre';
  }

  @override
  String homeGreeting(Object name) {
    return 'Hallo,\n$name';
  }

  @override
  String get homeStarsHint =>
      'Aus Missionen wachsen Sterne und schalten neue Preise frei.';

  @override
  String get homeLockedLevelHint =>
      'Dieses Level öffnet sich nach neuen Sternen.';

  @override
  String get homeStreakSavedHint =>
      'Streak gerettet! Morgen kommt eine neue Mission.';

  @override
  String get homeStreakNeedMissionHint =>
      'Schließe die tägliche Mission ab, um den Streak zu retten.';

  @override
  String get homeStreakTitle => 'Täglicher Streak';

  @override
  String homeStreakDays(int days) {
    return '$days Tage in Folge!';
  }

  @override
  String get homeStreakWaiting => 'Die Mission wartet';

  @override
  String get homeMissionDaily => 'Tägliche Mission';

  @override
  String get homeMissionFreePlay => 'Freies Spiel';

  @override
  String get homeTrainingOpen => 'Das Training ist geöffnet';

  @override
  String homeLevel(int level) {
    return 'Ebene $level';
  }

  @override
  String get homeMissionStart => 'Start';

  @override
  String get homeMissionChoose => 'Wählen';

  @override
  String get homeMissionTag => 'Hauptmission';

  @override
  String get homeFreePlayTitle => 'Spielen Sie sich selbst';

  @override
  String get homeFreePlaySubtitle =>
      'Wähle einen Helden und trainiere dein Gehirn';

  @override
  String get homeMiniGamesTitle => 'Minispiele';

  @override
  String get homeMiniGamesSubtitle => 'schnelles Training nach Levels';

  @override
  String get homeQuickPairs => 'Paare';

  @override
  String get homeQuickPath => 'Weg';

  @override
  String get homeQuickCount => 'Zählen';

  @override
  String get homeProgressTitle => 'Mein Fortschritt';

  @override
  String homeProgressStars(int current, int total) {
    return '$current / $total Sterne';
  }

  @override
  String get homeCollectionTitle => 'Sammlung';

  @override
  String get homeCollectionStickers => 'Aufkleber';

  @override
  String get homeLevelsTitle => 'Ebenen';

  @override
  String get homeLevelsSubtitle => '8 Trainingsthemen, kein Kalender';

  @override
  String get homeNodeCompleted => 'Erledigt';

  @override
  String get homeNodePlay => 'spielen';

  @override
  String get homeNodeSoon => 'bald';

  @override
  String get homeMapStart => 'Start';

  @override
  String get homeMapShapes => 'Formen';

  @override
  String get homeMapPairs => 'Paare';

  @override
  String get homeMapCount => 'Zählen';

  @override
  String get homeMapPath => 'Weg';

  @override
  String get homeMapRhythm => 'Rhythmus';

  @override
  String get homeMapCompare => 'Vergleichen';

  @override
  String get homeMapFinal => 'Finale';

  @override
  String get parentTitle => 'Elternbereich';

  @override
  String get parentIntroTitle => 'Ruhezone für Erwachsene';

  @override
  String get parentIntroBody =>
      'Profil, Fortschritt, Sprache und zukünftiges Abonnement leben getrennt von der Kindermission.';

  @override
  String get parentProfileTitle => 'Familienprofil';

  @override
  String get parentLocalBadge => 'lokal';

  @override
  String get parentChildLabel => 'Kind';

  @override
  String get parentAgeLabel => 'Alter';

  @override
  String get parentCompletedTasksLabel => 'Aufgaben erledigt';

  @override
  String get parentLanguageLabel => 'Sprache';

  @override
  String get settingsLanguage => 'App-Sprache';

  @override
  String get parentSubscriptionTitle => 'Familienabonnement';

  @override
  String get parentSubscriptionSoon => 'bald';

  @override
  String get parentSubscriptionBody =>
      'Hier werden Zahlungsstatus, Familiensitze und Planverwaltung angezeigt.';

  @override
  String get parentFamilySeatsLabel => 'Familiensitze';

  @override
  String get parentFamilySeatsValue => 'geplant';

  @override
  String get parentPaymentLabel => 'Zahlung';

  @override
  String get parentPaymentValue => 'nicht verbunden';

  @override
  String get parentResetProfile => 'Profil zurücksetzen';

  @override
  String get parentResetTitle => 'Profil zurücksetzen?';

  @override
  String get parentResetBody =>
      'Das Onboarding wird wieder geöffnet und der lokale Fortschritt wird gelöscht.';

  @override
  String get challengeTitle => 'Denkspiele';

  @override
  String get challengeDayDone => 'Tag abgeschlossen';

  @override
  String get challengeDailyMission => 'Tägliche Mission';

  @override
  String get challengeDayDoneBody =>
      'Belohnung erhalten. Sie können wiederholen oder frei spielen.';

  @override
  String get challengeDailyBody =>
      'Führen Sie 3 Schritte aus, um den Streak zu speichern und den Preis einzusammeln.';

  @override
  String get challengePrize => 'Preis';

  @override
  String get challengeMissionProgress => 'Missionsfortschritt';

  @override
  String countOfTotal(int count, int total) {
    return '$count von $total';
  }

  @override
  String get challengeRepeatMission => 'Mission wiederholen';

  @override
  String challengeStepsTraining(int steps) {
    return '$steps Schritte für das Training';
  }

  @override
  String challengeStepNumber(int step) {
    return 'Schritt $step';
  }

  @override
  String get challengeAgain => 'wieder';

  @override
  String minutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String get challengeBrainGymTitle => 'Gehirn-Fitnessstudio';

  @override
  String challengeBrainGymSubtitle(int count) {
    return '$count-Bereiche, in beliebiger Reihenfolge spielen';
  }

  @override
  String challengeAreaLevels(int done, int total) {
    return '$done/$total-Stufen';
  }

  @override
  String challengeAreaCompleted(int done, int total) {
    return '$done von $total komplett';
  }

  @override
  String get challengeStateCompleted => 'Erledigt';

  @override
  String get challengeStateNext => 'nächste';

  @override
  String get challengeStatePlay => 'spielen';

  @override
  String challengeLevelNumber(int level) {
    return 'Ebene $level';
  }

  @override
  String get challengeHideHint => 'Hinweis ausblenden';

  @override
  String get challengeShowHint => 'Hinweis anzeigen';

  @override
  String get challengeDailyTaskTitle => 'Tägliche Aufgabe';

  @override
  String get challengePuzzleTaskTitle => 'Puzzle';

  @override
  String get challengeDailyPath => 'Täglicher Weg';

  @override
  String get challengeFreePlay => 'Freies Spiel';

  @override
  String get challengeExcellent => 'Großartig!';

  @override
  String get challengeFlyNext => 'Als nächstes fliegen';

  @override
  String get challengeAllDone => 'Alles klar';

  @override
  String get challengePlayMore => 'Spielen Sie mehr';

  @override
  String get challengeMyCollection => 'Meine Sammlung';

  @override
  String get challengeDailyCompleteTitle => 'Tägliche Mission abgeschlossen!';

  @override
  String get challengeDailyCompleteBody =>
      'Sie haben alle Schritte abgeschlossen. Sammeln Sie den Preis und spielen Sie frei.';

  @override
  String get challengeRewardStars => 'Sterne';

  @override
  String get challengeRewardStreak => 'Strähne';

  @override
  String get challengeRewardSteps => 'Schritte';

  @override
  String get challengeWhatNextTitle => 'Was kommt als nächstes?';

  @override
  String get challengeWhatNextBody =>
      'Wählen Sie einen Helden: Logik, Gedächtnis, Aufmerksamkeit, Zählung oder Weg.';

  @override
  String challengeProgressStep(int current, int total) {
    return 'Schritt $current von $total';
  }

  @override
  String get challengeChooseAnswer => 'Wählen Sie eine Antwort';

  @override
  String challengeSelectedAnswer(Object answer) {
    return 'Antwort: $answer';
  }

  @override
  String get challengePickDifferentAnswer => 'Wählen Sie eine andere Antwort';

  @override
  String get challengeCorrectAnswer => 'Richtig!';

  @override
  String get challengeChecking => 'Überprüfung';

  @override
  String get challengeCheck => 'Überprüfen';

  @override
  String get challengeCorrectFeedbackTitle => 'Großartig!';

  @override
  String get challengeRetryFeedbackTitle => 'Fast da';

  @override
  String get challengeCorrectFeedbackText =>
      'Die Antwort ist richtig. Weiter geht\'s!';

  @override
  String get hintLogic =>
      'Die Regel wiederholt sich. Finden Sie den Anfang der nächsten Wiederholung und setzen Sie die Reihe fort.';

  @override
  String get hintMemory =>
      'Merken Sie sich zunächst, welche Bilder geöffnet wurden. Dann suchen Sie nach dem passenden Paar.';

  @override
  String get hintAttention =>
      'Vergleichen Sie die Details einzeln: Farbe, Form, Größe und Ort.';

  @override
  String get hintMath =>
      'Zählen Sie in kleinen Gruppen, damit Sie den Überblick nicht verlieren.';

  @override
  String get hintSpace =>
      'Folgen Sie dem Weg von Anfang bis Ende und benennen Sie die nächste Abzweigung.';

  @override
  String get collectionTitle => 'Meine Sammlung';

  @override
  String get collectionDayPrize => 'Tagespreis';

  @override
  String get collectionCosmoPrizes => 'Weltraumpreise';

  @override
  String collectionUnlocked(int total, int unlocked) {
    return '$unlocked von $total geöffnet';
  }

  @override
  String get collectionNewPrizeTitle => 'Neujahrspreis';

  @override
  String get collectionNewPrizeBody => 'Astronaut zur Sammlung hinzugefügt.';

  @override
  String collectionSnackUnlocked(Object title) {
    return '$title ist bereits in der Sammlung.';
  }

  @override
  String get collectionSnackLocked => 'Öffnet nach neuen Levels.';

  @override
  String get collectionNewBadge => 'neu';

  @override
  String collectionLockedLevel(int level) {
    return '$level lvl.';
  }

  @override
  String get parentOverviewTitle => 'Elternübersicht';

  @override
  String parentOverviewBody(String name) {
    return 'Profil $name, Fortschritt, heutiger Plan und Tipps zum Üben zu Hause.';
  }

  @override
  String parentStarsCount(int stars) {
    return '$stars-Sterne';
  }

  @override
  String get parentMissionClosed => 'Mission erledigt';

  @override
  String get parentMissionWaiting => 'Mission wartet';

  @override
  String get parentProgressTitle => 'Kinderfortschritt';

  @override
  String get parentOverviewBadge => 'Überblick';

  @override
  String get parentLevelsLabel => 'Ebenen';

  @override
  String parentLevelsValue(int completed, int total) {
    return '$completed von $total';
  }

  @override
  String get parentTodayLabel => 'Heute';

  @override
  String parentTodayValue(int done, int total) {
    return '$done von $total';
  }

  @override
  String get parentStarsLabel => 'Sterne';

  @override
  String get parentContentLabel => 'Inhalt';

  @override
  String parentContentValue(int done, int total) {
    return '$done von $total';
  }

  @override
  String get parentTodayPlanTitle => 'Der heutige Plan';

  @override
  String get parentTodayPlanBody =>
      'Eine kurze Serie ohne Druck: 2-3 ruhige Versuche sind besser als eine lange, müde Einheit.';

  @override
  String parentPuzzleMeta(String skill, int minutes) {
    return '$skill • $minutes min';
  }

  @override
  String get parentAreasTitle => 'Entwicklungsbereiche';

  @override
  String get parentBalanceBadge => 'Gleichgewicht';

  @override
  String get parentAreasBody =>
      'Dies ist eine Karte für Erwachsene: Kinder sollten Missionen und Helden sehen, keine trockenen Kategorien.';

  @override
  String get parentRecommendationDone =>
      'Die heutige Mission ist erledigt. Dies ist ein guter Zeitpunkt, die Anstrengung zu loben, nicht die Geschwindigkeit.';

  @override
  String parentRecommendationRemaining(int remaining) {
    return 'Heute gibt es Fortschritte: $remaining-Aufgaben übrig.';
  }

  @override
  String get parentRecommendationStart =>
      'Beginnen Sie heute mit einer kurzen Mission von 4 bis 6 Minuten.';

  @override
  String get parentRecommendationsTitle => 'Empfehlungen';

  @override
  String get parentHomeBadge => 'zu Hause';

  @override
  String get parentPaceLabel => 'Tempo';

  @override
  String get parentWeekFocusLabel => 'Schwerpunkt der Woche';

  @override
  String parentFocusArea(String areaTitle, String areaSubtitle) {
    return 'Der Bereich, der jetzt die meiste Aufmerksamkeit erfordert, ist „$areaTitle“: $areaSubtitle.';
  }

  @override
  String get parentDiscussLabel => 'Wie man diskutiert';

  @override
  String get parentDiscussBody =>
      'Fragen Sie nach einer Aufgabe: „Wie haben Sie die Regel gefunden?“ Dies baut auf Erklärungen auf, nicht auf Vermutungen.';

  @override
  String get parentFamilySecurityTitle => 'Familie und Sicherheit';

  @override
  String get parentStorageLabel => 'Lagerung';

  @override
  String get parentStorageLocal => 'auf dem Gerät';

  @override
  String get notificationDailyTitle => 'Eine neue Mission wartet';

  @override
  String notificationDailyBody(String name) {
    return '$name, löse ein kleines Rätsel und halte die Sternenserie am Leuchten.';
  }

  @override
  String get notificationEveningTitle =>
      'Ein kleiner Schritt vor dem Schlafengehen?';

  @override
  String notificationEveningBody(String name) {
    return 'Für $name ist noch eine kurze Mission offen. 5 ruhige Minuten reichen.';
  }

  @override
  String get parentRemindersTitle => 'Erinnerungen';

  @override
  String get parentReminderStatusOn => 'an';

  @override
  String get parentReminderStatusOff => 'aus';

  @override
  String get parentRemindersBody =>
      'Eine sanfte tägliche Erinnerung hilft, ohne Druck zur Mission zurückzukehren.';

  @override
  String get parentReminderDailyLabel => 'Tagesmission';

  @override
  String get parentReminderDailyValue => '18:30 jeden Tag';

  @override
  String get parentReminderFollowUpLabel => 'Abendliche Erinnerung';

  @override
  String get parentReminderFollowUpValue => '20:15, wenn die Mission wartet';

  @override
  String get parentReminderToggleLabel => 'Rückkehr erinnern';

  @override
  String get parentReminderToggleOn =>
      'LogicUpX lädt das Kind zu einer kurzen Mission ein.';

  @override
  String get parentReminderToggleOff =>
      'Erinnerungen sind aus. Die App bleibt ruhig.';

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
      'Use Apple or email to prepare cloud sync, purchases and safe parent access.';

  @override
  String get accountStatusGuest => 'guest mode';

  @override
  String get accountAppleButton => 'Continue with Apple';

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
      'Account UI is ready. Connect auth service to finish sign-in.';

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
