// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Logic Loka';

  @override
  String get loadingMission => '미션 준비중..';

  @override
  String get navHome => '집';

  @override
  String get navChallenge => '일';

  @override
  String get navParent => '조상';

  @override
  String get commonCancel => '취소';

  @override
  String get commonReset => '다시 놓기';

  @override
  String languageChanged(Object language) {
    return '언어: $language';
  }

  @override
  String languageButtonSemantics(Object language) {
    return '언어를 변경하세요. 현재: $language';
  }

  @override
  String get onboardingSubmitSaving => '경로 준비 중';

  @override
  String get onboardingSubmitCreateHero => '영웅 만들기';

  @override
  String get onboardingDefaultHero => '젊은 영웅';

  @override
  String get onboardingTitle => '영웅 만들기';

  @override
  String onboardingHeroSummary(Object age, Object name) {
    return '$name, $age';
  }

  @override
  String get onboardingSubtitle => '사자가 일일 미션을 보여주면 아이는 두뇌 훈련을 선택할 수 있습니다.';

  @override
  String get childNameLabel => '아이 이름';

  @override
  String get childNameError => '영웅 이름을 입력하세요';

  @override
  String get onboardingMissionPill => '임무 시작';

  @override
  String get onboardingAgeTitle => '영웅시대';

  @override
  String get unlockMission => '사명';

  @override
  String get unlockGames => '계략';

  @override
  String get unlockPrizes => '상금';

  @override
  String ageYears(int years) {
    return '$years년';
  }

  @override
  String homeGreeting(Object name) {
    return '안녕하세요,\n$name님';
  }

  @override
  String get homeStarsHint => '임무를 통해 스타가 성장하고 새로운 상품을 잠금 해제할 수 있습니다.';

  @override
  String get homeLockedLevelHint => '이 레벨은 새로운 별 이후에 열립니다.';

  @override
  String get homeStreakSavedHint => '연속 기록이 저장되었습니다! 내일 새로운 임무가 도착합니다.';

  @override
  String get homeStreakNeedMissionHint => '연승을 저장하려면 일일 임무를 완료하세요.';

  @override
  String get homeStreakTitle => '일일 연속';

  @override
  String homeStreakDays(int days) {
    return '$days일 연속!';
  }

  @override
  String get homeStreakWaiting => '임무가 기다리고 있어요';

  @override
  String get homeMissionDaily => '일일미션';

  @override
  String get homeMissionFreePlay => '무료 플레이';

  @override
  String get homeTrainingOpen => '훈련이 열려있습니다';

  @override
  String homeLevel(int level) {
    return '레벨 $level';
  }

  @override
  String get homeMissionStart => '시작';

  @override
  String get homeMissionChoose => '선택하다';

  @override
  String get homeMissionTag => '주요 임무';

  @override
  String get homeFreePlayTitle => '자신을 플레이';

  @override
  String get homeFreePlaySubtitle => '영웅을 선택하고 두뇌를 훈련하세요';

  @override
  String get homeMiniGamesTitle => '미니게임';

  @override
  String get homeMiniGamesSubtitle => '레벨 후 빠른 훈련';

  @override
  String get homeQuickPairs => '한 쌍';

  @override
  String get homeQuickPath => '길';

  @override
  String get homeQuickCount => '세다';

  @override
  String get homeProgressTitle => '내 진행 상황';

  @override
  String homeProgressStars(int current, int total) {
    return '$current / $total 별';
  }

  @override
  String get homeCollectionTitle => '수집';

  @override
  String get homeCollectionStickers => '스티커';

  @override
  String get homeLevelsTitle => '레벨';

  @override
  String get homeLevelsSubtitle => '달력이 아닌 8가지 교육 테마';

  @override
  String get homeNodeCompleted => '완료';

  @override
  String get homeNodePlay => '놀다';

  @override
  String get homeNodeSoon => '곧';

  @override
  String get homeMapStart => '시작';

  @override
  String get homeMapShapes => '모양';

  @override
  String get homeMapPairs => '한 쌍';

  @override
  String get homeMapCount => '세다';

  @override
  String get homeMapPath => '길';

  @override
  String get homeMapRhythm => '율';

  @override
  String get homeMapCompare => '비교하다';

  @override
  String get homeMapFinal => '결정적인';

  @override
  String get parentTitle => '상위 영역';

  @override
  String get parentIntroTitle => '어른들을 위한 차분한 존';

  @override
  String get parentIntroBody => '프로필, 진행 상황, 언어 및 향후 구독은 하위 미션과 별도로 진행됩니다.';

  @override
  String get parentProfileTitle => '가족 프로필';

  @override
  String get parentLocalBadge => '현지의';

  @override
  String get parentChildLabel => '어린이';

  @override
  String get parentAgeLabel => '나이';

  @override
  String get parentCompletedTasksLabel => '완료된 작업';

  @override
  String get parentLanguageLabel => '언어';

  @override
  String get settingsLanguage => '앱 언어';

  @override
  String get parentSubscriptionTitle => '가족 구독';

  @override
  String get parentSubscriptionSoon => '곧';

  @override
  String get parentSubscriptionBody =>
      '출시 요금제: Free 이용, 월간 Premium Family, 초기 가격의 Annual.';

  @override
  String get parentFamilySeatsLabel => '패밀리석';

  @override
  String get parentFamilySeatsValue => '계획된';

  @override
  String get parentPaymentLabel => '지불';

  @override
  String get parentPaymentValue => '연결되지 않음';

  @override
  String get parentSubscriptionLaunchBadge => '초기 가격';

  @override
  String get parentSubscriptionCurrentFree => '무료';

  @override
  String get parentSubscriptionFreeTitle => '무료';

  @override
  String get parentSubscriptionFreePrice => '\$0';

  @override
  String get parentSubscriptionFreeBody => '일일 흐름을 가볍게 체험하는 시작.';

  @override
  String get parentSubscriptionFeatureDaily => '일일 미션';

  @override
  String get parentSubscriptionFeatureStarter => '시작 레벨';

  @override
  String get parentSubscriptionFeatureLocalProgress => '이 기기의 로컬 진행도';

  @override
  String get parentSubscriptionFreeCta => '현재 이용';

  @override
  String get parentSubscriptionPremiumTitle => '프리미엄 가족';

  @override
  String get parentSubscriptionPremiumPrice => '\$5.99/월';

  @override
  String get parentSubscriptionPremiumBadge => '출시 가격';

  @override
  String get parentSubscriptionPremiumBody => '콘텐츠 라이브러리가 성장하는 동안의 전체 가족 이용권.';

  @override
  String get parentSubscriptionFeatureAllLevels => '현재 및 신규 레벨 모두';

  @override
  String get parentSubscriptionFeatureParentTips => '부모 추천';

  @override
  String get parentSubscriptionFeaturePurchaseRestore => '구매 복원 준비됨';

  @override
  String get parentSubscriptionPremiumCta => '월간 선택';

  @override
  String get parentSubscriptionAnnualTitle => '연간';

  @override
  String get parentSubscriptionAnnualPrice => '\$39.99/년';

  @override
  String get parentSubscriptionAnnualBadge => '최고 가치';

  @override
  String get parentSubscriptionAnnualBody => '초기 연간 가격으로 Premium Family 1년 이용.';

  @override
  String get parentSubscriptionFeatureAnnualValue => '월간 12회 결제보다 저렴';

  @override
  String get parentSubscriptionFeatureYearAccess => '12개월 가족 이용';

  @override
  String get parentSubscriptionFeatureUpdatesIncluded => '연간 이용 기간 중 신규 레벨 포함';

  @override
  String get parentSubscriptionAnnualCta => '연간 선택';

  @override
  String get parentSubscriptionFuturePriceNote =>
      '나중에 고품질 레벨이 많이 생기면: \$7.99/월 및 \$49.99/년.';

  @override
  String get parentSubscriptionBillingSoonSnack =>
      '결제는 아직 연결되지 않았습니다. 이 요금제는 StoreKit 및 Google Play Billing용으로 준비되어 있습니다.';

  @override
  String get parentResetProfile => '프로필 재설정';

  @override
  String get parentResetTitle => '프로필을 재설정하시겠습니까?';

  @override
  String get parentResetBody => '온보딩이 다시 열리고 로컬 진행 상황이 지워집니다.';

  @override
  String get challengeTitle => '두뇌 게임';

  @override
  String get challengeDayDone => '일 완료';

  @override
  String get challengeDailyMission => '일일미션';

  @override
  String get challengeDayDoneBody => '보상을 받았습니다. 자유롭게 반복하거나 재생할 수 있습니다.';

  @override
  String get challengeDailyBody => '연속 기록을 저장하고 상품을 받으려면 3단계를 완료하세요.';

  @override
  String get challengePrize => '상';

  @override
  String get challengeMissionProgress => '미션 진행';

  @override
  String countOfTotal(int count, int total) {
    return '$total의 $count';
  }

  @override
  String get challengeRepeatMission => '반복 임무';

  @override
  String challengeStepsTraining(int steps) {
    return '훈련을 위한 $steps 단계';
  }

  @override
  String challengeStepNumber(int step) {
    return '단계 $step';
  }

  @override
  String get challengeAgain => '다시';

  @override
  String minutesShort(int minutes) {
    return '$minutes분';
  }

  @override
  String get challengeBrainGymTitle => '브레인짐';

  @override
  String challengeBrainGymSubtitle(int count) {
    return '$count 영역, 순서에 상관없이 플레이';
  }

  @override
  String challengeAreaLevels(int done, int total) {
    return '$done/$total 레벨';
  }

  @override
  String challengeAreaCompleted(int done, int total) {
    return '$total의 $done 완료';
  }

  @override
  String get challengeStateCompleted => '완료';

  @override
  String get challengeStateNext => '다음';

  @override
  String get challengeStatePlay => '놀다';

  @override
  String challengeLevelNumber(int level) {
    return '레벨 $level';
  }

  @override
  String get challengeHideHint => '힌트 숨기기';

  @override
  String get challengeShowHint => '힌트 표시';

  @override
  String get challengeDailyTaskTitle => '일일 작업';

  @override
  String get challengePuzzleTaskTitle => '퍼즐';

  @override
  String get challengeDailyPath => '일일 경로';

  @override
  String get challengeFreePlay => '무료 플레이';

  @override
  String get challengeExcellent => '엄청난!';

  @override
  String get challengeFlyNext => '다음 비행';

  @override
  String get challengeAllDone => '모든 세트';

  @override
  String get challengePlayMore => '더 많이 플레이하세요';

  @override
  String get challengeMyCollection => '내 컬렉션';

  @override
  String get challengeDailyCompleteTitle => '일일미션 완료!';

  @override
  String get challengeDailyCompleteBody =>
      '모든 단계를 완료했습니다. 상품을 모아 자유롭게 플레이해보세요.';

  @override
  String get challengeRewardStars => '별';

  @override
  String get challengeRewardStreak => '줄';

  @override
  String get challengeRewardSteps => '단계';

  @override
  String get challengeWhatNextTitle => '다음은 무엇입니까?';

  @override
  String get challengeWhatNextBody => '영웅을 선택하세요: 논리, 기억력, 주의력, 수, 경로.';

  @override
  String challengeProgressStep(int current, int total) {
    return '$total의 $current 단계';
  }

  @override
  String get challengeChooseAnswer => '답변을 선택하세요';

  @override
  String challengeSelectedAnswer(Object answer) {
    return '답: $answer';
  }

  @override
  String get challengePickDifferentAnswer => '다른 답변을 선택하세요';

  @override
  String get challengeCorrectAnswer => '옳은!';

  @override
  String get challengeChecking => '확인 중';

  @override
  String get challengeCheck => '확인하다';

  @override
  String get challengeCorrectFeedbackTitle => '엄청난!';

  @override
  String get challengeRetryFeedbackTitle => '거의 다 왔어';

  @override
  String get challengeCorrectFeedbackText => '대답은 정확합니다. 계속하세요!';

  @override
  String get hintLogic => '규칙이 반복됩니다. 다음 반복의 시작을 찾아 행을 계속하십시오.';

  @override
  String get hintMemory => '먼저 어떤 사진이 열렸는지 기억해 보세요. 그런 다음 일치하는 쌍을 찾으십시오.';

  @override
  String get hintAttention => '색상, 모양, 크기 및 위치 등 세부 사항을 하나씩 비교하십시오.';

  @override
  String get hintMath => '소그룹으로 나누어서 숫자를 세어 보면 길을 잃지 않는 것이 더 쉽습니다.';

  @override
  String get hintSpace => '처음부터 끝까지 경로를 따라가고 다음 차례의 이름을 지정하세요.';

  @override
  String get collectionTitle => '내 컬렉션';

  @override
  String get collectionDayPrize => '일상';

  @override
  String get collectionCosmoPrizes => '우주 상품';

  @override
  String collectionUnlocked(int total, int unlocked) {
    return '$total의 $unlocked 열림';
  }

  @override
  String get collectionNewPrizeTitle => '뉴데이 경품';

  @override
  String get collectionNewPrizeBody => '우주비행사가 컬렉션에 추가되었습니다.';

  @override
  String collectionSnackUnlocked(Object title) {
    return '$title는 이미 컬렉션에 있습니다.';
  }

  @override
  String get collectionSnackLocked => '새로운 레벨 이후에 열립니다.';

  @override
  String get collectionNewBadge => '새로운';

  @override
  String collectionLockedLevel(int level) {
    return '$level 레벨.';
  }

  @override
  String get parentOverviewTitle => '상위 개요';

  @override
  String parentOverviewBody(String name) {
    return '$name 프로필, 진행 상황, 오늘의 계획, 집에서 연습할 때 필요한 팁을 알려드립니다.';
  }

  @override
  String parentStarsCount(int stars) {
    return '$stars 별';
  }

  @override
  String get parentMissionClosed => '임무 완료';

  @override
  String get parentMissionWaiting => '임무 대기 중';

  @override
  String get parentProgressTitle => '아동 발달';

  @override
  String get parentOverviewBadge => '개요';

  @override
  String get parentLevelsLabel => '레벨';

  @override
  String parentLevelsValue(int completed, int total) {
    return '$total의 $completed';
  }

  @override
  String get parentTodayLabel => '오늘';

  @override
  String parentTodayValue(int done, int total) {
    return '$total의 $done';
  }

  @override
  String get parentStarsLabel => '별';

  @override
  String get parentContentLabel => '콘텐츠';

  @override
  String parentContentValue(int done, int total) {
    return '$total의 $done';
  }

  @override
  String get parentTodayPlanTitle => '오늘의 계획';

  @override
  String get parentTodayPlanBody =>
      '압박감 없는 짧은 시리즈: 2~3회의 차분한 시도가 길고 피곤한 세션보다 낫습니다.';

  @override
  String parentPuzzleMeta(String skill, int minutes) {
    return '$skill • $minutes분';
  }

  @override
  String get parentAreasTitle => '개발분야';

  @override
  String get parentBalanceBadge => '균형';

  @override
  String get parentAreasBody =>
      '이것은 성인용 지도입니다. 아이들은 딱딱한 카테고리가 아닌 미션과 영웅을 보아야 합니다.';

  @override
  String get parentRecommendationDone =>
      '오늘의 미션은 완료되었습니다. 속도가 아닌 노력을 칭찬하기에 좋은 순간이다.';

  @override
  String parentRecommendationRemaining(int remaining) {
    return '오늘 진행 상황이 있습니다. $remaining 작업이 남았습니다.';
  }

  @override
  String get parentRecommendationStart => '오늘은 4~6분 정도의 짧은 미션 하나로 시작해 보세요.';

  @override
  String get parentRecommendationsTitle => '권장 사항';

  @override
  String get parentHomeBadge => '집에서';

  @override
  String get parentPaceLabel => '속도';

  @override
  String get parentWeekFocusLabel => '주간 집중';

  @override
  String parentFocusArea(String areaTitle, String areaSubtitle) {
    return '지금 가장 주목해야 할 부분은 바로 \"$areaTitle\": $areaSubtitle 입니다.';
  }

  @override
  String get parentDiscussLabel => '토론하는 방법';

  @override
  String get parentDiscussBody =>
      '작업이 끝나면 \"규칙을 어떻게 찾았나요?\"라고 질문하세요. 이것은 추측이 아닌 설명을 구축합니다.';

  @override
  String get parentFamilySecurityTitle => '가족과 안전';

  @override
  String get parentStorageLabel => '저장';

  @override
  String get parentStorageLocal => '기기에서';

  @override
  String get notificationDailyTitle => '새 미션이 기다려요';

  @override
  String notificationDailyBody(String name) {
    return '$name, 작은 퍼즐을 풀고 별 연속 기록을 이어 가요.';
  }

  @override
  String get notificationEveningTitle => '잠들기 전 한 단계 더?';

  @override
  String notificationEveningBody(String name) {
    return '$name에게 짧은 미션이 남았어요. 차분한 5분이면 충분해요.';
  }

  @override
  String get parentRemindersTitle => '알림';

  @override
  String get parentReminderStatusOn => '켜짐';

  @override
  String get parentReminderStatusOff => '꺼짐';

  @override
  String get parentRemindersBody => '부드러운 매일 알림이 부담 없이 미션으로 돌아오게 도와줘요.';

  @override
  String get parentReminderDailyLabel => '오늘의 미션';

  @override
  String get parentReminderDailyValue => '매일 18:30';

  @override
  String get parentReminderFollowUpLabel => '저녁 알림';

  @override
  String get parentReminderFollowUpValue => '미션이 남아 있으면 20:15';

  @override
  String get parentReminderToggleLabel => '돌아오기 알림';

  @override
  String get parentReminderToggleOn => 'Logic Loka가 짧은 미션으로 아이를 초대해요.';

  @override
  String get parentReminderToggleOff => '알림이 꺼져 있어요. 앱은 조용히 있을게요.';

  @override
  String get parentAccountTitle => '계정';

  @override
  String get parentAccountBody =>
      '로그인하면 진행 상황을 동기화하고 구독을 이용하며 다른 기기에서 구매를 복원할 수 있습니다.';

  @override
  String get parentAccountStatusGuest => '게스트';

  @override
  String get parentAccountAction => '로그인';

  @override
  String get accountTitle => '계정 로그인';

  @override
  String get accountHeroTitle => '가족 프로필을 가까이에 두세요';

  @override
  String get accountHeroBody =>
      'Google, Apple 또는 이메일로 클라우드 동기화, 구매, 안전한 보호자 접근을 준비할 수 있습니다.';

  @override
  String get accountStatusGuest => '게스트 모드';

  @override
  String get accountAppleButton => 'Apple로 계속';

  @override
  String get accountGoogleButton => 'Google로 계속';

  @override
  String get accountAuthLoading => '확인 중...';

  @override
  String get accountProviderGoogle => 'Google';

  @override
  String get accountProviderApple => 'Apple';

  @override
  String get accountProviderEmail => 'Email';

  @override
  String get accountSignedInTitle => '로그인됨';

  @override
  String get accountSignOut => '로그아웃';

  @override
  String get accountGoogleSuccessSnack => 'Google로 로그인했습니다.';

  @override
  String get accountGoogleCanceledSnack => 'Google 로그인이 취소되었습니다.';

  @override
  String get accountGoogleUnsupportedSnack =>
      '이 플랫폼에서는 아직 Google 로그인을 지원하지 않습니다.';

  @override
  String get accountGoogleConfigSnack =>
      'Google 로그인에는 이 앱의 OAuth 클라이언트 설정이 필요합니다.';

  @override
  String accountGoogleErrorSnack(Object error) {
    return 'Google 로그인에 실패했습니다: $error';
  }

  @override
  String get accountBenefitGoogleTitle => 'Google 로그인';

  @override
  String get accountBenefitGoogleBody =>
      'OAuth를 설정한 뒤 Google 계정으로 보호자 화면에 빠르게 들어갈 수 있습니다.';

  @override
  String get accountEmailTitle => '이메일로 로그인';

  @override
  String get accountSignInTab => '로그인';

  @override
  String get accountCreateTab => '만들기';

  @override
  String get accountEmailLabel => 'Email';

  @override
  String get accountPasswordLabel => '비밀번호';

  @override
  String get accountConfirmPasswordLabel => '비밀번호 확인';

  @override
  String get accountRememberDevice => '이 기기 기억하기';

  @override
  String get accountSubmitSignIn => '로그인';

  @override
  String get accountSubmitCreate => '계정 만들기';

  @override
  String get accountForgotPassword => '비밀번호를 잊으셨나요?';

  @override
  String get accountRestorePurchases => '구매 복원';

  @override
  String get accountPrivacyNote => '계정 서비스가 연결될 때까지 아이는 이 기기에서 계속 플레이할 수 있습니다.';

  @override
  String get accountBenefitSyncTitle => '진행 상황 동기화';

  @override
  String get accountBenefitSyncBody =>
      '로그인한 프로필은 나중에 별과 연습 기록을 기기 간에 옮길 수 있습니다.';

  @override
  String get accountBenefitAppleTitle => 'Apple 로그인 준비됨';

  @override
  String get accountBenefitAppleBody => 'Apple 기본 인증 정보를 연결할 버튼을 준비했습니다.';

  @override
  String get accountBenefitPurchaseTitle => '구매 및 구독';

  @override
  String get accountBenefitPurchaseBody => '재설치하거나 기기를 바꾼 뒤에도 접근 권한을 복원하세요.';

  @override
  String get accountEmailError => '올바른 이메일을 입력하세요';

  @override
  String get accountPasswordError => '6자 이상 입력하세요';

  @override
  String get accountPasswordMismatch => '비밀번호가 일치하지 않습니다';

  @override
  String get accountDemoSnack =>
      '이메일로 기기 내 로그인을 했습니다. 서버에서 비밀번호를 확인하려면 백엔드를 연결하세요.';

  @override
  String get accountAppleSnack => 'Apple 로그인 화면은 기본 핸들러에 연결할 준비가 되었습니다.';

  @override
  String get accountRestoreSnack => '구매 복원 화면은 StoreKit에 연결할 준비가 되었습니다.';

  @override
  String get accountResetDialogTitle => '비밀번호 재설정';

  @override
  String get accountResetDialogBody => '계정 백엔드가 연결되면 비밀번호 재설정 메일을 보냅니다.';

  @override
  String get accountResetDialogAction => '확인';

  @override
  String get puzzleListenPrompt => '문제 듣기';

  @override
  String get puzzleStopNarration => '읽어주기 멈추기';
}
