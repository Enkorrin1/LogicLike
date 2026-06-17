// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'LogicLike';

  @override
  String get homeTab => 'بيت';

  @override
  String get challengeTab => 'كويست';

  @override
  String get parentTab => 'الوالد';

  @override
  String homeGreeting(Object childName) {
    return 'مرحبًا،\n$childName';
  }

  @override
  String get dailyStreakTitle => 'خط يومي';

  @override
  String get streakStart => 'يبدأ!';

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count أيام',
      many: '$count أيام',
      few: '$count أيام',
      two: '$count أيام',
      one: '$count يوم',
      zero: '$count أيام',
    );
    return '$_temp0';
  }

  @override
  String dayCountShort(Object count) {
    return '$count د';
  }

  @override
  String get missionOpenButton => 'يفتح';

  @override
  String get missionStartShortButton => 'يبدأ';

  @override
  String get missionStartButton => 'ابدأ المهمة';

  @override
  String get homeMissionCompletedTitle => 'المهمة\nكاملة!';

  @override
  String get homeMissionHelpTitle => 'مساعدة رائد الفضاء\nجمع النجوم!';

  @override
  String get dailyChallengeTag => 'السعي اليومي';

  @override
  String get myProgressTitle => 'تقدمي';

  @override
  String levelLabel(Object level) {
    return 'المستوى $level';
  }

  @override
  String get myCollectionTitle => 'مجموعتي';

  @override
  String stickerCountLabel(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ملصقات',
      many: '$count ملصقات',
      few: '$count ملصقات',
      two: '$count ملصقات',
      one: '$count ملصق',
      zero: '$count ملصقات',
    );
    return '$_temp0';
  }

  @override
  String homeParentHint(Object ageLabel, Object goalLabel, num minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes دقائق .هذا الاسبوع',
      many: '$minutes دقائق .هذا الاسبوع',
      few: '$minutes دقائق .هذا الاسبوع',
      two: '$minutes دقائق .هذا الاسبوع',
      one: '$minutes دقيقة .هذا الاسبوع',
      zero: '$minutes دقائق .هذا الاسبوع',
    );
    return '$ageLabel ? $goalLabel ? $_temp0';
  }

  @override
  String ageYears(num years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years سنين',
      many: '$years سنين',
      few: '$years سنين',
      two: '$years سنين',
      one: '$years سنة',
      zero: '$years سنين',
    );
    return '$_temp0';
  }

  @override
  String get goalLogicLabel => 'منطق';

  @override
  String get goalLogicDescription => 'الأنماط والتفكير وإيجاد القواعد.';

  @override
  String get goalMathLabel => 'الرياضيات';

  @override
  String get goalMathDescription => 'الأرقام والعد والحلول الدقيقة.';

  @override
  String get goalAttentionLabel => 'ركز';

  @override
  String get goalAttentionDescription => 'الاهتمام والذاكرة ومقارنة التفاصيل.';

  @override
  String get onboardingTitle => 'قم بإعداد LogicLike';

  @override
  String get onboardingSubtitle =>
      'قم بإنشاء ملف تعريف عائلي بحيث تتوافق المهام اليومية مع عمر الطفل وهدفه.';

  @override
  String get childNameLabel => 'اسم الطفل';

  @override
  String get childNameError => 'أدخل اسما';

  @override
  String get ageSectionTitle => 'عمر';

  @override
  String get learningGoalSectionTitle => 'هدف التعلم';

  @override
  String get learningGoalShortTitle => 'هدف';

  @override
  String get startButton => 'يبدأ';

  @override
  String get savingButton => 'توفير';

  @override
  String get onboardingHeroTitle => 'الرحلة الأولى جاهزة';

  @override
  String get parentTag => 'الوالد';

  @override
  String get parentDashboardTitle => 'مركز العائلة';

  @override
  String familyProfileSummary(
      Object ageLabel, Object childName, Object goalLabel) {
    return '$childName ؟ $ageLabel؟ $goalLabel';
  }

  @override
  String get currentStreakMetric => 'أثَر';

  @override
  String get sessionsMetric => 'جلسات';

  @override
  String get minutesMetric => 'دقائق';

  @override
  String get childrenProfilesTitle => 'ملفات تعريف الطفل';

  @override
  String get addChildButton => 'إضافة طفل';

  @override
  String childProgressChallengeCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count المهام',
      many: '$count المهام',
      few: '$count المهام',
      two: '$count المهام',
      one: '$count السعي',
      zero: '$count المهام',
    );
    return '$_temp0';
  }

  @override
  String ageGoalSummary(Object ageLabel, Object goalLabel) {
    return '$ageLabel؟ $goalLabel';
  }

  @override
  String get newChildTitle => 'طفل جديد';

  @override
  String get cancelButton => 'يلغي';

  @override
  String get addButton => 'يضيف';

  @override
  String get analyticsTitle => 'تحليلات الممارسة';

  @override
  String get streakMetricLabel => 'أثَر';

  @override
  String get bestStreakLabel => 'أفضل';

  @override
  String get last7DaysLabel => 'آخر 7 أيام';

  @override
  String get weeklyMinutesLabel => 'دقائق';

  @override
  String sessionsCountShort(Object count) {
    return '$count جلسة.';
  }

  @override
  String minutesShort(Object count) {
    return '$count دقيقة';
  }

  @override
  String minutesNarrow(Object count) {
    return '$count م';
  }

  @override
  String get lastSkillLabel => 'المهارة الأخيرة';

  @override
  String get lastSessionLabel => 'الجلسة الأخيرة';

  @override
  String get notAvailable => 'ليس بعد';

  @override
  String get weeklyRhythmTitle => 'إيقاع أسبوعي';

  @override
  String get weeklyRhythmSubtitle => 'أيام الممارسة والدقائق لكل يوم.';

  @override
  String get subscriptionTitle => 'الاشتراك العائلي';

  @override
  String get currentPlanLabel => 'الخطة الحالية';

  @override
  String get familySeatsLabel => 'مقاعد عائلية';

  @override
  String get updatedLabel => 'تم التحديث';

  @override
  String get recommendedLabel => 'أفضل قيمة';

  @override
  String get currentPlanButton => 'الخطة الحالية';

  @override
  String get chooseButton => 'يختار';

  @override
  String get resetProfilePanel =>
      'قم بإعادة تعيين ملف التعريف المحلي وتشغيل برنامج الإعداد مرة أخرى';

  @override
  String get resetButton => 'إعادة ضبط';

  @override
  String get resetDialogTitle => 'إعادة تعيين الملف الشخصي؟';

  @override
  String get resetDialogBody =>
      'سيتم فتح عملية الإعداد مرة أخرى وسيتم مسح التقدم المحلي.';

  @override
  String get resetConfirmButton => 'إعادة ضبط';

  @override
  String get limitPaidMessage => 'جميع المقاعد العائلية مستخدمة بالفعل.';

  @override
  String get limitStarterMessage =>
      'تتوفر المزيد من الملفات الشخصية في الخطة العائلية.';

  @override
  String get planStarterLabel => 'بداية';

  @override
  String get planStarterPrice => '0 ₽';

  @override
  String get planStarterCapacity => '1 ملف تعريف الطفل';

  @override
  String get planStarterDescription => 'حلقة يومية قصيرة والتقدم المحلي.';

  @override
  String get planMonthlyLabel => 'الأسرة شهريا';

  @override
  String get planMonthlyPrice => '399 ₽/شهر';

  @override
  String get planFamilyCapacity => 'ما يصل إلى 3 ملفات تعريف للأطفال';

  @override
  String get planMonthlyDescription =>
      'الوصول الكامل، وملفات تعريف الأسرة، وتحليلات الوالدين.';

  @override
  String get planAnnualLabel => 'سنوية عائلية';

  @override
  String get planAnnualPrice => '2990 ₽/ سنة';

  @override
  String get planAnnualDescription =>
      'نفس الوصول، مع قيمة أفضل للفواتير السنوية.';

  @override
  String get planActiveStatus => 'نشيط';

  @override
  String get planInactiveStatus => 'غير نشط';

  @override
  String get missionCompletedTitle => 'المهمة كاملة!';

  @override
  String childGoCta(Object childName) {
    return '$childName، دعنا نذهب!';
  }

  @override
  String get chooseAnswerTitle => 'اختر إجابة';

  @override
  String get checkingButton => 'توفير';

  @override
  String get checkAnswerButton => 'يفحص';

  @override
  String answerCorrect(Object explanation) {
    return 'صحيح! $explanation';
  }

  @override
  String answerAlmost(Object hint) {
    return 'بالكاد. $hint';
  }

  @override
  String get challengeCompletedToday => 'مهمة اليوم اكتملت';

  @override
  String get weekdayMondayShort => 'الاثنين';

  @override
  String get weekdayTuesdayShort => 'الثلاثاء';

  @override
  String get weekdayWednesdayShort => 'تزوج';

  @override
  String get weekdayThursdayShort => 'الخميس';

  @override
  String get weekdayFridayShort => 'الجمعة';

  @override
  String get weekdaySaturdayShort => 'قعد';

  @override
  String get weekdaySundayShort => 'شمس';

  @override
  String get skillPatterns => 'أنماط';

  @override
  String get skillCountingToFive => 'العد إلى خمسة';

  @override
  String get skillComparison => 'مقارنة';

  @override
  String get skillSequences => 'تسلسلات';

  @override
  String get skillAdditionToTen => 'بالإضافة إلى عشرة';

  @override
  String get skillWorkingMemory => 'الذاكرة العاملة';

  @override
  String get skillLogicDeduction => 'المنطق والاستنباط';

  @override
  String get skillMathThinking => 'التفكير الرياضي';

  @override
  String get skillDetailComparison => 'مقارنة التفاصيل';

  @override
  String get challengeShapePathTitle => 'مسار الشكل';

  @override
  String get challengeShapePathPrompt =>
      'انظر إلى الصف وابحث عن ما يأتي بعد ذلك.';

  @override
  String get challengeShapePathQuestion =>
      'دائرة، مربع، دائرة، مربع. ماذا يأتي بعد ذلك؟';

  @override
  String get challengeShapePathHint =>
      'وتتناوب الأشكال: شكل، ثم الآخر، ثم الأول مرة أخرى.';

  @override
  String get challengeShapePathExplanation =>
      'وبعد المربع تأتي دائرة مرة أخرى، لأن الصف يتكرر كل شكلين.';

  @override
  String get challengeToyCountTitle => 'عدد الألعاب';

  @override
  String get challengeToyCountPrompt => 'عد الأشياء واختر الإجابة الدقيقة.';

  @override
  String get challengeToyCountQuestion =>
      'هناك كتلتان وكرة واحدة على الرف. كم عدد الألعاب الموجودة؟';

  @override
  String get challengeToyCountHint => 'عد الكتل أولا، ثم قم بإضافة الكرة.';

  @override
  String get challengeToyCountExplanation =>
      'قطعتان وكرة واحدة تصنعان 3 ألعاب معًا.';

  @override
  String get challengeOddCardTitle => 'بطاقة غريبة خارج';

  @override
  String get challengeOddCardPrompt => 'ابحث عن العنصر المختلف عن الآخرين.';

  @override
  String get challengeOddCardQuestion =>
      'التفاح، الكمثرى، الكرة، الموز. أي واحد لا ينتمي؟';

  @override
  String get challengeOddCardHint => 'يمكن تناول ثلاثة أصناف وواحدة للعب.';

  @override
  String get challengeOddCardExplanation =>
      'الكرة لا تنتمي: التفاح والكمثرى والموز من الفواكه.';

  @override
  String get challengeLogicTrainTitle => 'قطار المنطق';

  @override
  String get challengeLogicTrainPrompt => 'وضع عربات القطار حسب القاعدة.';

  @override
  String get challengeLogicTrainQuestion =>
      'الأحمر، الأزرق، الأزرق، الأحمر، الأزرق، الأزرق. ماذا يأتي بعد ذلك؟';

  @override
  String get challengeLogicTrainHint =>
      'تتكرر القاعدة في مجموعات من ثلاثة: واحدة حمراء واثنتان باللون الأزرق.';

  @override
  String get challengeLogicTrainExplanation =>
      'السيارة التالية حمراء: بعد سيارتين زرقاء، تبدأ مجموعة جديدة.';

  @override
  String get challengeStickerSumTitle => 'ألبوم الملصقات';

  @override
  String get challengeStickerSumPrompt => 'أضف مجموعتين صغيرتين من الكائنات.';

  @override
  String get challengeStickerSumQuestion =>
      'كان لدى نيكا 3 ملصقات، ثم حصلت على 2 آخرين. كم لديها الآن؟';

  @override
  String get challengeStickerSumHint => 'ابدأ بثلاث خطوات وعد خطوتين أخريين.';

  @override
  String get challengeStickerSumExplanation =>
      '3 + 2 = 5، إذن لديها خمس ملصقات.';

  @override
  String get challengeMemoryPairsTitle => 'أزواج الذاكرة';

  @override
  String get challengeMemoryPairsPrompt => 'تذكر الزوج المطابق لكل عنصر.';

  @override
  String get challengeMemoryPairsQuestion => 'ما الذي يحدث مع المفتاح؟';

  @override
  String get challengeMemoryPairsHint => 'يتم استخدام المفتاح لفتح شيء ما.';

  @override
  String get challengeMemoryPairsExplanation =>
      'المفتاح يأتي مع القفل: معًا يشكلون زوجًا ذا معنى.';

  @override
  String get challengeCodeGridTitle => 'شبكة الكود';

  @override
  String get challengeCodeGridPrompt => 'حل القاعدة واختيار الخلية الصحيحة.';

  @override
  String get challengeCodeGridQuestion =>
      'الصف الأول هو 2، 4، 6. والثاني هو 3، 5،؟. ما هو الرقم المفقود؟';

  @override
  String get challengeCodeGridHint =>
      'الأرقام في الصف الثاني تنمو أيضًا بمقدار 2.';

  @override
  String get challengeCodeGridExplanation =>
      'بعد 3 و5 تأتي 7: كل خطوة تضيف درجتين.';

  @override
  String get challengeNumberBridgeTitle => 'جسر الرقم';

  @override
  String get challengeNumberBridgePrompt =>
      'قم بتوصيل الأرقام لبناء الطريق الصحيح.';

  @override
  String get challengeNumberBridgeQuestion =>
      'لديك 4 و2 و1. كيف يمكنك تكوين 7؟';

  @override
  String get challengeNumberBridgeHint =>
      'حاول استخدام جميع الأرقام مرة واحدة.';

  @override
  String get challengeNumberBridgeExplanation =>
      '4 + 2 + 1 = 7، لذا فإن الأرقام الثلاثة معًا تشكل الهدف.';

  @override
  String get challengeDetailCountTitle => 'خريطة التفاصيل';

  @override
  String get challengeDetailCountPrompt =>
      'ضع العديد من التفاصيل في الاعتبار وقارنها.';

  @override
  String get challengeDetailCountQuestion =>
      'هناك 3 دوائر حمراء ومربعان أزرقان ونجمة خضراء واحدة. أي مجموعة لديها أكثر؟';

  @override
  String get challengeDetailCountHint => 'قارن الكميات: 3، 2، 1.';

  @override
  String get challengeDetailCountExplanation =>
      'الدوائر الحمراء هي الأكثر: هناك ثلاث منها.';

  @override
  String get challengeMemoryRecallTitle => 'تذكر البطاقات';

  @override
  String get challengeMemoryRecallPrompt =>
      'انظر إلى الصف وابحث عن البطاقة المخفية.';

  @override
  String get challengeMemoryRecallQuestion => 'ما هي البطاقة المخفية؟';

  @override
  String get challengeMemoryRecallHint =>
      'تذكر الأشياء من اليسار إلى اليمين وتحقق من العنصر الأخير.';

  @override
  String get challengeMemoryRecallExplanation =>
      'كانت البطاقة المخفية في الصف الذي كان عليك أن تتذكره.';

  @override
  String get challengeSortingRuleTitle => 'قاعدة الصندوق';

  @override
  String get challengeSortingRulePrompt =>
      'ابحث عن الكائن الذي ينتمي إلى الآخرين.';

  @override
  String get challengeSortingRuleQuestion => 'ما الذي يتبع نفس القاعدة؟';

  @override
  String get challengeSortingRuleHint =>
      'ابحث أولاً عن الأشياء المشتركة بين العناصر الموجودة في الصندوق.';

  @override
  String get challengeSortingRuleExplanation =>
      'الكائن الصحيح يطابق قاعدة الصندوق.';

  @override
  String get challengeMissingPieceTitle => 'قطعة مفقودة';

  @override
  String get challengeMissingPiecePrompt => 'اختر الجزء الذي يكمل الصورة.';

  @override
  String get challengeMissingPieceQuestion => 'أي قطعة تناسب المكان الفارغ؟';

  @override
  String get challengeMissingPieceHint =>
      'قارن الشكل الفارغ مع اختيارات الإجابة.';

  @override
  String get challengeMissingPieceExplanation =>
      'هذه القطعة تكمل الصورة بدون زوايا إضافية.';

  @override
  String get challengeLogicDeductionTitle => 'اثنين من القرائن';

  @override
  String get challengeLogicDeductionPrompt =>
      'استخدم كلا الدليلين وقم بإزالة الاختيارات الخاطئة.';

  @override
  String get challengeLogicDeductionQuestion => 'ما الذي يطابق كل فكرة؟';

  @override
  String get challengeLogicDeductionHint =>
      'يزيل كل دليل خيارًا خاطئًا واحدًا على الأقل.';

  @override
  String get challengeLogicDeductionExplanation =>
      'الإجابة الصحيحة تطابق كلا الدليلين.';

  @override
  String get choiceTriangle => 'مثلث';

  @override
  String get choiceCircle => 'دائرة';

  @override
  String get choiceStar => 'نجم';

  @override
  String get choiceApple => 'تفاحة';

  @override
  String get choiceBall => 'كرة';

  @override
  String get choiceBanana => 'موز';

  @override
  String get choiceBlue => 'أزرق';

  @override
  String get choiceRed => 'أحمر';

  @override
  String get choiceGreen => 'أخضر';

  @override
  String get choiceKey => 'مفتاح';

  @override
  String get choiceLock => 'قفل';

  @override
  String get choiceShoe => 'حذاء';

  @override
  String get choiceCloud => 'سحاب';

  @override
  String get choiceBlueSquares => 'المربعات الزرقاء';

  @override
  String get choiceRedCircles => 'دوائر حمراء';

  @override
  String get choiceGreenStars => 'النجوم الخضراء';

  @override
  String mapLessonTitle(Object lesson) {
    return 'الدرس $lesson';
  }

  @override
  String get mapLessonSubtitle => 'المنطق والعد والتركيز في درس واحد قصير';

  @override
  String get mapStartButton => 'يبدأ';

  @override
  String get mapNodeStart => 'يبدأ';

  @override
  String get mapNodeShapes => 'الأشكال';

  @override
  String get mapNodePairs => 'أزواج';

  @override
  String get mapNodeCounting => 'عد';

  @override
  String get mapNodePath => 'طريق';

  @override
  String get mapNodeRhythm => 'إيقاع';

  @override
  String get mapNodeCompare => 'يقارن';

  @override
  String get mapNodeFinal => 'أخير';

  @override
  String get mapNodeCompleted => 'منتهي';

  @override
  String get mapNodeCurrent => 'يفتح';

  @override
  String get mapNodeLocked => 'مغلق';

  @override
  String mapPreviewTitle(Object lesson) {
    return 'الدرس $lesson';
  }

  @override
  String mapPreviewSteps(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count خطوات',
      many: '$count خطوات',
      few: '$count خطوات',
      two: '$count خطوات',
      one: '$count خطوة',
      zero: '$count خطوات',
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
      other: '$count قلوب',
      many: '$count قلوب',
      few: '$count قلوب',
      two: '$count قلوب',
      one: '$count قلب',
      zero: '$count قلوب',
    );
    return '$_temp0';
  }

  @override
  String get mapPreviewBody =>
      'درس قصير يحتوي على ألغاز مختلطة: المنطق والعد والمقارنة والتركيز.';

  @override
  String get mapPreviewStart => 'ابدأ الدرس';

  @override
  String get mapPreviewClose => 'لاحقاً';

  @override
  String lessonProgress(Object current, Object total) {
    return 'الخطوة $current من $total';
  }

  @override
  String get lessonNextButton => 'التالي';

  @override
  String get lessonFinishButton => 'إنهاء الدرس';

  @override
  String get lessonCompleteTitle => 'اكتمل الدرس!';

  @override
  String get lessonCompleteBody => 'لقد قمت بفتح الخطوة التالية على الخريطة.';

  @override
  String get lessonRewardStars => '+1 نجمة';

  @override
  String lessonRewardXp(Object xp) {
    return '+$xp XP';
  }

  @override
  String get lessonBackToMap => 'العودة إلى المنزل';

  @override
  String get courseCatalogTitle => 'الدورات والألغاز';

  @override
  String get courseLogicTitle => 'منطق';

  @override
  String get courseLogicSubtitle => 'القواعد، والغريب، والتفكير';

  @override
  String get courseMathTitle => 'الرياضيات';

  @override
  String get courseMathSubtitle => 'العد والمبالغ والمقارنة';

  @override
  String get courseSpatialTitle => 'الأشكال';

  @override
  String get courseSpatialSubtitle => 'الشكل والمسارات والفضاء';

  @override
  String get courseAttentionTitle => 'ركز';

  @override
  String get courseAttentionSubtitle => 'التفاصيل والذاكرة والانتباه';

  @override
  String get courseRebusTitle => 'إعادة النظر';

  @override
  String get courseRebusSubtitle => 'الصور والكلمات والألغاز';

  @override
  String get courseMixedTitle => 'مزيج يومي';

  @override
  String get courseMixedSubtitle => 'الألغاز المختلفة على التوالي';

  @override
  String progressCardBody(Object level, Object stars) {
    return 'المستوى $level؟ نجوم $stars';
  }

  @override
  String collectionCardBody(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ملصقات',
      many: '$count ملصقات',
      few: '$count ملصقات',
      two: '$count ملصقات',
      one: '$count ملصق',
      zero: '$count ملصقات',
    );
    return '$_temp0';
  }

  @override
  String get dailyMissionBody => 'مجموعة قصيرة من ألغاز المنطق والعد والتركيز.';

  @override
  String get openCourseButton => 'يفتح';

  @override
  String courseProgress(Object completed, Object total) {
    return 'اكتملت دروس $completed من $total';
  }

  @override
  String courseLessonTitle(Object lesson) {
    return 'الدرس $lesson';
  }

  @override
  String courseLessonMeta(num steps, Object xp) {
    String _temp0 = intl.Intl.pluralLogic(
      steps,
      locale: localeName,
      other: '$steps خطوات',
      many: '$steps خطوات',
      few: '$steps خطوات',
      two: '$steps خطوات',
      one: '$steps خطوة',
      zero: '$steps خطوات',
    );
    return '$_temp0 ? +$xp XP';
  }

  @override
  String get courseStartLessonButton => 'يبدأ';

  @override
  String get courseRepeatButton => 'يكرر';

  @override
  String get showHintButton => 'تَلمِيح';

  @override
  String get hideHintButton => 'إخفاء التلميح';

  @override
  String get lessonStickerUnlockedTitle => 'ملصق جديد!';

  @override
  String get lessonStickerUnlockedBody => 'نمت مجموعتك بعد الدرس.';

  @override
  String get lessonRewardCollection => '+1 ملصق';

  @override
  String get lessonRewardStreak => 'الخط ينمو';

  @override
  String get challengeShadowMatchTitle => 'مباراة الظل';

  @override
  String get challengeShadowMatchPrompt => 'ابحث عن الكائن الذي يناسب الظل.';

  @override
  String get challengeShadowMatchQuestion =>
      'الظل له جسم طويل وجناحين صغيرين. ما هذا؟';

  @override
  String get challengeShadowMatchHint =>
      'انظر إلى المخطط التفصيلي الكامل للكائن.';

  @override
  String get challengeShadowMatchExplanation =>
      'الصاروخ يطابق الظل: له جسم طويل وجناحين جانبيين.';

  @override
  String get challengeBalanceScaleTitle => 'مقياس التوازن';

  @override
  String get challengeBalanceScalePrompt => 'قارن الجوانب واختر ما هو مفقود.';

  @override
  String get challengeBalanceScaleQuestion =>
      'الجانب الأيسر به 2 تفاحات. الجانب الأيمن به تفاحة واحدة و؟. ماذا يجب أن تضيف؟';

  @override
  String get challengeBalanceScaleHint =>
      'يحتاج كلا الجانبين إلى نفس العدد من التفاح.';

  @override
  String get challengeBalanceScaleExplanation =>
      'تفاحة أخرى تجعل الجانب الأيمن مساويًا لليسار: 2 و2.';

  @override
  String get challengeShapeRotationTitle => 'بدوره الشكل';

  @override
  String get challengeShapeRotationPrompt => 'تخيل الشكل وهو يدور.';

  @override
  String get challengeShapeRotationQuestion =>
      'مثلث يتحول إلى اليمين. أي بطاقة تظهر نفس الشكل؟';

  @override
  String get challengeShapeRotationHint =>
      'الدوران يغير الاتجاه، لكن ليس الشكل نفسه.';

  @override
  String get challengeShapeRotationExplanation =>
      'وهو نفس المثلث: استدار ولم يتغير شكله.';

  @override
  String get choiceRocket => 'صاروخ';

  @override
  String get choicePlanet => 'كوكب';

  @override
  String get choiceSameTriangle => 'نفس المثلث';

  @override
  String get choiceSquare => 'مربع';

  @override
  String get skillInsightsTitle => 'المهارات والتوصيات';

  @override
  String get strongestAreaLabel => 'منطقة قوية';

  @override
  String get practiceFocusLabel => 'منطقة التركيز';

  @override
  String get recommendedPracticeLabel => 'تدرب بعد ذلك';

  @override
  String get noSkillDataLabel => 'لا توجد بيانات كافية حتى الآن';

  @override
  String get recommendationKeepGoing =>
      'استمر في تقديم دروس قصيرة: تصبح التوصيات أكثر وضوحًا بعد بضع جلسات.';

  @override
  String get recommendationPracticeFocus =>
      'أضف درسًا أو درسين قصيرين لهذه المنطقة خلال الأسبوع.';

  @override
  String get courseNextMetricLabel => 'التالي';

  @override
  String get courseStarsMetricLabel => 'النجوم';

  @override
  String get courseXpMetricLabel => 'XP';

  @override
  String get courseCompletedState => 'منتهي';

  @override
  String get courseOpenState => 'يفتح';

  @override
  String get courseLockedState => 'مغلق';

  @override
  String get collectionScreenTitle => 'مجموعة الملصقات';

  @override
  String get collectionScreenSubtitle =>
      'اجمع المكافآت من خلال إكمال الدروس ومواصلة التدريب.';

  @override
  String collectionUnlockedCount(Object total, Object unlocked) {
    return 'تم فتح $unlocked من $total';
  }

  @override
  String get collectionNextReward => 'المكافأة التالية';

  @override
  String get collectionAllRewardsUnlocked => 'جميع المكافآت مقفلة';

  @override
  String get collectionBackHome => 'العودة إلى المنزل';

  @override
  String collectionLockedHint(Object stars) {
    return 'يفتح بعد نجوم $stars';
  }

  @override
  String get rewardAstronautTitle => 'مساعد نجم';

  @override
  String get rewardAstronautBody => 'لإنهاء المهمة الأولى.';

  @override
  String get rewardRocketTitle => 'صاروخ شجاع';

  @override
  String get rewardRocketBody => 'لافتتاح دورة تعليمية.';

  @override
  String get rewardPlanetTitle => 'كوكب صغير';

  @override
  String get rewardPlanetBody => 'لاستكمال الدرسين.';

  @override
  String get rewardLionTitle => 'أسد المنطق';

  @override
  String get rewardLionBody => 'لبناء خط الممارسة.';

  @override
  String get rewardPuzzleTitle => 'شارة اللغز';

  @override
  String get rewardPuzzleBody => 'لحل الألغاز المختلطة.';

  @override
  String get rewardChampionTitle => 'بطل الفضاء';

  @override
  String get rewardChampionBody => 'من أجل ممارسة أسبوعية ثابتة.';

  @override
  String get accuracyMetricLabel => 'دقة';

  @override
  String get hintsMetricLabel => 'تلميحات';

  @override
  String recommendationImproveAccuracy(Object skill) {
    return 'تدرب على $skill ببطء هذا الأسبوع: الدقة هي الإشارة الرئيسية للتحسن.';
  }

  @override
  String recommendationReduceHints(Object skill) {
    return 'كرر $skill مع تلميحات أقل: توقف مؤقتًا قبل فتح المساعدة.';
  }

  @override
  String recommendationRepeatAttempts(Object skill) {
    return 'امنح $skill جلسة متكررة قصيرة واحدة لتقليل المحاولات الخاطئة.';
  }

  @override
  String get homeRecommendedLessonTitle => 'الدرس القادم';

  @override
  String get homeRecommendedLessonSubtitle =>
      'الدرس القصير التالي على طريق التعلم.';

  @override
  String get homeRecommendedLessonButton => 'يكمل';

  @override
  String get homeRecommendedLessonCompleted => 'اكتمل المسار';

  @override
  String get lessonReviewTitle => 'ملخص الدرس';

  @override
  String get lessonReviewPerfectBody => 'تركيز كبير: لا تلميحات أو أخطاء.';

  @override
  String get lessonReviewSupportBody =>
      'نهاية جيدة. في المرة القادمة حاول القيام بخطوة واحدة بمساعدة أقل.';

  @override
  String get lessonReviewQuestionsLabel => 'أسئلة';

  @override
  String get lessonReviewHintsLabel => 'تلميحات';

  @override
  String get lessonReviewMistakesLabel => 'أخطاء';

  @override
  String get lessonNextRecommendedButton => 'الدرس القادم';

  @override
  String get practiceHistoryTitle => 'تاريخ الممارسة';

  @override
  String get practiceHistorySubtitle =>
      'أحدث الدروس بالدقة والتلميحات والأخطاء.';

  @override
  String get practiceHistoryEmpty => 'لا توجد دروس مكتملة بعد.';

  @override
  String practiceHistorySessionMeta(Object date, Object minutes) {
    return '$date - $minutes دقيقة';
  }

  @override
  String get practiceHistoryMistakesLabel => 'أخطاء';

  @override
  String get lessonTryAgainButton => 'حاول ثانية';

  @override
  String get lessonHintTitle => 'فكر خطوة بخطوة';

  @override
  String get lessonRetryFeedback =>
      'محاولة جيدة. اقرأ التلميح، ثم اختر مرة أخرى.';

  @override
  String get languageSettingsTitle => 'لغة التطبيق';

  @override
  String get languageSettingsSubtitle => 'اختر لغة شاشات الأطفال والآباء.';

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
  String get choicePear => 'كُمَّثرَى';

  @override
  String get challengeFruitPatternTitle => 'صف الفاكهة';

  @override
  String get challengeFruitPatternPrompt => 'مواصلة نمط الفاكهة.';

  @override
  String get challengeFruitPatternQuestion =>
      'تفاح، موز، تفاح، موز. ماذا يأتي بعد ذلك؟';

  @override
  String get challengeFruitPatternHint =>
      'تتكرر الثمار واحدة تلو الأخرى: التفاح ثم الموز.';

  @override
  String get challengeFruitPatternExplanation =>
      'بعد الموز تأتي التفاحة مرة أخرى، لأن النمط يتكرر.';

  @override
  String get challengeLockKeyTitle => 'زوج سحري';

  @override
  String get challengeLockKeyPrompt => 'اختر الكائن الذي يشكل زوجًا.';

  @override
  String get challengeLockKeyQuestion => 'المفتاح يفتح شيئًا ما. ماذا يذهب مع؟';

  @override
  String get challengeLockKeyHint => 'فكر فيما يتم استخدام المفتاح من أجله.';

  @override
  String get challengeLockKeyExplanation =>
      'يعمل المفتاح والقفل معًا، لذا يشكلان الزوج.';

  @override
  String get challengeSpaceSequenceTitle => 'طريق الفضاء';

  @override
  String get challengeSpaceSequencePrompt => 'ابحث عن الجسم الفضائي التالي.';

  @override
  String get challengeSpaceSequenceQuestion =>
      'صاروخ، كوكب، صاروخ، كوكب. ماذا يأتي بعد ذلك؟';

  @override
  String get challengeSpaceSequenceHint => 'يتكرر المسار: الصاروخ، ثم الكوكب.';

  @override
  String get challengeSpaceSequenceExplanation =>
      'بعد الكوكب يأتي صاروخ مرة أخرى.';

  @override
  String get challengeShapeStackTitle => 'برج الشكل';

  @override
  String get challengeShapeStackPrompt => 'مواصلة حكم البرج.';

  @override
  String get challengeShapeStackQuestion =>
      'مربع، دائرة، مربع، دائرة. أي شكل هو التالي؟';

  @override
  String get challengeShapeStackHint => 'يتناوب البرج بين شكلين.';

  @override
  String get challengeShapeStackExplanation =>
      'بعد الدائرة يأتي مربع مرة أخرى.';

  @override
  String get challengePathMazeTitle => 'مكتشف المسار';

  @override
  String get challengePathMazePrompt => 'اتبع الطريق من البداية إلى النهاية.';

  @override
  String get challengePathMazeQuestion =>
      'مساعدة البطل للوصول إلى الهدف. ما هي الطريقة التي ينبغي أن تذهب؟';

  @override
  String get challengePathMazeHint =>
      'تتبع الطريق من البداية إلى النهاية واختر الاتجاه عند مفترق الطرق.';

  @override
  String get challengePathMazeExplanation =>
      'الطريق الصحيح يتبع الطريق المفتوح نحو الهدف.';

  @override
  String get lesson_001_title => 'مسار الشكل';

  @override
  String get lesson_002_title => 'عد الألعاب';

  @override
  String get lesson_003_title => 'بطاقة غريبة خارج';

  @override
  String get lesson_004_title => 'قطار المنطق';

  @override
  String get lesson_005_title => 'المبالغ والصفوف';

  @override
  String get lesson_006_title => 'الذاكرة والرموز';

  @override
  String get lesson_007_title => 'جسر الرقم';

  @override
  String get lesson_008_title => 'خريطة التفاصيل';

  @override
  String get lesson_009_title => 'الظلال والتوازن';

  @override
  String get lesson_010_title => 'إضافة ومقارنة';

  @override
  String get lesson_011_title => 'المنعطفات والمسارات';

  @override
  String get lesson_012_title => 'الذاكرة والتركيز';

  @override
  String get lesson_013_title => 'نمط الفاكهة';

  @override
  String get lesson_014_title => 'رف الرياضيات';

  @override
  String get lesson_015_title => 'برج الشكل';

  @override
  String get lesson_016_title => 'الأقفال والتفاصيل';

  @override
  String get lesson_017_title => 'الرمز والأرقام';

  @override
  String get lesson_018_title => 'تسلسل الفضاء';

  @override
  String get lesson_019_title => 'التركيز على الاختلافات';

  @override
  String get lesson_020_title => 'جسر الحل';

  @override
  String get lesson_021_title => 'القواعد على التوالي';

  @override
  String get lesson_022_title => 'الأشكال في الفضاء';

  @override
  String get lesson_023_title => 'الذاكرة والعد';

  @override
  String get lesson_024_title => 'المزيج النهائي';

  @override
  String get lesson_025_title => 'محقق التفاصيل';

  @override
  String get lesson_026_title => 'المقاييس والأرقام';

  @override
  String get lesson_027_title => 'غريبة منها وأزواج';

  @override
  String get lesson_028_title => 'أشكال الفضاء';

  @override
  String get lesson_029_title => 'مبالغ حذرة';

  @override
  String get lesson_030_title => 'القاعدة والرمز';

  @override
  String get lesson_031_title => 'الظلال والأشكال والذاكرة';

  @override
  String get lesson_032_title => 'أرقام وتفاصيل';

  @override
  String get lesson_033_title => 'سلسلة القواعد';

  @override
  String get lesson_034_title => 'يتحول الفضاء';

  @override
  String get lesson_035_title => 'طريق رقم كبير';

  @override
  String get lesson_036_title => 'خاتمة المراقب';

  @override
  String get lesson_037_title => 'المنعطفات والذاكرة';

  @override
  String get lesson_038_title => 'عد العدو';

  @override
  String get lesson_039_title => 'القاعدة والزوج';

  @override
  String get lesson_040_title => 'برج الفضاء';

  @override
  String get lesson_041_title => 'الميزان والتركيز';

  @override
  String get lesson_042_title => 'قطار الكود';

  @override
  String get lesson_043_title => 'الظلال والأقفال';

  @override
  String get lesson_044_title => 'الأرقام والذاكرة';

  @override
  String get lesson_045_title => 'سلسلة طويلة';

  @override
  String get lesson_046_title => 'الطريق المكاني';

  @override
  String get lesson_047_title => 'المبالغ والتفاصيل';

  @override
  String get lesson_048_title => 'التركيز المنطقي';

  @override
  String get lesson_049_title => 'الأشكال عن قرب';

  @override
  String get lesson_050_title => 'حسابية دقيقة';

  @override
  String get lesson_051_title => 'سيد النمط';

  @override
  String get lesson_052_title => 'الظلال في الفضاء';

  @override
  String get lesson_053_title => 'لغز الرقم';

  @override
  String get lesson_054_title => 'كود المراقب';

  @override
  String get lesson_055_title => 'البرج والمفتاح';

  @override
  String get lesson_056_title => 'التفاصيل والمقاييس';

  @override
  String get lesson_057_title => 'قواعد أصعب';

  @override
  String get lesson_058_title => 'الشكل النهائي';

  @override
  String get lesson_059_title => 'مهمة العدد الكبير';

  @override
  String get lesson_060_title => 'المنطق الفائق';
}
