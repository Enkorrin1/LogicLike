// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'Logic Loka';

  @override
  String get loadingMission => 'मिशन की तैयारी...';

  @override
  String get navHome => 'घर';

  @override
  String get navChallenge => 'काम';

  @override
  String get navParent => 'माता-पिता';

  @override
  String get commonCancel => 'रद्द करना';

  @override
  String get commonReset => 'रीसेट करें';

  @override
  String languageChanged(Object language) {
    return 'भाषा: $language';
  }

  @override
  String languageButtonSemantics(Object language) {
    return 'भाषा बदलें। वर्तमान: $language';
  }

  @override
  String get onboardingSubmitSaving => 'मार्ग तैयार किया जा रहा है';

  @override
  String get onboardingSubmitCreateHero => 'हीरो बनाएं';

  @override
  String get onboardingDefaultHero => 'युवा नायक';

  @override
  String get onboardingTitle => 'एक हीरो बनाएं';

  @override
  String onboardingHeroSummary(Object age, Object name) {
    return '$name, $age';
  }

  @override
  String get onboardingSubtitle =>
      'शेर दैनिक मिशन दिखाएगा, फिर आपका बच्चा मस्तिष्क प्रशिक्षण चुन सकता है।';

  @override
  String get childNameLabel => 'बच्चे का नाम';

  @override
  String get childNameError => 'नायक का नाम दर्ज करें';

  @override
  String get onboardingMissionPill => 'मिशन प्रारंभ';

  @override
  String get onboardingAgeTitle => 'हीरो की उम्र';

  @override
  String get unlockMission => 'उद्देश्य';

  @override
  String get unlockGames => 'खेल';

  @override
  String get unlockPrizes => 'पुरस्कार';

  @override
  String ageYears(int years) {
    return '$years वर्ष';
  }

  @override
  String homeGreeting(Object name) {
    return 'नमस्ते,\n$name';
  }

  @override
  String get homeStarsHint =>
      'सितारे मिशन से बढ़ते हैं और नए पुरस्कार अनलॉक करते हैं।';

  @override
  String get homeLockedLevelHint => 'यह स्तर नए सितारों के बाद खुलता है।';

  @override
  String get homeStreakSavedHint => 'स्ट्रीक बच गई! कल एक नया मिशन आएगा।';

  @override
  String get homeStreakNeedMissionHint =>
      'स्ट्रीक को बचाने के लिए दैनिक मिशन को पूरा करें।';

  @override
  String get homeStreakTitle => 'दैनिक लकीर';

  @override
  String homeStreakDays(int days) {
    return 'लगातार $days दिन!';
  }

  @override
  String get homeStreakWaiting => 'मिशन इंतज़ार कर रहा है';

  @override
  String get homeMissionDaily => 'दैनिक मिशन';

  @override
  String get homeMissionFreePlay => 'फ्री प्ले';

  @override
  String get homeTrainingOpen => 'प्रशिक्षण खुला है';

  @override
  String homeLevel(int level) {
    return 'स्तर $level';
  }

  @override
  String get homeMissionStart => 'शुरू';

  @override
  String get homeMissionChoose => 'चुनना';

  @override
  String get homeMissionTag => 'मुख्य मिशन';

  @override
  String get homeFreePlayTitle => 'खुद खेलें';

  @override
  String get homeFreePlaySubtitle =>
      'एक नायक चुनें और अपने मस्तिष्क को प्रशिक्षित करें';

  @override
  String get homeMiniGamesTitle => 'मिनी खेल';

  @override
  String get homeMiniGamesSubtitle => 'स्तरों के बाद त्वरित प्रशिक्षण';

  @override
  String get homeQuickPairs => 'जोड़े';

  @override
  String get homeQuickPath => 'पथ';

  @override
  String get homeQuickCount => 'गिनती करना';

  @override
  String get homeProgressTitle => 'मेरी तरक्की';

  @override
  String homeProgressStars(int current, int total) {
    return '$current / $total तारे';
  }

  @override
  String get homeCollectionTitle => 'संग्रह';

  @override
  String get homeCollectionStickers => 'स्टिकर';

  @override
  String get homeLevelsTitle => 'स्तरों';

  @override
  String get homeLevelsSubtitle => '8 प्रशिक्षण थीम, कोई कैलेंडर नहीं';

  @override
  String get homeNodeCompleted => 'हो गया';

  @override
  String get homeNodePlay => 'खेल';

  @override
  String get homeNodeSoon => 'जल्द ही';

  @override
  String get homeMapStart => 'शुरू';

  @override
  String get homeMapShapes => 'आकार';

  @override
  String get homeMapPairs => 'जोड़े';

  @override
  String get homeMapCount => 'गिनती करना';

  @override
  String get homeMapPath => 'पथ';

  @override
  String get homeMapRhythm => 'लय';

  @override
  String get homeMapCompare => 'तुलना करना';

  @override
  String get homeMapFinal => 'अंतिम';

  @override
  String get parentTitle => 'मूल क्षेत्र';

  @override
  String get parentIntroTitle => 'वयस्कों के लिए शांत क्षेत्र';

  @override
  String get parentIntroBody =>
      'प्रोफ़ाइल, प्रगति, भाषा और भविष्य की सदस्यता बाल मिशन से अलग रहती है।';

  @override
  String get parentProfileTitle => 'पारिवारिक प्रोफ़ाइल';

  @override
  String get parentLocalBadge => 'स्थानीय';

  @override
  String get parentChildLabel => 'बच्चा';

  @override
  String get parentAgeLabel => 'आयु';

  @override
  String get parentCompletedTasksLabel => 'कार्य पूर्ण';

  @override
  String get parentLanguageLabel => 'भाषा';

  @override
  String get settingsLanguage => 'ऐप भाषा';

  @override
  String get parentSubscriptionTitle => 'पारिवारिक सदस्यता';

  @override
  String get parentSubscriptionSoon => 'जल्द ही';

  @override
  String get parentSubscriptionBody =>
      'लॉन्च टैरिफ: Free एक्सेस, मासिक Premium Family और शुरुआती कीमत वाला Annual.';

  @override
  String get parentFamilySeatsLabel => 'पारिवारिक सीटें';

  @override
  String get parentFamilySeatsValue => 'की योजना बनाई';

  @override
  String get parentPaymentLabel => 'भुगतान';

  @override
  String get parentPaymentValue => 'जुड़े नहीं हैं';

  @override
  String get parentSubscriptionLaunchBadge => 'शुरुआती कीमत';

  @override
  String get parentSubscriptionCurrentFree => 'निःशुल्क';

  @override
  String get parentSubscriptionFreeTitle => 'निःशुल्क';

  @override
  String get parentSubscriptionFreePrice => '\$0';

  @override
  String get parentSubscriptionFreeBody =>
      'दैनिक चक्र आज़माने की हल्की शुरुआत.';

  @override
  String get parentSubscriptionFeatureDaily => 'दैनिक मिशन';

  @override
  String get parentSubscriptionFeatureStarter => 'शुरुआती स्तर';

  @override
  String get parentSubscriptionFeatureLocalProgress =>
      'इस डिवाइस पर स्थानीय प्रगति';

  @override
  String get parentSubscriptionFreeCta => 'मौजूदा एक्सेस';

  @override
  String get parentSubscriptionPremiumTitle => 'प्रीमियम परिवार';

  @override
  String get parentSubscriptionPremiumPrice => '\$5.99/माह';

  @override
  String get parentSubscriptionPremiumBadge => 'लॉन्च कीमत';

  @override
  String get parentSubscriptionPremiumBody =>
      'जब तक सामग्री लाइब्रेरी बढ़ रही है, पूरा पारिवारिक एक्सेस.';

  @override
  String get parentSubscriptionFeatureAllLevels => 'सभी मौजूदा और नए स्तर';

  @override
  String get parentSubscriptionFeatureParentTips => 'माता-पिता के लिए सुझाव';

  @override
  String get parentSubscriptionFeaturePurchaseRestore =>
      'खरीदारी बहाल करने के लिए तैयार';

  @override
  String get parentSubscriptionPremiumCta => 'मासिक चुनें';

  @override
  String get parentSubscriptionAnnualTitle => 'वार्षिक';

  @override
  String get parentSubscriptionAnnualPrice => '\$39.99/वर्ष';

  @override
  String get parentSubscriptionAnnualBadge => 'सबसे अच्छा मूल्य';

  @override
  String get parentSubscriptionAnnualBody =>
      'एक वर्ष के लिए Premium Family, शुरुआती वार्षिक कीमत पर.';

  @override
  String get parentSubscriptionFeatureAnnualValue => '12 मासिक भुगतानों से कम';

  @override
  String get parentSubscriptionFeatureYearAccess =>
      '12 महीने का पारिवारिक एक्सेस';

  @override
  String get parentSubscriptionFeatureUpdatesIncluded =>
      'वर्ष के दौरान नए स्तर शामिल';

  @override
  String get parentSubscriptionAnnualCta => 'वार्षिक चुनें';

  @override
  String get parentSubscriptionFuturePriceNote =>
      'बाद में, जब कई उच्च-गुणवत्ता वाले स्तर होंगे: \$7.99/माह और \$49.99/वर्ष.';

  @override
  String get parentSubscriptionBillingSoonSnack =>
      'बिलिंग अभी कनेक्ट नहीं है. ये प्लान StoreKit और Google Play Billing के लिए तैयार हैं.';

  @override
  String get parentResetProfile => 'प्रोफ़ाइल रीसेट करें';

  @override
  String get parentResetTitle => 'प्रोफ़ाइल रीसेट करें?';

  @override
  String get parentResetBody =>
      'ऑनबोर्डिंग फिर से खुलेगी और स्थानीय प्रगति साफ़ हो जाएगी।';

  @override
  String get challengeTitle => 'दिमागी खेल';

  @override
  String get challengeDayDone => 'दिन पूरा';

  @override
  String get challengeDailyMission => 'दैनिक मिशन';

  @override
  String get challengeDayDoneBody =>
      'इनाम मिला. आप दोहरा सकते हैं या स्वतंत्र रूप से खेल सकते हैं।';

  @override
  String get challengeDailyBody =>
      'स्ट्रीक को बचाने और पुरस्कार प्राप्त करने के लिए 3 चरणों को पूरा करें।';

  @override
  String get challengePrize => 'पुरस्कार';

  @override
  String get challengeMissionProgress => 'मिशन की प्रगति';

  @override
  String countOfTotal(int count, int total) {
    return '$total का $count';
  }

  @override
  String get challengeRepeatMission => 'मिशन दोहराएँ';

  @override
  String challengeStepsTraining(int steps) {
    return 'प्रशिक्षण के लिए $steps चरण';
  }

  @override
  String challengeStepNumber(int step) {
    return 'चरण $step';
  }

  @override
  String get challengeAgain => 'दोबारा';

  @override
  String minutesShort(int minutes) {
    return '$minutes मि';
  }

  @override
  String get challengeBrainGymTitle => 'ब्रेन जिम';

  @override
  String challengeBrainGymSubtitle(int count) {
    return '$count क्षेत्र, किसी भी क्रम में खेलें';
  }

  @override
  String challengeAreaLevels(int done, int total) {
    return '$done/$total स्तर';
  }

  @override
  String challengeAreaCompleted(int done, int total) {
    return '$total में से $done पूर्ण';
  }

  @override
  String get challengeStateCompleted => 'हो गया';

  @override
  String get challengeStateNext => 'अगला';

  @override
  String get challengeStatePlay => 'खेल';

  @override
  String challengeLevelNumber(int level) {
    return 'स्तर $level';
  }

  @override
  String get challengeHideHint => 'संकेत छिपाएँ';

  @override
  String get challengeShowHint => 'संकेत दिखाएँ';

  @override
  String get challengeDailyTaskTitle => 'दैनिक कार्य';

  @override
  String get challengePuzzleTaskTitle => 'पहेली';

  @override
  String get challengeDailyPath => 'दैनिक पथ';

  @override
  String get challengeFreePlay => 'फ्री प्ले';

  @override
  String get challengeExcellent => 'महान!';

  @override
  String get challengeFlyNext => 'आगे उड़ान';

  @override
  String get challengeAllDone => 'सब तैयार';

  @override
  String get challengePlayMore => 'अधिक खेलो';

  @override
  String get challengeMyCollection => 'मेरा संग्रह';

  @override
  String get challengeDailyCompleteTitle => 'दैनिक मिशन पूरा!';

  @override
  String get challengeDailyCompleteBody =>
      'आपने सभी चरण पूरे कर लिए. पुरस्कार लीजिए और खुलकर खेलिए।';

  @override
  String get challengeRewardStars => 'सितारे';

  @override
  String get challengeRewardStreak => 'धारी';

  @override
  String get challengeRewardSteps => 'कदम';

  @override
  String get challengeWhatNextTitle => 'आगे क्या?';

  @override
  String get challengeWhatNextBody =>
      'एक नायक चुनें: तर्क, स्मृति, ध्यान, गिनती या पथ।';

  @override
  String challengeProgressStep(int current, int total) {
    return '$total का चरण $current';
  }

  @override
  String get challengeChooseAnswer => 'एक उत्तर चुनें';

  @override
  String challengeSelectedAnswer(Object answer) {
    return 'उत्तर: $answer';
  }

  @override
  String get challengePickDifferentAnswer => 'दूसरा उत्तर चुनें';

  @override
  String get challengeCorrectAnswer => 'सही!';

  @override
  String get challengeChecking => 'चेकिंग';

  @override
  String get challengeCheck => 'जाँच करना';

  @override
  String get challengeCorrectFeedbackTitle => 'महान!';

  @override
  String get challengeRetryFeedbackTitle => 'वहाँ लगभग';

  @override
  String get challengeCorrectFeedbackText => 'उत्तर सही है. आगे बढ़ते रहना!';

  @override
  String get hintLogic =>
      'नियम दोहराता है. अगले दोहराव की शुरुआत ढूंढें और पंक्ति जारी रखें।';

  @override
  String get hintMemory =>
      'सबसे पहले याद रखें कि कौन सी तस्वीरें खुली थीं. फिर मैचिंग जोड़ी की तलाश करें।';

  @override
  String get hintAttention =>
      'विवरण की एक-एक करके तुलना करें: रंग, आकार, आकार और स्थान।';

  @override
  String get hintMath => 'छोटे समूहों में गिनें ताकि ट्रैक न खोना आसान हो।';

  @override
  String get hintSpace =>
      'प्रारंभ से अंत तक पथ का अनुसरण करें और अगले मोड़ को नाम दें।';

  @override
  String get collectionTitle => 'मेरा संग्रह';

  @override
  String get collectionDayPrize => 'दिन का पुरस्कार';

  @override
  String get collectionCosmoPrizes => 'अंतरिक्ष पुरस्कार';

  @override
  String collectionUnlocked(int total, int unlocked) {
    return '$total का $unlocked खुला';
  }

  @override
  String get collectionNewPrizeTitle => 'नए दिन का पुरस्कार';

  @override
  String get collectionNewPrizeBody =>
      'अंतरिक्ष यात्री को संग्रह में जोड़ा गया।';

  @override
  String collectionSnackUnlocked(Object title) {
    return '$title पहले से ही संग्रह में है।';
  }

  @override
  String get collectionSnackLocked => 'नए स्तरों के बाद खुलता है.';

  @override
  String get collectionNewBadge => 'नया';

  @override
  String collectionLockedLevel(int level) {
    return '$level लेवल।';
  }

  @override
  String get parentOverviewTitle => 'अभिभावक सिंहावलोकन';

  @override
  String parentOverviewBody(String name) {
    return 'प्रोफ़ाइल $name, प्रगति, आज की योजना और घर पर अभ्यास के लिए युक्तियाँ।';
  }

  @override
  String parentStarsCount(int stars) {
    return '$stars सितारे';
  }

  @override
  String get parentMissionClosed => 'मिशन पूरा हुआ';

  @override
  String get parentMissionWaiting => 'मिशन प्रतीक्षा';

  @override
  String get parentProgressTitle => 'संतान की उन्नति';

  @override
  String get parentOverviewBadge => 'सिंहावलोकन';

  @override
  String get parentLevelsLabel => 'स्तरों';

  @override
  String parentLevelsValue(int completed, int total) {
    return '$total का $completed';
  }

  @override
  String get parentTodayLabel => 'आज';

  @override
  String parentTodayValue(int done, int total) {
    return '$total का $done';
  }

  @override
  String get parentStarsLabel => 'सितारे';

  @override
  String get parentContentLabel => 'सामग्री';

  @override
  String parentContentValue(int done, int total) {
    return '$total का $done';
  }

  @override
  String get parentTodayPlanTitle => 'आज की योजना';

  @override
  String get parentTodayPlanBody =>
      'दबाव के बिना एक छोटी श्रृंखला: 2-3 शांत प्रयास एक लंबे थके हुए सत्र से बेहतर हैं।';

  @override
  String parentPuzzleMeta(String skill, int minutes) {
    return '$skill • $minutes मि';
  }

  @override
  String get parentAreasTitle => 'विकास क्षेत्र';

  @override
  String get parentBalanceBadge => 'संतुलन';

  @override
  String get parentAreasBody =>
      'यह एक वयस्क मानचित्र है: बच्चों को मिशन और नायक देखना चाहिए, न कि सूखी श्रेणियां।';

  @override
  String get parentRecommendationDone =>
      'आज का मिशन पूरा हो गया है. यह प्रयास की प्रशंसा करने का अच्छा क्षण है, गति की नहीं।';

  @override
  String parentRecommendationRemaining(int remaining) {
    return 'आज प्रगति हुई है: $remaining कार्य शेष हैं।';
  }

  @override
  String get parentRecommendationStart =>
      'आज, 4-6 मिनट के एक छोटे मिशन से शुरुआत करें।';

  @override
  String get parentRecommendationsTitle => 'सिफारिशों';

  @override
  String get parentHomeBadge => 'घर पर';

  @override
  String get parentPaceLabel => 'गति';

  @override
  String get parentWeekFocusLabel => 'सप्ताह फोकस';

  @override
  String parentFocusArea(String areaTitle, String areaSubtitle) {
    return 'जिस क्षेत्र पर अभी सबसे अधिक ध्यान देने की आवश्यकता है वह है \"$areaTitle\": $areaSubtitle।';
  }

  @override
  String get parentDiscussLabel => 'चर्चा कैसे करें';

  @override
  String get parentDiscussBody =>
      'किसी कार्य के बाद पूछें: \"आपको नियम कैसे मिला?\" इससे स्पष्टीकरण बनता है, अनुमान नहीं।';

  @override
  String get parentFamilySecurityTitle => 'परिवार और सुरक्षा';

  @override
  String get parentStorageLabel => 'भंडारण';

  @override
  String get parentStorageLocal => 'उपकरण पर';

  @override
  String get notificationDailyTitle => 'नई मिशन इंतज़ार कर रही है';

  @override
  String notificationDailyBody(String name) {
    return '$name, एक छोटी पहेली हल करो और सितारों की श्रृंखला चमकती रखो।';
  }

  @override
  String get notificationEveningTitle => 'सोने से पहले एक छोटा कदम?';

  @override
  String notificationEveningBody(String name) {
    return '$name के लिए एक छोटी मिशन बाकी है। 5 शांत मिनट काफी हैं।';
  }

  @override
  String get parentRemindersTitle => 'रिमाइंडर';

  @override
  String get parentReminderStatusOn => 'चालू';

  @override
  String get parentReminderStatusOff => 'बंद';

  @override
  String get parentRemindersBody =>
      'एक हल्का दैनिक रिमाइंडर बिना दबाव मिशन पर लौटने में मदद करता है।';

  @override
  String get parentReminderDailyLabel => 'दैनिक मिशन';

  @override
  String get parentReminderDailyValue => 'हर दिन 18:30';

  @override
  String get parentReminderFollowUpLabel => 'शाम का रिमाइंडर';

  @override
  String get parentReminderFollowUpValue => '20:15, अगर मिशन इंतज़ार कर रही है';

  @override
  String get parentReminderToggleLabel => 'वापस आने की याद दिलाएं';

  @override
  String get parentReminderToggleOn =>
      'Logic Loka बच्चे को एक छोटे मिशन के लिए बुलाएगा।';

  @override
  String get parentReminderToggleOff => 'रिमाइंडर बंद हैं। ऐप शांत रहेगा।';

  @override
  String get parentAccountTitle => 'खाता';

  @override
  String get parentAccountBody =>
      'प्रगति सिंक करने, सदस्यताएँ खोलने और दूसरे डिवाइस पर खरीदारी बहाल करने के लिए साइन इन करें।';

  @override
  String get parentAccountStatusGuest => 'अतिथि';

  @override
  String get parentAccountAction => 'साइन इन करें';

  @override
  String get accountTitle => 'खाते में साइन इन';

  @override
  String get accountHeroTitle => 'परिवार प्रोफ़ाइल को पास रखें';

  @override
  String get accountHeroBody =>
      'क्लाउड सिंक, खरीदारी और सुरक्षित अभिभावक पहुँच तैयार करने के लिए Google, Apple या ईमेल का उपयोग करें।';

  @override
  String get accountStatusGuest => 'अतिथि मोड';

  @override
  String get accountAppleButton => 'Apple से जारी रखें';

  @override
  String get accountGoogleButton => 'Google से जारी रखें';

  @override
  String get accountAuthLoading => 'जाँच रहे हैं...';

  @override
  String get accountProviderGoogle => 'Google';

  @override
  String get accountProviderApple => 'Apple';

  @override
  String get accountProviderEmail => 'Email';

  @override
  String get accountSignedInTitle => 'साइन इन हो गया';

  @override
  String get accountSignOut => 'साइन आउट';

  @override
  String get accountGoogleSuccessSnack => 'Google से साइन इन हो गया।';

  @override
  String get accountGoogleCanceledSnack => 'Google साइन इन रद्द कर दिया गया।';

  @override
  String get accountGoogleUnsupportedSnack =>
      'इस प्लेटफ़ॉर्म पर Google साइन इन अभी उपलब्ध नहीं है।';

  @override
  String get accountGoogleConfigSnack =>
      'Google साइन इन के लिए इस ऐप का OAuth क्लाइंट कॉन्फ़िगर करना होगा।';

  @override
  String accountGoogleErrorSnack(Object error) {
    return 'Google से साइन इन नहीं हो सका: $error';
  }

  @override
  String get accountBenefitGoogleTitle => 'Google से साइन इन';

  @override
  String get accountBenefitGoogleBody =>
      'OAuth कॉन्फ़िगर होने पर Google खाते से अभिभावक क्षेत्र में जल्दी पहुँचें।';

  @override
  String get accountEmailTitle => 'ईमेल से पहुँच';

  @override
  String get accountSignInTab => 'साइन इन';

  @override
  String get accountCreateTab => 'बनाएँ';

  @override
  String get accountEmailLabel => 'Email';

  @override
  String get accountPasswordLabel => 'पासवर्ड';

  @override
  String get accountConfirmPasswordLabel => 'पासवर्ड की पुष्टि करें';

  @override
  String get accountRememberDevice => 'इस डिवाइस को याद रखें';

  @override
  String get accountSubmitSignIn => 'साइन इन';

  @override
  String get accountSubmitCreate => 'खाता बनाएँ';

  @override
  String get accountForgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get accountRestorePurchases => 'खरीदारी बहाल करें';

  @override
  String get accountPrivacyNote =>
      'खाता सेवाएँ जुड़ने तक बच्चे इस डिवाइस पर खेलते रह सकते हैं।';

  @override
  String get accountBenefitSyncTitle => 'प्रगति सिंक';

  @override
  String get accountBenefitSyncBody =>
      'साइन इन किया हुआ प्रोफ़ाइल बाद में सितारों और अभ्यास इतिहास को डिवाइसों के बीच ले जा सकता है।';

  @override
  String get accountBenefitAppleTitle => 'Apple साइन इन तैयार है';

  @override
  String get accountBenefitAppleBody =>
      'बटन Apple की मूल साइन-इन जानकारी जोड़ने के लिए तैयार है।';

  @override
  String get accountBenefitPurchaseTitle => 'खरीदारी और सदस्यताएँ';

  @override
  String get accountBenefitPurchaseBody =>
      'दोबारा इंस्टॉल करने या डिवाइस बदलने के बाद पहुँच बहाल करें।';

  @override
  String get accountEmailError => 'मान्य ईमेल डालें';

  @override
  String get accountPasswordError => 'कम से कम 6 अक्षर लिखें';

  @override
  String get accountPasswordMismatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String get accountDemoSnack =>
      'ईमेल से इस डिवाइस पर साइन इन हो गया। सर्वर पर पासवर्ड जाँचने के लिए बैकएंड जोड़ें।';

  @override
  String get accountAppleSnack =>
      'Apple साइन-इन स्क्रीन मूल हैंडलर के लिए तैयार है।';

  @override
  String get accountRestoreSnack =>
      'खरीदारी बहाली स्क्रीन StoreKit के लिए तैयार है।';

  @override
  String get accountResetDialogTitle => 'पासवर्ड रीसेट करें';

  @override
  String get accountResetDialogBody =>
      'खाता बैकएंड जुड़ने पर पासवर्ड रीसेट ईमेल भेजे जाएँगे।';

  @override
  String get accountResetDialogAction => 'समझ गया';

  @override
  String get puzzleListenPrompt => 'निर्देश सुनें';

  @override
  String get puzzleStopNarration => 'आवाज़ बंद करें';
}
