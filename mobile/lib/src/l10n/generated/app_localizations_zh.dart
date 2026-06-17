// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'LogicLike';

  @override
  String get homeTab => '家';

  @override
  String get challengeTab => '寻求';

  @override
  String get parentTab => '家长';

  @override
  String homeGreeting(Object childName) {
    return 'Hi,\n$childName';
  }

  @override
  String get dailyStreakTitle => '每日连胜';

  @override
  String get streakStart => '开始！';

  @override
  String dayCount(num count) {
    return '$count 天';
  }

  @override
  String dayCountShort(Object count) {
    return '$count d';
  }

  @override
  String get missionOpenButton => '打开';

  @override
  String get missionStartShortButton => '开始';

  @override
  String get missionStartButton => '开始任务';

  @override
  String get homeMissionCompletedTitle => '使命\n完成！';

  @override
  String get homeMissionHelpTitle => '帮助宇航员\n收集星星！';

  @override
  String get dailyChallengeTag => '每日任务';

  @override
  String get myProgressTitle => '我的进步';

  @override
  String levelLabel(Object level) {
    return '级别 $level';
  }

  @override
  String get myCollectionTitle => '我的收藏';

  @override
  String stickerCountLabel(num count) {
    return '$count 贴纸';
  }

  @override
  String homeParentHint(Object ageLabel, Object goalLabel, num minutes) {
    return '$ageLabel ? $goalLabel ? $minutes min this week';
  }

  @override
  String ageYears(num years) {
    return '$years年';
  }

  @override
  String get goalLogicLabel => '逻辑';

  @override
  String get goalLogicDescription => '模式、推理和寻找规则。';

  @override
  String get goalMathLabel => '数学';

  @override
  String get goalMathDescription => '数字、计数和仔细的解决方案。';

  @override
  String get goalAttentionLabel => '重点';

  @override
  String get goalAttentionDescription => '注意力、记忆力和比较细节。';

  @override
  String get onboardingTitle => '设置 LogicLike';

  @override
  String get onboardingSubtitle => '创建家庭档案，以便每日任务符合孩子的年龄和目标。';

  @override
  String get childNameLabel => '孩子的名字';

  @override
  String get childNameError => '输入姓名';

  @override
  String get ageSectionTitle => '年龄';

  @override
  String get learningGoalSectionTitle => '学习目标';

  @override
  String get learningGoalShortTitle => '目标';

  @override
  String get startButton => '开始';

  @override
  String get savingButton => '保存';

  @override
  String get onboardingHeroTitle => '首飞航班准备就绪';

  @override
  String get parentTag => '家长';

  @override
  String get parentDashboardTitle => '家庭中心';

  @override
  String familyProfileSummary(
      Object ageLabel, Object childName, Object goalLabel) {
    return '$childName ? $ageLabel ? $goalLabel';
  }

  @override
  String get currentStreakMetric => '条纹';

  @override
  String get sessionsMetric => '会议';

  @override
  String get minutesMetric => '分钟';

  @override
  String get childrenProfilesTitle => '儿童档案';

  @override
  String get addChildButton => '添加孩子';

  @override
  String childProgressChallengeCount(num count) {
    return '$count 任务';
  }

  @override
  String ageGoalSummary(Object ageLabel, Object goalLabel) {
    return '$ageLabel ? $goalLabel';
  }

  @override
  String get newChildTitle => '新孩子';

  @override
  String get cancelButton => '取消';

  @override
  String get addButton => '添加';

  @override
  String get analyticsTitle => '实践分析';

  @override
  String get streakMetricLabel => '条纹';

  @override
  String get bestStreakLabel => '最好的';

  @override
  String get last7DaysLabel => '过去 7 天';

  @override
  String get weeklyMinutesLabel => '分钟';

  @override
  String sessionsCountShort(Object count) {
    return '$count 会话。';
  }

  @override
  String minutesShort(Object count) {
    return '$count 分钟';
  }

  @override
  String minutesNarrow(Object count) {
    return '$count 米';
  }

  @override
  String get lastSkillLabel => '最后一个技能';

  @override
  String get lastSessionLabel => '最后一次会议';

  @override
  String get notAvailable => '还没有';

  @override
  String get weeklyRhythmTitle => '每周节奏';

  @override
  String get weeklyRhythmSubtitle => '每天练习几天和几分钟。';

  @override
  String get subscriptionTitle => '家庭订阅';

  @override
  String get currentPlanLabel => '目前计划';

  @override
  String get familySeatsLabel => '家庭座位';

  @override
  String get updatedLabel => '已更新';

  @override
  String get recommendedLabel => '最超值';

  @override
  String get currentPlanButton => '目前计划';

  @override
  String get chooseButton => '选择';

  @override
  String get resetProfilePanel => '重置本地配置文件并再次运行安装程序';

  @override
  String get resetButton => '重置';

  @override
  String get resetDialogTitle => '重置个人资料？';

  @override
  String get resetDialogBody => '新手入门将再次开放，本地进度将被清除。';

  @override
  String get resetConfirmButton => '重置';

  @override
  String get limitPaidMessage => '所有家庭座位均已使用。';

  @override
  String get limitStarterMessage => '家庭计划上提供了更多配置文件。';

  @override
  String get planStarterLabel => '起动机';

  @override
  String get planStarterPrice => '0 ₽';

  @override
  String get planStarterCapacity => '1 份儿童资料';

  @override
  String get planStarterDescription => '简短的每日循环和本地进度。';

  @override
  String get planMonthlyLabel => '家庭月刊';

  @override
  String get planMonthlyPrice => '399 ₽/月';

  @override
  String get planFamilyCapacity => '最多 3 个儿童档案';

  @override
  String get planMonthlyDescription => '完全访问权限、家庭档案和家长分析。';

  @override
  String get planAnnualLabel => '家庭年会';

  @override
  String get planAnnualPrice => '2990 ₽/年';

  @override
  String get planAnnualDescription => '相同的访问权限，年度计费更有价值。';

  @override
  String get planActiveStatus => '积极的';

  @override
  String get planInactiveStatus => '不活跃';

  @override
  String get missionCompletedTitle => '任务完成！';

  @override
  String childGoCta(Object childName) {
    return '$childName，我们走吧！';
  }

  @override
  String get chooseAnswerTitle => '选择一个答案';

  @override
  String get checkingButton => '保存';

  @override
  String get checkAnswerButton => '查看';

  @override
  String answerCorrect(Object explanation) {
    return 'Correct! $explanation';
  }

  @override
  String answerAlmost(Object hint) {
    return 'Almost. $hint';
  }

  @override
  String get challengeCompletedToday => '今天的任务完成了';

  @override
  String get weekdayMondayShort => '周一';

  @override
  String get weekdayTuesdayShort => '星期二';

  @override
  String get weekdayWednesdayShort => '周三';

  @override
  String get weekdayThursdayShort => '星期四';

  @override
  String get weekdayFridayShort => '周五';

  @override
  String get weekdaySaturdayShort => '星期六';

  @override
  String get weekdaySundayShort => '太阳';

  @override
  String get skillPatterns => '图案';

  @override
  String get skillCountingToFive => '数到五';

  @override
  String get skillComparison => '比较';

  @override
  String get skillSequences => '序列';

  @override
  String get skillAdditionToTen => '加到十';

  @override
  String get skillWorkingMemory => '工作记忆';

  @override
  String get skillLogicDeduction => '逻辑与演绎';

  @override
  String get skillMathThinking => '数学思维';

  @override
  String get skillDetailComparison => '细节对比';

  @override
  String get challengeShapePathTitle => '形状路径';

  @override
  String get challengeShapePathPrompt => '查看该行并找出接下来会发生什么。';

  @override
  String get challengeShapePathQuestion => '圆，方，圆，方。接下来会发生什么？';

  @override
  String get challengeShapePathHint => '这些形状交替出现：一个形状，然后是另一个形状，然后又是第一个形状。';

  @override
  String get challengeShapePathExplanation => '正方形之后又是一个圆形，因为该行每两个形状重复一次。';

  @override
  String get challengeToyCountTitle => '玩具计数';

  @override
  String get challengeToyCountPrompt => '数出物体的数量并选择正确的答案。';

  @override
  String get challengeToyCountQuestion => '架子上有 2 个积木和 1 个球。有多少个玩具？';

  @override
  String get challengeToyCountHint => '先数数块，然后添加球。';

  @override
  String get challengeToyCountExplanation => '2 个积木和 1 个球总共可以制作 3 个玩具。';

  @override
  String get challengeOddCardTitle => '奇数卡出局';

  @override
  String get challengeOddCardPrompt => '找出与其他项目不同的项目。';

  @override
  String get challengeOddCardQuestion => '苹果、梨、球、香蕉。哪一个不属于？';

  @override
  String get challengeOddCardHint => '三样可以吃，一件可以玩。';

  @override
  String get challengeOddCardExplanation => '球不属于：苹果、梨和香蕉是水果。';

  @override
  String get challengeLogicTrainTitle => '逻辑列车';

  @override
  String get challengeLogicTrainPrompt => '按规则放置火车车厢。';

  @override
  String get challengeLogicTrainQuestion => '红，蓝，蓝，红，蓝，蓝。接下来会发生什么？';

  @override
  String get challengeLogicTrainHint => '该规则以三组为一组重复：一个红色，两个蓝色。';

  @override
  String get challengeLogicTrainExplanation => '下一辆车是红色的：在两辆蓝色车之后，新的一组开始。';

  @override
  String get challengeStickerSumTitle => '贴纸相册';

  @override
  String get challengeStickerSumPrompt => '添加两小组对象。';

  @override
  String get challengeStickerSumQuestion => 'Nika 有 3 个贴纸，然后又得到了 2 个。她现在有多少个？';

  @override
  String get challengeStickerSumHint => '从三步开始，再数两步。';

  @override
  String get challengeStickerSumExplanation => '3 + 2 = 5，所以她有五张贴纸。';

  @override
  String get challengeMemoryPairsTitle => '记忆对';

  @override
  String get challengeMemoryPairsPrompt => '记住每个项目的匹配对。';

  @override
  String get challengeMemoryPairsQuestion => '钥匙配什么？';

  @override
  String get challengeMemoryPairsHint => '钥匙用于打开某物。';

  @override
  String get challengeMemoryPairsExplanation => '钥匙与锁相配：它们一起构成了一对有意义的组合。';

  @override
  String get challengeCodeGridTitle => '代码网格';

  @override
  String get challengeCodeGridPrompt => '解决规则并选择正确的单元格。';

  @override
  String get challengeCodeGridQuestion => '第一行是 2, 4, 6。第二行是 3, 5, ?。缺少什么号码？';

  @override
  String get challengeCodeGridHint => '第二行的数字也增加了 2。';

  @override
  String get challengeCodeGridExplanation => '3 和 5 之后是 7：每一步加 2。';

  @override
  String get challengeNumberBridgeTitle => '号码桥';

  @override
  String get challengeNumberBridgePrompt => '连接数字以构建正确的路线。';

  @override
  String get challengeNumberBridgeQuestion => '你有 4、2 和 1。你怎样才能得到 7？';

  @override
  String get challengeNumberBridgeHint => '尝试使用所有数字一次。';

  @override
  String get challengeNumberBridgeExplanation =>
      '4 + 2 + 1 = 7，因此所有三个数字一起构成目标。';

  @override
  String get challengeDetailCountTitle => '详细地图';

  @override
  String get challengeDetailCountPrompt => '记住几个细节并进行比较。';

  @override
  String get challengeDetailCountQuestion =>
      '有 3 个红色圆圈、2 个蓝色方块和 1 个绿色星星。 Which group has the most?';

  @override
  String get challengeDetailCountHint => '比较数量：3、2 和 1。';

  @override
  String get challengeDetailCountExplanation => '红色圆圈最多：有三个。';

  @override
  String get challengeMemoryRecallTitle => '记住卡片';

  @override
  String get challengeMemoryRecallPrompt => '查看该行并找到隐藏的卡片。';

  @override
  String get challengeMemoryRecallQuestion => '哪张卡被隐藏了？';

  @override
  String get challengeMemoryRecallHint => '从左到右记住物体并检查最后一个。';

  @override
  String get challengeMemoryRecallExplanation => '隐藏的卡片位于您必须记住的行中。';

  @override
  String get challengeSortingRuleTitle => '盒子规则';

  @override
  String get challengeSortingRulePrompt => '找到属于其他人的物体。';

  @override
  String get challengeSortingRuleQuestion => '什么遵循同样的规则？';

  @override
  String get challengeSortingRuleHint => '首先找出盒子里的物体有什么共同点。';

  @override
  String get challengeSortingRuleExplanation => '正确的对象符合框规则。';

  @override
  String get challengeMissingPieceTitle => '缺少一块';

  @override
  String get challengeMissingPiecePrompt => '选择使图片完整的部分。';

  @override
  String get challengeMissingPieceQuestion => '哪一块适合空的地方？';

  @override
  String get challengeMissingPieceHint => '将空形状与答案选项进行比较。';

  @override
  String get challengeMissingPieceExplanation => '这件作品完成了这幅画，没有多余的角。';

  @override
  String get challengeLogicDeductionTitle => '两条线索';

  @override
  String get challengeLogicDeductionPrompt => '使用这两条线索并删除错误的选择。';

  @override
  String get challengeLogicDeductionQuestion => '每条线索都匹配什么？';

  @override
  String get challengeLogicDeductionHint => '每条线索至少消除一个错误选择。';

  @override
  String get challengeLogicDeductionExplanation => '正确答案与两条线索相符。';

  @override
  String get choiceTriangle => '三角形';

  @override
  String get choiceCircle => '圆圈';

  @override
  String get choiceStar => '星星';

  @override
  String get choiceApple => '苹果';

  @override
  String get choiceBall => '球';

  @override
  String get choiceBanana => '香蕉';

  @override
  String get choiceBlue => '蓝色的';

  @override
  String get choiceRed => '红色的';

  @override
  String get choiceGreen => '绿色的';

  @override
  String get choiceKey => '钥匙';

  @override
  String get choiceLock => '锁';

  @override
  String get choiceShoe => '鞋';

  @override
  String get choiceCloud => '云';

  @override
  String get choiceBlueSquares => '蓝色方块';

  @override
  String get choiceRedCircles => '红色圆圈';

  @override
  String get choiceGreenStars => '绿色星星';

  @override
  String mapLessonTitle(Object lesson) {
    return '课程 $lesson';
  }

  @override
  String get mapLessonSubtitle => '逻辑、计数和专注在一门简短的课程中';

  @override
  String get mapStartButton => '开始';

  @override
  String get mapNodeStart => '开始';

  @override
  String get mapNodeShapes => '形状';

  @override
  String get mapNodePairs => '对';

  @override
  String get mapNodeCounting => '计数';

  @override
  String get mapNodePath => '小路';

  @override
  String get mapNodeRhythm => '韵律';

  @override
  String get mapNodeCompare => '比较';

  @override
  String get mapNodeFinal => '最终的';

  @override
  String get mapNodeCompleted => '完毕';

  @override
  String get mapNodeCurrent => '打开';

  @override
  String get mapNodeLocked => '锁定';

  @override
  String mapPreviewTitle(Object lesson) {
    return '课程 $lesson';
  }

  @override
  String mapPreviewSteps(num count) {
    return '$count 步数';
  }

  @override
  String mapPreviewReward(Object xp) {
    return '+$xp XP';
  }

  @override
  String mapPreviewHearts(num count) {
    return '$count 心';
  }

  @override
  String get mapPreviewBody => '包含混合谜题的简短课程：逻辑、计数、比较和焦点。';

  @override
  String get mapPreviewStart => '开始上课';

  @override
  String get mapPreviewClose => '之后';

  @override
  String lessonProgress(Object current, Object total) {
    return '$total 的步骤 $current';
  }

  @override
  String get lessonNextButton => '下一个';

  @override
  String get lessonFinishButton => '完成课程';

  @override
  String get lessonCompleteTitle => '课程完成！';

  @override
  String get lessonCompleteBody => '您解锁了地图上的下一步。';

  @override
  String get lessonRewardStars => '+1 星';

  @override
  String lessonRewardXp(Object xp) {
    return '+$xp XP';
  }

  @override
  String get lessonBackToMap => '回到家';

  @override
  String get courseCatalogTitle => '课程和谜题';

  @override
  String get courseLogicTitle => '逻辑';

  @override
  String get courseLogicSubtitle => '规则、奇数和推理';

  @override
  String get courseMathTitle => '数学';

  @override
  String get courseMathSubtitle => '计数、求和和比较';

  @override
  String get courseSpatialTitle => '形状';

  @override
  String get courseSpatialSubtitle => '形式、路径和空间';

  @override
  String get courseAttentionTitle => '重点';

  @override
  String get courseAttentionSubtitle => '细节、记忆和注意力';

  @override
  String get courseRebusTitle => '画谜';

  @override
  String get courseRebusSubtitle => '图片、文字和谜语';

  @override
  String get courseMixedTitle => '日常搭配';

  @override
  String get courseMixedSubtitle => '连续不同的谜题';

  @override
  String progressCardBody(Object level, Object stars) {
    return '级别 $level ？ $stars星星';
  }

  @override
  String collectionCardBody(num count) {
    return '$count 贴纸';
  }

  @override
  String get dailyMissionBody => '一组简短的逻辑、计数和焦点谜题。';

  @override
  String get openCourseButton => '打开';

  @override
  String courseProgress(Object completed, Object total) {
    return '$total 课程的 $completed 已完成';
  }

  @override
  String courseLessonTitle(Object lesson) {
    return '课程 $lesson';
  }

  @override
  String courseLessonMeta(num steps, Object xp) {
    return '$steps 步骤？ +$xp XP';
  }

  @override
  String get courseStartLessonButton => '开始';

  @override
  String get courseRepeatButton => '重复';

  @override
  String get showHintButton => '暗示';

  @override
  String get hideHintButton => '隐藏提示';

  @override
  String get lessonStickerUnlockedTitle => '新贴纸！';

  @override
  String get lessonStickerUnlockedBody => '课后你的收藏增多了。';

  @override
  String get lessonRewardCollection => '+1 贴纸';

  @override
  String get lessonRewardStreak => '连胜增长';

  @override
  String get challengeShadowMatchTitle => '影子比赛';

  @override
  String get challengeShadowMatchPrompt => '找到适合阴影的物体。';

  @override
  String get challengeShadowMatchQuestion => '影子有着高大的身躯和两只小翅膀。它是什么？';

  @override
  String get challengeShadowMatchHint => '观察物体的整体轮廓。';

  @override
  String get challengeShadowMatchExplanation => '火箭与影子相匹配：它有一个高大的身体和两个侧翼。';

  @override
  String get challengeBalanceScaleTitle => '天平秤';

  @override
  String get challengeBalanceScalePrompt => '比较两侧并选择缺少的部分。';

  @override
  String get challengeBalanceScaleQuestion => '左边有2个苹果。右侧有 1 个苹果和 ?。你应该添加什么？';

  @override
  String get challengeBalanceScaleHint => '双方需要相同数量的苹果。';

  @override
  String get challengeBalanceScaleExplanation => '再多一个苹果，右边就等于左边：2 和 2。';

  @override
  String get challengeShapeRotationTitle => '形状转弯';

  @override
  String get challengeShapeRotationPrompt => '想象一下旋转的形状。';

  @override
  String get challengeShapeRotationQuestion => '一个三角形向右转。哪张卡片显示相同的形状？';

  @override
  String get challengeShapeRotationHint => '转动会改变方向，但不会改变形状本身。';

  @override
  String get challengeShapeRotationExplanation => '这是同一个三角形：它转动了，但没有变成不同的形状。';

  @override
  String get choiceRocket => '火箭';

  @override
  String get choicePlanet => '行星';

  @override
  String get choiceSameTriangle => '同一个三角形';

  @override
  String get choiceSquare => '正方形';

  @override
  String get skillInsightsTitle => '技能和建议';

  @override
  String get strongestAreaLabel => '强区';

  @override
  String get practiceFocusLabel => '重点领域';

  @override
  String get recommendedPracticeLabel => '接下来练习';

  @override
  String get noSkillDataLabel => '还没有足够的数据';

  @override
  String get recommendationKeepGoing => '继续进行短期课程：经过几次课程后，建议会变得更加清晰。';

  @override
  String get recommendationPracticeFocus => '一周内针对该领域添加 1-2 门短期课程。';

  @override
  String get courseNextMetricLabel => '下一个';

  @override
  String get courseStarsMetricLabel => '星星';

  @override
  String get courseXpMetricLabel => 'XP';

  @override
  String get courseCompletedState => '完毕';

  @override
  String get courseOpenState => '打开';

  @override
  String get courseLockedState => '锁定';

  @override
  String get collectionScreenTitle => '贴纸合集';

  @override
  String get collectionScreenSubtitle => '通过完成课程并继续练习来收集奖励。';

  @override
  String collectionUnlockedCount(Object total, Object unlocked) {
    return '$total 的 $unlocked 已解锁';
  }

  @override
  String get collectionNextReward => '下一个奖励';

  @override
  String get collectionAllRewardsUnlocked => '所有奖励已解锁';

  @override
  String get collectionBackHome => '回到家';

  @override
  String collectionLockedHint(Object stars) {
    return '$stars 星星后解锁';
  }

  @override
  String get rewardAstronautTitle => '明星帮手';

  @override
  String get rewardAstronautBody => '为了完成第一个任务。';

  @override
  String get rewardRocketTitle => '勇敢的火箭';

  @override
  String get rewardRocketBody => '用于开设学习课程。';

  @override
  String get rewardPlanetTitle => '小小星球';

  @override
  String get rewardPlanetBody => '完成两节课。';

  @override
  String get rewardLionTitle => '逻辑狮子';

  @override
  String get rewardLionBody => '用于建立连续练习。';

  @override
  String get rewardPuzzleTitle => '拼图徽章';

  @override
  String get rewardPuzzleBody => '用于解决混合难题。';

  @override
  String get rewardChampionTitle => '太空冠军';

  @override
  String get rewardChampionBody => '用于每周稳定的练习。';

  @override
  String get accuracyMetricLabel => '准确性';

  @override
  String get hintsMetricLabel => '提示';

  @override
  String recommendationImproveAccuracy(Object skill) {
    return '本周慢慢练习$skill：准确性是提高的主要信号。';
  }

  @override
  String recommendationReduceHints(Object skill) {
    return '用更少的提示重复 $skill：打开帮助之前暂停。';
  }

  @override
  String recommendationRepeatAttempts(Object skill) {
    return '给 $skill 一次简短的重复训练，以减少错误尝试。';
  }

  @override
  String get homeRecommendedLessonTitle => '下一课';

  @override
  String get homeRecommendedLessonSubtitle => '关于学习路线的下一个简短课程。';

  @override
  String get homeRecommendedLessonButton => '继续';

  @override
  String get homeRecommendedLessonCompleted => '路线完成';

  @override
  String get lessonReviewTitle => '课程总结';

  @override
  String get lessonReviewPerfectBody => '重点突出：没有提示或错误。';

  @override
  String get lessonReviewSupportBody => '很好的完成。下次尝试在更少的帮助下迈出一步。';

  @override
  String get lessonReviewQuestionsLabel => '问题';

  @override
  String get lessonReviewHintsLabel => '提示';

  @override
  String get lessonReviewMistakesLabel => '错误';

  @override
  String get lessonNextRecommendedButton => '下一课';

  @override
  String get practiceHistoryTitle => '实践历史';

  @override
  String get practiceHistorySubtitle => '最近的课程包含准确性、提示和错误。';

  @override
  String get practiceHistoryEmpty => '尚未完成任何课程。';

  @override
  String practiceHistorySessionMeta(Object date, Object minutes) {
    return '$date - $minutes 分钟';
  }

  @override
  String get practiceHistoryMistakesLabel => '错误';

  @override
  String get lessonTryAgainButton => '再试一次';

  @override
  String get lessonHintTitle => '一步步思考';

  @override
  String get lessonRetryFeedback => '很好的尝试。阅读提示，然后再次选择。';

  @override
  String get languageSettingsTitle => '应用语言';

  @override
  String get languageSettingsSubtitle => '选择子屏幕和父屏幕的语言。';

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
  String get choicePear => '梨';

  @override
  String get challengeFruitPatternTitle => '水果排';

  @override
  String get challengeFruitPatternPrompt => '继续水果图案。';

  @override
  String get challengeFruitPatternQuestion => '苹果，香蕉，苹果，香蕉。接下来会发生什么？';

  @override
  String get challengeFruitPatternHint => '水果一一重复：苹果，然后是香蕉。';

  @override
  String get challengeFruitPatternExplanation => '香蕉之后又是苹果，因为模式重复。';

  @override
  String get challengeLockKeyTitle => '魔术对';

  @override
  String get challengeLockKeyPrompt => '选择配对的物体。';

  @override
  String get challengeLockKeyQuestion => '一把钥匙可以打开一些东西。它与什么搭配？';

  @override
  String get challengeLockKeyHint => '考虑一下钥匙的用途。';

  @override
  String get challengeLockKeyExplanation => '钥匙和锁一起工作，因此它们形成一对。';

  @override
  String get challengeSpaceSequenceTitle => '太空航线';

  @override
  String get challengeSpaceSequencePrompt => '找到下一个空间物体。';

  @override
  String get challengeSpaceSequenceQuestion => '火箭，行星，火箭，行星。接下来会发生什么？';

  @override
  String get challengeSpaceSequenceHint => '路线重复：火箭，然后行星。';

  @override
  String get challengeSpaceSequenceExplanation => '行星之后又出现了火箭。';

  @override
  String get challengeShapeStackTitle => '形状塔';

  @override
  String get challengeShapeStackPrompt => '继续塔规则。';

  @override
  String get challengeShapeStackQuestion => '方形，圆形，方形，圆形。下一个是什么形状？';

  @override
  String get challengeShapeStackHint => '塔在两种形状之间交替。';

  @override
  String get challengeShapeStackExplanation => '一个圆圈之后又是一个正方形。';

  @override
  String get challengePathMazeTitle => '探路者';

  @override
  String get challengePathMazePrompt => '从头到尾沿着路走。';

  @override
  String get challengePathMazeQuestion => '帮助英雄达到目标。应该走哪条路？';

  @override
  String get challengePathMazeHint => '从起点到终点追踪道路并在岔路口选择方向。';

  @override
  String get challengePathMazeExplanation => '正确的道路是沿着通往目标的开放道路。';

  @override
  String get lesson_001_title => '形状路径';

  @override
  String get lesson_002_title => '玩具计数';

  @override
  String get lesson_003_title => '奇数卡出局';

  @override
  String get lesson_004_title => '逻辑列车';

  @override
  String get lesson_005_title => '总和和行';

  @override
  String get lesson_006_title => '内存和代码';

  @override
  String get lesson_007_title => '号码桥';

  @override
  String get lesson_008_title => '详细地图';

  @override
  String get lesson_009_title => '阴影和平衡';

  @override
  String get lesson_010_title => '添加和比较';

  @override
  String get lesson_011_title => '转弯和路径';

  @override
  String get lesson_012_title => '记忆力和注意力';

  @override
  String get lesson_013_title => '水果图案';

  @override
  String get lesson_014_title => '数学架';

  @override
  String get lesson_015_title => '形状塔';

  @override
  String get lesson_016_title => '锁和细节';

  @override
  String get lesson_017_title => '代码和数字';

  @override
  String get lesson_018_title => '空间序列';

  @override
  String get lesson_019_title => '关注差异';

  @override
  String get lesson_020_title => '解桥';

  @override
  String get lesson_021_title => '连续规则';

  @override
  String get lesson_022_title => '空间中的形状';

  @override
  String get lesson_023_title => '记忆和计数';

  @override
  String get lesson_024_title => '最终混音';

  @override
  String get lesson_025_title => '细节侦探';

  @override
  String get lesson_026_title => '比例和数字';

  @override
  String get lesson_027_title => '奇数和对';

  @override
  String get lesson_028_title => '空间形状';

  @override
  String get lesson_029_title => '小心求和';

  @override
  String get lesson_030_title => '规则和代码';

  @override
  String get lesson_031_title => '阴影、形状、记忆';

  @override
  String get lesson_032_title => '数字和详细信息';

  @override
  String get lesson_033_title => '规则链';

  @override
  String get lesson_034_title => '空间转动';

  @override
  String get lesson_035_title => '大数路线';

  @override
  String get lesson_036_title => '观察家大结局';

  @override
  String get lesson_037_title => '回合与记忆';

  @override
  String get lesson_038_title => '计数冲刺';

  @override
  String get lesson_039_title => '规则和配对';

  @override
  String get lesson_040_title => '太空塔';

  @override
  String get lesson_041_title => '尺度和焦点';

  @override
  String get lesson_042_title => '代码列车';

  @override
  String get lesson_043_title => '阴影和锁';

  @override
  String get lesson_044_title => '数字和记忆';

  @override
  String get lesson_045_title => '长链';

  @override
  String get lesson_046_title => '空间路线';

  @override
  String get lesson_047_title => '总数和细节';

  @override
  String get lesson_048_title => '逻辑焦点';

  @override
  String get lesson_049_title => '形状近距离';

  @override
  String get lesson_050_title => '仔细算术';

  @override
  String get lesson_051_title => '图案大师';

  @override
  String get lesson_052_title => '太空中的阴影';

  @override
  String get lesson_053_title => '数字谜语';

  @override
  String get lesson_054_title => '观察者代码';

  @override
  String get lesson_055_title => '塔和钥匙';

  @override
  String get lesson_056_title => '细节和比例';

  @override
  String get lesson_057_title => '更严格的规则';

  @override
  String get lesson_058_title => '形状结局';

  @override
  String get lesson_059_title => '大数字任务';

  @override
  String get lesson_060_title => '逻辑超级混音';
}
