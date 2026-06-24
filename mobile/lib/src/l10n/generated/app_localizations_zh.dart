// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'LogicUpX';

  @override
  String get loadingMission => '准备任务...';

  @override
  String get navHome => '家';

  @override
  String get navChallenge => '任务';

  @override
  String get navParent => '家长';

  @override
  String get commonCancel => '取消';

  @override
  String get commonReset => '重置';

  @override
  String languageChanged(Object language) {
    return '语言：$language';
  }

  @override
  String languageButtonSemantics(Object language) {
    return '更改语言。当前：$language';
  }

  @override
  String get onboardingSubmitSaving => '准备路线';

  @override
  String get onboardingSubmitCreateHero => '创建英雄';

  @override
  String get onboardingDefaultHero => '少年英雄';

  @override
  String get onboardingTitle => '创建一个英雄';

  @override
  String onboardingHeroSummary(Object age, Object name) {
    return '$name, $age';
  }

  @override
  String get onboardingSubtitle => '狮子会显示每日任务，然后您的孩子可以选择大脑训练。';

  @override
  String get childNameLabel => '孩子姓名';

  @override
  String get childNameError => '输入英雄名字';

  @override
  String get onboardingMissionPill => '任务开始';

  @override
  String get onboardingAgeTitle => '英雄时代';

  @override
  String get unlockMission => '使命';

  @override
  String get unlockGames => '游戏';

  @override
  String get unlockPrizes => '奖品';

  @override
  String ageYears(int years) {
    return '$years年';
  }

  @override
  String homeGreeting(Object name) {
    return '嗨，\n$name';
  }

  @override
  String get homeStarsHint => '星星从任务中成长并解锁新的奖品。';

  @override
  String get homeLockedLevelHint => '此级别在新星星出现后开放。';

  @override
  String get homeStreakSavedHint => '连胜得救了！明天会有新的任务到来。';

  @override
  String get homeStreakNeedMissionHint => '完成每日任务以挽救连胜。';

  @override
  String get homeStreakTitle => '每日连胜';

  @override
  String homeStreakDays(int days) {
    return '$days 连续几天！';
  }

  @override
  String get homeStreakWaiting => '任务正在等待';

  @override
  String get homeMissionDaily => '每日任务';

  @override
  String get homeMissionFreePlay => '自由发挥';

  @override
  String get homeTrainingOpen => '培训已开放';

  @override
  String homeLevel(int level) {
    return '级别 $level';
  }

  @override
  String get homeMissionStart => '开始';

  @override
  String get homeMissionChoose => '选择';

  @override
  String get homeMissionTag => '主要任务';

  @override
  String get homeFreePlayTitle => '玩自己';

  @override
  String get homeFreePlaySubtitle => '选择一个英雄并训练你的大脑';

  @override
  String get homeMiniGamesTitle => '小游戏';

  @override
  String get homeMiniGamesSubtitle => '等级后快速训练';

  @override
  String get homeQuickPairs => '对';

  @override
  String get homeQuickPath => '小路';

  @override
  String get homeQuickCount => '数数';

  @override
  String get homeProgressTitle => '我的进步';

  @override
  String homeProgressStars(int current, int total) {
    return '$current / $total 星星';
  }

  @override
  String get homeCollectionTitle => '收藏';

  @override
  String get homeCollectionStickers => '贴纸';

  @override
  String get homeLevelsTitle => '级别';

  @override
  String get homeLevelsSubtitle => '8 个培训主题，而不是日历';

  @override
  String get homeNodeCompleted => '完毕';

  @override
  String get homeNodePlay => '玩';

  @override
  String get homeNodeSoon => '很快';

  @override
  String get homeMapStart => '开始';

  @override
  String get homeMapShapes => '形状';

  @override
  String get homeMapPairs => '对';

  @override
  String get homeMapCount => '数数';

  @override
  String get homeMapPath => '小路';

  @override
  String get homeMapRhythm => '韵律';

  @override
  String get homeMapCompare => '比较';

  @override
  String get homeMapFinal => '最终的';

  @override
  String get parentTitle => '家长区';

  @override
  String get parentIntroTitle => '成人平静区';

  @override
  String get parentIntroBody => '个人资料、进度、语言和未来订阅与子任务分开进行。';

  @override
  String get parentProfileTitle => '家庭概况';

  @override
  String get parentLocalBadge => '当地的';

  @override
  String get parentChildLabel => '孩子';

  @override
  String get parentAgeLabel => '年龄';

  @override
  String get parentCompletedTasksLabel => '任务完成';

  @override
  String get parentLanguageLabel => '语言';

  @override
  String get settingsLanguage => '应用语言';

  @override
  String get parentSubscriptionTitle => '家庭订阅';

  @override
  String get parentSubscriptionSoon => '很快';

  @override
  String get parentSubscriptionBody => '付款状态、家庭席位和计划管理将显示在这里。';

  @override
  String get parentFamilySeatsLabel => '家庭座位';

  @override
  String get parentFamilySeatsValue => '计划';

  @override
  String get parentPaymentLabel => '支付';

  @override
  String get parentPaymentValue => '未连接';

  @override
  String get parentResetProfile => '重置个人资料';

  @override
  String get parentResetTitle => '重置个人资料？';

  @override
  String get parentResetBody => '新手入门将再次开放，本地进度将被清除。';

  @override
  String get challengeTitle => '脑力游戏';

  @override
  String get challengeDayDone => '一天完成';

  @override
  String get challengeDailyMission => '每日任务';

  @override
  String get challengeDayDoneBody => '奖励已收到。您可以重复或自由播放。';

  @override
  String get challengeDailyBody => '完成 3 个步骤即可保存连胜并领取奖品。';

  @override
  String get challengePrize => '奖';

  @override
  String get challengeMissionProgress => '任务进展';

  @override
  String countOfTotal(int count, int total) {
    return '$total的$count';
  }

  @override
  String get challengeRepeatMission => '重复任务';

  @override
  String challengeStepsTraining(int steps) {
    return '$steps 训练步骤';
  }

  @override
  String challengeStepNumber(int step) {
    return '步骤 $step';
  }

  @override
  String get challengeAgain => '再次';

  @override
  String minutesShort(int minutes) {
    return '$minutes 分钟';
  }

  @override
  String get challengeBrainGymTitle => '大脑健身房';

  @override
  String challengeBrainGymSubtitle(int count) {
    return '$count区域，任意顺序玩';
  }

  @override
  String challengeAreaLevels(int done, int total) {
    return '$done/$total 级别';
  }

  @override
  String challengeAreaCompleted(int done, int total) {
    return '$done $total 完整';
  }

  @override
  String get challengeStateCompleted => '完毕';

  @override
  String get challengeStateNext => '下一个';

  @override
  String get challengeStatePlay => '玩';

  @override
  String challengeLevelNumber(int level) {
    return '级别 $level';
  }

  @override
  String get challengeHideHint => '隐藏提示';

  @override
  String get challengeShowHint => '显示提示';

  @override
  String get challengeDailyTaskTitle => '每日任务';

  @override
  String get challengePuzzleTaskTitle => '谜';

  @override
  String get challengeDailyPath => '日常路径';

  @override
  String get challengeFreePlay => '自由发挥';

  @override
  String get challengeExcellent => '伟大的！';

  @override
  String get challengeFlyNext => '接下来飞行';

  @override
  String get challengeAllDone => '一切就绪';

  @override
  String get challengePlayMore => '玩更多';

  @override
  String get challengeMyCollection => '我的收藏';

  @override
  String get challengeDailyCompleteTitle => '每日任务完成！';

  @override
  String get challengeDailyCompleteBody => '您已完成所有步骤。收集奖品并自由玩耍。';

  @override
  String get challengeRewardStars => '星星';

  @override
  String get challengeRewardStreak => '条纹';

  @override
  String get challengeRewardSteps => '步骤';

  @override
  String get challengeWhatNextTitle => '接下来怎么办？';

  @override
  String get challengeWhatNextBody => '选择英雄：逻辑、记忆、注意力、计数或路径。';

  @override
  String challengeProgressStep(int current, int total) {
    return '$total 的步骤 $current';
  }

  @override
  String get challengeChooseAnswer => '选择一个答案';

  @override
  String challengeSelectedAnswer(Object answer) {
    return '答案：$answer';
  }

  @override
  String get challengePickDifferentAnswer => '选择另一个答案';

  @override
  String get challengeCorrectAnswer => '正确的！';

  @override
  String get challengeChecking => '检查';

  @override
  String get challengeCheck => '查看';

  @override
  String get challengeCorrectFeedbackTitle => '伟大的！';

  @override
  String get challengeRetryFeedbackTitle => '快到了';

  @override
  String get challengeCorrectFeedbackText => '答案是正确的。继续前进！';

  @override
  String get hintLogic => '规则重复。找到下一个重复的开始并继续该行。';

  @override
  String get hintMemory => '首先记住打开了哪些图片。然后寻找匹配的对。';

  @override
  String get hintAttention => '一一比较细节：颜色、形状、大小和位置。';

  @override
  String get hintMath => '分成小组数数，这样就更容易不迷失方向。';

  @override
  String get hintSpace => '从头到尾遵循路径并命名下一个回合。';

  @override
  String get collectionTitle => '我的收藏';

  @override
  String get collectionDayPrize => '日间奖';

  @override
  String get collectionCosmoPrizes => '太空奖品';

  @override
  String collectionUnlocked(int total, int unlocked) {
    return '$unlocked $total 开启';
  }

  @override
  String get collectionNewPrizeTitle => '新一天奖品';

  @override
  String get collectionNewPrizeBody => '宇航员已添加到收藏中。';

  @override
  String collectionSnackUnlocked(Object title) {
    return '$title 已在集合中。';
  }

  @override
  String get collectionSnackLocked => '新关卡后打开。';

  @override
  String get collectionNewBadge => '新的';

  @override
  String collectionLockedLevel(int level) {
    return '$level 级。';
  }

  @override
  String get parentOverviewTitle => '家长概览';

  @override
  String parentOverviewBody(String name) {
    return '简介 $name、进度、今天的计划以及在家练习的技巧。';
  }

  @override
  String parentStarsCount(int stars) {
    return '$stars 星星';
  }

  @override
  String get parentMissionClosed => '任务完成';

  @override
  String get parentMissionWaiting => '任务等待';

  @override
  String get parentProgressTitle => '孩子进步';

  @override
  String get parentOverviewBadge => '概述';

  @override
  String get parentLevelsLabel => '级别';

  @override
  String parentLevelsValue(int completed, int total) {
    return '$total的$completed';
  }

  @override
  String get parentTodayLabel => '今天';

  @override
  String parentTodayValue(int done, int total) {
    return '$total的$done';
  }

  @override
  String get parentStarsLabel => '星星';

  @override
  String get parentContentLabel => '内容';

  @override
  String parentContentValue(int done, int total) {
    return '$total的$done';
  }

  @override
  String get parentTodayPlanTitle => '今天的计划';

  @override
  String get parentTodayPlanBody => '没有压力的简短系列：2-3次平静的尝试比一次漫长而疲惫的训练要好。';

  @override
  String parentPuzzleMeta(String skill, int minutes) {
    return '$skill • $minutes 最小值';
  }

  @override
  String get parentAreasTitle => '开发领域';

  @override
  String get parentBalanceBadge => '平衡';

  @override
  String get parentAreasBody => '这是成人地图：孩子们应该看到任务和英雄，而不是枯燥的类别。';

  @override
  String get parentRecommendationDone => '今天的任务完成了。这是赞扬努力而不是速度的好时机。';

  @override
  String parentRecommendationRemaining(int remaining) {
    return '今天有进展：$remaining 任务还剩。';
  }

  @override
  String get parentRecommendationStart => '今天，从一项 4-6 分钟的简短任务开始。';

  @override
  String get parentRecommendationsTitle => '建议';

  @override
  String get parentHomeBadge => '在家里';

  @override
  String get parentPaceLabel => '步伐';

  @override
  String get parentWeekFocusLabel => '周焦点';

  @override
  String parentFocusArea(String areaTitle, String areaSubtitle) {
    return '现在最需要关注的区域是“$areaTitle”：$areaSubtitle。';
  }

  @override
  String get parentDiscussLabel => '如何讨论';

  @override
  String get parentDiscussBody => '完成一项任务后，问：“你是如何发现规则的？”这建立了解释，而不是猜测。';

  @override
  String get parentFamilySecurityTitle => '家庭与安全';

  @override
  String get parentStorageLabel => '贮存';

  @override
  String get parentStorageLocal => '在设备上';

  @override
  String get notificationDailyTitle => '新任务在等你';

  @override
  String notificationDailyBody(String name) {
    return '$name，完成一个小谜题，让星星连胜继续发光。';
  }

  @override
  String get notificationEveningTitle => '睡前再走一步？';

  @override
  String notificationEveningBody(String name) {
    return '$name 还有一个短任务。安静练习 5 分钟就够了。';
  }

  @override
  String get parentRemindersTitle => '提醒';

  @override
  String get parentReminderStatusOn => '开启';

  @override
  String get parentReminderStatusOff => '关闭';

  @override
  String get parentRemindersBody => '温和的每日提醒帮助孩子无压力地回到任务。';

  @override
  String get parentReminderDailyLabel => '每日任务';

  @override
  String get parentReminderDailyValue => '每天 18:30';

  @override
  String get parentReminderFollowUpLabel => '晚间提醒';

  @override
  String get parentReminderFollowUpValue => '如果任务还在等待，20:15';

  @override
  String get parentReminderToggleLabel => '提醒回来';

  @override
  String get parentReminderToggleOn => 'LogicUpX 会邀请孩子完成一个短任务。';

  @override
  String get parentReminderToggleOff => '提醒已关闭。应用会保持安静。';

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
