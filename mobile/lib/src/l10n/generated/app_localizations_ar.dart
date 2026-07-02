// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'LogicLoka';

  @override
  String get loadingMission => 'تحضير المهمة...';

  @override
  String get navHome => 'بيت';

  @override
  String get navChallenge => 'مهمة';

  @override
  String get navParent => 'الوالد';

  @override
  String get commonCancel => 'يلغي';

  @override
  String get commonReset => 'إعادة ضبط';

  @override
  String languageChanged(Object language) {
    return 'اللغة: $language';
  }

  @override
  String languageButtonSemantics(Object language) {
    return 'تغيير اللغة. الحالي: $language';
  }

  @override
  String get onboardingSubmitSaving => 'تحضير الطريق';

  @override
  String get onboardingSubmitCreateHero => 'خلق البطل';

  @override
  String get onboardingDefaultHero => 'البطل الشاب';

  @override
  String get onboardingTitle => 'خلق بطلا';

  @override
  String onboardingHeroSummary(Object age, Object name) {
    return '$name, $age';
  }

  @override
  String get onboardingSubtitle =>
      'سيظهر الأسد المهمة اليومية، ثم يمكن لطفلك اختيار تدريب الدماغ.';

  @override
  String get childNameLabel => 'اسم الطفل';

  @override
  String get childNameError => 'أدخل اسم البطل';

  @override
  String get onboardingMissionPill => 'بداية المهمة';

  @override
  String get onboardingAgeTitle => 'عمر البطل';

  @override
  String get unlockMission => 'مهمة';

  @override
  String get unlockGames => 'ألعاب';

  @override
  String get unlockPrizes => 'الجوائز';

  @override
  String ageYears(int years) {
    return 'سنوات $years';
  }

  @override
  String homeGreeting(Object name) {
    return 'مرحبًا،\n$name';
  }

  @override
  String get homeStarsHint => 'تنمو النجوم من خلال المهام وتفتح جوائز جديدة.';

  @override
  String get homeLockedLevelHint => 'يفتح هذا المستوى بعد النجوم الجدد.';

  @override
  String get homeStreakSavedHint => 'تم حفظ الخط! مهمة جديدة تصل غدا.';

  @override
  String get homeStreakNeedMissionHint => 'أكمل المهمة اليومية لحفظ الخط.';

  @override
  String get homeStreakTitle => 'خط يومي';

  @override
  String homeStreakDays(int days) {
    return '$days أيام على التوالي!';
  }

  @override
  String get homeStreakWaiting => 'المهمة تنتظر';

  @override
  String get homeMissionDaily => 'مهمة يومية';

  @override
  String get homeMissionFreePlay => 'اللعب الحر';

  @override
  String get homeTrainingOpen => 'التدريب مفتوح';

  @override
  String homeLevel(int level) {
    return 'المستوى $level';
  }

  @override
  String get homeMissionStart => 'يبدأ';

  @override
  String get homeMissionChoose => 'يختار';

  @override
  String get homeMissionTag => 'المهمة الرئيسية';

  @override
  String get homeFreePlayTitle => 'العب بنفسك';

  @override
  String get homeFreePlaySubtitle => 'اختيار البطل وتدريب دماغك';

  @override
  String get homeMiniGamesTitle => 'ألعاب مصغرة';

  @override
  String get homeMiniGamesSubtitle => 'التدريب السريع بعد المستويات';

  @override
  String get homeQuickPairs => 'أزواج';

  @override
  String get homeQuickPath => 'طريق';

  @override
  String get homeQuickCount => 'عدد';

  @override
  String get homeProgressTitle => 'تقدمي';

  @override
  String homeProgressStars(int current, int total) {
    return 'نجوم $current / $total';
  }

  @override
  String get homeCollectionTitle => 'مجموعة';

  @override
  String get homeCollectionStickers => 'ملصقات';

  @override
  String get homeLevelsTitle => 'المستويات';

  @override
  String get homeLevelsSubtitle => '8 مواضيع تدريبية، وليس التقويم';

  @override
  String get homeNodeCompleted => 'منتهي';

  @override
  String get homeNodePlay => 'يلعب';

  @override
  String get homeNodeSoon => 'قريباً';

  @override
  String get homeMapStart => 'يبدأ';

  @override
  String get homeMapShapes => 'الأشكال';

  @override
  String get homeMapPairs => 'أزواج';

  @override
  String get homeMapCount => 'عدد';

  @override
  String get homeMapPath => 'طريق';

  @override
  String get homeMapRhythm => 'إيقاع';

  @override
  String get homeMapCompare => 'يقارن';

  @override
  String get homeMapFinal => 'أخير';

  @override
  String get parentTitle => 'منطقة الوالدين';

  @override
  String get parentIntroTitle => 'منطقة هادئة للبالغين';

  @override
  String get parentIntroBody =>
      'الملف الشخصي والتقدم واللغة والاشتراك المستقبلي مباشر بشكل منفصل عن مهمة الطفل.';

  @override
  String get parentProfileTitle => 'الملف الشخصي للعائلة';

  @override
  String get parentLocalBadge => 'محلي';

  @override
  String get parentChildLabel => 'طفل';

  @override
  String get parentAgeLabel => 'عمر';

  @override
  String get parentCompletedTasksLabel => 'اكتملت المهام';

  @override
  String get parentLanguageLabel => 'لغة';

  @override
  String get settingsLanguage => 'لغة التطبيق';

  @override
  String get parentSubscriptionTitle => 'الاشتراك العائلي';

  @override
  String get parentSubscriptionSoon => 'قريباً';

  @override
  String get parentSubscriptionBody =>
      'أسعار الإطلاق: وصول Free، وPremium Family شهري، وAnnual بالسعر المبكر.';

  @override
  String get parentFamilySeatsLabel => 'مقاعد عائلية';

  @override
  String get parentFamilySeatsValue => 'المخطط لها';

  @override
  String get parentPaymentLabel => 'قسط';

  @override
  String get parentPaymentValue => 'غير متصل';

  @override
  String get parentSubscriptionLaunchBadge => 'سعر مبكر';

  @override
  String get parentSubscriptionCurrentFree => 'Free';

  @override
  String get parentSubscriptionFreeTitle => 'Free';

  @override
  String get parentSubscriptionFreePrice => '\$0';

  @override
  String get parentSubscriptionFreeBody => 'بداية هادئة لتجربة المسار اليومي.';

  @override
  String get parentSubscriptionFeatureDaily => 'المهمة اليومية';

  @override
  String get parentSubscriptionFeatureStarter => 'مستويات البداية';

  @override
  String get parentSubscriptionFeatureLocalProgress =>
      'تقدم محلي على هذا الجهاز';

  @override
  String get parentSubscriptionFreeCta => 'الوصول الحالي';

  @override
  String get parentSubscriptionPremiumTitle => 'Premium Family';

  @override
  String get parentSubscriptionPremiumPrice => '\$5.99/شهر';

  @override
  String get parentSubscriptionPremiumBadge => 'سعر الإطلاق';

  @override
  String get parentSubscriptionPremiumBody =>
      'وصول عائلي كامل بينما مكتبة المحتوى ما زالت تنمو.';

  @override
  String get parentSubscriptionFeatureAllLevels =>
      'كل المستويات الحالية والجديدة';

  @override
  String get parentSubscriptionFeatureParentTips => 'توصيات للوالدين';

  @override
  String get parentSubscriptionFeaturePurchaseRestore =>
      'جاهز لاستعادة المشتريات';

  @override
  String get parentSubscriptionPremiumCta => 'اختر الشهري';

  @override
  String get parentSubscriptionAnnualTitle => 'Annual';

  @override
  String get parentSubscriptionAnnualPrice => '\$39.99/سنة';

  @override
  String get parentSubscriptionAnnualBadge => 'الأفضل قيمة';

  @override
  String get parentSubscriptionAnnualBody =>
      'Premium Family لمدة عام بالسعر السنوي المبكر.';

  @override
  String get parentSubscriptionFeatureAnnualValue => 'أقل من 12 دفعة شهرية';

  @override
  String get parentSubscriptionFeatureYearAccess =>
      '12 شهرًا من الوصول العائلي';

  @override
  String get parentSubscriptionFeatureUpdatesIncluded =>
      'مستويات جديدة مشمولة خلال العام';

  @override
  String get parentSubscriptionAnnualCta => 'اختر السنوي';

  @override
  String get parentSubscriptionFuturePriceNote =>
      'لاحقًا، عندما تتوفر مستويات كثيرة عالية الجودة: \$7.99/شهر و\$49.99/سنة.';

  @override
  String get parentSubscriptionBillingSoonSnack =>
      'الفوترة غير متصلة بعد. هذه الخطط جاهزة لـ StoreKit وGoogle Play Billing.';

  @override
  String get parentResetProfile => 'إعادة تعيين الملف الشخصي';

  @override
  String get parentResetTitle => 'إعادة تعيين الملف الشخصي؟';

  @override
  String get parentResetBody =>
      'سيتم فتح عملية الإعداد مرة أخرى وسيتم مسح التقدم المحلي.';

  @override
  String get challengeTitle => 'العاب الدماغ';

  @override
  String get challengeDayDone => 'يوم كامل';

  @override
  String get challengeDailyMission => 'مهمة يومية';

  @override
  String get challengeDayDoneBody =>
      'تم استلام المكافأة. يمكنك تكرار أو اللعب بحرية.';

  @override
  String get challengeDailyBody => 'أكمل 3 خطوات لحفظ الخط واستلام الجائزة.';

  @override
  String get challengePrize => 'جائزة';

  @override
  String get challengeMissionProgress => 'تقدم المهمة';

  @override
  String countOfTotal(int count, int total) {
    return '$count من $total';
  }

  @override
  String get challengeRepeatMission => 'كرر المهمة';

  @override
  String challengeStepsTraining(int steps) {
    return 'خطوات $steps للتدريب';
  }

  @override
  String challengeStepNumber(int step) {
    return 'الخطوة $step';
  }

  @override
  String get challengeAgain => 'مرة أخرى';

  @override
  String minutesShort(int minutes) {
    return '$minutes دقيقة';
  }

  @override
  String get challengeBrainGymTitle => 'صالة الألعاب الرياضية الدماغ';

  @override
  String challengeBrainGymSubtitle(int count) {
    return 'مناطق $count، العب بأي ترتيب';
  }

  @override
  String challengeAreaLevels(int done, int total) {
    return 'مستويات $done/$total';
  }

  @override
  String challengeAreaCompleted(int done, int total) {
    return 'اكتمل $done من $total';
  }

  @override
  String get challengeStateCompleted => 'منتهي';

  @override
  String get challengeStateNext => 'التالي';

  @override
  String get challengeStatePlay => 'يلعب';

  @override
  String challengeLevelNumber(int level) {
    return 'المستوى $level';
  }

  @override
  String get challengeHideHint => 'إخفاء التلميح';

  @override
  String get challengeShowHint => 'إظهار التلميح';

  @override
  String get challengeDailyTaskTitle => 'مهمة يومية';

  @override
  String get challengePuzzleTaskTitle => 'لغز';

  @override
  String get challengeDailyPath => 'المسار اليومي';

  @override
  String get challengeFreePlay => 'اللعب الحر';

  @override
  String get challengeExcellent => 'عظيم!';

  @override
  String get challengeFlyNext => 'الطيران المقبل';

  @override
  String get challengeAllDone => 'كل شيء جاهز';

  @override
  String get challengePlayMore => 'العب أكثر';

  @override
  String get challengeMyCollection => 'مجموعتي';

  @override
  String get challengeDailyCompleteTitle => 'المهمة اليومية كاملة!';

  @override
  String get challengeDailyCompleteBody =>
      'لقد انتهيت من جميع الخطوات. اجمع الجائزة والعب بحرية.';

  @override
  String get challengeRewardStars => 'النجوم';

  @override
  String get challengeRewardStreak => 'أثَر';

  @override
  String get challengeRewardSteps => 'خطوات';

  @override
  String get challengeWhatNextTitle => 'ماذا بعد؟';

  @override
  String get challengeWhatNextBody =>
      'اختر البطل: المنطق أو الذاكرة أو الاهتمام أو العد أو المسار.';

  @override
  String challengeProgressStep(int current, int total) {
    return 'الخطوة $current من $total';
  }

  @override
  String get challengeChooseAnswer => 'اختر إجابة';

  @override
  String challengeSelectedAnswer(Object answer) {
    return 'الجواب: $answer';
  }

  @override
  String get challengePickDifferentAnswer => 'اختر إجابة أخرى';

  @override
  String get challengeCorrectAnswer => 'صحيح!';

  @override
  String get challengeChecking => 'التحقق';

  @override
  String get challengeCheck => 'يفحص';

  @override
  String get challengeCorrectFeedbackTitle => 'عظيم!';

  @override
  String get challengeRetryFeedbackTitle => 'هناك تقريبا';

  @override
  String get challengeCorrectFeedbackText => 'الجواب صحيح. المضي قدما!';

  @override
  String get hintLogic =>
      'القاعدة تتكرر. ابحث عن بداية التكرار التالي واستمر في الصف.';

  @override
  String get hintMemory =>
      'تذكر أولاً الصور التي تم فتحها. ثم ابحث عن الزوج المطابق.';

  @override
  String get hintAttention =>
      'قارن التفاصيل واحدة تلو الأخرى: اللون والشكل والحجم والمكان.';

  @override
  String get hintMath =>
      'قم بالعد في مجموعات صغيرة حتى يكون من الأسهل عدم فقدان المسار.';

  @override
  String get hintSpace =>
      'اتبع المسار من البداية إلى النهاية وقم بتسمية المنعطف التالي.';

  @override
  String get collectionTitle => 'مجموعتي';

  @override
  String get collectionDayPrize => 'جائزة اليوم';

  @override
  String get collectionCosmoPrizes => 'جوائز الفضاء';

  @override
  String collectionUnlocked(int total, int unlocked) {
    return '$unlocked من $total مفتوح';
  }

  @override
  String get collectionNewPrizeTitle => 'جائزة اليوم الجديد';

  @override
  String get collectionNewPrizeBody => 'تمت إضافة رائد الفضاء إلى المجموعة.';

  @override
  String collectionSnackUnlocked(Object title) {
    return '$title موجود بالفعل في المجموعة.';
  }

  @override
  String get collectionSnackLocked => 'يفتح بعد مستويات جديدة.';

  @override
  String get collectionNewBadge => 'جديد';

  @override
  String collectionLockedLevel(int level) {
    return 'مستوى $level.';
  }

  @override
  String get parentOverviewTitle => 'نظرة عامة على الوالدين';

  @override
  String parentOverviewBody(String name) {
    return 'ملف تعريف $name والتقدم وخطة اليوم ونصائح للتمرين في المنزل.';
  }

  @override
  String parentStarsCount(int stars) {
    return 'نجوم $stars';
  }

  @override
  String get parentMissionClosed => 'تمت المهمة';

  @override
  String get parentMissionWaiting => 'مهمة الانتظار';

  @override
  String get parentProgressTitle => 'تقدم الطفل';

  @override
  String get parentOverviewBadge => 'ملخص';

  @override
  String get parentLevelsLabel => 'المستويات';

  @override
  String parentLevelsValue(int completed, int total) {
    return '$completed من $total';
  }

  @override
  String get parentTodayLabel => 'اليوم';

  @override
  String parentTodayValue(int done, int total) {
    return '$done من $total';
  }

  @override
  String get parentStarsLabel => 'النجوم';

  @override
  String get parentContentLabel => 'محتوى';

  @override
  String parentContentValue(int done, int total) {
    return '$done من $total';
  }

  @override
  String get parentTodayPlanTitle => 'خطة اليوم';

  @override
  String get parentTodayPlanBody =>
      'سلسلة قصيرة بدون ضغوط: 2-3 محاولات هادئة أفضل من جلسة طويلة متعبة.';

  @override
  String parentPuzzleMeta(String skill, int minutes) {
    return '$skill • $minutes دقيقة';
  }

  @override
  String get parentAreasTitle => 'مجالات التطوير';

  @override
  String get parentBalanceBadge => 'توازن';

  @override
  String get parentAreasBody =>
      'هذه خريطة للبالغين: يجب أن يرى الأطفال المهام والأبطال، وليس الفئات الجافة.';

  @override
  String get parentRecommendationDone =>
      'تمت مهمة اليوم. هذه لحظة جيدة لثناء الجهد، وليس السرعة.';

  @override
  String parentRecommendationRemaining(int remaining) {
    return 'هناك تقدم اليوم: تبقى مهام $remaining.';
  }

  @override
  String get parentRecommendationStart =>
      'اليوم، ابدأ بمهمة قصيرة مدتها 4-6 دقائق.';

  @override
  String get parentRecommendationsTitle => 'التوصيات';

  @override
  String get parentHomeBadge => 'في البيت';

  @override
  String get parentPaceLabel => 'خطوة';

  @override
  String get parentWeekFocusLabel => 'التركيز الأسبوعي';

  @override
  String parentFocusArea(String areaTitle, String areaSubtitle) {
    return 'المنطقة التي تحتاج إلى أكبر قدر من الاهتمام الآن هي \"$areaTitle\": $areaSubtitle.';
  }

  @override
  String get parentDiscussLabel => 'كيفية المناقشة';

  @override
  String get parentDiscussBody =>
      'بعد انتهاء المهمة، اسأل: \"كيف وجدت القاعدة؟\" وهذا يبني تفسيرا، وليس التخمين.';

  @override
  String get parentFamilySecurityTitle => 'الأسرة والسلامة';

  @override
  String get parentStorageLabel => 'تخزين';

  @override
  String get parentStorageLocal => 'على الجهاز';

  @override
  String get notificationDailyTitle => 'مهمة جديدة بانتظارك';

  @override
  String notificationDailyBody(String name) {
    return '$name، حل لغزا صغيرا وحافظ على سلسلة النجوم.';
  }

  @override
  String get notificationEveningTitle => 'خطوة صغيرة قبل النوم؟';

  @override
  String notificationEveningBody(String name) {
    return 'لدى $name مهمة قصيرة متبقية. خمس دقائق هادئة تكفي.';
  }

  @override
  String get parentRemindersTitle => 'التذكيرات';

  @override
  String get parentReminderStatusOn => 'مفعلة';

  @override
  String get parentReminderStatusOff => 'متوقفة';

  @override
  String get parentRemindersBody =>
      'يساعد تذكير يومي لطيف على العودة إلى المهمة دون ضغط.';

  @override
  String get parentReminderDailyLabel => 'مهمة اليوم';

  @override
  String get parentReminderDailyValue => '18:30 كل يوم';

  @override
  String get parentReminderFollowUpLabel => 'تذكير المساء';

  @override
  String get parentReminderFollowUpValue => '20:15 إذا كانت المهمة تنتظر';

  @override
  String get parentReminderToggleLabel => 'التذكير بالعودة';

  @override
  String get parentReminderToggleOn => 'سيدعو LogicLoka الطفل إلى مهمة قصيرة.';

  @override
  String get parentReminderToggleOff =>
      'التذكيرات متوقفة. سيبقى التطبيق هادئا.';

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
