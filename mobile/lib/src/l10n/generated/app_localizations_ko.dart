// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'LogicLike';

  @override
  String get homeTab => '집';

  @override
  String get challengeTab => '탐구';

  @override
  String get parentTab => '조상';

  @override
  String homeGreeting(Object childName) {
    return '안녕하세요.\n$childName';
  }

  @override
  String get dailyStreakTitle => '일일 연속';

  @override
  String get streakStart => '시작!';

  @override
  String dayCount(num count) {
    return '$count일';
  }

  @override
  String dayCountShort(Object count) {
    return '${count}d';
  }

  @override
  String get missionOpenButton => '열려 있는';

  @override
  String get missionStartShortButton => '시작';

  @override
  String get missionStartButton => '퀘스트 시작';

  @override
  String get homeMissionCompletedTitle => '임무\n완료!';

  @override
  String get homeMissionHelpTitle => '우주비행사를 도와주세요\n별을 모아라!';

  @override
  String get dailyChallengeTag => '일일퀘스트';

  @override
  String get myProgressTitle => '내 진행 상황';

  @override
  String levelLabel(Object level) {
    return '레벨 $level';
  }

  @override
  String get myCollectionTitle => '내 컬렉션';

  @override
  String stickerCountLabel(num count) {
    return '$count 스티커';
  }

  @override
  String homeParentHint(Object ageLabel, Object goalLabel, num minutes) {
    return '$ageLabel ? $goalLabel ? 이번 주에는 $minutes분';
  }

  @override
  String ageYears(num years) {
    return '$years년';
  }

  @override
  String get goalLogicLabel => '논리';

  @override
  String get goalLogicDescription => '패턴, 추론, 규칙 ​​찾기.';

  @override
  String get goalMathLabel => '수학';

  @override
  String get goalMathDescription => '숫자, 계산 및 신중한 솔루션.';

  @override
  String get goalAttentionLabel => '집중하다';

  @override
  String get goalAttentionDescription => '주의력, 기억력, 세부사항 비교.';

  @override
  String get onboardingTitle => 'LogicLike 설정';

  @override
  String get onboardingSubtitle => '일일 퀘스트가 자녀의 연령 및 목표와 일치하도록 가족 프로필을 만드세요.';

  @override
  String get childNameLabel => '아이의 이름';

  @override
  String get childNameError => '이름을 입력하세요';

  @override
  String get ageSectionTitle => '나이';

  @override
  String get learningGoalSectionTitle => '학습목표';

  @override
  String get learningGoalShortTitle => '목표';

  @override
  String get startButton => '시작';

  @override
  String get savingButton => '절약';

  @override
  String get onboardingHeroTitle => '첫 비행 준비 완료';

  @override
  String get parentTag => '조상';

  @override
  String get parentDashboardTitle => '가족 허브';

  @override
  String familyProfileSummary(
      Object ageLabel, Object childName, Object goalLabel) {
    return '$childName ? $ageLabel ? $goalLabel';
  }

  @override
  String get currentStreakMetric => '줄';

  @override
  String get sessionsMetric => '세션';

  @override
  String get minutesMetric => '분';

  @override
  String get childrenProfilesTitle => '자녀 프로필';

  @override
  String get addChildButton => '자녀 추가';

  @override
  String childProgressChallengeCount(num count) {
    return '$count 퀘스트';
  }

  @override
  String ageGoalSummary(Object ageLabel, Object goalLabel) {
    return '$ageLabel ? $goalLabel';
  }

  @override
  String get newChildTitle => '새로운 아이';

  @override
  String get cancelButton => '취소';

  @override
  String get addButton => '추가하다';

  @override
  String get analyticsTitle => '분석 실습';

  @override
  String get streakMetricLabel => '줄';

  @override
  String get bestStreakLabel => '최상의';

  @override
  String get last7DaysLabel => '지난 7일';

  @override
  String get weeklyMinutesLabel => '분';

  @override
  String sessionsCountShort(Object count) {
    return '$count 세션.';
  }

  @override
  String minutesShort(Object count) {
    return '$count분';
  }

  @override
  String minutesNarrow(Object count) {
    return '${count}m';
  }

  @override
  String get lastSkillLabel => '마지막 스킬';

  @override
  String get lastSessionLabel => '마지막 세션';

  @override
  String get notAvailable => '아직 아님';

  @override
  String get weeklyRhythmTitle => '주간리듬';

  @override
  String get weeklyRhythmSubtitle => '매일 요일과 분을 연습하세요.';

  @override
  String get subscriptionTitle => '가족 구독';

  @override
  String get currentPlanLabel => '현재 계획';

  @override
  String get familySeatsLabel => '패밀리석';

  @override
  String get updatedLabel => '업데이트됨';

  @override
  String get recommendedLabel => '최고의 가치';

  @override
  String get currentPlanButton => '현재 계획';

  @override
  String get chooseButton => '선택하다';

  @override
  String get resetProfilePanel => '로컬 프로필을 재설정하고 설정을 다시 실행하세요.';

  @override
  String get resetButton => '다시 놓기';

  @override
  String get resetDialogTitle => '프로필을 재설정하시겠습니까?';

  @override
  String get resetDialogBody => '온보딩이 다시 열리고 로컬 진행 상황이 지워집니다.';

  @override
  String get resetConfirmButton => '다시 놓기';

  @override
  String get limitPaidMessage => '패밀리석은 이미 모두 사용되었습니다.';

  @override
  String get limitStarterMessage => '가족 요금제에서 더 많은 프로필을 사용할 수 있습니다.';

  @override
  String get planStarterLabel => '기동기';

  @override
  String get planStarterPrice => '0 ₽';

  @override
  String get planStarterCapacity => '자녀 프로필 1개';

  @override
  String get planStarterDescription => '짧은 일일 루프 및 로컬 진행.';

  @override
  String get planMonthlyLabel => '가족월간';

  @override
  String get planMonthlyPrice => '399 ₽/월';

  @override
  String get planFamilyCapacity => '최대 3개의 자녀 프로필';

  @override
  String get planMonthlyDescription => '전체 액세스, 가족 프로필 및 부모 분석.';

  @override
  String get planAnnualLabel => '가족 연간';

  @override
  String get planAnnualPrice => '2990 ₽/년';

  @override
  String get planAnnualDescription => '동일한 액세스 권한으로 연간 청구에 있어 더 나은 가치를 제공합니다.';

  @override
  String get planActiveStatus => '활동적인';

  @override
  String get planInactiveStatus => '비활성';

  @override
  String get missionCompletedTitle => '임무 완료!';

  @override
  String childGoCta(Object childName) {
    return '$childName, 가자!';
  }

  @override
  String get chooseAnswerTitle => '답변을 선택하세요';

  @override
  String get checkingButton => '절약';

  @override
  String get checkAnswerButton => '확인하다';

  @override
  String answerCorrect(Object explanation) {
    return '옳은! $explanation';
  }

  @override
  String answerAlmost(Object hint) {
    return '거의. $hint';
  }

  @override
  String get challengeCompletedToday => '오늘의 퀘스트가 완료되었습니다';

  @override
  String get weekdayMondayShort => '월';

  @override
  String get weekdayTuesdayShort => '화요일';

  @override
  String get weekdayWednesdayShort => '수요일';

  @override
  String get weekdayThursdayShort => '목';

  @override
  String get weekdayFridayShort => '금';

  @override
  String get weekdaySaturdayShort => '앉았다';

  @override
  String get weekdaySundayShort => '해';

  @override
  String get skillPatterns => '패턴';

  @override
  String get skillCountingToFive => '5까지 센다';

  @override
  String get skillComparison => '비교';

  @override
  String get skillSequences => '시퀀스';

  @override
  String get skillAdditionToTen => '10에 추가';

  @override
  String get skillWorkingMemory => '작업기억';

  @override
  String get skillLogicDeduction => '논리와 추론';

  @override
  String get skillMathThinking => '수학적인 사고';

  @override
  String get skillDetailComparison => '세부 비교';

  @override
  String get challengeShapePathTitle => '모양 경로';

  @override
  String get challengeShapePathPrompt => '행을 보고 다음에 무엇이 올지 찾아보세요.';

  @override
  String get challengeShapePathQuestion => '원형, 정사각형, 원형, 정사각형. 다음은 무엇입니까?';

  @override
  String get challengeShapePathHint =>
      '모양이 번갈아 나타납니다. 한 모양, 다른 모양, 다시 첫 번째 모양입니다.';

  @override
  String get challengeShapePathExplanation =>
      '행이 두 모양마다 반복되기 때문에 사각형 뒤에 다시 원이 옵니다.';

  @override
  String get challengeToyCountTitle => '장난감 개수';

  @override
  String get challengeToyCountPrompt => '물건의 수를 세고 정확한 답을 선택하세요.';

  @override
  String get challengeToyCountQuestion =>
      '선반 위에 블록 2개와 공 1개가 있습니다. 장난감이 몇 개 있나요?';

  @override
  String get challengeToyCountHint => '먼저 블록 수를 세고 공을 추가하세요.';

  @override
  String get challengeToyCountExplanation => '블록 2개와 공 1개로 총 3개의 장난감이 됩니다.';

  @override
  String get challengeOddCardTitle => '홀수 카드 아웃';

  @override
  String get challengeOddCardPrompt => '남들과 다른 아이템을 찾아보세요.';

  @override
  String get challengeOddCardQuestion => '사과, 배, 공, 바나나. 어느 것이 속하지 않습니까?';

  @override
  String get challengeOddCardHint => '세 가지 아이템을 먹을 수 있고, 하나는 플레이용입니다.';

  @override
  String get challengeOddCardExplanation => '공은 속하지 않습니다. 사과, 배, 바나나는 과일입니다.';

  @override
  String get challengeLogicTrainTitle => '논리 열차';

  @override
  String get challengeLogicTrainPrompt => '규칙에 따라 기차 차량을 배치하십시오.';

  @override
  String get challengeLogicTrainQuestion =>
      '빨간색, 파란색, 파란색, 빨간색, 파란색, 파란색. 다음은 무엇입니까?';

  @override
  String get challengeLogicTrainHint => '규칙은 세 그룹(빨간색 하나, 파란색 두 개)으로 반복됩니다.';

  @override
  String get challengeLogicTrainExplanation =>
      '다음 차량은 빨간색입니다. 파란색 차량 두 대 이후에는 새 그룹이 시작됩니다.';

  @override
  String get challengeStickerSumTitle => '스티커 앨범';

  @override
  String get challengeStickerSumPrompt => '두 개의 작은 개체 그룹을 추가합니다.';

  @override
  String get challengeStickerSumQuestion =>
      'Nika는 스티커 3개를 가지고 있었고 그다음에 2개를 더 받았습니다. 그녀는 지금 몇 개를 갖고 있나요?';

  @override
  String get challengeStickerSumHint => '3단계부터 시작하여 2단계를 더 세어보세요.';

  @override
  String get challengeStickerSumExplanation => '3 + 2 = 5이므로 스티커가 5개 있습니다.';

  @override
  String get challengeMemoryPairsTitle => '메모리 쌍';

  @override
  String get challengeMemoryPairsPrompt => '각 항목에 대해 일치하는 쌍을 기억하십시오.';

  @override
  String get challengeMemoryPairsQuestion => '열쇠는 어떻게 되나요?';

  @override
  String get challengeMemoryPairsHint => '열쇠는 무언가를 여는 데 사용됩니다.';

  @override
  String get challengeMemoryPairsExplanation =>
      '열쇠는 자물쇠와 함께 사용됩니다. 함께 의미 있는 쌍을 이룹니다.';

  @override
  String get challengeCodeGridTitle => '코드 그리드';

  @override
  String get challengeCodeGridPrompt => '규칙을 풀고 올바른 셀을 선택하세요.';

  @override
  String get challengeCodeGridQuestion =>
      '첫 번째 행은 2, 4, 6입니다. 두 번째 행은 3, 5, ?입니다. 어떤 숫자가 빠졌나요?';

  @override
  String get challengeCodeGridHint => '두 번째 행의 숫자도 2씩 증가합니다.';

  @override
  String get challengeCodeGridExplanation =>
      '3과 5 뒤에는 7이 옵니다. 각 단계마다 2가 추가됩니다.';

  @override
  String get challengeNumberBridgeTitle => '넘버 브리지';

  @override
  String get challengeNumberBridgePrompt => '숫자를 연결하여 올바른 경로를 만드세요.';

  @override
  String get challengeNumberBridgeQuestion => '4, 2, 1이 있습니다. 어떻게 7을 만들 수 있나요?';

  @override
  String get challengeNumberBridgeHint => '모든 숫자를 한 번씩 사용해 보세요.';

  @override
  String get challengeNumberBridgeExplanation =>
      '4 + 2 + 1 = 7이므로 세 숫자가 모두 함께 목표가 됩니다.';

  @override
  String get challengeDetailCountTitle => '상세지도';

  @override
  String get challengeDetailCountPrompt => '몇 가지 세부 사항을 염두에 두고 비교해 보세요.';

  @override
  String get challengeDetailCountQuestion =>
      '빨간색 원 3개, 파란색 사각형 2개, 녹색 별 1개가 있습니다. 어느 그룹이 가장 많은가요?';

  @override
  String get challengeDetailCountHint => '3, 2, 1의 양을 비교합니다.';

  @override
  String get challengeDetailCountExplanation =>
      '빨간색 원이 가장 많습니다. 그 중 세 개가 있습니다.';

  @override
  String get challengeMemoryRecallTitle => '카드를 기억하세요';

  @override
  String get challengeMemoryRecallPrompt => '행을 보고 숨겨진 카드를 찾으세요.';

  @override
  String get challengeMemoryRecallQuestion => '어떤 카드가 숨겨져 있나요?';

  @override
  String get challengeMemoryRecallHint => '왼쪽부터 오른쪽으로 개체를 기억하고 마지막 개체를 확인하세요.';

  @override
  String get challengeMemoryRecallExplanation => '기억해야 할 줄에 숨겨진 카드가 있었습니다.';

  @override
  String get challengeSortingRuleTitle => '상자 법칙';

  @override
  String get challengeSortingRulePrompt => '다른 사람에게 속한 물건을 찾으십시오.';

  @override
  String get challengeSortingRuleQuestion => '동일한 규칙을 따르는 것은 무엇입니까?';

  @override
  String get challengeSortingRuleHint => '먼저 상자 안에 있는 물건들의 공통점을 찾아보세요.';

  @override
  String get challengeSortingRuleExplanation => '올바른 개체는 상자 규칙과 일치합니다.';

  @override
  String get challengeMissingPieceTitle => '누락된 조각';

  @override
  String get challengeMissingPiecePrompt => '그림을 완성하는 부분을 선택하세요.';

  @override
  String get challengeMissingPieceQuestion => '빈 곳에 들어갈 조각은 무엇인가요?';

  @override
  String get challengeMissingPieceHint => '빈 모양을 답안과 비교하세요.';

  @override
  String get challengeMissingPieceExplanation => '이 작품은 불필요한 모서리 없이 그림을 완성합니다.';

  @override
  String get challengeLogicDeductionTitle => '단서 2개';

  @override
  String get challengeLogicDeductionPrompt => '두 가지 단서를 모두 사용하고 잘못된 선택을 제거하세요.';

  @override
  String get challengeLogicDeductionQuestion => '모든 단서와 일치하는 것은 무엇입니까?';

  @override
  String get challengeLogicDeductionHint => '각 단서는 적어도 하나의 잘못된 선택을 제거합니다.';

  @override
  String get challengeLogicDeductionExplanation => '정답은 두 단서 모두와 일치합니다.';

  @override
  String get choiceTriangle => '삼각형';

  @override
  String get choiceCircle => '원';

  @override
  String get choiceStar => '별';

  @override
  String get choiceApple => '사과';

  @override
  String get choiceBall => '공';

  @override
  String get choiceBanana => '바나나';

  @override
  String get choiceBlue => '파란색';

  @override
  String get choiceRed => '빨간색';

  @override
  String get choiceGreen => '녹색';

  @override
  String get choiceKey => '열쇠';

  @override
  String get choiceLock => '잠그다';

  @override
  String get choiceShoe => '구두';

  @override
  String get choiceCloud => '구름';

  @override
  String get choiceBlueSquares => '파란색 사각형';

  @override
  String get choiceRedCircles => '빨간색 원';

  @override
  String get choiceGreenStars => '녹색 별';

  @override
  String mapLessonTitle(Object lesson) {
    return '$lesson 수업';
  }

  @override
  String get mapLessonSubtitle => '하나의 짧은 수업으로 논리, 계산, 집중하기';

  @override
  String get mapStartButton => '시작';

  @override
  String get mapNodeStart => '시작';

  @override
  String get mapNodeShapes => '모양';

  @override
  String get mapNodePairs => '한 쌍';

  @override
  String get mapNodeCounting => '계산';

  @override
  String get mapNodePath => '길';

  @override
  String get mapNodeRhythm => '율';

  @override
  String get mapNodeCompare => '비교하다';

  @override
  String get mapNodeFinal => '결정적인';

  @override
  String get mapNodeCompleted => '완료';

  @override
  String get mapNodeCurrent => '열려 있는';

  @override
  String get mapNodeLocked => '잠긴';

  @override
  String mapPreviewTitle(Object lesson) {
    return '$lesson 수업';
  }

  @override
  String mapPreviewSteps(num count) {
    return '$count걸음';
  }

  @override
  String mapPreviewReward(Object xp) {
    return '+$xp XP';
  }

  @override
  String mapPreviewHearts(num count) {
    return '$count 하트';
  }

  @override
  String get mapPreviewBody => '논리, 계산, 비교, 집중 등 다양한 퍼즐이 포함된 짧은 수업입니다.';

  @override
  String get mapPreviewStart => '수업 시작';

  @override
  String get mapPreviewClose => '나중에';

  @override
  String lessonProgress(Object current, Object total) {
    return '$total의 $current 단계';
  }

  @override
  String get lessonNextButton => '다음';

  @override
  String get lessonFinishButton => '수업 종료';

  @override
  String get lessonCompleteTitle => '강의가 완료되었습니다!';

  @override
  String get lessonCompleteBody => '지도에서 다음 단계의 잠금을 해제했습니다.';

  @override
  String get lessonRewardStars => '별점 +1개';

  @override
  String lessonRewardXp(Object xp) {
    return '+$xp XP';
  }

  @override
  String get lessonBackToMap => '집으로 돌아가기';

  @override
  String get courseCatalogTitle => '코스와 퍼즐';

  @override
  String get courseLogicTitle => '논리';

  @override
  String get courseLogicSubtitle => '규칙, 이상한 것, 그리고 추론';

  @override
  String get courseMathTitle => '수학';

  @override
  String get courseMathSubtitle => '계산, 합계 및 비교';

  @override
  String get courseSpatialTitle => '모양';

  @override
  String get courseSpatialSubtitle => '형태, 경로 및 공간';

  @override
  String get courseAttentionTitle => '집중하다';

  @override
  String get courseAttentionSubtitle => '세부사항, 기억력, 주의력';

  @override
  String get courseRebusTitle => '수수께끼';

  @override
  String get courseRebusSubtitle => '그림, 단어, 수수께끼';

  @override
  String get courseMixedTitle => '일일 믹스';

  @override
  String get courseMixedSubtitle => '연속으로 다른 퍼즐';

  @override
  String progressCardBody(Object level, Object stars) {
    return '레벨 $level ? $stars 스타';
  }

  @override
  String collectionCardBody(num count) {
    return '$count 스티커';
  }

  @override
  String get dailyMissionBody => '짧은 논리, 계산 및 집중 퍼즐 세트입니다.';

  @override
  String get openCourseButton => '열려 있는';

  @override
  String courseProgress(Object completed, Object total) {
    return '$total 수업 중 $completed 수업 완료';
  }

  @override
  String courseLessonTitle(Object lesson) {
    return '$lesson 수업';
  }

  @override
  String courseLessonMeta(num steps, Object xp) {
    return '$steps 단계? +$xp XP';
  }

  @override
  String get courseStartLessonButton => '시작';

  @override
  String get courseRepeatButton => '반복하다';

  @override
  String get showHintButton => '힌트';

  @override
  String get hideHintButton => '힌트 숨기기';

  @override
  String get lessonStickerUnlockedTitle => '새로운 스티커!';

  @override
  String get lessonStickerUnlockedBody => '수업이 끝난 후 컬렉션이 늘어났습니다.';

  @override
  String get lessonRewardCollection => '+1 스티커';

  @override
  String get lessonRewardStreak => '연속 성장';

  @override
  String get challengeShadowMatchTitle => '섀도우 매치';

  @override
  String get challengeShadowMatchPrompt => '그림자에 맞는 물체를 찾아보세요.';

  @override
  String get challengeShadowMatchQuestion =>
      '그림자는 키가 큰 몸체와 두 개의 작은 날개를 가지고 있습니다. 그것은 무엇입니까?';

  @override
  String get challengeShadowMatchHint => '물체의 전체적인 윤곽을 살펴보세요.';

  @override
  String get challengeShadowMatchExplanation =>
      '로켓은 그림자와 일치합니다. 로켓에는 키가 큰 몸체와 두 개의 측면 날개가 있습니다.';

  @override
  String get challengeBalanceScaleTitle => '균형 규모';

  @override
  String get challengeBalanceScalePrompt => '측면을 비교하고 빠진 것을 선택하십시오.';

  @override
  String get challengeBalanceScaleQuestion =>
      '왼쪽에는 사과 2개가 있습니다. 오른쪽에는 사과 1개와 ?가 있습니다. 무엇을 추가해야 합니까?';

  @override
  String get challengeBalanceScaleHint => '양쪽에 같은 수의 사과가 필요합니다.';

  @override
  String get challengeBalanceScaleExplanation =>
      '사과를 하나 더 추가하면 오른쪽이 왼쪽과 동일해집니다(2와 2).';

  @override
  String get challengeShapeRotationTitle => '모양 회전';

  @override
  String get challengeShapeRotationPrompt => '모양이 돌아간다고 상상해 보세요.';

  @override
  String get challengeShapeRotationQuestion =>
      '삼각형이 오른쪽으로 회전합니다. 같은 모양을 나타내는 카드는 무엇입니까?';

  @override
  String get challengeShapeRotationHint => '회전하면 방향이 바뀌지만 모양 자체는 바뀌지 않습니다.';

  @override
  String get challengeShapeRotationExplanation =>
      '그것은 같은 삼각형입니다. 회전했지만 다른 모양이 되지는 않았습니다.';

  @override
  String get choiceRocket => '로켓';

  @override
  String get choicePlanet => '행성';

  @override
  String get choiceSameTriangle => '같은 삼각형';

  @override
  String get choiceSquare => '정사각형';

  @override
  String get skillInsightsTitle => '기술 및 권장 사항';

  @override
  String get strongestAreaLabel => '강한 지역';

  @override
  String get practiceFocusLabel => '초점 영역';

  @override
  String get recommendedPracticeLabel => '다음 연습';

  @override
  String get noSkillDataLabel => '아직 데이터가 충분하지 않습니다.';

  @override
  String get recommendationKeepGoing =>
      '짧은 강의를 계속하세요. 몇 번의 세션이 지나면 권장사항이 더 명확해집니다.';

  @override
  String get recommendationPracticeFocus => '주중에 이 영역에 대한 짧은 수업을 1~2회 추가하세요.';

  @override
  String get courseNextMetricLabel => '다음';

  @override
  String get courseStarsMetricLabel => '별';

  @override
  String get courseXpMetricLabel => 'XP';

  @override
  String get courseCompletedState => '완료';

  @override
  String get courseOpenState => '열려 있는';

  @override
  String get courseLockedState => '잠긴';

  @override
  String get collectionScreenTitle => '스티커 컬렉션';

  @override
  String get collectionScreenSubtitle => '수업을 완료하고 계속 연습하여 보상을 받으세요.';

  @override
  String collectionUnlockedCount(Object total, Object unlocked) {
    return '$total 중 $unlocked가 잠금 해제되었습니다.';
  }

  @override
  String get collectionNextReward => '다음 보상';

  @override
  String get collectionAllRewardsUnlocked => '모든 보상 잠금 해제';

  @override
  String get collectionBackHome => '집으로 돌아가기';

  @override
  String collectionLockedHint(Object stars) {
    return '$stars 별 이후 잠금 해제';
  }

  @override
  String get rewardAstronautTitle => '별 도우미';

  @override
  String get rewardAstronautBody => '첫 번째 임무를 완료하기 위해.';

  @override
  String get rewardRocketTitle => '용감한 로켓';

  @override
  String get rewardRocketBody => '학습 과정을 개설합니다.';

  @override
  String get rewardPlanetTitle => '작은 행성';

  @override
  String get rewardPlanetBody => '두 개의 수업을 마치기 위해.';

  @override
  String get rewardLionTitle => '논리 사자';

  @override
  String get rewardLionBody => '연속 연습을 구축하기 위한 것입니다.';

  @override
  String get rewardPuzzleTitle => '퍼즐 배지';

  @override
  String get rewardPuzzleBody => '혼합 퍼즐을 풀기 위한 것입니다.';

  @override
  String get rewardChampionTitle => '우주 챔피언';

  @override
  String get rewardChampionBody => '꾸준한 주간 연습을 위해.';

  @override
  String get accuracyMetricLabel => '정확성';

  @override
  String get hintsMetricLabel => '힌트';

  @override
  String recommendationImproveAccuracy(Object skill) {
    return '이번 주에는 $skill를 천천히 연습하세요. 정확도가 향상되어야 하는 주요 신호입니다.';
  }

  @override
  String recommendationReduceHints(Object skill) {
    return '더 적은 수의 힌트로 $skill를 반복합니다. 도움말을 열기 전에 일시 중지하세요.';
  }

  @override
  String recommendationRepeatAttempts(Object skill) {
    return '잘못된 시도를 줄이려면 $skill에 한 번의 짧은 반복 세션을 제공하십시오.';
  }

  @override
  String get homeRecommendedLessonTitle => '다음 수업';

  @override
  String get homeRecommendedLessonSubtitle => '학습 경로에 대한 다음 짧은 강의입니다.';

  @override
  String get homeRecommendedLessonButton => '계속하다';

  @override
  String get homeRecommendedLessonCompleted => '경로 완료';

  @override
  String get lessonReviewTitle => '수업 요약';

  @override
  String get lessonReviewPerfectBody => '뛰어난 집중력: 힌트나 실수가 없습니다.';

  @override
  String get lessonReviewSupportBody => '좋은 마무리. 다음번에는 도움을 덜 받고 한 단계씩 시도해 보세요.';

  @override
  String get lessonReviewQuestionsLabel => '질문';

  @override
  String get lessonReviewHintsLabel => '힌트';

  @override
  String get lessonReviewMistakesLabel => '실수';

  @override
  String get lessonNextRecommendedButton => '다음 수업';

  @override
  String get practiceHistoryTitle => '실습 이력';

  @override
  String get practiceHistorySubtitle => '정확성, 힌트, 실수가 포함된 최근 수업입니다.';

  @override
  String get practiceHistoryEmpty => '아직 완료된 강의가 없습니다.';

  @override
  String practiceHistorySessionMeta(Object date, Object minutes) {
    return '$date - $minutes분';
  }

  @override
  String get practiceHistoryMistakesLabel => '실수';

  @override
  String get lessonTryAgainButton => '다시 시도하세요';

  @override
  String get lessonHintTitle => '단계별로 생각해보세요';

  @override
  String get lessonRetryFeedback => '좋은 시도입니다. 힌트를 읽고 다시 선택하세요.';

  @override
  String get languageSettingsTitle => '앱 언어';

  @override
  String get languageSettingsSubtitle => '자녀 및 부모 화면의 언어를 선택하세요.';

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
  String get choicePear => '배';

  @override
  String get challengeFruitPatternTitle => '과일 행';

  @override
  String get challengeFruitPatternPrompt => '과일 패턴을 계속하십시오.';

  @override
  String get challengeFruitPatternQuestion => '사과, 바나나, 사과, 바나나. 다음은 무엇입니까?';

  @override
  String get challengeFruitPatternHint => '과일은 사과, 바나나 순으로 하나씩 반복됩니다.';

  @override
  String get challengeFruitPatternExplanation =>
      '패턴이 반복되기 때문에 바나나 다음에 사과가 다시 옵니다.';

  @override
  String get challengeLockKeyTitle => '매직페어';

  @override
  String get challengeLockKeyPrompt => '쌍을 이루는 개체를 선택하세요.';

  @override
  String get challengeLockKeyQuestion => '열쇠는 무언가를 엽니다. 그것은 무엇과 함께 가는가?';

  @override
  String get challengeLockKeyHint => '열쇠가 어떤 용도로 사용되는지 생각해 보세요.';

  @override
  String get challengeLockKeyExplanation => '열쇠와 자물쇠는 함께 작동하므로 쌍을 이룹니다.';

  @override
  String get challengeSpaceSequenceTitle => '우주 루트';

  @override
  String get challengeSpaceSequencePrompt => '다음 우주 물체를 찾으세요.';

  @override
  String get challengeSpaceSequenceQuestion => '로켓, 행성, 로켓, 행성. 다음은 무엇입니까?';

  @override
  String get challengeSpaceSequenceHint => '경로는 로켓, 행성 순으로 반복됩니다.';

  @override
  String get challengeSpaceSequenceExplanation => '행성 후에 로켓이 다시 온다.';

  @override
  String get challengeShapeStackTitle => '셰이프 타워';

  @override
  String get challengeShapeStackPrompt => '타워 규칙을 계속하십시오.';

  @override
  String get challengeShapeStackQuestion => '정사각형, 원형, 정사각형, 원형. 다음은 어떤 모양인가요?';

  @override
  String get challengeShapeStackHint => '타워는 두 가지 모양이 번갈아 나타납니다.';

  @override
  String get challengeShapeStackExplanation => '원 뒤에는 다시 사각형이 옵니다.';

  @override
  String get challengePathMazeTitle => '경로 찾기';

  @override
  String get challengePathMazePrompt => '처음부터 끝까지 길을 따라가세요.';

  @override
  String get challengePathMazeQuestion =>
      '영웅이 목표를 달성하도록 도와주세요. 어느 방향으로 가야 하나요?';

  @override
  String get challengePathMazeHint => '처음부터 끝까지 도로를 추적하고 분기점에서 방향을 선택합니다.';

  @override
  String get challengePathMazeExplanation => '올바른 도로는 목표까지 열린 경로를 따릅니다.';

  @override
  String get lesson_001_title => '모양 경로';

  @override
  String get lesson_002_title => '장난감 계산';

  @override
  String get lesson_003_title => '홀수 카드 아웃';

  @override
  String get lesson_004_title => '논리 열차';

  @override
  String get lesson_005_title => '합계 및 행';

  @override
  String get lesson_006_title => '메모리와 코드';

  @override
  String get lesson_007_title => '넘버 브리지';

  @override
  String get lesson_008_title => '상세지도';

  @override
  String get lesson_009_title => '그림자와 균형';

  @override
  String get lesson_010_title => '추가 및 비교';

  @override
  String get lesson_011_title => '회전 및 경로';

  @override
  String get lesson_012_title => '기억력과 집중력';

  @override
  String get lesson_013_title => '과일 패턴';

  @override
  String get lesson_014_title => '수학 선반';

  @override
  String get lesson_015_title => '셰이프 타워';

  @override
  String get lesson_016_title => '자물쇠 및 세부정보';

  @override
  String get lesson_017_title => '코드 및 숫자';

  @override
  String get lesson_018_title => '공간순서';

  @override
  String get lesson_019_title => '차이점에 집중';

  @override
  String get lesson_020_title => '솔루션 브릿지';

  @override
  String get lesson_021_title => '연속된 규칙';

  @override
  String get lesson_022_title => '공간 속의 모양';

  @override
  String get lesson_023_title => '기억과 계산';

  @override
  String get lesson_024_title => '최종 믹스';

  @override
  String get lesson_025_title => '디테일 탐정';

  @override
  String get lesson_026_title => '저울과 숫자';

  @override
  String get lesson_027_title => '홀수와 쌍';

  @override
  String get lesson_028_title => '공간 모양';

  @override
  String get lesson_029_title => '신중한 금액';

  @override
  String get lesson_030_title => '규칙 및 코드';

  @override
  String get lesson_031_title => '그림자, 모양, 기억';

  @override
  String get lesson_032_title => '숫자 및 세부정보';

  @override
  String get lesson_033_title => '규칙 체인';

  @override
  String get lesson_034_title => '공간 회전';

  @override
  String get lesson_035_title => '빅 넘버 루트';

  @override
  String get lesson_036_title => '관찰자 피날레';

  @override
  String get lesson_037_title => '회전과 기억';

  @override
  String get lesson_038_title => '스프린트 계산';

  @override
  String get lesson_039_title => '규칙과 쌍';

  @override
  String get lesson_040_title => '스페이스 타워';

  @override
  String get lesson_041_title => '규모와 초점';

  @override
  String get lesson_042_title => '코드트레인';

  @override
  String get lesson_043_title => '그림자와 자물쇠';

  @override
  String get lesson_044_title => '숫자와 기억';

  @override
  String get lesson_045_title => '긴 사슬';

  @override
  String get lesson_046_title => '공간 경로';

  @override
  String get lesson_047_title => '합계 및 세부정보';

  @override
  String get lesson_048_title => '논리 초점';

  @override
  String get lesson_049_title => '가까이서 본 모양';

  @override
  String get lesson_050_title => '신중한 산술';

  @override
  String get lesson_051_title => '패턴 마스터';

  @override
  String get lesson_052_title => '우주의 그림자';

  @override
  String get lesson_053_title => '숫자 수수께끼';

  @override
  String get lesson_054_title => '관찰자 코드';

  @override
  String get lesson_055_title => '타워와 열쇠';

  @override
  String get lesson_056_title => '세부 사항 및 규모';

  @override
  String get lesson_057_title => '더 엄격한 규칙';

  @override
  String get lesson_058_title => '모양 피날레';

  @override
  String get lesson_059_title => '큰 숫자 작업';

  @override
  String get lesson_060_title => '논리 슈퍼믹스';
}
