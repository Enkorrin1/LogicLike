// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'LogicLike';

  @override
  String get homeTab => '家';

  @override
  String get challengeTab => 'クエスト';

  @override
  String get parentTab => '親';

  @override
  String homeGreeting(Object childName) {
    return 'こんにちは。\n$childName';
  }

  @override
  String get dailyStreakTitle => '毎日の連続記録';

  @override
  String get streakStart => '始める！';

  @override
  String dayCount(num count) {
    return '$count 日';
  }

  @override
  String dayCountShort(Object count) {
    return '${count}d';
  }

  @override
  String get missionOpenButton => '開ける';

  @override
  String get missionStartShortButton => '始める';

  @override
  String get missionStartButton => 'クエストを開始する';

  @override
  String get homeMissionCompletedTitle => '使命\n完成しました！';

  @override
  String get homeMissionHelpTitle => '宇宙飛行士を助けて\nスターを集めよう！';

  @override
  String get dailyChallengeTag => 'デイリークエスト';

  @override
  String get myProgressTitle => '私の進歩';

  @override
  String levelLabel(Object level) {
    return 'レベル$level';
  }

  @override
  String get myCollectionTitle => '私のコレクション';

  @override
  String stickerCountLabel(num count) {
    return '$count ステッカー';
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
  String get goalLogicLabel => '論理';

  @override
  String get goalLogicDescription => 'パターン、推論、ルールの発見。';

  @override
  String get goalMathLabel => '数学';

  @override
  String get goalMathDescription => '数字、数え方、そして慎重な解決策。';

  @override
  String get goalAttentionLabel => '集中';

  @override
  String get goalAttentionDescription => '注意、記憶、詳細の比較。';

  @override
  String get onboardingTitle => 'LogicLikeをセットアップする';

  @override
  String get onboardingSubtitle => '毎日のクエストが子供の年齢と目標に一致するように、家族のプロフィールを作成します。';

  @override
  String get childNameLabel => 'お子様の名前';

  @override
  String get childNameError => '名前を入力してください';

  @override
  String get ageSectionTitle => '年';

  @override
  String get learningGoalSectionTitle => '学習目標';

  @override
  String get learningGoalShortTitle => 'ゴール';

  @override
  String get startButton => '始める';

  @override
  String get savingButton => '保存';

  @override
  String get onboardingHeroTitle => '初飛行準備完了';

  @override
  String get parentTag => '親';

  @override
  String get parentDashboardTitle => '家族の拠点';

  @override
  String familyProfileSummary(
      Object ageLabel, Object childName, Object goalLabel) {
    return '$childName ? $ageLabel ? $goalLabel';
  }

  @override
  String get currentStreakMetric => '縞模様';

  @override
  String get sessionsMetric => 'セッション';

  @override
  String get minutesMetric => '分';

  @override
  String get childrenProfilesTitle => '子供のプロフィール';

  @override
  String get addChildButton => '子の追加';

  @override
  String childProgressChallengeCount(num count) {
    return '$count クエスト';
  }

  @override
  String ageGoalSummary(Object ageLabel, Object goalLabel) {
    return '$ageLabel ? $goalLabel';
  }

  @override
  String get newChildTitle => '新しい子';

  @override
  String get cancelButton => 'キャンセル';

  @override
  String get addButton => '追加';

  @override
  String get analyticsTitle => '分析を実践する';

  @override
  String get streakMetricLabel => 'ストリーク';

  @override
  String get bestStreakLabel => '最高';

  @override
  String get last7DaysLabel => '過去 7 日間';

  @override
  String get weeklyMinutesLabel => '分';

  @override
  String sessionsCountShort(Object count) {
    return '$count セッション。';
  }

  @override
  String minutesShort(Object count) {
    return '$count分';
  }

  @override
  String minutesNarrow(Object count) {
    return '${count}m';
  }

  @override
  String get lastSkillLabel => '最後のスキル';

  @override
  String get lastSessionLabel => '最後のセッション';

  @override
  String get notAvailable => 'まだ';

  @override
  String get weeklyRhythmTitle => '週ごとのリズム';

  @override
  String get weeklyRhythmSubtitle => '毎日何日も何分も練習します。';

  @override
  String get subscriptionTitle => 'ファミリーサブスクリプション';

  @override
  String get currentPlanLabel => '現在の計画';

  @override
  String get familySeatsLabel => 'ファミリーシート';

  @override
  String get updatedLabel => '更新されました';

  @override
  String get recommendedLabel => '最高の価値';

  @override
  String get currentPlanButton => '現在の計画';

  @override
  String get chooseButton => '選ぶ';

  @override
  String get resetProfilePanel => 'ローカル プロファイルをリセットし、セットアップを再度実行します';

  @override
  String get resetButton => 'リセット';

  @override
  String get resetDialogTitle => 'プロファイルをリセットしますか?';

  @override
  String get resetDialogBody => 'オンボーディングが再び開き、ローカルの進行状況がクリアされます。';

  @override
  String get resetConfirmButton => 'リセット';

  @override
  String get limitPaidMessage => 'ファミリーシートは全て使用済みです。';

  @override
  String get limitStarterMessage => 'ファミリー プランでは、より多くのプロファイルを利用できます。';

  @override
  String get planStarterLabel => 'スターター';

  @override
  String get planStarterPrice => '0 ₽';

  @override
  String get planStarterCapacity => '1 人の子供のプロフィール';

  @override
  String get planStarterDescription => '短い毎日のループとローカルの進行状況。';

  @override
  String get planMonthlyLabel => 'ファミリーマンスリー';

  @override
  String get planMonthlyPrice => '399 ₽/月';

  @override
  String get planFamilyCapacity => '最大 3 つの子プロファイル';

  @override
  String get planMonthlyDescription => 'フルアクセス、家族プロフィール、親の分析。';

  @override
  String get planAnnualLabel => 'ファミリーアニュアル';

  @override
  String get planAnnualPrice => '2990 ₽/年';

  @override
  String get planAnnualDescription => '同じアクセス権で、年間請求額がよりお得になります。';

  @override
  String get planActiveStatus => 'アクティブ';

  @override
  String get planInactiveStatus => 'アクティブではありません';

  @override
  String get missionCompletedTitle => 'ミッション完了！';

  @override
  String childGoCta(Object childName) {
    return '$childName、行こう！';
  }

  @override
  String get chooseAnswerTitle => '答えを選択してください';

  @override
  String get checkingButton => '保存';

  @override
  String get checkAnswerButton => 'チェック';

  @override
  String answerCorrect(Object explanation) {
    return 'Correct! $explanation';
  }

  @override
  String answerAlmost(Object hint) {
    return 'ほとんど。 $hint';
  }

  @override
  String get challengeCompletedToday => '今日のクエストは完了です';

  @override
  String get weekdayMondayShort => '月';

  @override
  String get weekdayTuesdayShort => '火';

  @override
  String get weekdayWednesdayShort => '水';

  @override
  String get weekdayThursdayShort => '木';

  @override
  String get weekdayFridayShort => '金';

  @override
  String get weekdaySaturdayShort => '土';

  @override
  String get weekdaySundayShort => '太陽';

  @override
  String get skillPatterns => 'パターン';

  @override
  String get skillCountingToFive => '5つ数えます';

  @override
  String get skillComparison => '比較';

  @override
  String get skillSequences => 'シーケンス';

  @override
  String get skillAdditionToTen => '10に追加';

  @override
  String get skillWorkingMemory => 'ワーキングメモリ';

  @override
  String get skillLogicDeduction => '論理と推論';

  @override
  String get skillMathThinking => '数学的思考';

  @override
  String get skillDetailComparison => '詳細比較';

  @override
  String get challengeShapePathTitle => 'シェイプパス';

  @override
  String get challengeShapePathPrompt => '行を見て、次に来るものを見つけてください。';

  @override
  String get challengeShapePathQuestion => '丸、四角、丸、四角。次に何が来るでしょうか？';

  @override
  String get challengeShapePathHint =>
      '形状が交互に表示されます。一方の形状、次にもう一方の形状、そして再び最初の形状になります。';

  @override
  String get challengeShapePathExplanation =>
      '正方形の後には再び円が来ます。これは、行が 2 つの図形ごとに繰り返されるためです。';

  @override
  String get challengeToyCountTitle => 'おもちゃの数';

  @override
  String get challengeToyCountPrompt => 'オブジェクトを数えて、正確な答えを選択してください。';

  @override
  String get challengeToyCountQuestion => '棚にはブロックが2つとボールが1つあります。おもちゃは何個ありますか？';

  @override
  String get challengeToyCountHint => '最初にブロックを数えてから、ボールを追加します。';

  @override
  String get challengeToyCountExplanation => '2つのブロックと1つのボールで合計3つのおもちゃができます。';

  @override
  String get challengeOddCardTitle => '奇数カードアウト';

  @override
  String get challengeOddCardPrompt => '他とは違うアイテムを見つけてください。';

  @override
  String get challengeOddCardQuestion => 'リンゴ、ナシ、ボール、バナナ。属さないのはどれですか?';

  @override
  String get challengeOddCardHint => '食べられるのは3品、遊ぶのは1品。';

  @override
  String get challengeOddCardExplanation => 'ボールは属しません。リンゴ、ナシ、バナナは果物です。';

  @override
  String get challengeLogicTrainTitle => 'ロジックトレイン';

  @override
  String get challengeLogicTrainPrompt => '電車の車両をルールに従って配置します。';

  @override
  String get challengeLogicTrainQuestion => '赤、青、青、赤、青、青。次に何が来るでしょうか？';

  @override
  String get challengeLogicTrainHint => 'このルールは、赤 1 つと青 2 つの 3 つのグループで繰り返されます。';

  @override
  String get challengeLogicTrainExplanation =>
      '次の車は赤です。2 台の青い車の後、新しいグループが始まります。';

  @override
  String get challengeStickerSumTitle => 'ステッカーアルバム';

  @override
  String get challengeStickerSumPrompt => 'オブジェクトの 2 つの小さなグループを追加します。';

  @override
  String get challengeStickerSumQuestion =>
      'ニカはステッカーを 3 枚持っていましたが、さらに 2 枚もらいました。彼女は今何個持っていますか？';

  @override
  String get challengeStickerSumHint => '3 歩から始めて、さらに 2 歩数えます。';

  @override
  String get challengeStickerSumExplanation => '3 + 2 = 5 なので、ステッカーは 5 枚あります。';

  @override
  String get challengeMemoryPairsTitle => 'メモリペア';

  @override
  String get challengeMemoryPairsPrompt => '各アイテムの一致するペアを覚えておいてください。';

  @override
  String get challengeMemoryPairsQuestion => '鍵には何がつきますか?';

  @override
  String get challengeMemoryPairsHint => '鍵は何かを開けるために使用されます。';

  @override
  String get challengeMemoryPairsExplanation =>
      'キーはロックと一緒に使用されます。これらは一緒に意味のあるペアを形成します。';

  @override
  String get challengeCodeGridTitle => 'コードグリッド';

  @override
  String get challengeCodeGridPrompt => 'ルールを解決して、正しいセルを選択してください。';

  @override
  String get challengeCodeGridQuestion =>
      '最初の行は 2、4、6 です。2 番目の行は 3、5、? です。不足している番号は何ですか?';

  @override
  String get challengeCodeGridHint => '2 行目の数字も 2 ずつ増えます。';

  @override
  String get challengeCodeGridExplanation =>
      '3 と 5 の後に 7 が来ます。各ステップで 2 が加算されます。';

  @override
  String get challengeNumberBridgeTitle => 'ナンバーブリッジ';

  @override
  String get challengeNumberBridgePrompt => '数字をつなげて正しいルートを構築します。';

  @override
  String get challengeNumberBridgeQuestion => '4、2、1 があります。どうすれば 7 になりますか?';

  @override
  String get challengeNumberBridgeHint => '一度すべての数字を使ってみてください。';

  @override
  String get challengeNumberBridgeExplanation =>
      '4 + 2 + 1 = 7 なので、3 つの数字をすべて合わせるとターゲットになります。';

  @override
  String get challengeDetailCountTitle => '詳細図';

  @override
  String get challengeDetailCountPrompt => 'いくつかの詳細を念頭に置いて比較してください。';

  @override
  String get challengeDetailCountQuestion =>
      '赤い丸が 3 つ、青い四角が 2 つ、緑色の星が 1 つあります。どのグループが一番多いですか?';

  @override
  String get challengeDetailCountHint => '3、2、1 の量を比較します。';

  @override
  String get challengeDetailCountExplanation => '赤い丸が最も多く、3 つあります。';

  @override
  String get challengeMemoryRecallTitle => 'カードを覚えておいてください';

  @override
  String get challengeMemoryRecallPrompt => '列を見て、隠されたカードを見つけてください。';

  @override
  String get challengeMemoryRecallQuestion => 'どのカードが隠されているのでしょうか？';

  @override
  String get challengeMemoryRecallHint => 'オブジェクトを左から右に覚えて、最後のオブジェクトを確認してください。';

  @override
  String get challengeMemoryRecallExplanation =>
      '隠されたカードは覚えておかなければならない列にありました。';

  @override
  String get challengeSortingRuleTitle => 'ボックスルール';

  @override
  String get challengeSortingRulePrompt => '他のオブジェクトと一致するオブジェクトを見つけます。';

  @override
  String get challengeSortingRuleQuestion => '同じルールに従うものは何でしょうか?';

  @override
  String get challengeSortingRuleHint => 'まず、箱の中の物に共通するものを見つけます。';

  @override
  String get challengeSortingRuleExplanation => '正しいオブジェクトはボックス ルールに一致します。';

  @override
  String get challengeMissingPieceTitle => '欠けている部分';

  @override
  String get challengeMissingPiecePrompt => '絵を完成させる部分を選択してください。';

  @override
  String get challengeMissingPieceQuestion => '空いている場所にぴったりの作品はどれですか?';

  @override
  String get challengeMissingPieceHint => '空の図形と回答の選択肢を比較します。';

  @override
  String get challengeMissingPieceExplanation => 'この作品は余分な角のない絵を完成させます。';

  @override
  String get challengeLogicDeductionTitle => '2つの手がかり';

  @override
  String get challengeLogicDeductionPrompt => '両方の手がかりを利用して、間違った選択肢を取り除いてください。';

  @override
  String get challengeLogicDeductionQuestion => 'すべての手がかりに一致するものは何ですか?';

  @override
  String get challengeLogicDeductionHint => '各手がかりは、少なくとも 1 つの間違った選択肢を取り除きます。';

  @override
  String get challengeLogicDeductionExplanation => '正しい答えは両方の手がかりと一致します。';

  @override
  String get choiceTriangle => '三角形';

  @override
  String get choiceCircle => '丸';

  @override
  String get choiceStar => '星';

  @override
  String get choiceApple => 'りんご';

  @override
  String get choiceBall => 'ボール';

  @override
  String get choiceBanana => 'バナナ';

  @override
  String get choiceBlue => '青';

  @override
  String get choiceRed => '赤';

  @override
  String get choiceGreen => '緑';

  @override
  String get choiceKey => '鍵';

  @override
  String get choiceLock => 'ロック';

  @override
  String get choiceShoe => '靴';

  @override
  String get choiceCloud => '雲';

  @override
  String get choiceBlueSquares => '青い四角';

  @override
  String get choiceRedCircles => '赤い丸';

  @override
  String get choiceGreenStars => '緑の星';

  @override
  String mapLessonTitle(Object lesson) {
    return 'レッスン$lesson';
  }

  @override
  String get mapLessonSubtitle => '論理、計算、集中力を 1 回の短いレッスンで習得';

  @override
  String get mapStartButton => '始める';

  @override
  String get mapNodeStart => '始める';

  @override
  String get mapNodeShapes => '形状';

  @override
  String get mapNodePairs => 'ペア';

  @override
  String get mapNodeCounting => '数える';

  @override
  String get mapNodePath => 'パス';

  @override
  String get mapNodeRhythm => 'リズム';

  @override
  String get mapNodeCompare => '比較する';

  @override
  String get mapNodeFinal => 'ファイナル';

  @override
  String get mapNodeCompleted => '終わり';

  @override
  String get mapNodeCurrent => '開ける';

  @override
  String get mapNodeLocked => 'ロックされた';

  @override
  String mapPreviewTitle(Object lesson) {
    return 'レッスン$lesson';
  }

  @override
  String mapPreviewSteps(num count) {
    return '$count 歩';
  }

  @override
  String mapPreviewReward(Object xp) {
    return '+$xp XP';
  }

  @override
  String mapPreviewHearts(num count) {
    return '$count ハート';
  }

  @override
  String get mapPreviewBody => 'ロジック、数え方、比較、焦点などのパズルを組み合わせた短いレッスン。';

  @override
  String get mapPreviewStart => 'レッスンを開始する';

  @override
  String get mapPreviewClose => '後で';

  @override
  String lessonProgress(Object current, Object total) {
    return '$total のステップ $current';
  }

  @override
  String get lessonNextButton => '次';

  @override
  String get lessonFinishButton => 'レッスンを終了する';

  @override
  String get lessonCompleteTitle => 'レッスン完了！';

  @override
  String get lessonCompleteBody => 'マップ上の次のステップのロックが解除されました。';

  @override
  String get lessonRewardStars => '+1 つ星';

  @override
  String lessonRewardXp(Object xp) {
    return '+$xp XP';
  }

  @override
  String get lessonBackToMap => '家に帰ります';

  @override
  String get courseCatalogTitle => 'コースとパズル';

  @override
  String get courseLogicTitle => '論理';

  @override
  String get courseLogicSubtitle => 'ルール、奇数アウト、推理';

  @override
  String get courseMathTitle => '数学';

  @override
  String get courseMathSubtitle => '数えること、合計すること、比較すること';

  @override
  String get courseSpatialTitle => '形状';

  @override
  String get courseSpatialSubtitle => '形、道、空間';

  @override
  String get courseAttentionTitle => '集中';

  @override
  String get courseAttentionSubtitle => '詳細、記憶、注意';

  @override
  String get courseRebusTitle => '判じ絵';

  @override
  String get courseRebusSubtitle => '絵と言葉となぞなぞ';

  @override
  String get courseMixedTitle => 'デイリーミックス';

  @override
  String get courseMixedSubtitle => 'さまざまなパズルが連続して登場';

  @override
  String progressCardBody(Object level, Object stars) {
    return 'レベル $level ? $stars スター';
  }

  @override
  String collectionCardBody(num count) {
    return '$count ステッカー';
  }

  @override
  String get dailyMissionBody => 'ロジック、カウンティング、フォーカスのパズルの短いセット。';

  @override
  String get openCourseButton => '開ける';

  @override
  String courseProgress(Object completed, Object total) {
    return '$completed/$total レッスンが完了しました';
  }

  @override
  String courseLessonTitle(Object lesson) {
    return 'レッスン$lesson';
  }

  @override
  String courseLessonMeta(num steps, Object xp) {
    return '$steps歩数? +$xp XP';
  }

  @override
  String get courseStartLessonButton => '始める';

  @override
  String get courseRepeatButton => '繰り返す';

  @override
  String get showHintButton => 'ヒント';

  @override
  String get hideHintButton => 'ヒントを隠す';

  @override
  String get lessonStickerUnlockedTitle => '新しいステッカー！';

  @override
  String get lessonStickerUnlockedBody => 'レッスン後、あなたのコレクションは増えました。';

  @override
  String get lessonRewardCollection => '+1 ステッカー';

  @override
  String get lessonRewardStreak => 'スジが伸びる';

  @override
  String get challengeShadowMatchTitle => 'シャドウマッチ';

  @override
  String get challengeShadowMatchPrompt => '影に合うオブジェクトを見つけます。';

  @override
  String get challengeShadowMatchQuestion => '影には高い胴体と 2 つの小さな翼があります。それは何ですか？';

  @override
  String get challengeShadowMatchHint => 'オブジェクトの全体の輪郭を見てください。';

  @override
  String get challengeShadowMatchExplanation =>
      'ロケットはその影と一致しており、高い胴体と 2 つの側面翼を備えています。';

  @override
  String get challengeBalanceScaleTitle => '天秤秤';

  @override
  String get challengeBalanceScalePrompt => '側面を比較して、足りないものを選択してください。';

  @override
  String get challengeBalanceScaleQuestion =>
      '左側にはリンゴが2個あります。右側にはリンゴが1個と?があります。何を追加する必要がありますか?';

  @override
  String get challengeBalanceScaleHint => '両側に同じ数のリンゴが必要です。';

  @override
  String get challengeBalanceScaleExplanation =>
      'リンゴがもう 1 つあると、右側は左側と等しくなります: 2 と 2。';

  @override
  String get challengeShapeRotationTitle => 'シェイプターン';

  @override
  String get challengeShapeRotationPrompt => '形が回転することを想像してください。';

  @override
  String get challengeShapeRotationQuestion => '三角形は右に曲がります。同じ形をしているカードはどれですか?';

  @override
  String get challengeShapeRotationHint => '回転すると方向は変わりますが、形状自体は変わりません。';

  @override
  String get challengeShapeRotationExplanation =>
      'それは同じ三角形です。回転しましたが、別の形にはなりませんでした。';

  @override
  String get choiceRocket => 'ロケット';

  @override
  String get choicePlanet => '惑星';

  @override
  String get choiceSameTriangle => '同じ三角形';

  @override
  String get choiceSquare => '四角';

  @override
  String get skillInsightsTitle => 'スキルと推奨事項';

  @override
  String get strongestAreaLabel => '得意分野';

  @override
  String get practiceFocusLabel => '重点領域';

  @override
  String get recommendedPracticeLabel => '次は練習してください';

  @override
  String get noSkillDataLabel => 'まだ十分なデータがありません';

  @override
  String get recommendationKeepGoing =>
      '短いレッスンを続けてください。数回のセッションの後、推奨事項がより明確になります。';

  @override
  String get recommendationPracticeFocus => 'この分野の短いレッスンを週に 1 ～ 2 回追加します。';

  @override
  String get courseNextMetricLabel => '次';

  @override
  String get courseStarsMetricLabel => 'スター';

  @override
  String get courseXpMetricLabel => 'XP';

  @override
  String get courseCompletedState => '終わり';

  @override
  String get courseOpenState => '開ける';

  @override
  String get courseLockedState => 'ロックされた';

  @override
  String get collectionScreenTitle => 'ステッカーコレクション';

  @override
  String get collectionScreenSubtitle => 'レッスンを完了し、練習を続けることで報酬を獲得できます。';

  @override
  String collectionUnlockedCount(Object total, Object unlocked) {
    return '$total の $unlocked がロック解除されました';
  }

  @override
  String get collectionNextReward => '次の報酬';

  @override
  String get collectionAllRewardsUnlocked => 'すべての報酬がロック解除されました';

  @override
  String get collectionBackHome => '家に帰ります';

  @override
  String collectionLockedHint(Object stars) {
    return '$stars がスターを獲得するとロックが解除されます';
  }

  @override
  String get rewardAstronautTitle => 'スターヘルパー';

  @override
  String get rewardAstronautBody => '最初のミッションを完了するため。';

  @override
  String get rewardRocketTitle => 'ブレイブロケット';

  @override
  String get rewardRocketBody => '学習コースの開設のため。';

  @override
  String get rewardPlanetTitle => '小さな惑星';

  @override
  String get rewardPlanetBody => '2 つのレッスンを完了するため。';

  @override
  String get rewardLionTitle => 'ロジックライオン';

  @override
  String get rewardLionBody => '練習の連続記録を築くために。';

  @override
  String get rewardPuzzleTitle => 'パズルバッジ';

  @override
  String get rewardPuzzleBody => '混合パズルを解くため。';

  @override
  String get rewardChampionTitle => '宇宙チャンピオン';

  @override
  String get rewardChampionBody => '毎週の着実な練習に。';

  @override
  String get accuracyMetricLabel => '正確さ';

  @override
  String get hintsMetricLabel => 'ヒント';

  @override
  String recommendationImproveAccuracy(Object skill) {
    return '今週はゆっくりと $skill を練習してください。精度が向上するための主なシグナルです。';
  }

  @override
  String recommendationReduceHints(Object skill) {
    return '少ないヒントで $skill を繰り返します。ヘルプを開く前に一時停止してください。';
  }

  @override
  String recommendationRepeatAttempts(Object skill) {
    return '間違った試行を減らすために、$skill に 1 回の短い繰り返しセッションを与えます。';
  }

  @override
  String get homeRecommendedLessonTitle => '次のレッスン';

  @override
  String get homeRecommendedLessonSubtitle => '学習ルートに関する次の短いレッスン。';

  @override
  String get homeRecommendedLessonButton => '続く';

  @override
  String get homeRecommendedLessonCompleted => 'ルート完了';

  @override
  String get lessonReviewTitle => 'レッスンの概要';

  @override
  String get lessonReviewPerfectBody => '素晴らしい集中力: ヒントや間違いはありません。';

  @override
  String get lessonReviewSupportBody => '良い仕上がり。次回は、ヘルプを減らして 1 つのステップを試してください。';

  @override
  String get lessonReviewQuestionsLabel => '質問';

  @override
  String get lessonReviewHintsLabel => 'ヒント';

  @override
  String get lessonReviewMistakesLabel => '間違い';

  @override
  String get lessonNextRecommendedButton => '次のレッスン';

  @override
  String get practiceHistoryTitle => '実践歴';

  @override
  String get practiceHistorySubtitle => '正確さ、ヒント、間違いを含む最近のレッスン。';

  @override
  String get practiceHistoryEmpty => 'まだ完了したレッスンはありません。';

  @override
  String practiceHistorySessionMeta(Object date, Object minutes) {
    return '$date - $minutes 分';
  }

  @override
  String get practiceHistoryMistakesLabel => '間違い';

  @override
  String get lessonTryAgainButton => 'もう一度やり直してください';

  @override
  String get lessonHintTitle => '段階的に考えてみる';

  @override
  String get lessonRetryFeedback => '頑張ってね。ヒントを読んでから、もう一度選択してください。';

  @override
  String get languageSettingsTitle => 'アプリ言語';

  @override
  String get languageSettingsSubtitle => '子画面と親画面の言語を選択します。';

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
  String get challengeFruitPatternTitle => '果物の列';

  @override
  String get challengeFruitPatternPrompt => 'フルーツパターンを続けます。';

  @override
  String get challengeFruitPatternQuestion => 'リンゴ、バナナ、リンゴ、バナナ。次に何が来るでしょうか？';

  @override
  String get challengeFruitPatternHint => '果物はリンゴ、バナナの順に 1 つずつ繰り返されます。';

  @override
  String get challengeFruitPatternExplanation =>
      'バナナの次にリンゴが来るのは、このパターンが繰り返されるからです。';

  @override
  String get challengeLockKeyTitle => 'マジックペア';

  @override
  String get challengeLockKeyPrompt => 'ペアとなるオブジェクトを選択します。';

  @override
  String get challengeLockKeyQuestion => '鍵を押すと何かが開きます。何と一緒ですか？';

  @override
  String get challengeLockKeyHint => '鍵が何に使われるかを考えてみましょう。';

  @override
  String get challengeLockKeyExplanation => 'キーとロックは連携して機能するため、ペアを形成します。';

  @override
  String get challengeSpaceSequenceTitle => '宇宙航路';

  @override
  String get challengeSpaceSequencePrompt => '次の空間オブジェクトを見つけます。';

  @override
  String get challengeSpaceSequenceQuestion => 'ロケット、惑星、ロケット、惑星。次に何が来るでしょうか？';

  @override
  String get challengeSpaceSequenceHint => 'ルートは繰り返されます: ロケット、次に惑星。';

  @override
  String get challengeSpaceSequenceExplanation => '惑星の後には再びロケットがやって来ます。';

  @override
  String get challengeShapeStackTitle => 'シェイプタワー';

  @override
  String get challengeShapeStackPrompt => 'タワールールを継続します。';

  @override
  String get challengeShapeStackQuestion => '四角、丸、四角、丸。次はどの形でしょうか？';

  @override
  String get challengeShapeStackHint => 'タワーは 2 つの形状を交互に繰り返します。';

  @override
  String get challengeShapeStackExplanation => '円の後には再び正方形が来ます。';

  @override
  String get challengePathMazeTitle => 'パスファインダー';

  @override
  String get challengePathMazePrompt => '最初から最後まで道に従ってください。';

  @override
  String get challengePathMazeQuestion => '主人公が目標に到達するのを手伝ってください。どちらに進むべきですか?';

  @override
  String get challengePathMazeHint => '道路を最初から最後までトレースし、分岐点で方向を選択します。';

  @override
  String get challengePathMazeExplanation => '正しい道はゴールまで開かれた道をたどります。';

  @override
  String get lesson_001_title => 'シェイプパス';

  @override
  String get lesson_002_title => 'おもちゃの数を数える';

  @override
  String get lesson_003_title => '奇数カードアウト';

  @override
  String get lesson_004_title => 'ロジックトレイン';

  @override
  String get lesson_005_title => '合計と行';

  @override
  String get lesson_006_title => 'メモリとコード';

  @override
  String get lesson_007_title => 'ナンバーブリッジ';

  @override
  String get lesson_008_title => '詳細図';

  @override
  String get lesson_009_title => '影とバランス';

  @override
  String get lesson_010_title => '追加と比較';

  @override
  String get lesson_011_title => 'ターンとパス';

  @override
  String get lesson_012_title => '記憶力と集中力';

  @override
  String get lesson_013_title => 'フルーツ柄';

  @override
  String get lesson_014_title => '数学の棚';

  @override
  String get lesson_015_title => 'シェイプタワー';

  @override
  String get lesson_016_title => 'ロックと詳細';

  @override
  String get lesson_017_title => 'コードと番号';

  @override
  String get lesson_018_title => 'スペースシーケンス';

  @override
  String get lesson_019_title => '違いに焦点を当てる';

  @override
  String get lesson_020_title => 'ソリューションブリッジ';

  @override
  String get lesson_021_title => '連続したルール';

  @override
  String get lesson_022_title => '空間の形';

  @override
  String get lesson_023_title => '記憶と数え方';

  @override
  String get lesson_024_title => 'ファイナルミックス';

  @override
  String get lesson_025_title => 'ディテール探偵';

  @override
  String get lesson_026_title => 'スケールと数字';

  @override
  String get lesson_027_title => '奇数とペア';

  @override
  String get lesson_028_title => '空間の形';

  @override
  String get lesson_029_title => '慎重な合計額';

  @override
  String get lesson_030_title => 'ルールとコード';

  @override
  String get lesson_031_title => '影、形、記憶';

  @override
  String get lesson_032_title => '数値と詳細';

  @override
  String get lesson_033_title => 'ルールチェーン';

  @override
  String get lesson_034_title => 'スペースターン';

  @override
  String get lesson_035_title => 'ビッグナンバールート';

  @override
  String get lesson_036_title => 'オブザーバーのフィナーレ';

  @override
  String get lesson_037_title => '回転と記憶';

  @override
  String get lesson_038_title => 'スプリントのカウント';

  @override
  String get lesson_039_title => 'ルールとペア';

  @override
  String get lesson_040_title => 'スペースタワー';

  @override
  String get lesson_041_title => 'スケールとフォーカス';

  @override
  String get lesson_042_title => 'コードトレイン';

  @override
  String get lesson_043_title => '影とロック';

  @override
  String get lesson_044_title => '数字と記憶';

  @override
  String get lesson_045_title => 'ロングチェーン';

  @override
  String get lesson_046_title => '空間ルート';

  @override
  String get lesson_047_title => '合計と詳細';

  @override
  String get lesson_048_title => 'ロジック重視';

  @override
  String get lesson_049_title => '間近で見る形';

  @override
  String get lesson_050_title => '慎重な算術';

  @override
  String get lesson_051_title => 'パターンマスター';

  @override
  String get lesson_052_title => '空間の影';

  @override
  String get lesson_053_title => '数字のなぞなぞ';

  @override
  String get lesson_054_title => 'オブザーバーコード';

  @override
  String get lesson_055_title => '塔と鍵';

  @override
  String get lesson_056_title => '詳細とスケール';

  @override
  String get lesson_057_title => 'より厳しいルール';

  @override
  String get lesson_058_title => 'シェイプフィナーレ';

  @override
  String get lesson_059_title => '大きな数のタスク';

  @override
  String get lesson_060_title => 'ロジックスーパーミックス';
}
