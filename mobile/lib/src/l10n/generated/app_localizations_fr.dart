// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'BrainUp';

  @override
  String get loadingMission => 'Préparation de la mission...';

  @override
  String get navHome => 'Maison';

  @override
  String get navChallenge => 'Tâche';

  @override
  String get navParent => 'Mère';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonReset => 'Réinitialiser';

  @override
  String languageChanged(Object language) {
    return 'Langue : $language';
  }

  @override
  String languageButtonSemantics(Object language) {
    return 'Changer de langue. Actuel : $language';
  }

  @override
  String get onboardingSubmitSaving => 'Préparation de l\'itinéraire';

  @override
  String get onboardingSubmitCreateHero => 'Créer un héros';

  @override
  String get onboardingDefaultHero => 'Jeune héros';

  @override
  String get onboardingTitle => 'Créer un héros';

  @override
  String onboardingHeroSummary(Object age, Object name) {
    return '$name, $age';
  }

  @override
  String get onboardingSubtitle =>
      'Le lion montrera la mission quotidienne, puis votre enfant pourra choisir l\'entraînement cérébral.';

  @override
  String get childNameLabel => 'Nom de l\'enfant';

  @override
  String get childNameError => 'Entrez le nom du héros';

  @override
  String get onboardingMissionPill => 'début de mission';

  @override
  String get onboardingAgeTitle => 'Âge du héros';

  @override
  String get unlockMission => 'Mission';

  @override
  String get unlockGames => 'Jeux';

  @override
  String get unlockPrizes => 'Prix';

  @override
  String ageYears(int years) {
    return '$years années';
  }

  @override
  String homeGreeting(Object name) {
    return 'Bonjour,\n$name';
  }

  @override
  String get homeStarsHint =>
      'Les étoiles grandissent au fil des missions et débloquent de nouveaux prix.';

  @override
  String get homeLockedLevelHint =>
      'Ce niveau s\'ouvre après de nouvelles étoiles.';

  @override
  String get homeStreakSavedHint =>
      'Série sauvée ! Une nouvelle mission arrive demain.';

  @override
  String get homeStreakNeedMissionHint =>
      'Terminez la mission quotidienne pour sauver la séquence.';

  @override
  String get homeStreakTitle => 'Série quotidienne';

  @override
  String homeStreakDays(int days) {
    return '$days jours d\'affilée !';
  }

  @override
  String get homeStreakWaiting => 'la mission attend';

  @override
  String get homeMissionDaily => 'Mission quotidienne';

  @override
  String get homeMissionFreePlay => 'Jeu gratuit';

  @override
  String get homeTrainingOpen => 'La formation est ouverte';

  @override
  String homeLevel(int level) {
    return 'Niveau $level';
  }

  @override
  String get homeMissionStart => 'Commencer';

  @override
  String get homeMissionChoose => 'Choisir';

  @override
  String get homeMissionTag => 'Mission principale';

  @override
  String get homeFreePlayTitle => 'Jouez vous-même';

  @override
  String get homeFreePlaySubtitle =>
      'choisissez un héros et entraînez votre cerveau';

  @override
  String get homeMiniGamesTitle => 'Mini-jeux';

  @override
  String get homeMiniGamesSubtitle => 'entraînement rapide après les niveaux';

  @override
  String get homeQuickPairs => 'Paires';

  @override
  String get homeQuickPath => 'Chemin';

  @override
  String get homeQuickCount => 'Compter';

  @override
  String get homeProgressTitle => 'Mes progrès';

  @override
  String homeProgressStars(int current, int total) {
    return 'Étoiles $current / $total';
  }

  @override
  String get homeCollectionTitle => 'Collection';

  @override
  String get homeCollectionStickers => 'autocollants';

  @override
  String get homeLevelsTitle => 'Niveaux';

  @override
  String get homeLevelsSubtitle => '8 thèmes de formation, pas un calendrier';

  @override
  String get homeNodeCompleted => 'fait';

  @override
  String get homeNodePlay => 'jouer';

  @override
  String get homeNodeSoon => 'bientôt';

  @override
  String get homeMapStart => 'Commencer';

  @override
  String get homeMapShapes => 'Formes';

  @override
  String get homeMapPairs => 'Paires';

  @override
  String get homeMapCount => 'Compter';

  @override
  String get homeMapPath => 'Chemin';

  @override
  String get homeMapRhythm => 'Rythme';

  @override
  String get homeMapCompare => 'Comparer';

  @override
  String get homeMapFinal => 'Final';

  @override
  String get parentTitle => 'Espace parents';

  @override
  String get parentIntroTitle => 'Zone calme pour adultes';

  @override
  String get parentIntroBody =>
      'Profil, progression, langue et futur abonnement en direct séparément de la mission enfant.';

  @override
  String get parentProfileTitle => 'Profil familial';

  @override
  String get parentLocalBadge => 'locale';

  @override
  String get parentChildLabel => 'Enfant';

  @override
  String get parentAgeLabel => 'Âge';

  @override
  String get parentCompletedTasksLabel => 'Tâches terminées';

  @override
  String get parentLanguageLabel => 'Langue';

  @override
  String get settingsLanguage => 'Langue de l\'application';

  @override
  String get parentSubscriptionTitle => 'Abonnement familial';

  @override
  String get parentSubscriptionSoon => 'bientôt';

  @override
  String get parentSubscriptionBody =>
      'Le statut de paiement, les sièges familiaux et la gestion du plan apparaîtront ici.';

  @override
  String get parentFamilySeatsLabel => 'Sièges familiaux';

  @override
  String get parentFamilySeatsValue => 'prévu';

  @override
  String get parentPaymentLabel => 'Paiement';

  @override
  String get parentPaymentValue => 'non connecté';

  @override
  String get parentResetProfile => 'Réinitialiser le profil';

  @override
  String get parentResetTitle => 'Réinitialiser le profil ?';

  @override
  String get parentResetBody =>
      'L\'intégration s\'ouvrira à nouveau et les progrès locaux seront effacés.';

  @override
  String get challengeTitle => 'Jeux de réflexion';

  @override
  String get challengeDayDone => 'Journée terminée';

  @override
  String get challengeDailyMission => 'Mission quotidienne';

  @override
  String get challengeDayDoneBody =>
      'Récompense reçue. Vous pouvez répéter ou jouer librement.';

  @override
  String get challengeDailyBody =>
      'Effectuez 3 étapes pour sauvegarder la séquence et récupérer le prix.';

  @override
  String get challengePrize => 'prix';

  @override
  String get challengeMissionProgress => 'Avancement de la mission';

  @override
  String countOfTotal(int count, int total) {
    return '$count ou $total';
  }

  @override
  String get challengeRepeatMission => 'Répéter la mission';

  @override
  String challengeStepsTraining(int steps) {
    return 'Étapes $steps pour la formation';
  }

  @override
  String challengeStepNumber(int step) {
    return 'Étape $step';
  }

  @override
  String get challengeAgain => 'encore';

  @override
  String minutesShort(int minutes) {
    return '$minutes min.';
  }

  @override
  String get challengeBrainGymTitle => 'Gymnastique cérébrale';

  @override
  String challengeBrainGymSubtitle(int count) {
    return 'Zones $count, jouez dans n\'importe quel ordre';
  }

  @override
  String challengeAreaLevels(int done, int total) {
    return 'Niveaux $done/$total';
  }

  @override
  String challengeAreaCompleted(int done, int total) {
    return '$done de $total complet';
  }

  @override
  String get challengeStateCompleted => 'fait';

  @override
  String get challengeStateNext => 'suivant';

  @override
  String get challengeStatePlay => 'jouer';

  @override
  String challengeLevelNumber(int level) {
    return 'Niveau $level';
  }

  @override
  String get challengeHideHint => 'Masquer l\'indice';

  @override
  String get challengeShowHint => 'Afficher l\'indice';

  @override
  String get challengeDailyTaskTitle => 'Tâche quotidienne';

  @override
  String get challengePuzzleTaskTitle => 'Puzzle';

  @override
  String get challengeDailyPath => 'Chemin quotidien';

  @override
  String get challengeFreePlay => 'Jeu gratuit';

  @override
  String get challengeExcellent => 'Super!';

  @override
  String get challengeFlyNext => 'Voler ensuite';

  @override
  String get challengeAllDone => 'Tout est prêt';

  @override
  String get challengePlayMore => 'Jouez plus';

  @override
  String get challengeMyCollection => 'Ma collection';

  @override
  String get challengeDailyCompleteTitle => 'Mission quotidienne terminée !';

  @override
  String get challengeDailyCompleteBody =>
      'Vous avez terminé toutes les étapes. Récupérez le prix et jouez librement.';

  @override
  String get challengeRewardStars => 'étoiles';

  @override
  String get challengeRewardStreak => 'traînée';

  @override
  String get challengeRewardSteps => 'mesures';

  @override
  String get challengeWhatNextTitle => 'Et ensuite ?';

  @override
  String get challengeWhatNextBody =>
      'Choisissez un héros : logique, mémoire, attention, compte ou chemin.';

  @override
  String challengeProgressStep(int current, int total) {
    return 'Étape $current de $total';
  }

  @override
  String get challengeChooseAnswer => 'Choisissez une réponse';

  @override
  String challengeSelectedAnswer(Object answer) {
    return 'Réponse : $answer';
  }

  @override
  String get challengePickDifferentAnswer => 'Choisissez une autre réponse';

  @override
  String get challengeCorrectAnswer => 'Correct!';

  @override
  String get challengeChecking => 'Vérification';

  @override
  String get challengeCheck => 'Vérifier';

  @override
  String get challengeCorrectFeedbackTitle => 'Super!';

  @override
  String get challengeRetryFeedbackTitle => 'Presque là';

  @override
  String get challengeCorrectFeedbackText =>
      'La réponse est correcte. Passons à autre chose !';

  @override
  String get hintLogic =>
      'La règle se répète. Trouvez le début de la répétition suivante et continuez la rangée.';

  @override
  String get hintMemory =>
      'Rappelez-vous d’abord quelles images ont été ouvertes. Recherchez ensuite la paire correspondante.';

  @override
  String get hintAttention =>
      'Comparez les détails un par un : couleur, forme, taille et lieu.';

  @override
  String get hintMath =>
      'Comptez en petits groupes pour qu’il soit plus facile de ne pas perdre le fil.';

  @override
  String get hintSpace =>
      'Suivez le chemin du début à la fin et nommez le prochain virage.';

  @override
  String get collectionTitle => 'Ma collection';

  @override
  String get collectionDayPrize => 'Prix ​​du jour';

  @override
  String get collectionCosmoPrizes => 'Prix ​​​​spatiaux';

  @override
  String collectionUnlocked(int total, int unlocked) {
    return '$unlocked ou $total ouvert';
  }

  @override
  String get collectionNewPrizeTitle => 'Prix ​​du nouveau jour';

  @override
  String get collectionNewPrizeBody => 'Astronaute ajouté à la collection.';

  @override
  String collectionSnackUnlocked(Object title) {
    return '$title est déjà dans la collection.';
  }

  @override
  String get collectionSnackLocked => 'S\'ouvre après de nouveaux niveaux.';

  @override
  String get collectionNewBadge => 'nouveau';

  @override
  String collectionLockedLevel(int level) {
    return '$level niveau.';
  }

  @override
  String get parentOverviewTitle => 'Aperçu des parents';

  @override
  String parentOverviewBody(String name) {
    return 'Profil $name, progrès, plan du jour et conseils pour s\'entraîner à la maison.';
  }

  @override
  String parentStarsCount(int stars) {
    return 'Étoiles $stars';
  }

  @override
  String get parentMissionClosed => 'mission accomplie';

  @override
  String get parentMissionWaiting => 'mission en attente';

  @override
  String get parentProgressTitle => 'Progrès de l\'enfant';

  @override
  String get parentOverviewBadge => 'aperçu';

  @override
  String get parentLevelsLabel => 'Niveaux';

  @override
  String parentLevelsValue(int completed, int total) {
    return '$completed ou $total';
  }

  @override
  String get parentTodayLabel => 'Aujourd\'hui';

  @override
  String parentTodayValue(int done, int total) {
    return '$done ou $total';
  }

  @override
  String get parentStarsLabel => 'Étoiles';

  @override
  String get parentContentLabel => 'Contenu';

  @override
  String parentContentValue(int done, int total) {
    return '$done ou $total';
  }

  @override
  String get parentTodayPlanTitle => 'Le plan d\'aujourd\'hui';

  @override
  String get parentTodayPlanBody =>
      'Une série courte sans pression : 2-3 essais calmes valent mieux qu\'une longue séance fatiguée.';

  @override
  String parentPuzzleMeta(String skill, int minutes) {
    return '$skill • $minutes min';
  }

  @override
  String get parentAreasTitle => 'Domaines de développement';

  @override
  String get parentBalanceBadge => 'équilibre';

  @override
  String get parentAreasBody =>
      'Il s\'agit d\'une carte pour adultes : les enfants devraient voir les missions et les héros, pas des catégories sèches.';

  @override
  String get parentRecommendationDone =>
      'La mission d\'aujourd\'hui est terminée. C’est le bon moment pour saluer l’effort, pas la vitesse.';

  @override
  String parentRecommendationRemaining(int remaining) {
    return 'Il y a des progrès aujourd\'hui : il reste des tâches $remaining.';
  }

  @override
  String get parentRecommendationStart =>
      'Aujourd\'hui, commencez par une courte mission de 4 à 6 minutes.';

  @override
  String get parentRecommendationsTitle => 'Recommandations';

  @override
  String get parentHomeBadge => 'à la maison';

  @override
  String get parentPaceLabel => 'Rythme';

  @override
  String get parentWeekFocusLabel => 'Focus de la semaine';

  @override
  String parentFocusArea(String areaTitle, String areaSubtitle) {
    return 'Le domaine qui nécessite le plus d’attention actuellement est « $areaTitle » : $areaSubtitle.';
  }

  @override
  String get parentDiscussLabel => 'Comment discuter';

  @override
  String get parentDiscussBody =>
      'Après une tâche, demandez : « Comment avez-vous trouvé la règle ? Cela construit une explication, pas une supposition.';

  @override
  String get parentFamilySecurityTitle => 'Famille et sécurité';

  @override
  String get parentStorageLabel => 'Stockage';

  @override
  String get parentStorageLocal => 'sur l\'appareil';
}
