// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'LogicLike';

  @override
  String get homeTab => 'घर';

  @override
  String get challengeTab => 'खोज';

  @override
  String get parentTab => 'माता-पिता';

  @override
  String homeGreeting(Object childName) {
    return 'नमस्ते,\n$childName';
  }

  @override
  String get dailyStreakTitle => 'दैनिक लकीर';

  @override
  String get streakStart => 'शुरू करना!';

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिन',
      one: '$count दिन',
    );
    return '$_temp0';
  }

  @override
  String dayCountShort(Object count) {
    return '$count डी';
  }

  @override
  String get missionOpenButton => 'खुला';

  @override
  String get missionStartShortButton => 'शुरू';

  @override
  String get missionStartButton => 'खोज प्रारंभ करें';

  @override
  String get homeMissionCompletedTitle => 'मिशन पूरा!';

  @override
  String get homeMissionHelpTitle =>
      'अंतरिक्ष यात्री की मदद करें\nतारे इकट्ठा करो!';

  @override
  String get dailyChallengeTag => 'दैनिक खोज';

  @override
  String get myProgressTitle => 'मेरी तरक्की';

  @override
  String levelLabel(Object level) {
    return 'लेवल $level';
  }

  @override
  String get myCollectionTitle => 'मेरा संग्रह';

  @override
  String stickerCountLabel(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count स्टिकर',
      one: '$count कँटिया',
    );
    return '$_temp0';
  }

  @override
  String homeParentHint(Object ageLabel, Object goalLabel, num minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes मिनट इस सप्ताह',
      one: '$minutes मिनट इस सप्ताह',
    );
    return '$ageLabel ? $goalLabel ? $_temp0';
  }

  @override
  String ageYears(num years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years साल',
      one: '$years वर्ष',
    );
    return '$_temp0';
  }

  @override
  String get goalLogicLabel => 'तर्क';

  @override
  String get goalLogicDescription => 'पैटर्न, तर्क और नियम खोजना।';

  @override
  String get goalMathLabel => 'गणित';

  @override
  String get goalMathDescription => 'संख्याएँ, गिनती और सावधानीपूर्वक समाधान।';

  @override
  String get goalAttentionLabel => 'केंद्र';

  @override
  String get goalAttentionDescription => 'ध्यान, स्मृति, और तुलना विवरण।';

  @override
  String get onboardingTitle => 'लॉजिकलाइक सेट करें';

  @override
  String get onboardingSubtitle =>
      'एक पारिवारिक प्रोफ़ाइल बनाएं ताकि दैनिक खोज बच्चे की उम्र और लक्ष्य से मेल खाए।';

  @override
  String get childNameLabel => 'बच्चे का नाम';

  @override
  String get childNameError => 'नाम डालें';

  @override
  String get ageSectionTitle => 'आयु';

  @override
  String get learningGoalSectionTitle => 'सीखने का लक्ष्य';

  @override
  String get learningGoalShortTitle => 'लक्ष्य';

  @override
  String get startButton => 'शुरू';

  @override
  String get savingButton => 'सहेजा जा रहा है';

  @override
  String get onboardingHeroTitle => 'पहली उड़ान तैयार';

  @override
  String get parentTag => 'माता-पिता';

  @override
  String get parentDashboardTitle => 'पारिवारिक केंद्र';

  @override
  String familyProfileSummary(
      Object ageLabel, Object childName, Object goalLabel) {
    return '$childName ? $ageLabel ? $goalLabel';
  }

  @override
  String get currentStreakMetric => 'धारी';

  @override
  String get sessionsMetric => 'सत्र';

  @override
  String get minutesMetric => 'मिनट';

  @override
  String get childrenProfilesTitle => 'बाल प्रोफाइल';

  @override
  String get addChildButton => 'बच्चा जोड़ें';

  @override
  String childProgressChallengeCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count अन्वेषणों',
      one: '$count खोज',
    );
    return '$_temp0';
  }

  @override
  String ageGoalSummary(Object ageLabel, Object goalLabel) {
    return '$ageLabel ? $goalLabel';
  }

  @override
  String get newChildTitle => 'नया बच्चा';

  @override
  String get cancelButton => 'रद्द करना';

  @override
  String get addButton => 'जोड़ना';

  @override
  String get analyticsTitle => 'विश्लेषण का अभ्यास करें';

  @override
  String get streakMetricLabel => 'धारी';

  @override
  String get bestStreakLabel => 'श्रेष्ठ';

  @override
  String get last7DaysLabel => 'पिछले 7 दिन';

  @override
  String get weeklyMinutesLabel => 'मिनट';

  @override
  String sessionsCountShort(Object count) {
    return '$count सत्र।';
  }

  @override
  String minutesShort(Object count) {
    return '$count मि';
  }

  @override
  String minutesNarrow(Object count) {
    return '$count एम';
  }

  @override
  String get lastSkillLabel => 'अंतिम कौशल';

  @override
  String get lastSessionLabel => 'पिछला सत्र';

  @override
  String get notAvailable => 'अभी तक नहीं';

  @override
  String get weeklyRhythmTitle => 'साप्ताहिक लय';

  @override
  String get weeklyRhythmSubtitle =>
      'प्रत्येक दिन के लिए दिन और मिनट का अभ्यास करें।';

  @override
  String get subscriptionTitle => 'पारिवारिक सदस्यता';

  @override
  String get currentPlanLabel => 'वर्तमान योजना';

  @override
  String get familySeatsLabel => 'पारिवारिक सीटें';

  @override
  String get updatedLabel => 'अद्यतन';

  @override
  String get recommendedLabel => 'सबसे अच्छा मूल्य';

  @override
  String get currentPlanButton => 'वर्तमान योजना';

  @override
  String get chooseButton => 'चुनना';

  @override
  String get resetProfilePanel =>
      'स्थानीय प्रोफ़ाइल रीसेट करें और सेटअप फिर से चलाएँ';

  @override
  String get resetButton => 'रीसेट करें';

  @override
  String get resetDialogTitle => 'प्रोफ़ाइल रीसेट करें?';

  @override
  String get resetDialogBody =>
      'ऑनबोर्डिंग फिर से खुलेगी और स्थानीय प्रगति साफ़ हो जाएगी।';

  @override
  String get resetConfirmButton => 'रीसेट करें';

  @override
  String get limitPaidMessage =>
      'सभी पारिवारिक सीटें पहले ही उपयोग की जा चुकी हैं।';

  @override
  String get limitStarterMessage =>
      'परिवार योजना पर अधिक प्रोफ़ाइल उपलब्ध हैं।';

  @override
  String get planStarterLabel => 'स्टार्टर';

  @override
  String get planStarterPrice => '0 ₽';

  @override
  String get planStarterCapacity => '1 बच्चे की प्रोफ़ाइल';

  @override
  String get planStarterDescription => 'लघु दैनिक लूप और स्थानीय प्रगति।';

  @override
  String get planMonthlyLabel => 'पारिवारिक मासिक';

  @override
  String get planMonthlyPrice => '399 ₽/महीना';

  @override
  String get planFamilyCapacity => '3 बच्चों की प्रोफ़ाइल तक';

  @override
  String get planMonthlyDescription =>
      'पूर्ण पहुंच, पारिवारिक प्रोफ़ाइल और अभिभावक विश्लेषण।';

  @override
  String get planAnnualLabel => 'पारिवारिक वार्षिक';

  @override
  String get planAnnualPrice => '2990 ₽/वर्ष';

  @override
  String get planAnnualDescription =>
      'वार्षिक बिलिंग के लिए बेहतर मूल्य के साथ समान पहुंच।';

  @override
  String get planActiveStatus => 'सक्रिय';

  @override
  String get planInactiveStatus => 'सक्रिय नहीं';

  @override
  String get missionCompletedTitle => 'मिशन पूरा!';

  @override
  String childGoCta(Object childName) {
    return '$childName, हमें जाने दो!';
  }

  @override
  String get chooseAnswerTitle => 'एक उत्तर चुनें';

  @override
  String get checkingButton => 'सहेजा जा रहा है';

  @override
  String get checkAnswerButton => 'जाँच करना';

  @override
  String answerCorrect(Object explanation) {
    return 'सही! $explanation';
  }

  @override
  String answerAlmost(Object hint) {
    return 'लगभग। $hint';
  }

  @override
  String get challengeCompletedToday => 'आज की तलाश पूरी हुई';

  @override
  String get weekdayMondayShort => 'सोम';

  @override
  String get weekdayTuesdayShort => 'मंगल';

  @override
  String get weekdayWednesdayShort => 'बुध';

  @override
  String get weekdayThursdayShort => 'गुरु';

  @override
  String get weekdayFridayShort => 'शुक्र';

  @override
  String get weekdaySaturdayShort => 'बैठा';

  @override
  String get weekdaySundayShort => 'सूरज';

  @override
  String get skillPatterns => 'पैटर्न्स';

  @override
  String get skillCountingToFive => 'पांच तक गिनती';

  @override
  String get skillComparison => 'तुलना';

  @override
  String get skillSequences => 'दृश्यों';

  @override
  String get skillAdditionToTen => 'दस के अतिरिक्त';

  @override
  String get skillWorkingMemory => 'क्रियाशील स्मृति';

  @override
  String get skillLogicDeduction => 'तर्क और कटौती';

  @override
  String get skillMathThinking => 'गणित सोच';

  @override
  String get skillDetailComparison => 'विस्तृत तुलना';

  @override
  String get challengeShapePathTitle => 'आकार पथ';

  @override
  String get challengeShapePathPrompt =>
      'पंक्ति को देखें और जानें कि आगे क्या आता है।';

  @override
  String get challengeShapePathQuestion =>
      'वृत्त, वर्ग, वृत्त, वर्ग। आगे क्या आता है?';

  @override
  String get challengeShapePathHint =>
      'आकृतियाँ वैकल्पिक होती हैं: एक आकृति, फिर दूसरी, फिर पहली।';

  @override
  String get challengeShapePathExplanation =>
      'वर्ग के बाद फिर से एक वृत्त आता है, क्योंकि पंक्ति हर दो आकृतियों को दोहराती है।';

  @override
  String get challengeToyCountTitle => 'खिलौनों की गिनती';

  @override
  String get challengeToyCountPrompt => 'वस्तुओं को गिनें और सटीक उत्तर चुनें।';

  @override
  String get challengeToyCountQuestion =>
      'शेल्फ पर 2 ब्लॉक और 1 गेंद हैं। वहां कितने खिलौने हैं?';

  @override
  String get challengeToyCountHint => 'पहले ब्लॉक गिनें, फिर गेंद जोड़ें।';

  @override
  String get challengeToyCountExplanation =>
      '2 ब्लॉक और 1 गेंद कुल मिलाकर 3 खिलौने बनाते हैं।';

  @override
  String get challengeOddCardTitle => 'अजीब कार्ड आउट';

  @override
  String get challengeOddCardPrompt => 'वह वस्तु ढूंढें जो दूसरों से भिन्न हो।';

  @override
  String get challengeOddCardQuestion =>
      'सेब, नाशपाती, गेंद, केला। कौन सा एक संबंधित नहीं है?';

  @override
  String get challengeOddCardHint =>
      'तीन वस्तुएँ खाई जा सकती हैं, और एक खेलने के लिए है।';

  @override
  String get challengeOddCardExplanation =>
      'गेंद संबंधित नहीं है: सेब, नाशपाती और केला फल हैं।';

  @override
  String get challengeLogicTrainTitle => 'तर्क ट्रेन';

  @override
  String get challengeLogicTrainPrompt =>
      'ट्रेन के डिब्बों को नियम के अनुसार रखें।';

  @override
  String get challengeLogicTrainQuestion =>
      'लाल, नीला, नीला, लाल, नीला, नीला। आगे क्या आता है?';

  @override
  String get challengeLogicTrainHint =>
      'नियम तीन के समूहों में दोहराया जाता है: एक लाल और दो नीला।';

  @override
  String get challengeLogicTrainExplanation =>
      'अगली कार लाल है: दो नीली कारों के बाद, एक नया समूह शुरू होता है।';

  @override
  String get challengeStickerSumTitle => 'स्टीकर एलबम';

  @override
  String get challengeStickerSumPrompt => 'वस्तुओं के दो छोटे समूह जोड़ें।';

  @override
  String get challengeStickerSumQuestion =>
      'नीका के पास 3 स्टिकर थे, फिर 2 और मिले। अब उसके पास कितने हैं?';

  @override
  String get challengeStickerSumHint => 'तीन से शुरू करें और दो और चरण गिनें।';

  @override
  String get challengeStickerSumExplanation =>
      '3 + 2 = 5, इसलिए उसके पास पाँच स्टिकर हैं।';

  @override
  String get challengeMemoryPairsTitle => 'स्मृति युग्म';

  @override
  String get challengeMemoryPairsPrompt =>
      'प्रत्येक आइटम के लिए मेल खाने वाली जोड़ी को याद रखें।';

  @override
  String get challengeMemoryPairsQuestion => 'कुंजी के साथ क्या होता है?';

  @override
  String get challengeMemoryPairsHint =>
      'किसी चीज़ को खोलने के लिए कुंजी का उपयोग किया जाता है।';

  @override
  String get challengeMemoryPairsExplanation =>
      'चाबी ताले के साथ चलती है: साथ मिलकर वे एक सार्थक जोड़ी बनाते हैं।';

  @override
  String get challengeCodeGridTitle => 'कोड ग्रिड';

  @override
  String get challengeCodeGridPrompt => 'नियम को हल करें और सही सेल चुनें।';

  @override
  String get challengeCodeGridQuestion =>
      'पहली पंक्ति 2, 4, 6 है। दूसरी पंक्ति 3, 5, ? है। कौन सा नंबर गायब है?';

  @override
  String get challengeCodeGridHint =>
      'दूसरी पंक्ति की संख्या भी 2 से बढ़ती है।';

  @override
  String get challengeCodeGridExplanation =>
      '3 और 5 के बाद 7 आता है: प्रत्येक चरण में दो जोड़े जाते हैं।';

  @override
  String get challengeNumberBridgeTitle => 'नंबर ब्रिज';

  @override
  String get challengeNumberBridgePrompt =>
      'सही मार्ग बनाने के लिए संख्याओं को जोड़ें।';

  @override
  String get challengeNumberBridgeQuestion =>
      'आपके पास 4, 2, और 1 है। आप 7 कैसे बना सकते हैं?';

  @override
  String get challengeNumberBridgeHint =>
      'सभी नंबरों का एक बार उपयोग करके देखें.';

  @override
  String get challengeNumberBridgeExplanation =>
      '4 + 2 + 1 = 7, अतः तीनों संख्याएँ मिलकर लक्ष्य बनाती हैं।';

  @override
  String get challengeDetailCountTitle => 'विस्तृत मानचित्र';

  @override
  String get challengeDetailCountPrompt =>
      'कई विवरणों को ध्यान में रखें और उनकी तुलना करें।';

  @override
  String get challengeDetailCountQuestion =>
      'इसमें 3 लाल वृत्त, 2 नीले वर्ग और 1 हरा तारा है। किस समूह के पास सबसे अधिक है?';

  @override
  String get challengeDetailCountHint => 'राशियों की तुलना करें: 3, 2, और 1।';

  @override
  String get challengeDetailCountExplanation =>
      'लाल वृत्त सबसे अधिक हैं: ये तीन हैं।';

  @override
  String get challengeMemoryRecallTitle => 'कार्ड याद रखें';

  @override
  String get challengeMemoryRecallPrompt =>
      'पंक्ति को देखें और छिपा हुआ कार्ड ढूंढें।';

  @override
  String get challengeMemoryRecallQuestion => 'कौन सा कार्ड छिपा है?';

  @override
  String get challengeMemoryRecallHint =>
      'वस्तुओं को बाएँ से दाएँ याद रखें और अंतिम की जाँच करें।';

  @override
  String get challengeMemoryRecallExplanation =>
      'छिपा हुआ कार्ड उस पंक्ति में था जिसे आपको याद रखना था।';

  @override
  String get challengeSortingRuleTitle => 'बॉक्स नियम';

  @override
  String get challengeSortingRulePrompt =>
      'वह वस्तु ढूंढें जो दूसरों से संबंधित है।';

  @override
  String get challengeSortingRuleQuestion => 'समान नियम का पालन क्या करता है?';

  @override
  String get challengeSortingRuleHint =>
      'सबसे पहले पता लगाएं कि बॉक्स में मौजूद वस्तुओं में क्या समानता है।';

  @override
  String get challengeSortingRuleExplanation =>
      'सही ऑब्जेक्ट बॉक्स नियम से मेल खाता है।';

  @override
  String get challengeMissingPieceTitle => 'गुम टुकड़ा';

  @override
  String get challengeMissingPiecePrompt =>
      'वह भाग चुनें जो चित्र को पूरा करता है।';

  @override
  String get challengeMissingPieceQuestion =>
      'खाली जगह पर कौन सा टुकड़ा फिट बैठता है?';

  @override
  String get challengeMissingPieceHint =>
      'उत्तर विकल्पों के साथ खाली आकृति की तुलना करें।';

  @override
  String get challengeMissingPieceExplanation =>
      'यह टुकड़ा अतिरिक्त कोनों के बिना चित्र को पूरा करता है।';

  @override
  String get challengeLogicDeductionTitle => 'दो सुराग';

  @override
  String get challengeLogicDeductionPrompt =>
      'दोनों सुरागों का उपयोग करें और गलत विकल्पों को हटा दें।';

  @override
  String get challengeLogicDeductionQuestion =>
      'प्रत्येक सुराग से क्या मेल खाता है?';

  @override
  String get challengeLogicDeductionHint =>
      'प्रत्येक सुराग कम से कम एक गलत विकल्प को हटा देता है।';

  @override
  String get challengeLogicDeductionExplanation =>
      'सही उत्तर दोनों सुरागों से मेल खाता है।';

  @override
  String get choiceTriangle => 'त्रिकोण';

  @override
  String get choiceCircle => 'घेरा';

  @override
  String get choiceStar => 'तारा';

  @override
  String get choiceApple => 'सेब';

  @override
  String get choiceBall => 'गेंद';

  @override
  String get choiceBanana => 'केला';

  @override
  String get choiceBlue => 'नीला';

  @override
  String get choiceRed => 'लाल';

  @override
  String get choiceGreen => 'हरा';

  @override
  String get choiceKey => 'चाबी';

  @override
  String get choiceLock => 'ताला';

  @override
  String get choiceShoe => 'जूता';

  @override
  String get choiceCloud => 'बादल';

  @override
  String get choiceBlueSquares => 'नीला वर्ग';

  @override
  String get choiceRedCircles => 'लाल घेरे';

  @override
  String get choiceGreenStars => 'हरे तारे';

  @override
  String mapLessonTitle(Object lesson) {
    return 'पाठ $lesson';
  }

  @override
  String get mapLessonSubtitle => 'एक छोटे से पाठ में तर्क, गिनती और फोकस';

  @override
  String get mapStartButton => 'शुरू';

  @override
  String get mapNodeStart => 'शुरू';

  @override
  String get mapNodeShapes => 'आकार';

  @override
  String get mapNodePairs => 'जोड़े';

  @override
  String get mapNodeCounting => 'गिनती';

  @override
  String get mapNodePath => 'पथ';

  @override
  String get mapNodeRhythm => 'लय';

  @override
  String get mapNodeCompare => 'तुलना करना';

  @override
  String get mapNodeFinal => 'अंतिम';

  @override
  String get mapNodeCompleted => 'हो गया';

  @override
  String get mapNodeCurrent => 'खुला';

  @override
  String get mapNodeLocked => 'बंद';

  @override
  String mapPreviewTitle(Object lesson) {
    return 'पाठ $lesson';
  }

  @override
  String mapPreviewSteps(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count कदम',
      one: '$count कदम',
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
      other: '$count दिल',
      one: '$count दिल',
    );
    return '$_temp0';
  }

  @override
  String get mapPreviewBody =>
      'मिश्रित पहेलियों के साथ एक छोटा पाठ: तर्क, गिनती, तुलना और फोकस।';

  @override
  String get mapPreviewStart => 'पाठ प्रारंभ करें';

  @override
  String get mapPreviewClose => 'बाद में';

  @override
  String lessonProgress(Object current, Object total) {
    return '$total का चरण $current';
  }

  @override
  String get lessonNextButton => 'अगला';

  @override
  String get lessonFinishButton => 'पाठ समाप्त करें';

  @override
  String get lessonCompleteTitle => 'पाठ पूरा हुआ!';

  @override
  String get lessonCompleteBody =>
      'आपने मानचित्र पर अगला चरण अनलॉक कर दिया है.';

  @override
  String get lessonRewardStars => '+1 सितारा';

  @override
  String lessonRewardXp(Object xp) {
    return '+$xp XP';
  }

  @override
  String get lessonBackToMap => 'वापस घर';

  @override
  String get courseCatalogTitle => 'पाठ्यक्रम और पहेलियाँ';

  @override
  String get courseLogicTitle => 'तर्क';

  @override
  String get courseLogicSubtitle => 'नियम, एक से बढ़कर एक, और तर्क';

  @override
  String get courseMathTitle => 'गणित';

  @override
  String get courseMathSubtitle => 'गिनती, योग और तुलना';

  @override
  String get courseSpatialTitle => 'आकार';

  @override
  String get courseSpatialSubtitle => 'रूप, पथ और स्थान';

  @override
  String get courseAttentionTitle => 'केंद्र';

  @override
  String get courseAttentionSubtitle => 'विवरण, स्मृति और ध्यान';

  @override
  String get courseRebusTitle => 'खंडन';

  @override
  String get courseRebusSubtitle => 'चित्र, शब्द और पहेलियाँ';

  @override
  String get courseMixedTitle => 'दैनिक मिश्रण';

  @override
  String get courseMixedSubtitle => 'एक पंक्ति में विभिन्न पहेलियाँ';

  @override
  String progressCardBody(Object level, Object stars) {
    return 'स्तर $level ? $stars सितारे';
  }

  @override
  String collectionCardBody(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count स्टिकर',
      one: '$count कँटिया',
    );
    return '$_temp0';
  }

  @override
  String get dailyMissionBody => 'तर्क, गिनती और फोकस पहेलियों का एक छोटा सेट।';

  @override
  String get openCourseButton => 'खुला';

  @override
  String courseProgress(Object completed, Object total) {
    return '$total में से $completed पाठ पूर्ण';
  }

  @override
  String courseLessonTitle(Object lesson) {
    return 'पाठ $lesson';
  }

  @override
  String courseLessonMeta(num steps, Object xp) {
    String _temp0 = intl.Intl.pluralLogic(
      steps,
      locale: localeName,
      other: '$steps कदम',
      one: '$steps कदम',
    );
    return '$_temp0 ? +$xp XP';
  }

  @override
  String get courseStartLessonButton => 'शुरू';

  @override
  String get courseRepeatButton => 'दोहराना';

  @override
  String get showHintButton => 'संकेत देना';

  @override
  String get hideHintButton => 'संकेत छिपाएँ';

  @override
  String get lessonStickerUnlockedTitle => 'समाचार लटकन!';

  @override
  String get lessonStickerUnlockedBody => 'पाठ के बाद आपका संग्रह बढ़ गया।';

  @override
  String get lessonRewardCollection => '+1 स्टिकर';

  @override
  String get lessonRewardStreak => 'लकीर बढ़ती है';

  @override
  String get challengeShadowMatchTitle => 'छाया मिलान';

  @override
  String get challengeShadowMatchPrompt =>
      'वह वस्तु ढूंढें जो छाया में फिट बैठती है।';

  @override
  String get challengeShadowMatchQuestion =>
      'छाया का शरीर लंबा और दो छोटे पंख होते हैं। यह क्या है?';

  @override
  String get challengeShadowMatchHint => 'वस्तु की पूरी रूपरेखा देखें.';

  @override
  String get challengeShadowMatchExplanation =>
      'रॉकेट छाया से मेल खाता है: इसका एक लंबा शरीर और दो पार्श्व पंख हैं।';

  @override
  String get challengeBalanceScaleTitle => 'संतुलन पैमाना';

  @override
  String get challengeBalanceScalePrompt =>
      'पक्षों की तुलना करें और चुनें कि क्या कमी है।';

  @override
  String get challengeBalanceScaleQuestion =>
      'बाईं ओर 2 सेब हैं। दाईं ओर 1 सेब और ? है। आपको क्या जोड़ना चाहिए?';

  @override
  String get challengeBalanceScaleHint =>
      'दोनों पक्षों को समान संख्या में सेबों की आवश्यकता है।';

  @override
  String get challengeBalanceScaleExplanation =>
      'एक और सेब दाईं ओर को बाईं ओर के बराबर बनाता है: 2 और 2।';

  @override
  String get challengeShapeRotationTitle => 'आकार बदलो';

  @override
  String get challengeShapeRotationPrompt =>
      'कल्पना कीजिए कि आकृति घूम रही है।';

  @override
  String get challengeShapeRotationQuestion =>
      'एक त्रिभुज दाहिनी ओर मुड़ता है। कौन सा कार्ड समान आकार दिखाता है?';

  @override
  String get challengeShapeRotationHint =>
      'मुड़ने से दिशा बदलती है, लेकिन आकार नहीं।';

  @override
  String get challengeShapeRotationExplanation =>
      'यह वही त्रिभुज है: यह घूम गया, लेकिन कोई अलग आकार नहीं बना।';

  @override
  String get choiceRocket => 'राकेट';

  @override
  String get choicePlanet => 'ग्रह';

  @override
  String get choiceSameTriangle => 'वही त्रिकोण';

  @override
  String get choiceSquare => 'वर्ग';

  @override
  String get skillInsightsTitle => 'कौशल और सिफ़ारिशें';

  @override
  String get strongestAreaLabel => 'मजबूत क्षेत्र';

  @override
  String get practiceFocusLabel => 'फोकस क्षेत्र';

  @override
  String get recommendedPracticeLabel => 'अगला अभ्यास करें';

  @override
  String get noSkillDataLabel => 'अभी पर्याप्त डेटा नहीं है';

  @override
  String get recommendationKeepGoing =>
      'छोटे पाठ करते रहें: कुछ सत्रों के बाद अनुशंसाएँ तेज़ हो जाती हैं।';

  @override
  String get recommendationPracticeFocus =>
      'सप्ताह के दौरान इस क्षेत्र के लिए 1-2 छोटे पाठ जोड़ें।';

  @override
  String get courseNextMetricLabel => 'अगला';

  @override
  String get courseStarsMetricLabel => 'सितारे';

  @override
  String get courseXpMetricLabel => 'एक्सपी';

  @override
  String get courseCompletedState => 'हो गया';

  @override
  String get courseOpenState => 'खुला';

  @override
  String get courseLockedState => 'बंद';

  @override
  String get collectionScreenTitle => 'स्टीकर संग्रह';

  @override
  String get collectionScreenSubtitle =>
      'पाठ पूरा करके और अभ्यास जारी रखकर पुरस्कार प्राप्त करें।';

  @override
  String collectionUnlockedCount(Object total, Object unlocked) {
    return '$total में से $unlocked अनलॉक हो गया';
  }

  @override
  String get collectionNextReward => 'अगला पुरस्कार';

  @override
  String get collectionAllRewardsUnlocked => 'सभी पुरस्कार अनलॉक हो गए';

  @override
  String get collectionBackHome => 'वापस घर';

  @override
  String collectionLockedHint(Object stars) {
    return '$stars सितारों के बाद अनलॉक होता है';
  }

  @override
  String get rewardAstronautTitle => 'सितारा सहायक';

  @override
  String get rewardAstronautBody => 'पहला मिशन ख़त्म करने के लिए.';

  @override
  String get rewardRocketTitle => 'बहादुर रॉकेट';

  @override
  String get rewardRocketBody => 'एक शिक्षण पाठ्यक्रम खोलने के लिए.';

  @override
  String get rewardPlanetTitle => 'छोटा ग्रह';

  @override
  String get rewardPlanetBody => 'दो पाठ पूरे करने के लिए.';

  @override
  String get rewardLionTitle => 'तर्क सिंह';

  @override
  String get rewardLionBody => 'अभ्यास शृंखला बनाने के लिए.';

  @override
  String get rewardPuzzleTitle => 'पहेली बिल्ला';

  @override
  String get rewardPuzzleBody => 'मिश्रित पहेलियाँ सुलझाने के लिए.';

  @override
  String get rewardChampionTitle => 'अंतरिक्ष चैंपियन';

  @override
  String get rewardChampionBody => 'स्थिर साप्ताहिक अभ्यास के लिए.';

  @override
  String get accuracyMetricLabel => 'शुद्धता';

  @override
  String get hintsMetricLabel => 'संकेत';

  @override
  String recommendationImproveAccuracy(Object skill) {
    return 'इस सप्ताह धीरे-धीरे $skill का अभ्यास करें: सटीकता सुधार का मुख्य संकेत है।';
  }

  @override
  String recommendationReduceHints(Object skill) {
    return 'कम संकेतों के साथ $skill को दोहराएं: सहायता खोलने से पहले रुकें।';
  }

  @override
  String recommendationRepeatAttempts(Object skill) {
    return 'गलत प्रयासों को कम करने के लिए $skill को एक छोटा दोहराव सत्र दें।';
  }

  @override
  String get homeRecommendedLessonTitle => 'अगला पाठ';

  @override
  String get homeRecommendedLessonSubtitle =>
      'सीखने के मार्ग पर अगला संक्षिप्त पाठ।';

  @override
  String get homeRecommendedLessonButton => 'जारी रखना';

  @override
  String get homeRecommendedLessonCompleted => 'मार्ग पूर्ण';

  @override
  String get lessonReviewTitle => 'पाठ सारांश';

  @override
  String get lessonReviewPerfectBody =>
      'बढ़िया फोकस: कोई संकेत या ग़लतियाँ नहीं।';

  @override
  String get lessonReviewSupportBody =>
      'अच्छा समापन. अगली बार कम सहायता के साथ एक कदम आज़माएँ।';

  @override
  String get lessonReviewQuestionsLabel => 'प्रश्न';

  @override
  String get lessonReviewHintsLabel => 'संकेत';

  @override
  String get lessonReviewMistakesLabel => 'गलतियाँ';

  @override
  String get lessonNextRecommendedButton => 'अगला पाठ';

  @override
  String get practiceHistoryTitle => 'इतिहास का अभ्यास करें';

  @override
  String get practiceHistorySubtitle =>
      'सटीकता, संकेत और गलतियों के साथ हाल के पाठ।';

  @override
  String get practiceHistoryEmpty => 'अभी तक कोई पाठ पूरा नहीं हुआ.';

  @override
  String practiceHistorySessionMeta(Object date, Object minutes) {
    return '$date - $minutes मिनट';
  }

  @override
  String get practiceHistoryMistakesLabel => 'गलतियाँ';

  @override
  String get lessonTryAgainButton => 'पुनः प्रयास करें';

  @override
  String get lessonHintTitle => 'चरण दर चरण सोचें';

  @override
  String get lessonRetryFeedback =>
      'अच्छा प्रयास. संकेत पढ़ें, फिर दोबारा चुनें.';

  @override
  String get languageSettingsTitle => 'ऐप भाषा';

  @override
  String get languageSettingsSubtitle =>
      'बच्चे और अभिभावक स्क्रीन के लिए भाषा चुनें।';

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
  String get choicePear => 'नाशपाती';

  @override
  String get challengeFruitPatternTitle => 'फलों की कतार';

  @override
  String get challengeFruitPatternPrompt => 'फलों का पैटर्न जारी रखें.';

  @override
  String get challengeFruitPatternQuestion =>
      'सेब, केला, सेब, केला। आगे क्या आता है?';

  @override
  String get challengeFruitPatternHint =>
      'फल एक-एक करके दोहराएँ: सेब, फिर केला।';

  @override
  String get challengeFruitPatternExplanation =>
      'केले के बाद सेब फिर आता है, क्योंकि पैटर्न दोहराता है।';

  @override
  String get challengeLockKeyTitle => 'जादुई जोड़ी';

  @override
  String get challengeLockKeyPrompt => 'वह वस्तु चुनें जो जोड़ी बनाती है।';

  @override
  String get challengeLockKeyQuestion =>
      'एक कुंजी कुछ खोलती है. यह किसके साथ जाता है?';

  @override
  String get challengeLockKeyHint =>
      'इस बारे में सोचें कि कुंजी का उपयोग किस लिए किया जाता है।';

  @override
  String get challengeLockKeyExplanation =>
      'चाबी और ताला एक साथ काम करते हैं, इसलिए वे जोड़ी बनाते हैं।';

  @override
  String get challengeSpaceSequenceTitle => 'अंतरिक्ष मार्ग';

  @override
  String get challengeSpaceSequencePrompt => 'अगली अंतरिक्ष वस्तु खोजें.';

  @override
  String get challengeSpaceSequenceQuestion =>
      'रॉकेट, ग्रह, रॉकेट, ग्रह। आगे क्या आता है?';

  @override
  String get challengeSpaceSequenceHint => 'मार्ग दोहराता है: रॉकेट, फिर ग्रह।';

  @override
  String get challengeSpaceSequenceExplanation =>
      'ग्रह के बाद फिर आता है एक रॉकेट.';

  @override
  String get challengeShapeStackTitle => 'आकृति टावर';

  @override
  String get challengeShapeStackPrompt => 'टावर नियम जारी रखें.';

  @override
  String get challengeShapeStackQuestion =>
      'वर्ग, वृत्त, वर्ग, वृत्त. अगला आकार कौन सा है?';

  @override
  String get challengeShapeStackHint =>
      'टावर दो आकृतियों के बीच बदलता रहता है।';

  @override
  String get challengeShapeStackExplanation =>
      'एक वृत्त के बाद फिर एक वर्ग आता है।';

  @override
  String get challengePathMazeTitle => 'पथ खोजक';

  @override
  String get challengePathMazePrompt =>
      'प्रारंभ से अंत तक सड़क का अनुसरण करें.';

  @override
  String get challengePathMazeQuestion =>
      'नायक को लक्ष्य तक पहुंचने में मदद करें. इसे किस ओर जाना चाहिए?';

  @override
  String get challengePathMazeHint =>
      'शुरू से अंत तक सड़क का पता लगाएं और दोराहे पर दिशा चुनें।';

  @override
  String get challengePathMazeExplanation =>
      'सही रास्ता लक्ष्य तक पहुंचने वाले खुले रास्ते का अनुसरण करता है।';

  @override
  String get lesson_001_title => 'आकार पथ';

  @override
  String get lesson_002_title => 'खिलौनों की गिनती';

  @override
  String get lesson_003_title => 'अजीब कार्ड आउट';

  @override
  String get lesson_004_title => 'तर्क ट्रेन';

  @override
  String get lesson_005_title => 'योग और पंक्तियाँ';

  @override
  String get lesson_006_title => 'मेमोरी और कोड';

  @override
  String get lesson_007_title => 'नंबर ब्रिज';

  @override
  String get lesson_008_title => 'विस्तृत मानचित्र';

  @override
  String get lesson_009_title => 'छाया और संतुलन';

  @override
  String get lesson_010_title => 'जोड़ना और तुलना करना';

  @override
  String get lesson_011_title => 'मोड़ और रास्ते';

  @override
  String get lesson_012_title => 'स्मृति और फोकस';

  @override
  String get lesson_013_title => 'फल पैटर्न';

  @override
  String get lesson_014_title => 'गणित शेल्फ';

  @override
  String get lesson_015_title => 'आकृति टावर';

  @override
  String get lesson_016_title => 'ताले और विवरण';

  @override
  String get lesson_017_title => 'कोड और नंबर';

  @override
  String get lesson_018_title => 'अंतरिक्ष क्रम';

  @override
  String get lesson_019_title => 'मतभेदों पर ध्यान दें';

  @override
  String get lesson_020_title => 'समाधान पुल';

  @override
  String get lesson_021_title => 'एक पंक्ति में नियम';

  @override
  String get lesson_022_title => 'अंतरिक्ष में आकृतियाँ';

  @override
  String get lesson_023_title => 'स्मृति और गिनती';

  @override
  String get lesson_024_title => 'अंतिम मिश्रण';

  @override
  String get lesson_025_title => 'विस्तृत जासूस';

  @override
  String get lesson_026_title => 'तराजू और संख्या';

  @override
  String get lesson_027_title => 'अजीब और जोड़े';

  @override
  String get lesson_028_title => 'अंतरिक्ष आकार';

  @override
  String get lesson_029_title => 'सावधान रकम';

  @override
  String get lesson_030_title => 'नियम और संहिता';

  @override
  String get lesson_031_title => 'छाया, आकार, स्मृति';

  @override
  String get lesson_032_title => 'संख्याएँ और विवरण';

  @override
  String get lesson_033_title => 'नियम शृंखला';

  @override
  String get lesson_034_title => 'अंतरिक्ष बदल जाता है';

  @override
  String get lesson_035_title => 'बड़ी संख्या वाला मार्ग';

  @override
  String get lesson_036_title => 'पर्यवेक्षक समापन';

  @override
  String get lesson_037_title => 'मोड़ और स्मृति';

  @override
  String get lesson_038_title => 'स्प्रिंट गिनती';

  @override
  String get lesson_039_title => 'नियम और जोड़ी';

  @override
  String get lesson_040_title => 'अंतरिक्ष मीनार';

  @override
  String get lesson_041_title => 'तराजू और फोकस';

  @override
  String get lesson_042_title => 'कोड ट्रेन';

  @override
  String get lesson_043_title => 'छाया और ताले';

  @override
  String get lesson_044_title => 'संख्याएँ और स्मृति';

  @override
  String get lesson_045_title => 'लंबी श्रृंखला';

  @override
  String get lesson_046_title => 'स्थानिक मार्ग';

  @override
  String get lesson_047_title => 'रकम और विवरण';

  @override
  String get lesson_048_title => 'तर्क फोकस';

  @override
  String get lesson_049_title => 'करीब से आकार देता है';

  @override
  String get lesson_050_title => 'सावधान अंकगणित';

  @override
  String get lesson_051_title => 'पैटर्न मास्टर';

  @override
  String get lesson_052_title => 'अंतरिक्ष में छाया';

  @override
  String get lesson_053_title => 'संख्या पहेली';

  @override
  String get lesson_054_title => 'प्रेक्षक कोड';

  @override
  String get lesson_055_title => 'मीनार और चाबी';

  @override
  String get lesson_056_title => 'विवरण और पैमाने';

  @override
  String get lesson_057_title => 'कठिन नियम';

  @override
  String get lesson_058_title => 'आकार समापन';

  @override
  String get lesson_059_title => 'बड़ी संख्या का कार्य';

  @override
  String get lesson_060_title => 'तर्क सुपरमिक्स';
}
