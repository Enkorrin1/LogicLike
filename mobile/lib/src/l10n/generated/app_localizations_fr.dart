// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'LogicLike';

  @override
  String get homeTab => 'Maison';

  @override
  String get challengeTab => 'Quête';

  @override
  String get parentTab => 'Mère';

  @override
  String homeGreeting(Object childName) {
    return 'Bonjour,\n$childName';
  }

  @override
  String get dailyStreakTitle => 'Série quotidienne';

  @override
  String get streakStart => 'Commencer!';

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours',
      one: '$count jour',
    );
    return '$_temp0';
  }

  @override
  String dayCountShort(Object count) {
    return '$count j';
  }

  @override
  String get missionOpenButton => 'Ouvrir';

  @override
  String get missionStartShortButton => 'Commencer';

  @override
  String get missionStartButton => 'Commencer la quête';

  @override
  String get homeMissionCompletedTitle => 'Mission\ncomplet !';

  @override
  String get homeMissionHelpTitle =>
      'Aidez l\'astronaute\ncollectionnez les étoiles !';

  @override
  String get dailyChallengeTag => 'Quête quotidienne';

  @override
  String get myProgressTitle => 'Mes progrès';

  @override
  String levelLabel(Object level) {
    return 'Niveau $level';
  }

  @override
  String get myCollectionTitle => 'Ma collection';

  @override
  String stickerCountLabel(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'autocollants',
      one: 'autocollant',
    );
    return '$_temp0';
  }

  @override
  String homeParentHint(Object ageLabel, Object goalLabel, num minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes min cette semaine',
      one: '$minutes min cette semaine',
    );
    return '$ageLabel ? $goalLabel ? $_temp0';
  }

  @override
  String ageYears(num years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years ans',
      one: '$years an',
    );
    return '$_temp0';
  }

  @override
  String get goalLogicLabel => 'Logique';

  @override
  String get goalLogicDescription =>
      'Modèles, raisonnement et recherche de règles.';

  @override
  String get goalMathLabel => 'Mathématiques';

  @override
  String get goalMathDescription =>
      'Chiffres, comptage et solutions prudentes.';

  @override
  String get goalAttentionLabel => 'Se concentrer';

  @override
  String get goalAttentionDescription =>
      'Attention, mémoire et comparaison des détails.';

  @override
  String get onboardingTitle => 'Configurer LogicLike';

  @override
  String get onboardingSubtitle =>
      'Créez un profil familial afin que les quêtes quotidiennes correspondent à l\'âge et à l\'objectif de l\'enfant.';

  @override
  String get childNameLabel => 'Nom de l\'enfant';

  @override
  String get childNameError => 'Entrez un nom';

  @override
  String get ageSectionTitle => 'Âge';

  @override
  String get learningGoalSectionTitle => 'Objectif d\'apprentissage';

  @override
  String get learningGoalShortTitle => 'But';

  @override
  String get startButton => 'Commencer';

  @override
  String get savingButton => 'Économie';

  @override
  String get onboardingHeroTitle => 'Premier vol prêt';

  @override
  String get parentTag => 'Mère';

  @override
  String get parentDashboardTitle => 'Centre familial';

  @override
  String familyProfileSummary(
      Object ageLabel, Object childName, Object goalLabel) {
    return '$childName ? $ageLabel ? $goalLabel';
  }

  @override
  String get currentStreakMetric => 'traînée';

  @override
  String get sessionsMetric => 'séances';

  @override
  String get minutesMetric => 'minutes';

  @override
  String get childrenProfilesTitle => 'Profils enfants';

  @override
  String get addChildButton => 'Ajouter un enfant';

  @override
  String childProgressChallengeCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count d?fis',
      one: '$count d?fi',
    );
    return '$_temp0';
  }

  @override
  String ageGoalSummary(Object ageLabel, Object goalLabel) {
    return '$ageLabel ? $goalLabel';
  }

  @override
  String get newChildTitle => 'Nouvel enfant';

  @override
  String get cancelButton => 'Annuler';

  @override
  String get addButton => 'Ajouter';

  @override
  String get analyticsTitle => 'Pratiquer l\'analyse';

  @override
  String get streakMetricLabel => 'Traînée';

  @override
  String get bestStreakLabel => 'Meilleur';

  @override
  String get last7DaysLabel => '7 derniers jours';

  @override
  String get weeklyMinutesLabel => 'Minutes';

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
  String get lastSkillLabel => 'Dernière compétence';

  @override
  String get lastSessionLabel => 'Dernière séance';

  @override
  String get notAvailable => 'Pas encore';

  @override
  String get weeklyRhythmTitle => 'Rythme hebdomadaire';

  @override
  String get weeklyRhythmSubtitle =>
      'Pratiquez les jours et les minutes pour chaque jour.';

  @override
  String get subscriptionTitle => 'Abonnement familial';

  @override
  String get currentPlanLabel => 'Forfait actuel';

  @override
  String get familySeatsLabel => 'Sièges familiaux';

  @override
  String get updatedLabel => 'Mis à jour';

  @override
  String get recommendedLabel => 'Meilleur rapport qualité-prix';

  @override
  String get currentPlanButton => 'Forfait actuel';

  @override
  String get chooseButton => 'Choisir';

  @override
  String get resetProfilePanel =>
      'Réinitialisez le profil local et réexécutez l\'installation';

  @override
  String get resetButton => 'Réinitialiser';

  @override
  String get resetDialogTitle => 'Réinitialiser le profil ?';

  @override
  String get resetDialogBody =>
      'L\'intégration s\'ouvrira à nouveau et les progrès locaux seront effacés.';

  @override
  String get resetConfirmButton => 'Réinitialiser';

  @override
  String get limitPaidMessage =>
      'Tous les sièges familiaux sont déjà utilisés.';

  @override
  String get limitStarterMessage =>
      'Plus de profils sont disponibles sur le plan familial.';

  @override
  String get planStarterLabel => 'Démarreur';

  @override
  String get planStarterPrice => '0 ₽';

  @override
  String get planStarterCapacity => '1 profil enfant';

  @override
  String get planStarterDescription =>
      'Boucle quotidienne courte et progression locale.';

  @override
  String get planMonthlyLabel => 'Famille mensuelle';

  @override
  String get planMonthlyPrice => '399 ₽/mois';

  @override
  String get planFamilyCapacity => 'jusqu\'à 3 profils enfants';

  @override
  String get planMonthlyDescription =>
      'Accès complet, profils familiaux et analyses des parents.';

  @override
  String get planAnnualLabel => 'Famille annuelle';

  @override
  String get planAnnualPrice => '2990 ₽/an';

  @override
  String get planAnnualDescription =>
      'Le même accès, avec un meilleur rapport qualité-prix pour la facturation annuelle.';

  @override
  String get planActiveStatus => 'Actif';

  @override
  String get planInactiveStatus => 'Pas actif';

  @override
  String get missionCompletedTitle => 'Mission terminée !';

  @override
  String childGoCta(Object childName) {
    return '$childName, c?est parti !';
  }

  @override
  String get chooseAnswerTitle => 'Choisissez une réponse';

  @override
  String get checkingButton => 'Économie';

  @override
  String get checkAnswerButton => 'Vérifier';

  @override
  String answerCorrect(Object explanation) {
    return 'Exact ! $explanation';
  }

  @override
  String answerAlmost(Object hint) {
    return 'Presque. $hint';
  }

  @override
  String get challengeCompletedToday => 'La quête d\'aujourd\'hui est terminée';

  @override
  String get weekdayMondayShort => 'Lun';

  @override
  String get weekdayTuesdayShort => 'Mar';

  @override
  String get weekdayWednesdayShort => 'Épouser';

  @override
  String get weekdayThursdayShort => 'Jeu';

  @override
  String get weekdayFridayShort => 'Ven';

  @override
  String get weekdaySaturdayShort => 'Assis';

  @override
  String get weekdaySundayShort => 'Soleil';

  @override
  String get skillPatterns => 'Motifs';

  @override
  String get skillCountingToFive => 'Compter jusqu\'à cinq';

  @override
  String get skillComparison => 'Comparaison';

  @override
  String get skillSequences => 'Séquences';

  @override
  String get skillAdditionToTen => 'Ajout à dix';

  @override
  String get skillWorkingMemory => 'Mémoire de travail';

  @override
  String get skillLogicDeduction => 'Logique et déduction';

  @override
  String get skillMathThinking => 'Pensée mathématique';

  @override
  String get skillDetailComparison => 'Comparaison détaillée';

  @override
  String get challengeShapePathTitle => 'Chemin de forme';

  @override
  String get challengeShapePathPrompt =>
      'Regardez la rangée et trouvez la suite.';

  @override
  String get challengeShapePathQuestion =>
      'Cercle, carré, cercle, carré. Qu’est-ce qui vient ensuite ?';

  @override
  String get challengeShapePathHint =>
      'Les formes alternent : une forme, puis l\'autre, puis à nouveau la première.';

  @override
  String get challengeShapePathExplanation =>
      'Après le carré vient à nouveau un cercle, car la rangée se répète toutes les deux formes.';

  @override
  String get challengeToyCountTitle => 'Nombre de jouets';

  @override
  String get challengeToyCountPrompt =>
      'Comptez les objets et choisissez la réponse exacte.';

  @override
  String get challengeToyCountQuestion =>
      'Il y a 2 blocs et 1 balle sur l\'étagère. Combien y a-t-il de jouets ?';

  @override
  String get challengeToyCountHint =>
      'Comptez d\'abord les blocs, puis ajoutez la balle.';

  @override
  String get challengeToyCountExplanation =>
      '2 blocs et 1 balle font 3 jouets au total.';

  @override
  String get challengeOddCardTitle => 'Carte étrange sortie';

  @override
  String get challengeOddCardPrompt =>
      'Trouvez l\'élément qui est différent des autres.';

  @override
  String get challengeOddCardQuestion =>
      'Pomme, poire, boule, banane. Lequel n\'appartient pas ?';

  @override
  String get challengeOddCardHint =>
      'Trois objets peuvent être mangés, et un pour jouer.';

  @override
  String get challengeOddCardExplanation =>
      'La balle n’a pas sa place : la pomme, la poire et la banane sont des fruits.';

  @override
  String get challengeLogicTrainTitle => 'Train logique';

  @override
  String get challengeLogicTrainPrompt => 'Placez les wagons selon la règle.';

  @override
  String get challengeLogicTrainQuestion =>
      'Rouge, bleu, bleu, rouge, bleu, bleu. Qu’est-ce qui vient ensuite ?';

  @override
  String get challengeLogicTrainHint =>
      'La règle se répète par groupes de trois : un rouge et deux bleus.';

  @override
  String get challengeLogicTrainExplanation =>
      'La voiture suivante est rouge : après deux voitures bleues, un nouveau groupe démarre.';

  @override
  String get challengeStickerSumTitle => 'Album d\'autocollants';

  @override
  String get challengeStickerSumPrompt =>
      'Ajoutez deux petits groupes d\'objets.';

  @override
  String get challengeStickerSumQuestion =>
      'Nika avait 3 autocollants, puis en a reçu 2 autres. Combien en a-t-elle maintenant ?';

  @override
  String get challengeStickerSumHint =>
      'Commencez par trois et comptez encore deux pas.';

  @override
  String get challengeStickerSumExplanation =>
      '3 + 2 = 5, elle a donc cinq autocollants.';

  @override
  String get challengeMemoryPairsTitle => 'Paires de mémoire';

  @override
  String get challengeMemoryPairsPrompt =>
      'N\'oubliez pas la paire correspondante pour chaque élément.';

  @override
  String get challengeMemoryPairsQuestion => 'Qu\'est-ce qui va avec une clé ?';

  @override
  String get challengeMemoryPairsHint =>
      'Une clé est utilisée pour ouvrir quelque chose.';

  @override
  String get challengeMemoryPairsExplanation =>
      'Une clé va avec une serrure : ensemble, elles forment un couple significatif.';

  @override
  String get challengeCodeGridTitle => 'Grille de codes';

  @override
  String get challengeCodeGridPrompt =>
      'Résolvez la règle et choisissez la bonne cellule.';

  @override
  String get challengeCodeGridQuestion =>
      'La première ligne est 2, 4, 6. La seconde est 3, 5, ?. Quel numéro manque-t-il ?';

  @override
  String get challengeCodeGridHint =>
      'Les nombres de la deuxième rangée augmentent également de 2.';

  @override
  String get challengeCodeGridExplanation =>
      'Après 3 et 5 vient 7 : chaque pas en ajoute deux.';

  @override
  String get challengeNumberBridgeTitle => 'Pont numérique';

  @override
  String get challengeNumberBridgePrompt =>
      'Connectez les numéros pour construire le bon itinéraire.';

  @override
  String get challengeNumberBridgeQuestion =>
      'Vous avez 4, 2 et 1. Comment pouvez-vous faire 7 ?';

  @override
  String get challengeNumberBridgeHint =>
      'Essayez d\'utiliser tous les nombres une fois.';

  @override
  String get challengeNumberBridgeExplanation =>
      '4 + 2 + 1 = 7, donc les trois nombres ensemble constituent la cible.';

  @override
  String get challengeDetailCountTitle => 'Carte détaillée';

  @override
  String get challengeDetailCountPrompt =>
      'Gardez plusieurs détails à l’esprit et comparez-les.';

  @override
  String get challengeDetailCountQuestion =>
      'Il y a 3 cercles rouges, 2 carrés bleus et 1 étoile verte. Quel groupe en a le plus ?';

  @override
  String get challengeDetailCountHint => 'Comparez les montants : 3, 2 et 1.';

  @override
  String get challengeDetailCountExplanation =>
      'Les cercles rouges sont les plus nombreux : ils sont au nombre de trois.';

  @override
  String get challengeMemoryRecallTitle => 'Rappelez-vous les cartes';

  @override
  String get challengeMemoryRecallPrompt =>
      'Regardez la rangée et trouvez la carte cachée.';

  @override
  String get challengeMemoryRecallQuestion => 'Quelle carte est cachée ?';

  @override
  String get challengeMemoryRecallHint =>
      'Mémorisez les objets de gauche à droite et vérifiez le dernier.';

  @override
  String get challengeMemoryRecallExplanation =>
      'La carte cachée se trouvait dans la rangée dont vous deviez vous souvenir.';

  @override
  String get challengeSortingRuleTitle => 'Règle de la boîte';

  @override
  String get challengeSortingRulePrompt =>
      'Trouvez l\'objet qui appartient aux autres.';

  @override
  String get challengeSortingRuleQuestion =>
      'Qu\'est-ce qui suit la même règle ?';

  @override
  String get challengeSortingRuleHint =>
      'Trouvez d’abord ce que les objets de la boîte ont en commun.';

  @override
  String get challengeSortingRuleExplanation =>
      'L\'objet correct correspond à la règle de la boîte.';

  @override
  String get challengeMissingPieceTitle => 'Pièce manquante';

  @override
  String get challengeMissingPiecePrompt =>
      'Choisissez la partie qui complète le tableau.';

  @override
  String get challengeMissingPieceQuestion =>
      'Quelle pièce correspond à l’espace vide ?';

  @override
  String get challengeMissingPieceHint =>
      'Comparez la forme vide avec les choix de réponses.';

  @override
  String get challengeMissingPieceExplanation =>
      'Cette pièce complète le tableau sans coins supplémentaires.';

  @override
  String get challengeLogicDeductionTitle => 'Deux indices';

  @override
  String get challengeLogicDeductionPrompt =>
      'Utilisez les deux indices et supprimez les mauvais choix.';

  @override
  String get challengeLogicDeductionQuestion =>
      'Qu\'est-ce qui correspond à chaque indice ?';

  @override
  String get challengeLogicDeductionHint =>
      'Chaque indice supprime au moins un mauvais choix.';

  @override
  String get challengeLogicDeductionExplanation =>
      'La bonne réponse correspond aux deux indices.';

  @override
  String get choiceTriangle => 'Triangle';

  @override
  String get choiceCircle => 'Cercle';

  @override
  String get choiceStar => 'Étoile';

  @override
  String get choiceApple => 'Pomme';

  @override
  String get choiceBall => 'Balle';

  @override
  String get choiceBanana => 'Banane';

  @override
  String get choiceBlue => 'Bleu';

  @override
  String get choiceRed => 'Rouge';

  @override
  String get choiceGreen => 'Vert';

  @override
  String get choiceKey => 'Clé';

  @override
  String get choiceLock => 'Verrouillage';

  @override
  String get choiceShoe => 'Chaussure';

  @override
  String get choiceCloud => 'Nuage';

  @override
  String get choiceBlueSquares => 'Carrés bleus';

  @override
  String get choiceRedCircles => 'Cercles rouges';

  @override
  String get choiceGreenStars => 'Étoiles vertes';

  @override
  String mapLessonTitle(Object lesson) {
    return 'Le?on $lesson';
  }

  @override
  String get mapLessonSubtitle =>
      'Logique, comptage et concentration en une courte leçon';

  @override
  String get mapStartButton => 'Commencer';

  @override
  String get mapNodeStart => 'Commencer';

  @override
  String get mapNodeShapes => 'Formes';

  @override
  String get mapNodePairs => 'Paires';

  @override
  String get mapNodeCounting => 'Compte';

  @override
  String get mapNodePath => 'Chemin';

  @override
  String get mapNodeRhythm => 'Rythme';

  @override
  String get mapNodeCompare => 'Comparer';

  @override
  String get mapNodeFinal => 'Final';

  @override
  String get mapNodeCompleted => 'fait';

  @override
  String get mapNodeCurrent => 'ouvrir';

  @override
  String get mapNodeLocked => 'fermé';

  @override
  String mapPreviewTitle(Object lesson) {
    return 'Le?on $lesson';
  }

  @override
  String mapPreviewSteps(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ?tapes',
      one: '$count ?tape',
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
      other: '$count c?urs',
      one: '$count c?ur',
    );
    return '$_temp0';
  }

  @override
  String get mapPreviewBody =>
      'Une courte leçon avec des énigmes mixtes : logique, comptage, comparaison et concentration.';

  @override
  String get mapPreviewStart => 'Commencer la leçon';

  @override
  String get mapPreviewClose => 'Plus tard';

  @override
  String lessonProgress(Object current, Object total) {
    return '?tape $current sur $total';
  }

  @override
  String get lessonNextButton => 'Suivant';

  @override
  String get lessonFinishButton => 'Terminer la leçon';

  @override
  String get lessonCompleteTitle => 'Leçon terminée !';

  @override
  String get lessonCompleteBody =>
      'Vous avez débloqué l\'étape suivante sur la carte.';

  @override
  String get lessonRewardStars => '+1 étoile';

  @override
  String lessonRewardXp(Object xp) {
    return '+$xp XP';
  }

  @override
  String get lessonBackToMap => 'De retour à la maison';

  @override
  String get courseCatalogTitle => 'Cours et énigmes';

  @override
  String get courseLogicTitle => 'Logique';

  @override
  String get courseLogicSubtitle => 'Règles, impairs et raisonnement';

  @override
  String get courseMathTitle => 'Mathématiques';

  @override
  String get courseMathSubtitle => 'Comptage, sommes et comparaison';

  @override
  String get courseSpatialTitle => 'Formes';

  @override
  String get courseSpatialSubtitle => 'Forme, chemins et espace';

  @override
  String get courseAttentionTitle => 'Se concentrer';

  @override
  String get courseAttentionSubtitle => 'Détails, mémoire et attention';

  @override
  String get courseRebusTitle => 'Rébus';

  @override
  String get courseRebusSubtitle => 'Images, mots et énigmes';

  @override
  String get courseMixedTitle => 'Mélange quotidien';

  @override
  String get courseMixedSubtitle => 'Différentes énigmes d\'affilée';

  @override
  String progressCardBody(Object level, Object stars) {
    return 'Niveau $level ? $stars ?toiles';
  }

  @override
  String collectionCardBody(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count autocollants',
      one: '$count autocollant',
    );
    return '$_temp0';
  }

  @override
  String get dailyMissionBody =>
      'Un court ensemble d\'énigmes de logique, de comptage et de concentration.';

  @override
  String get openCourseButton => 'Ouvrir';

  @override
  String courseProgress(Object completed, Object total) {
    return '$completed le?ons sur $total termin?es';
  }

  @override
  String courseLessonTitle(Object lesson) {
    return 'Le?on $lesson';
  }

  @override
  String courseLessonMeta(num steps, Object xp) {
    String _temp0 = intl.Intl.pluralLogic(
      steps,
      locale: localeName,
      other: '$steps ?tapes',
      one: '$steps ?tape',
    );
    return '$_temp0 ? +$xp XP';
  }

  @override
  String get courseStartLessonButton => 'Commencer';

  @override
  String get courseRepeatButton => 'Répéter';

  @override
  String get showHintButton => 'Indice';

  @override
  String get hideHintButton => 'Masquer l\'indice';

  @override
  String get lessonStickerUnlockedTitle => 'Nouvel autocollant !';

  @override
  String get lessonStickerUnlockedBody =>
      'Votre collection s\'est agrandie après la leçon.';

  @override
  String get lessonRewardCollection => '+1 autocollant';

  @override
  String get lessonRewardStreak => 'La séquence grandit';

  @override
  String get challengeShadowMatchTitle => 'Match d\'ombre';

  @override
  String get challengeShadowMatchPrompt =>
      'Trouvez l\'objet qui correspond à l\'ombre.';

  @override
  String get challengeShadowMatchQuestion =>
      'L\'ombre a un corps grand et deux petites ailes. Qu\'est-ce que c\'est?';

  @override
  String get challengeShadowMatchHint =>
      'Regardez tout le contour de l\'objet.';

  @override
  String get challengeShadowMatchExplanation =>
      'La fusée correspond à l\'ombre : elle a un corps haut et deux ailes latérales.';

  @override
  String get challengeBalanceScaleTitle => 'Balance';

  @override
  String get challengeBalanceScalePrompt =>
      'Comparez les côtés et choisissez ce qui manque.';

  @override
  String get challengeBalanceScaleQuestion =>
      'Le côté gauche a 2 pommes. Le côté droit a 1 pomme et ?. Que faut-il ajouter ?';

  @override
  String get challengeBalanceScaleHint =>
      'Les deux côtés ont besoin du même nombre de pommes.';

  @override
  String get challengeBalanceScaleExplanation =>
      'Une pomme de plus rend le côté droit égal au côté gauche : 2 et 2.';

  @override
  String get challengeShapeRotationTitle => 'Tour de forme';

  @override
  String get challengeShapeRotationPrompt =>
      'Imaginez la forme qui se retourne.';

  @override
  String get challengeShapeRotationQuestion =>
      'Un triangle tourne vers la droite. Quelle carte montre la même forme ?';

  @override
  String get challengeShapeRotationHint =>
      'Tourner change la direction, mais pas la forme elle-même.';

  @override
  String get challengeShapeRotationExplanation =>
      'C\'est le même triangle : il a tourné, mais n\'a pas pris une forme différente.';

  @override
  String get choiceRocket => 'Fusée';

  @override
  String get choicePlanet => 'Planète';

  @override
  String get choiceSameTriangle => 'Même triangle';

  @override
  String get choiceSquare => 'Carré';

  @override
  String get skillInsightsTitle => 'Compétences et recommandations';

  @override
  String get strongestAreaLabel => 'Zone forte';

  @override
  String get practiceFocusLabel => 'Zone de mise au point';

  @override
  String get recommendedPracticeLabel => 'Entraînez-vous ensuite';

  @override
  String get noSkillDataLabel => 'Pas encore assez de données';

  @override
  String get recommendationKeepGoing =>
      'Continuez à faire des leçons courtes : les recommandations deviennent plus précises après quelques séances.';

  @override
  String get recommendationPracticeFocus =>
      'Ajoutez 1 à 2 courtes leçons pour ce domaine pendant la semaine.';

  @override
  String get courseNextMetricLabel => 'Suivant';

  @override
  String get courseStarsMetricLabel => 'Étoiles';

  @override
  String get courseXpMetricLabel => 'XP';

  @override
  String get courseCompletedState => 'fait';

  @override
  String get courseOpenState => 'ouvrir';

  @override
  String get courseLockedState => 'fermé';

  @override
  String get collectionScreenTitle => 'Collection d\'autocollants';

  @override
  String get collectionScreenSubtitle =>
      'Collectez des récompenses en suivant des leçons et en continuant à vous entraîner.';

  @override
  String collectionUnlockedCount(Object total, Object unlocked) {
    return '$unlocked sur $total d?bloqu?s';
  }

  @override
  String get collectionNextReward => 'Prochaine récompense';

  @override
  String get collectionAllRewardsUnlocked =>
      'Toutes les récompenses débloquées';

  @override
  String get collectionBackHome => 'De retour à la maison';

  @override
  String collectionLockedHint(Object stars) {
    return 'Se d?bloque apr?s $stars ?toiles';
  }

  @override
  String get rewardAstronautTitle => 'Aide étoile';

  @override
  String get rewardAstronautBody => 'Pour avoir terminé la première mission.';

  @override
  String get rewardRocketTitle => 'Fusée courageuse';

  @override
  String get rewardRocketBody => 'Pour ouvrir un cours d\'apprentissage.';

  @override
  String get rewardPlanetTitle => 'Petite planète';

  @override
  String get rewardPlanetBody => 'Pour avoir terminé deux leçons.';

  @override
  String get rewardLionTitle => 'Lion logique';

  @override
  String get rewardLionBody => 'Pour construire une séquence d’entraînement.';

  @override
  String get rewardPuzzleTitle => 'Insigne de puzzle';

  @override
  String get rewardPuzzleBody => 'Pour résoudre des énigmes mixtes.';

  @override
  String get rewardChampionTitle => 'Champion de l\'espace';

  @override
  String get rewardChampionBody => 'Pour une pratique hebdomadaire régulière.';

  @override
  String get accuracyMetricLabel => 'Précision';

  @override
  String get hintsMetricLabel => 'Conseils';

  @override
  String recommendationImproveAccuracy(Object skill) {
    return 'Travaillez $skill lentement cette semaine : la pr?cision est le signal cl?.';
  }

  @override
  String recommendationReduceHints(Object skill) {
    return 'R?p?tez $skill avec moins d?indices : faites une pause avant d?ouvrir l?aide.';
  }

  @override
  String recommendationRepeatAttempts(Object skill) {
    return 'Ajoutez une courte s?ance sur $skill pour r?duire les erreurs.';
  }

  @override
  String get homeRecommendedLessonTitle => 'Leçon suivante';

  @override
  String get homeRecommendedLessonSubtitle =>
      'Prochaine courte leçon sur le parcours d\'apprentissage.';

  @override
  String get homeRecommendedLessonButton => 'Continuer';

  @override
  String get homeRecommendedLessonCompleted => 'Itinéraire terminé';

  @override
  String get lessonReviewTitle => 'Résumé de la leçon';

  @override
  String get lessonReviewPerfectBody =>
      'Excellente concentration : pas d\'indices ni d\'erreurs.';

  @override
  String get lessonReviewSupportBody =>
      'Bonne finition. La prochaine fois, essayez une étape avec moins d\'aide.';

  @override
  String get lessonReviewQuestionsLabel => 'Questions';

  @override
  String get lessonReviewHintsLabel => 'Conseils';

  @override
  String get lessonReviewMistakesLabel => 'Erreurs';

  @override
  String get lessonNextRecommendedButton => 'Leçon suivante';

  @override
  String get practiceHistoryTitle => 'Historique de la pratique';

  @override
  String get practiceHistorySubtitle =>
      'Leçons récentes avec précision, astuces et erreurs.';

  @override
  String get practiceHistoryEmpty => 'Aucune leçon terminée pour l\'instant.';

  @override
  String practiceHistorySessionMeta(Object date, Object minutes) {
    return '$date - $minutes min';
  }

  @override
  String get practiceHistoryMistakesLabel => 'Erreurs';

  @override
  String get lessonTryAgainButton => 'Essayer à nouveau';

  @override
  String get lessonHintTitle => 'Réfléchissez étape par étape';

  @override
  String get lessonRetryFeedback =>
      'Bon essai. Lisez l\'indice, puis choisissez à nouveau.';

  @override
  String get languageSettingsTitle => 'Langue de l\'application';

  @override
  String get languageSettingsSubtitle =>
      'Choisissez la langue des écrans enfants et parents.';

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
  String get choicePear => 'Poire';

  @override
  String get challengeFruitPatternTitle => 'Rangée de fruits';

  @override
  String get challengeFruitPatternPrompt => 'Continuez le motif de fruits.';

  @override
  String get challengeFruitPatternQuestion =>
      'Pomme, banane, pomme, banane. Qu’est-ce qui vient ensuite ?';

  @override
  String get challengeFruitPatternHint =>
      'Les fruits se répètent un à un : pomme, puis banane.';

  @override
  String get challengeFruitPatternExplanation =>
      'Après la banane vient à nouveau la pomme, car le motif se répète.';

  @override
  String get challengeLockKeyTitle => 'Paire magique';

  @override
  String get challengeLockKeyPrompt =>
      'Choisissez l\'objet qui fait une paire.';

  @override
  String get challengeLockKeyQuestion =>
      'Une clé ouvre quelque chose. Avec quoi ça va ?';

  @override
  String get challengeLockKeyHint => 'Pensez à quoi sert une clé.';

  @override
  String get challengeLockKeyExplanation =>
      'Une clé et une serrure fonctionnent ensemble, elles forment donc la paire.';

  @override
  String get challengeSpaceSequenceTitle => 'Route spatiale';

  @override
  String get challengeSpaceSequencePrompt =>
      'Trouvez le prochain objet spatial.';

  @override
  String get challengeSpaceSequenceQuestion =>
      'Fusée, planète, fusée, planète. Qu’est-ce qui vient ensuite ?';

  @override
  String get challengeSpaceSequenceHint =>
      'Le parcours se répète : fusée, puis planète.';

  @override
  String get challengeSpaceSequenceExplanation =>
      'Après la planète vient à nouveau une fusée.';

  @override
  String get challengeShapeStackTitle => 'Tour de forme';

  @override
  String get challengeShapeStackPrompt => 'Continuez la règle de la tour.';

  @override
  String get challengeShapeStackQuestion =>
      'Carré, cercle, carré, cercle. Quelle forme est la suivante ?';

  @override
  String get challengeShapeStackHint => 'La tour alterne entre deux formes.';

  @override
  String get challengeShapeStackExplanation =>
      'Après un cercle vient à nouveau un carré.';

  @override
  String get challengePathMazeTitle => 'Recherche de chemin';

  @override
  String get challengePathMazePrompt => 'Suivez la route du début à la fin.';

  @override
  String get challengePathMazeQuestion =>
      'Aidez le héros à atteindre le but. Dans quelle direction faut-il aller ?';

  @override
  String get challengePathMazeHint =>
      'Tracez la route du début à la fin et choisissez la direction à la fourche.';

  @override
  String get challengePathMazeExplanation =>
      'La bonne route suit le chemin ouvert jusqu\'au but.';

  @override
  String get lesson_001_title => 'Chemin de forme';

  @override
  String get lesson_002_title => 'Compter les jouets';

  @override
  String get lesson_003_title => 'Carte étrange sortie';

  @override
  String get lesson_004_title => 'Train logique';

  @override
  String get lesson_005_title => 'Sommes et lignes';

  @override
  String get lesson_006_title => 'Mémoire et codes';

  @override
  String get lesson_007_title => 'Pont numérique';

  @override
  String get lesson_008_title => 'Carte détaillée';

  @override
  String get lesson_009_title => 'Ombres et équilibre';

  @override
  String get lesson_010_title => 'Ajouter et comparer';

  @override
  String get lesson_011_title => 'Virages et chemins';

  @override
  String get lesson_012_title => 'Mémoire et concentration';

  @override
  String get lesson_013_title => 'Modèle de fruits';

  @override
  String get lesson_014_title => 'Étagère mathématique';

  @override
  String get lesson_015_title => 'Tour de forme';

  @override
  String get lesson_016_title => 'Serrures et détails';

  @override
  String get lesson_017_title => 'Code et numéros';

  @override
  String get lesson_018_title => 'Séquence spatiale';

  @override
  String get lesson_019_title => 'Concentrez-vous sur les différences';

  @override
  String get lesson_020_title => 'Pont de solutions';

  @override
  String get lesson_021_title => 'Règles d\'affilée';

  @override
  String get lesson_022_title => 'Formes dans l\'espace';

  @override
  String get lesson_023_title => 'Mémoire et comptage';

  @override
  String get lesson_024_title => 'Mélange final';

  @override
  String get lesson_025_title => 'Détective de détail';

  @override
  String get lesson_026_title => 'Échelles et chiffres';

  @override
  String get lesson_027_title => 'Les impairs et les paires';

  @override
  String get lesson_028_title => 'Formes spatiales';

  @override
  String get lesson_029_title => 'Des sommes prudentes';

  @override
  String get lesson_030_title => 'Règle et code';

  @override
  String get lesson_031_title => 'Ombres, formes, mémoire';

  @override
  String get lesson_032_title => 'Chiffres et détails';

  @override
  String get lesson_033_title => 'Chaîne de règles';

  @override
  String get lesson_034_title => 'L\'espace tourne';

  @override
  String get lesson_035_title => 'Itinéraire en grand nombre';

  @override
  String get lesson_036_title => 'Finale des observateurs';

  @override
  String get lesson_037_title => 'Tours et mémoire';

  @override
  String get lesson_038_title => 'Compter les sprints';

  @override
  String get lesson_039_title => 'Règle et paire';

  @override
  String get lesson_040_title => 'Tour spatiale';

  @override
  String get lesson_041_title => 'Échelles et concentration';

  @override
  String get lesson_042_title => 'Train de codes';

  @override
  String get lesson_043_title => 'Ombres et serrures';

  @override
  String get lesson_044_title => 'Chiffres et mémoire';

  @override
  String get lesson_045_title => 'Longue chaîne';

  @override
  String get lesson_046_title => 'Itinéraire spatial';

  @override
  String get lesson_047_title => 'Sommes et détails';

  @override
  String get lesson_048_title => 'Focus logique';

  @override
  String get lesson_049_title => 'Des formes de près';

  @override
  String get lesson_050_title => 'Arithmétique minutieuse';

  @override
  String get lesson_051_title => 'Maître des modèles';

  @override
  String get lesson_052_title => 'Ombres dans l\'espace';

  @override
  String get lesson_053_title => 'Énigme numérique';

  @override
  String get lesson_054_title => 'Code observateur';

  @override
  String get lesson_055_title => 'Tour et clé';

  @override
  String get lesson_056_title => 'Détails et échelles';

  @override
  String get lesson_057_title => 'Des règles plus strictes';

  @override
  String get lesson_058_title => 'Forme finale';

  @override
  String get lesson_059_title => 'Tâche de grand nombre';

  @override
  String get lesson_060_title => 'Supermix logique';
}
