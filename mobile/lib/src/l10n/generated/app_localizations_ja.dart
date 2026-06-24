// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'LogicUpX';

  @override
  String get loadingMission => 'ミッションの準備中...';

  @override
  String get navHome => '家';

  @override
  String get navChallenge => 'タスク';

  @override
  String get navParent => '親';

  @override
  String get commonCancel => 'キャンセル';

  @override
  String get commonReset => 'リセット';

  @override
  String languageChanged(Object language) {
    return '言語: $language';
  }

  @override
  String languageButtonSemantics(Object language) {
    return '言語を変更します。現在: $language';
  }

  @override
  String get onboardingSubmitSaving => 'ルートの準備中';

  @override
  String get onboardingSubmitCreateHero => 'ヒーローの作成';

  @override
  String get onboardingDefaultHero => '若き英雄';

  @override
  String get onboardingTitle => 'ヒーローを作成する';

  @override
  String onboardingHeroSummary(Object age, Object name) {
    return '$name, $age';
  }

  @override
  String get onboardingSubtitle => 'ライオンが毎日のミッションを示し、お子様は脳トレーニングを選択できます。';

  @override
  String get childNameLabel => '子供の名前';

  @override
  String get childNameError => 'ヒーロー名を入力してください';

  @override
  String get onboardingMissionPill => 'ミッション開始';

  @override
  String get onboardingAgeTitle => 'ヒーローの年齢';

  @override
  String get unlockMission => 'ミッション';

  @override
  String get unlockGames => 'ゲーム';

  @override
  String get unlockPrizes => '賞品';

  @override
  String ageYears(int years) {
    return '$years年';
  }

  @override
  String homeGreeting(Object name) {
    return 'こんにちは、\n$name';
  }

  @override
  String get homeStarsHint => 'スターはミッションによって成長し、新しい賞品のロックを解除します。';

  @override
  String get homeLockedLevelHint => 'このレベルは新しいスターの後に開きます。';

  @override
  String get homeStreakSavedHint => '連続記録を保存しました!明日、新たなミッションが到着します。';

  @override
  String get homeStreakNeedMissionHint => 'デイリーミッションを完了して連続記録を保存しましょう。';

  @override
  String get homeStreakTitle => '毎日の連続記録';

  @override
  String homeStreakDays(int days) {
    return '$days 連日！';
  }

  @override
  String get homeStreakWaiting => 'ミッションが待っています';

  @override
  String get homeMissionDaily => 'デイリーミッション';

  @override
  String get homeMissionFreePlay => 'フリープレイ';

  @override
  String get homeTrainingOpen => 'トレーニングは公開中です';

  @override
  String homeLevel(int level) {
    return 'レベル$level';
  }

  @override
  String get homeMissionStart => '始める';

  @override
  String get homeMissionChoose => '選ぶ';

  @override
  String get homeMissionTag => 'メインミッション';

  @override
  String get homeFreePlayTitle => '自分でプレイしてください';

  @override
  String get homeFreePlaySubtitle => 'ヒーローを選んで脳を鍛えましょう';

  @override
  String get homeMiniGamesTitle => 'ミニゲーム';

  @override
  String get homeMiniGamesSubtitle => 'レベル後の簡単なトレーニング';

  @override
  String get homeQuickPairs => 'ペア';

  @override
  String get homeQuickPath => 'パス';

  @override
  String get homeQuickCount => 'カウント';

  @override
  String get homeProgressTitle => '私の進歩';

  @override
  String homeProgressStars(int current, int total) {
    return '$current / $total 星';
  }

  @override
  String get homeCollectionTitle => 'コレクション';

  @override
  String get homeCollectionStickers => 'ステッカー';

  @override
  String get homeLevelsTitle => 'レベル';

  @override
  String get homeLevelsSubtitle => 'カレンダーではなく、8つのトレーニングテーマ';

  @override
  String get homeNodeCompleted => '終わり';

  @override
  String get homeNodePlay => '遊ぶ';

  @override
  String get homeNodeSoon => 'すぐ';

  @override
  String get homeMapStart => '始める';

  @override
  String get homeMapShapes => '形状';

  @override
  String get homeMapPairs => 'ペア';

  @override
  String get homeMapCount => 'カウント';

  @override
  String get homeMapPath => 'パス';

  @override
  String get homeMapRhythm => 'リズム';

  @override
  String get homeMapCompare => '比較する';

  @override
  String get homeMapFinal => 'ファイナル';

  @override
  String get parentTitle => '親エリア';

  @override
  String get parentIntroTitle => '大人の落ち着いたゾーン';

  @override
  String get parentIntroBody =>
      'プロフィール、進捗状況、言語、および今後のサブスクリプションは、子ミッションとは別に表示されます。';

  @override
  String get parentProfileTitle => '家族プロフィール';

  @override
  String get parentLocalBadge => '地元';

  @override
  String get parentChildLabel => '子供';

  @override
  String get parentAgeLabel => '年';

  @override
  String get parentCompletedTasksLabel => '完了したタスク';

  @override
  String get parentLanguageLabel => '言語';

  @override
  String get settingsLanguage => 'アプリ言語';

  @override
  String get parentSubscriptionTitle => 'ファミリーサブスクリプション';

  @override
  String get parentSubscriptionSoon => 'すぐ';

  @override
  String get parentSubscriptionBody => 'ここには支払い状況、ファミリーシート、プラン管理が表示されます。';

  @override
  String get parentFamilySeatsLabel => 'ファミリーシート';

  @override
  String get parentFamilySeatsValue => '計画された';

  @override
  String get parentPaymentLabel => '支払い';

  @override
  String get parentPaymentValue => '接続されていません';

  @override
  String get parentResetProfile => 'プロファイルをリセット';

  @override
  String get parentResetTitle => 'プロファイルをリセットしますか?';

  @override
  String get parentResetBody => 'オンボーディングが再び開き、ローカルの進行状況がクリアされます。';

  @override
  String get challengeTitle => '頭脳ゲーム';

  @override
  String get challengeDayDone => '一日が終わりました';

  @override
  String get challengeDailyMission => 'デイリーミッション';

  @override
  String get challengeDayDoneBody => '報酬を受け取りました。繰り返したり、自由に再生したりできます。';

  @override
  String get challengeDailyBody => '3 つのステップを完了して連続記録を保存し、賞品を受け取ります。';

  @override
  String get challengePrize => '賞';

  @override
  String get challengeMissionProgress => 'ミッションの進行状況';

  @override
  String countOfTotal(int count, int total) {
    return '$totalの$count';
  }

  @override
  String get challengeRepeatMission => 'リピートミッション';

  @override
  String challengeStepsTraining(int steps) {
    return '$steps トレーニングの手順';
  }

  @override
  String challengeStepNumber(int step) {
    return 'ステップ$step';
  }

  @override
  String get challengeAgain => 'また';

  @override
  String minutesShort(int minutes) {
    return '$minutes 分';
  }

  @override
  String get challengeBrainGymTitle => 'ブレインジム';

  @override
  String challengeBrainGymSubtitle(int count) {
    return '$count エリア、任意の順序でプレイ';
  }

  @override
  String challengeAreaLevels(int done, int total) {
    return '$done/$totalレベル';
  }

  @override
  String challengeAreaCompleted(int done, int total) {
    return '$done の $total 完成';
  }

  @override
  String get challengeStateCompleted => '終わり';

  @override
  String get challengeStateNext => '次';

  @override
  String get challengeStatePlay => '遊ぶ';

  @override
  String challengeLevelNumber(int level) {
    return 'レベル$level';
  }

  @override
  String get challengeHideHint => 'ヒントを隠す';

  @override
  String get challengeShowHint => 'ヒントを表示';

  @override
  String get challengeDailyTaskTitle => '日々のタスク';

  @override
  String get challengePuzzleTaskTitle => 'パズル';

  @override
  String get challengeDailyPath => '毎日のパス';

  @override
  String get challengeFreePlay => 'フリープレイ';

  @override
  String get challengeExcellent => '素晴らしい！';

  @override
  String get challengeFlyNext => '次に飛ぶ';

  @override
  String get challengeAllDone => '準備完了';

  @override
  String get challengePlayMore => 'もっとプレイする';

  @override
  String get challengeMyCollection => '私のコレクション';

  @override
  String get challengeDailyCompleteTitle => 'デイリーミッション完了！';

  @override
  String get challengeDailyCompleteBody => 'すべての手順が完了しました。賞品を集めて自由に遊んでください。';

  @override
  String get challengeRewardStars => '星';

  @override
  String get challengeRewardStreak => '縞模様';

  @override
  String get challengeRewardSteps => 'ステップ';

  @override
  String get challengeWhatNextTitle => '次は何でしょうか？';

  @override
  String get challengeWhatNextBody => 'ロジック、記憶、注意、カウント、またはパスからヒーローを選択します。';

  @override
  String challengeProgressStep(int current, int total) {
    return '$totalのステップ$current';
  }

  @override
  String get challengeChooseAnswer => '答えを選択してください';

  @override
  String challengeSelectedAnswer(Object answer) {
    return '答え：$answer';
  }

  @override
  String get challengePickDifferentAnswer => '別の答えを選択してください';

  @override
  String get challengeCorrectAnswer => '正しい！';

  @override
  String get challengeChecking => 'チェック中';

  @override
  String get challengeCheck => 'チェック';

  @override
  String get challengeCorrectFeedbackTitle => '素晴らしい！';

  @override
  String get challengeRetryFeedbackTitle => 'もうすぐそこ';

  @override
  String get challengeCorrectFeedbackText => '答えは正しいです。続けていきましょう！';

  @override
  String get hintLogic => 'ルールは繰り返されます。次の繰り返しの開始点を見つけて、行を続行します。';

  @override
  String get hintMemory => 'まず、どの写真が開かれたかを思い出してください。次に、一致するペアを探します。';

  @override
  String get hintAttention => '色、形、サイズ、場所などの詳細を 1 つずつ比較します。';

  @override
  String get hintMath => '小さなグループに分けて数えることで、見失ってしまうことを防ぎやすくなります。';

  @override
  String get hintSpace => '最初から最後までパスをたどり、次のターンに名前を付けます。';

  @override
  String get collectionTitle => '私のコレクション';

  @override
  String get collectionDayPrize => '当日賞品';

  @override
  String get collectionCosmoPrizes => '宇宙賞';

  @override
  String collectionUnlocked(int total, int unlocked) {
    return '$unlocked の $total オープン';
  }

  @override
  String get collectionNewPrizeTitle => 'ニューデイ賞';

  @override
  String get collectionNewPrizeBody => '宇宙飛行士がコレクションに追加されました。';

  @override
  String collectionSnackUnlocked(Object title) {
    return '$title はすでにコレクションに含まれています。';
  }

  @override
  String get collectionSnackLocked => '新しいレベルの後に開きます。';

  @override
  String get collectionNewBadge => '新しい';

  @override
  String collectionLockedLevel(int level) {
    return '$level Lv.';
  }

  @override
  String get parentOverviewTitle => '親の概要';

  @override
  String parentOverviewBody(String name) {
    return '$nameのプロフィール、進捗状況、今日の予定、自宅練習のヒントなど。';
  }

  @override
  String parentStarsCount(int stars) {
    return '$stars 星';
  }

  @override
  String get parentMissionClosed => '任務完了';

  @override
  String get parentMissionWaiting => 'ミッション待機中';

  @override
  String get parentProgressTitle => '子供の進歩';

  @override
  String get parentOverviewBadge => '概要';

  @override
  String get parentLevelsLabel => 'レベル';

  @override
  String parentLevelsValue(int completed, int total) {
    return '$completed/$total';
  }

  @override
  String get parentTodayLabel => '今日';

  @override
  String parentTodayValue(int done, int total) {
    return '$done/$total';
  }

  @override
  String get parentStarsLabel => 'スター';

  @override
  String get parentContentLabel => 'コンテンツ';

  @override
  String parentContentValue(int done, int total) {
    return '$done/$total';
  }

  @override
  String get parentTodayPlanTitle => '今日の予定';

  @override
  String get parentTodayPlanBody =>
      'プレッシャーのない短いシリーズ: 疲れた長いセッションを 1 回行うよりも、2 ～ 3 回の落ち着いたトライのほうが優れています。';

  @override
  String parentPuzzleMeta(String skill, int minutes) {
    return '$skill • $minutes 分';
  }

  @override
  String get parentAreasTitle => '開発エリア';

  @override
  String get parentBalanceBadge => 'バランス';

  @override
  String get parentAreasBody =>
      'これは大人向けのマップです。子供たちは無味乾燥なカテゴリではなく、ミッションとヒーローを参照する必要があります。';

  @override
  String get parentRecommendationDone =>
      '今日のミッションは完了です。スピードではなく努力を称賛するのに良い瞬間です。';

  @override
  String parentRecommendationRemaining(int remaining) {
    return '今日は進捗があります: $remaining タスクが残っています。';
  }

  @override
  String get parentRecommendationStart => '今日は、4 ～ 6 分の短いミッションを 1 つ始めてください。';

  @override
  String get parentRecommendationsTitle => '推奨事項';

  @override
  String get parentHomeBadge => '自宅で';

  @override
  String get parentPaceLabel => 'ペース';

  @override
  String get parentWeekFocusLabel => '週の焦点';

  @override
  String parentFocusArea(String areaTitle, String areaSubtitle) {
    return '今最も注意が必要なのは「$areaTitle」：$areaSubtitleです。';
  }

  @override
  String get parentDiscussLabel => '話し合う方法';

  @override
  String get parentDiscussBody =>
      'タスクの後で、「ルールをどうやって見つけましたか?」と尋ねます。これにより、推測ではなく説明が構築されます。';

  @override
  String get parentFamilySecurityTitle => '家族と安全';

  @override
  String get parentStorageLabel => 'ストレージ';

  @override
  String get parentStorageLocal => 'デバイス上で';

  @override
  String get notificationDailyTitle => '新しいミッションが待ってるよ';

  @override
  String notificationDailyBody(String name) {
    return '$name、小さなパズルを解いて星の連続記録を光らせよう。';
  }

  @override
  String get notificationEveningTitle => '寝る前にもう1ステップ？';

  @override
  String notificationEveningBody(String name) {
    return '$nameには短いミッションが残っています。落ち着いた5分で十分です。';
  }

  @override
  String get parentRemindersTitle => 'リマインダー';

  @override
  String get parentReminderStatusOn => 'オン';

  @override
  String get parentReminderStatusOff => 'オフ';

  @override
  String get parentRemindersBody => 'やさしい毎日の通知で、プレッシャーなくミッションに戻れます。';

  @override
  String get parentReminderDailyLabel => '今日のミッション';

  @override
  String get parentReminderDailyValue => '毎日18:30';

  @override
  String get parentReminderFollowUpLabel => '夜のフォロー';

  @override
  String get parentReminderFollowUpValue => 'ミッションが残っている場合は20:15';

  @override
  String get parentReminderToggleLabel => '戻る通知';

  @override
  String get parentReminderToggleOn => 'LogicUpXが短いミッションへそっと誘います。';

  @override
  String get parentReminderToggleOff => 'リマインダーはオフです。アプリは静かにしています。';

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
