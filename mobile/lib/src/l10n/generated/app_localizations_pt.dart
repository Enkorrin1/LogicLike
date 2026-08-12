// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Logic Loka';

  @override
  String get loadingMission => 'Preparando a missão...';

  @override
  String get navHome => 'Lar';

  @override
  String get navChallenge => 'Tarefa';

  @override
  String get navParent => 'Pai';

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
    return 'Alterar idioma. Atual: $language';
  }

  @override
  String get onboardingSubmitSaving => 'Preparando rota';

  @override
  String get onboardingSubmitCreateHero => 'Criar herói';

  @override
  String get onboardingDefaultHero => 'Jovem herói';

  @override
  String get onboardingTitle => 'Crie um herói';

  @override
  String onboardingHeroSummary(Object age, Object name) {
    return '$name, $age';
  }

  @override
  String get onboardingSubtitle =>
      'O leão mostrará a missão diária, então seu filho poderá escolher o treinamento cerebral.';

  @override
  String get childNameLabel => 'Nome da criança';

  @override
  String get childNameError => 'Digite o nome do herói';

  @override
  String get onboardingMissionPill => 'início da missão';

  @override
  String get onboardingAgeTitle => 'Idade do herói';

  @override
  String get unlockMission => 'Missão';

  @override
  String get unlockGames => 'Jogos';

  @override
  String get unlockPrizes => 'Prêmios';

  @override
  String ageYears(int years) {
    return '$years anos';
  }

  @override
  String homeGreeting(Object name) {
    return 'Olá,\n$name';
  }

  @override
  String get homeStarsHint =>
      'As estrelas crescem a partir de missões e desbloqueiam novos prêmios.';

  @override
  String get homeLockedLevelHint => 'Este nível abre após novas estrelas.';

  @override
  String get homeStreakSavedHint =>
      'Sequência salva! Uma nova missão chega amanhã.';

  @override
  String get homeStreakNeedMissionHint =>
      'Complete a missão diária para salvar a seqüência.';

  @override
  String get homeStreakTitle => 'Sequência diária';

  @override
  String homeStreakDays(int days) {
    return '$days dias seguidos!';
  }

  @override
  String get homeStreakWaiting => 'missão está esperando';

  @override
  String get homeMissionDaily => 'Missão diária';

  @override
  String get homeMissionFreePlay => 'Jogo grátis';

  @override
  String get homeTrainingOpen => 'O treinamento está aberto';

  @override
  String homeLevel(int level) {
    return 'Nível $level';
  }

  @override
  String get homeMissionStart => 'Começar';

  @override
  String get homeMissionChoose => 'Escolher';

  @override
  String get homeMissionTag => 'Missão principal';

  @override
  String get homeFreePlayTitle => 'Jogue você mesmo';

  @override
  String get homeFreePlaySubtitle => 'escolha um herói e treine seu cérebro';

  @override
  String get homeMiniGamesTitle => 'Minijogos';

  @override
  String get homeMiniGamesSubtitle => 'treinamento rápido após os níveis';

  @override
  String get homeQuickPairs => 'Pares';

  @override
  String get homeQuickPath => 'Caminho';

  @override
  String get homeQuickCount => 'Contar';

  @override
  String get homeProgressTitle => 'Meu progresso';

  @override
  String homeProgressStars(int current, int total) {
    return 'Estrelas $current / $total';
  }

  @override
  String get homeCollectionTitle => 'Coleção';

  @override
  String get homeCollectionStickers => 'adesivos';

  @override
  String get homeLevelsTitle => 'Níveis';

  @override
  String get homeLevelsSubtitle => '8 temas de treinamento, não um calendário';

  @override
  String get homeNodeCompleted => 'feito';

  @override
  String get homeNodePlay => 'jogar';

  @override
  String get homeNodeSoon => 'breve';

  @override
  String get homeMapStart => 'Começar';

  @override
  String get homeMapShapes => 'Formas';

  @override
  String get homeMapPairs => 'Pares';

  @override
  String get homeMapCount => 'Contar';

  @override
  String get homeMapPath => 'Caminho';

  @override
  String get homeMapRhythm => 'Ritmo';

  @override
  String get homeMapCompare => 'Comparar';

  @override
  String get homeMapFinal => 'Final';

  @override
  String get parentTitle => 'Área pai';

  @override
  String get parentIntroTitle => 'Zona calma para adultos';

  @override
  String get parentIntroBody =>
      'Perfil, progresso, idioma e assinatura futura vivem separadamente da missão infantil.';

  @override
  String get parentProfileTitle => 'Perfil familiar';

  @override
  String get parentLocalBadge => 'local';

  @override
  String get parentChildLabel => 'Criança';

  @override
  String get parentAgeLabel => 'Idade';

  @override
  String get parentCompletedTasksLabel => 'Tarefas concluídas';

  @override
  String get parentLanguageLabel => 'Linguagem';

  @override
  String get settingsLanguage => 'Idioma do aplicativo';

  @override
  String get parentSubscriptionTitle => 'Assinatura familiar';

  @override
  String get parentSubscriptionSoon => 'breve';

  @override
  String get parentSubscriptionBody =>
      'Grade de lançamento: acesso Free, Premium Family mensal e Annual com preço inicial.';

  @override
  String get parentFamilySeatsLabel => 'Assentos familiares';

  @override
  String get parentFamilySeatsValue => 'planejado';

  @override
  String get parentPaymentLabel => 'Pagamento';

  @override
  String get parentPaymentValue => 'não conectado';

  @override
  String get parentSubscriptionLaunchBadge => 'preço inicial';

  @override
  String get parentSubscriptionCurrentFree => 'Grátis';

  @override
  String get parentSubscriptionFreeTitle => 'Grátis';

  @override
  String get parentSubscriptionFreePrice => '\$0';

  @override
  String get parentSubscriptionFreeBody =>
      'Um começo leve para testar o ciclo diário.';

  @override
  String get parentSubscriptionFeatureDaily => 'Missão diária';

  @override
  String get parentSubscriptionFeatureStarter => 'Níveis iniciais';

  @override
  String get parentSubscriptionFeatureLocalProgress =>
      'Progresso local neste dispositivo';

  @override
  String get parentSubscriptionFreeCta => 'Acesso atual';

  @override
  String get parentSubscriptionPremiumTitle => 'Família Premium';

  @override
  String get parentSubscriptionPremiumPrice => '\$5.99/mês';

  @override
  String get parentSubscriptionPremiumBadge => 'preço de lançamento';

  @override
  String get parentSubscriptionPremiumBody =>
      'Acesso familiar completo enquanto a biblioteca de conteúdo ainda cresce.';

  @override
  String get parentSubscriptionFeatureAllLevels =>
      'Todos os níveis atuais e novos';

  @override
  String get parentSubscriptionFeatureParentTips => 'Recomendações para pais';

  @override
  String get parentSubscriptionFeaturePurchaseRestore =>
      'Preparado para restaurar compras';

  @override
  String get parentSubscriptionPremiumCta => 'Escolher mensal';

  @override
  String get parentSubscriptionAnnualTitle => 'Anual';

  @override
  String get parentSubscriptionAnnualPrice => '\$39.99/ano';

  @override
  String get parentSubscriptionAnnualBadge => 'melhor valor';

  @override
  String get parentSubscriptionAnnualBody =>
      'Premium Family por um ano com preço anual inicial.';

  @override
  String get parentSubscriptionFeatureAnnualValue =>
      'Menos que 12 pagamentos mensais';

  @override
  String get parentSubscriptionFeatureYearAccess =>
      '12 meses de acesso familiar';

  @override
  String get parentSubscriptionFeatureUpdatesIncluded =>
      'Novos níveis incluídos durante o ano';

  @override
  String get parentSubscriptionAnnualCta => 'Escolher anual';

  @override
  String get parentSubscriptionFuturePriceNote =>
      'Depois, quando houver muitos níveis de qualidade: \$7.99/mês e \$49.99/ano.';

  @override
  String get parentSubscriptionBillingSoonSnack =>
      'A cobrança ainda não está conectada. Estes planos estão prontos para StoreKit e Google Play Billing.';

  @override
  String get parentResetProfile => 'Redefinir perfil';

  @override
  String get parentResetTitle => 'Redefinir perfil?';

  @override
  String get parentResetBody =>
      'A integração será aberta novamente e o progresso local será apagado.';

  @override
  String get challengeTitle => 'Jogos cerebrais';

  @override
  String get challengeDayDone => 'Dia completo';

  @override
  String get challengeDailyMission => 'Missão diária';

  @override
  String get challengeDayDoneBody =>
      'Recompensa recebida. Você pode repetir ou jogar livremente.';

  @override
  String get challengeDailyBody =>
      'Complete 3 etapas para salvar a sequência e receber o prêmio.';

  @override
  String get challengePrize => 'prêmio';

  @override
  String get challengeMissionProgress => 'Progresso da missão';

  @override
  String countOfTotal(int count, int total) {
    return '$count de $total';
  }

  @override
  String get challengeRepeatMission => 'Repetir missão';

  @override
  String challengeStepsTraining(int steps) {
    return 'Etapas $steps para treinamento';
  }

  @override
  String challengeStepNumber(int step) {
    return 'Passo $step';
  }

  @override
  String get challengeAgain => 'de novo';

  @override
  String minutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String get challengeBrainGymTitle => 'Ginásio cerebral';

  @override
  String challengeBrainGymSubtitle(int count) {
    return 'Áreas $count, jogue em qualquer ordem';
  }

  @override
  String challengeAreaLevels(int done, int total) {
    return 'Níveis $done/$total';
  }

  @override
  String challengeAreaCompleted(int done, int total) {
    return '$done de $total completo';
  }

  @override
  String get challengeStateCompleted => 'feito';

  @override
  String get challengeStateNext => 'próximo';

  @override
  String get challengeStatePlay => 'jogar';

  @override
  String challengeLevelNumber(int level) {
    return 'Nível $level';
  }

  @override
  String get challengeHideHint => 'Ocultar dica';

  @override
  String get challengeShowHint => 'Mostrar dica';

  @override
  String get challengeDailyTaskTitle => 'Tarefa diária';

  @override
  String get challengePuzzleTaskTitle => 'Quebra-cabeça';

  @override
  String get challengeDailyPath => 'Caminho diário';

  @override
  String get challengeFreePlay => 'Jogo grátis';

  @override
  String get challengeExcellent => 'Ótimo!';

  @override
  String get challengeFlyNext => 'Voando em seguida';

  @override
  String get challengeAllDone => 'Tudo pronto';

  @override
  String get challengePlayMore => 'Jogue mais';

  @override
  String get challengeMyCollection => 'Minha coleção';

  @override
  String get challengeDailyCompleteTitle => 'Missão diária concluída!';

  @override
  String get challengeDailyCompleteBody =>
      'Você concluiu todas as etapas. Receba o prêmio e jogue livremente.';

  @override
  String get challengeRewardStars => 'estrelas';

  @override
  String get challengeRewardStreak => 'onda';

  @override
  String get challengeRewardSteps => 'passos';

  @override
  String get challengeWhatNextTitle => 'O que vem a seguir?';

  @override
  String get challengeWhatNextBody =>
      'Escolha um herói: lógica, memória, atenção, contagem ou caminho.';

  @override
  String challengeProgressStep(int current, int total) {
    return 'Etapa $current de $total';
  }

  @override
  String get challengeChooseAnswer => 'Escolha uma resposta';

  @override
  String challengeSelectedAnswer(Object answer) {
    return 'Resposta: $answer';
  }

  @override
  String get challengePickDifferentAnswer => 'Escolha outra resposta';

  @override
  String get challengeCorrectAnswer => 'Correto!';

  @override
  String get challengeChecking => 'Verificando';

  @override
  String get challengeCheck => 'Verificar';

  @override
  String get challengeCorrectFeedbackTitle => 'Ótimo!';

  @override
  String get challengeRetryFeedbackTitle => 'Quase lá';

  @override
  String get challengeCorrectFeedbackText =>
      'A resposta está correta. Seguindo em frente!';

  @override
  String get hintLogic =>
      'A regra se repete. Encontre o início da próxima repetição e continue a linha.';

  @override
  String get hintMemory =>
      'Primeiro lembre-se de quais fotos foram abertas. Em seguida, procure o par correspondente.';

  @override
  String get hintAttention =>
      'Compare os detalhes um por um: cor, forma, tamanho e localização.';

  @override
  String get hintMath =>
      'Conte em pequenos grupos para que seja mais fácil não perder o controle.';

  @override
  String get hintSpace =>
      'Siga o caminho do início ao fim e nomeie a próxima curva.';

  @override
  String get collectionTitle => 'Minha coleção';

  @override
  String get collectionDayPrize => 'Prêmio do dia';

  @override
  String get collectionCosmoPrizes => 'Prêmios espaciais';

  @override
  String collectionUnlocked(int total, int unlocked) {
    return '$unlocked de $total aberto';
  }

  @override
  String get collectionNewPrizeTitle => 'Prêmio do novo dia';

  @override
  String get collectionNewPrizeBody => 'Astronauta adicionado à coleção.';

  @override
  String collectionSnackUnlocked(Object title) {
    return '$title já está na coleção.';
  }

  @override
  String get collectionSnackLocked => 'Abre após novos níveis.';

  @override
  String get collectionNewBadge => 'novo';

  @override
  String collectionLockedLevel(int level) {
    return '$level nível.';
  }

  @override
  String get parentOverviewTitle => 'Visão geral dos pais';

  @override
  String parentOverviewBody(String name) {
    return 'Perfil $name, progresso, plano de hoje e dicas para praticar em casa.';
  }

  @override
  String parentStarsCount(int stars) {
    return 'Estrelas $stars';
  }

  @override
  String get parentMissionClosed => 'missão cumprida';

  @override
  String get parentMissionWaiting => 'missão esperando';

  @override
  String get parentProgressTitle => 'Progresso infantil';

  @override
  String get parentOverviewBadge => 'visão geral';

  @override
  String get parentLevelsLabel => 'Níveis';

  @override
  String parentLevelsValue(int completed, int total) {
    return '$completed de $total';
  }

  @override
  String get parentTodayLabel => 'Hoje';

  @override
  String parentTodayValue(int done, int total) {
    return '$done de $total';
  }

  @override
  String get parentStarsLabel => 'Estrelas';

  @override
  String get parentContentLabel => 'Contente';

  @override
  String parentContentValue(int done, int total) {
    return '$done de $total';
  }

  @override
  String get parentTodayPlanTitle => 'O plano de hoje';

  @override
  String get parentTodayPlanBody =>
      'Uma série curta sem pressão: 2-3 tentativas calmas são melhores do que uma sessão longa e cansativa.';

  @override
  String parentPuzzleMeta(String skill, int minutes) {
    return '$skill • $minutes min';
  }

  @override
  String get parentAreasTitle => 'Áreas de desenvolvimento';

  @override
  String get parentBalanceBadge => 'equilíbrio';

  @override
  String get parentAreasBody =>
      'Este é um mapa adulto: as crianças devem ver missões e heróis, não categorias áridas.';

  @override
  String get parentRecommendationDone =>
      'A missão de hoje está cumprida. Este é um bom momento para elogiar o esforço, não a velocidade.';

  @override
  String parentRecommendationRemaining(int remaining) {
    return 'Há progresso hoje: tarefas $remaining restantes.';
  }

  @override
  String get parentRecommendationStart =>
      'Hoje, comece com uma missão curta de 4 a 6 minutos.';

  @override
  String get parentRecommendationsTitle => 'Recomendações';

  @override
  String get parentHomeBadge => 'em casa';

  @override
  String get parentPaceLabel => 'Ritmo';

  @override
  String get parentWeekFocusLabel => 'Foco da semana';

  @override
  String parentFocusArea(String areaTitle, String areaSubtitle) {
    return 'A área que precisa de mais atenção agora é “$areaTitle”: $areaSubtitle.';
  }

  @override
  String get parentDiscussLabel => 'Como discutir';

  @override
  String get parentDiscussBody =>
      'Após uma tarefa, pergunte: “Como você encontrou a regra?” Isso constrói explicação, não adivinhação.';

  @override
  String get parentFamilySecurityTitle => 'Família e segurança';

  @override
  String get parentStorageLabel => 'Armazenar';

  @override
  String get parentStorageLocal => 'no dispositivo';

  @override
  String get notificationDailyTitle => 'Uma nova missão espera';

  @override
  String notificationDailyBody(String name) {
    return '$name, resolva um pequeno desafio e mantenha a sequência de estrelas brilhando.';
  }

  @override
  String get notificationEveningTitle => 'Um passo antes de dormir?';

  @override
  String notificationEveningBody(String name) {
    return '$name ainda tem uma missão curta. 5 minutos tranquilos bastam.';
  }

  @override
  String get parentRemindersTitle => 'Lembretes';

  @override
  String get parentReminderStatusOn => 'ativos';

  @override
  String get parentReminderStatusOff => 'inativos';

  @override
  String get parentRemindersBody =>
      'Um lembrete diário leve ajuda a voltar à missão sem pressão.';

  @override
  String get parentReminderDailyLabel => 'Missão diária';

  @override
  String get parentReminderDailyValue => '18:30 todos os dias';

  @override
  String get parentReminderFollowUpLabel => 'Lembrete da noite';

  @override
  String get parentReminderFollowUpValue =>
      '20:15 se a missão estiver esperando';

  @override
  String get parentReminderToggleLabel => 'Lembrar de voltar';

  @override
  String get parentReminderToggleOn =>
      'O Logic Loka chamará a criança para uma missão curta.';

  @override
  String get parentReminderToggleOff =>
      'Os lembretes estão desligados. O app ficará silencioso.';

  @override
  String get parentAccountTitle => 'Conta';

  @override
  String get parentAccountBody =>
      'Entre para sincronizar o progresso, liberar assinaturas e restaurar compras em outro dispositivo.';

  @override
  String get parentAccountStatusGuest => 'convidado';

  @override
  String get parentAccountAction => 'Entrar';

  @override
  String get accountTitle => 'Entrar na conta';

  @override
  String get accountHeroTitle => 'Mantenha o perfil da família por perto';

  @override
  String get accountHeroBody =>
      'Use Google, Apple ou e-mail para preparar a sincronização na nuvem, compras e acesso seguro para responsáveis.';

  @override
  String get accountStatusGuest => 'modo convidado';

  @override
  String get accountAppleButton => 'Continuar com Apple';

  @override
  String get accountGoogleButton => 'Continuar com Google';

  @override
  String get accountAuthLoading => 'Verificando...';

  @override
  String get accountProviderGoogle => 'Google';

  @override
  String get accountProviderApple => 'Apple';

  @override
  String get accountProviderEmail => 'Email';

  @override
  String get accountSignedInTitle => 'Sessão iniciada';

  @override
  String get accountSignOut => 'Sair';

  @override
  String get accountGoogleSuccessSnack => 'Sessão iniciada com Google.';

  @override
  String get accountGoogleCanceledSnack => 'O acesso com Google foi cancelado.';

  @override
  String get accountGoogleUnsupportedSnack =>
      'O acesso com Google ainda não é compatível com esta plataforma.';

  @override
  String get accountGoogleConfigSnack =>
      'O acesso com Google precisa da configuração de um cliente OAuth para este app.';

  @override
  String accountGoogleErrorSnack(Object error) {
    return 'Não foi possível entrar com Google: $error';
  }

  @override
  String get accountBenefitGoogleTitle => 'Acesso com Google';

  @override
  String get accountBenefitGoogleBody =>
      'Use uma conta Google para acesso rápido dos responsáveis quando o OAuth estiver configurado.';

  @override
  String get accountEmailTitle => 'Acesso por e-mail';

  @override
  String get accountSignInTab => 'Entrar';

  @override
  String get accountCreateTab => 'Criar';

  @override
  String get accountEmailLabel => 'Email';

  @override
  String get accountPasswordLabel => 'Senha';

  @override
  String get accountConfirmPasswordLabel => 'Confirmar senha';

  @override
  String get accountRememberDevice => 'Lembrar este dispositivo';

  @override
  String get accountSubmitSignIn => 'Entrar';

  @override
  String get accountSubmitCreate => 'Criar conta';

  @override
  String get accountForgotPassword => 'Esqueci minha senha';

  @override
  String get accountRestorePurchases => 'Restaurar compras';

  @override
  String get accountPrivacyNote =>
      'As crianças continuam brincando localmente até os serviços de conta serem conectados.';

  @override
  String get accountBenefitSyncTitle => 'Sincronizar progresso';

  @override
  String get accountBenefitSyncBody =>
      'Um perfil conectado poderá levar estrelas e histórico de prática entre dispositivos mais tarde.';

  @override
  String get accountBenefitAppleTitle => 'Acesso com Apple pronto';

  @override
  String get accountBenefitAppleBody =>
      'O botão está pronto para vincular credenciais nativas da Apple.';

  @override
  String get accountBenefitPurchaseTitle => 'Compras e assinaturas';

  @override
  String get accountBenefitPurchaseBody =>
      'Restaure o acesso depois de reinstalar ou trocar de dispositivo.';

  @override
  String get accountEmailError => 'Informe um e-mail válido';

  @override
  String get accountPasswordError => 'Use pelo menos 6 caracteres';

  @override
  String get accountPasswordMismatch => 'As senhas não coincidem';

  @override
  String get accountDemoSnack =>
      'Sessão iniciada localmente por e-mail. Conecte um backend para verificar senhas no servidor.';

  @override
  String get accountAppleSnack =>
      'A interface de acesso Apple está pronta para o manipulador nativo.';

  @override
  String get accountRestoreSnack =>
      'A interface de restauração de compras está pronta para StoreKit.';

  @override
  String get accountResetDialogTitle => 'Redefinir senha';

  @override
  String get accountResetDialogBody =>
      'Os e-mails de redefinição serão enviados quando o backend de contas estiver conectado.';

  @override
  String get accountResetDialogAction => 'Entendi';

  @override
  String get puzzleListenPrompt => 'Ouvir a tarefa';

  @override
  String get puzzleStopNarration => 'Parar a narração';
}
