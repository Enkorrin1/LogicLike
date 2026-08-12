// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Logic Loka';

  @override
  String get loadingMission => 'Готовим миссию...';

  @override
  String get navHome => 'Домой';

  @override
  String get navChallenge => 'Задание';

  @override
  String get navParent => 'Родителю';

  @override
  String get commonCancel => 'Отмена';

  @override
  String get commonReset => 'Сбросить';

  @override
  String languageChanged(Object language) {
    return 'Язык: $language';
  }

  @override
  String languageButtonSemantics(Object language) {
    return 'Сменить язык. Сейчас $language';
  }

  @override
  String get onboardingSubmitSaving => 'Готовим маршрут';

  @override
  String get onboardingSubmitCreateHero => 'Создать героя';

  @override
  String get onboardingDefaultHero => 'Юный герой';

  @override
  String get onboardingTitle => 'Создай героя';

  @override
  String onboardingHeroSummary(Object age, Object name) {
    return '$name, $age';
  }

  @override
  String get onboardingSubtitle =>
      'Лев покажет миссию дня, а дальше ребенок сам выберет тренировки.';

  @override
  String get childNameLabel => 'Имя ребенка';

  @override
  String get childNameError => 'Введите имя героя';

  @override
  String get onboardingMissionPill => 'старт миссии';

  @override
  String get onboardingAgeTitle => 'Возраст героя';

  @override
  String get unlockMission => 'Миссия';

  @override
  String get unlockGames => 'Игры';

  @override
  String get unlockPrizes => 'Призы';

  @override
  String ageYears(int years) {
    return '$years лет';
  }

  @override
  String homeGreeting(Object name) {
    return 'Привет,\n$name';
  }

  @override
  String get homeStarsHint =>
      'Звезды копятся за миссии и открывают новые призы.';

  @override
  String get homeLockedLevelHint => 'Этот уровень откроется после новых звезд.';

  @override
  String get homeStreakSavedHint =>
      'Серия сохранена! Завтра будет новая миссия.';

  @override
  String get homeStreakNeedMissionHint =>
      'Пройди миссию дня, чтобы сохранить серию.';

  @override
  String get homeStreakTitle => 'Серия дня';

  @override
  String homeStreakDays(int days) {
    return '$days дней подряд!';
  }

  @override
  String get homeStreakWaiting => 'миссия ждет тебя';

  @override
  String get homeMissionDaily => 'Миссия дня';

  @override
  String get homeMissionFreePlay => 'Играть свободно';

  @override
  String get homeTrainingOpen => 'Тренировки открыты';

  @override
  String homeLevel(int level) {
    return 'Уровень $level';
  }

  @override
  String get homeMissionStart => 'Старт';

  @override
  String get homeMissionChoose => 'Выбрать';

  @override
  String get homeMissionTag => 'Главная миссия';

  @override
  String get homeFreePlayTitle => 'Играй сам';

  @override
  String get homeFreePlaySubtitle => 'выбирай героя и тренируй мозг';

  @override
  String get homeMiniGamesTitle => 'Мини-игры';

  @override
  String get homeMiniGamesSubtitle => 'быстрая тренировка после уровней';

  @override
  String get homeQuickPairs => 'Пары';

  @override
  String get homeQuickPath => 'Путь';

  @override
  String get homeQuickCount => 'Счет';

  @override
  String get homeProgressTitle => 'Мой прогресс';

  @override
  String homeProgressStars(int current, int total) {
    return '$current / $total звезд';
  }

  @override
  String get homeCollectionTitle => 'Коллекция';

  @override
  String get homeCollectionStickers => 'наклеек';

  @override
  String get homeLevelsTitle => 'Уровни';

  @override
  String get homeLevelsSubtitle => '8 тем для тренировки, не календарь';

  @override
  String get homeNodeCompleted => 'пройдено';

  @override
  String get homeNodePlay => 'играть';

  @override
  String get homeNodeSoon => 'скоро';

  @override
  String get homeMapStart => 'Старт';

  @override
  String get homeMapShapes => 'Фигуры';

  @override
  String get homeMapPairs => 'Пары';

  @override
  String get homeMapCount => 'Счет';

  @override
  String get homeMapPath => 'Путь';

  @override
  String get homeMapRhythm => 'Ритм';

  @override
  String get homeMapCompare => 'Сравни';

  @override
  String get homeMapFinal => 'Финал';

  @override
  String get parentTitle => 'Родительский контур';

  @override
  String get parentIntroTitle => 'Спокойная зона для взрослых';

  @override
  String get parentIntroBody =>
      'Профиль, прогресс, язык и будущая подписка собраны отдельно от детской миссии.';

  @override
  String get parentProfileTitle => 'Семейный профиль';

  @override
  String get parentLocalBadge => 'локально';

  @override
  String get parentChildLabel => 'Ребенок';

  @override
  String get parentAgeLabel => 'Возраст';

  @override
  String get parentCompletedTasksLabel => 'Заданий выполнено';

  @override
  String get parentLanguageLabel => 'Язык';

  @override
  String get settingsLanguage => 'Язык приложения';

  @override
  String get parentSubscriptionTitle => 'Семейная подписка';

  @override
  String get parentSubscriptionSoon => 'скоро';

  @override
  String get parentSubscriptionBody =>
      'Стартовая сетка тарифов: Free, месячный Premium Family и Annual по ранней цене.';

  @override
  String get parentFamilySeatsLabel => 'Семейные места';

  @override
  String get parentFamilySeatsValue => 'в плане';

  @override
  String get parentPaymentLabel => 'Оплата';

  @override
  String get parentPaymentValue => 'не подключена';

  @override
  String get parentSubscriptionLaunchBadge => 'ранняя цена';

  @override
  String get parentSubscriptionCurrentFree => 'Бесплатный';

  @override
  String get parentSubscriptionFreeTitle => 'Бесплатный';

  @override
  String get parentSubscriptionFreePrice => '\$0';

  @override
  String get parentSubscriptionFreeBody =>
      'Мягкий старт, чтобы попробовать ежедневный цикл.';

  @override
  String get parentSubscriptionFeatureDaily => 'Миссия дня';

  @override
  String get parentSubscriptionFeatureStarter => 'Стартовые уровни';

  @override
  String get parentSubscriptionFeatureLocalProgress =>
      'Локальный прогресс на этом устройстве';

  @override
  String get parentSubscriptionFreeCta => 'Текущий доступ';

  @override
  String get parentSubscriptionPremiumTitle => 'Премиум для семьи';

  @override
  String get parentSubscriptionPremiumPrice => '\$5.99/мес';

  @override
  String get parentSubscriptionPremiumBadge => 'цена запуска';

  @override
  String get parentSubscriptionPremiumBody =>
      'Полный семейный доступ, пока библиотека контента еще растет.';

  @override
  String get parentSubscriptionFeatureAllLevels => 'Все текущие и новые уровни';

  @override
  String get parentSubscriptionFeatureParentTips => 'Родительские рекомендации';

  @override
  String get parentSubscriptionFeaturePurchaseRestore =>
      'Подготовлено к восстановлению покупок';

  @override
  String get parentSubscriptionPremiumCta => 'Выбрать месяц';

  @override
  String get parentSubscriptionAnnualTitle => 'Годовой';

  @override
  String get parentSubscriptionAnnualPrice => '\$39.99/год';

  @override
  String get parentSubscriptionAnnualBadge => 'выгодно';

  @override
  String get parentSubscriptionAnnualBody =>
      'Premium Family на год по ранней годовой цене.';

  @override
  String get parentSubscriptionFeatureAnnualValue =>
      'Дешевле 12 месячных оплат';

  @override
  String get parentSubscriptionFeatureYearAccess =>
      '12 месяцев семейного доступа';

  @override
  String get parentSubscriptionFeatureUpdatesIncluded =>
      'Новые уровни входят в год доступа';

  @override
  String get parentSubscriptionAnnualCta => 'Выбрать год';

  @override
  String get parentSubscriptionFuturePriceNote =>
      'Позже, когда появится много качественных уровней: \$7.99/мес и \$49.99/год.';

  @override
  String get parentSubscriptionBillingSoonSnack =>
      'Оплата еще не подключена. Тарифы готовы для StoreKit и Google Play Billing.';

  @override
  String get parentResetProfile => 'Сбросить профиль';

  @override
  String get parentResetTitle => 'Сбросить профиль?';

  @override
  String get parentResetBody =>
      'Onboarding откроется заново, а локальный прогресс будет очищен.';

  @override
  String get challengeTitle => 'Игры для мозга';

  @override
  String get challengeDayDone => 'День закрыт';

  @override
  String get challengeDailyMission => 'Миссия дня';

  @override
  String get challengeDayDoneBody =>
      'Награда получена. Можно повторять или играть свободно.';

  @override
  String get challengeDailyBody =>
      'Пройди 3 шага, чтобы сохранить серию и забрать приз.';

  @override
  String get challengePrize => 'приз';

  @override
  String get challengeMissionProgress => 'Прогресс миссии';

  @override
  String countOfTotal(int count, int total) {
    return '$count из $total';
  }

  @override
  String get challengeRepeatMission => 'Повторить миссию';

  @override
  String challengeStepsTraining(int steps) {
    return '$steps шага для тренировки';
  }

  @override
  String challengeStepNumber(int step) {
    return 'Шаг $step';
  }

  @override
  String get challengeAgain => 'еще';

  @override
  String minutesShort(int minutes) {
    return '$minutes мин';
  }

  @override
  String get challengeBrainGymTitle => 'Тренажер мозга';

  @override
  String challengeBrainGymSubtitle(int count) {
    return '$count областей, играй в любом порядке';
  }

  @override
  String challengeAreaLevels(int done, int total) {
    return '$done/$total уровней';
  }

  @override
  String challengeAreaCompleted(int done, int total) {
    return '$done из $total пройдено';
  }

  @override
  String get challengeStateCompleted => 'пройдено';

  @override
  String get challengeStateNext => 'следующий';

  @override
  String get challengeStatePlay => 'играть';

  @override
  String challengeLevelNumber(int level) {
    return 'Уровень $level';
  }

  @override
  String get challengeHideHint => 'Скрыть подсказку';

  @override
  String get challengeShowHint => 'Показать подсказку';

  @override
  String get challengeDailyTaskTitle => 'Задание дня';

  @override
  String get challengePuzzleTaskTitle => 'Головоломка';

  @override
  String get challengeDailyPath => 'Ежедневный путь';

  @override
  String get challengeFreePlay => 'Свободная игра';

  @override
  String get challengeExcellent => 'Отлично!';

  @override
  String get challengeFlyNext => 'Летим дальше';

  @override
  String get challengeAllDone => 'Все готово';

  @override
  String get challengePlayMore => 'Играть дальше';

  @override
  String get challengeMyCollection => 'Моя коллекция';

  @override
  String get challengeDailyCompleteTitle => 'Миссия дня выполнена!';

  @override
  String get challengeDailyCompleteBody =>
      'Ты закрыл все шаги. Можно забрать приз и играть свободно.';

  @override
  String get challengeRewardStars => 'звезды';

  @override
  String get challengeRewardStreak => 'серия';

  @override
  String get challengeRewardSteps => 'шага';

  @override
  String get challengeWhatNextTitle => 'Что дальше?';

  @override
  String get challengeWhatNextBody =>
      'Выбирай героя: логика, память, внимание, счет или путь.';

  @override
  String challengeProgressStep(int current, int total) {
    return 'Шаг $current из $total';
  }

  @override
  String get challengeChooseAnswer => 'Выбери ответ';

  @override
  String challengeSelectedAnswer(Object answer) {
    return 'Ответ: $answer';
  }

  @override
  String get challengePickDifferentAnswer => 'Выбери другой ответ';

  @override
  String get challengeCorrectAnswer => 'Верно!';

  @override
  String get challengeChecking => 'Проверяем';

  @override
  String get challengeCheck => 'Проверить';

  @override
  String get challengeCorrectFeedbackTitle => 'Отлично!';

  @override
  String get challengeRetryFeedbackTitle => 'Почти получилось';

  @override
  String get challengeCorrectFeedbackText => 'Ответ верный. Идем дальше!';

  @override
  String get hintLogic =>
      'Правило повторяется. Найди начало нового повтора и продолжи ряд.';

  @override
  String get hintMemory =>
      'Сначала вспомни, какие картинки уже были открыты. Потом ищи такую же пару.';

  @override
  String get hintAttention =>
      'Сравни детали по одной: цвет, форму, размер и место. Отличие обычно маленькое.';

  @override
  String get hintMath =>
      'Считай не все сразу, а маленькими группами. Так легче не сбиться.';

  @override
  String get hintSpace =>
      'Следи за дорожкой от старта к финишу и называй следующий поворот.';

  @override
  String get collectionTitle => 'Моя коллекция';

  @override
  String get collectionDayPrize => 'Приз дня';

  @override
  String get collectionCosmoPrizes => 'Космо-призы';

  @override
  String collectionUnlocked(int total, int unlocked) {
    return '$unlocked из $total открыто';
  }

  @override
  String get collectionNewPrizeTitle => 'Новый приз дня';

  @override
  String get collectionNewPrizeBody => 'Космонавт добавлен в коллекцию.';

  @override
  String collectionSnackUnlocked(Object title) {
    return '$title уже в коллекции.';
  }

  @override
  String get collectionSnackLocked => 'Откроется после новых уровней.';

  @override
  String get collectionNewBadge => 'новый';

  @override
  String collectionLockedLevel(int level) {
    return '$level ур.';
  }

  @override
  String get parentOverviewTitle => 'Родительский обзор';

  @override
  String parentOverviewBody(String name) {
    return 'Профиль $name, прогресс, сегодняшний план и подсказки для занятий дома.';
  }

  @override
  String parentStarsCount(int stars) {
    return '$stars звезд';
  }

  @override
  String get parentMissionClosed => 'миссия закрыта';

  @override
  String get parentMissionWaiting => 'миссия ждет';

  @override
  String get parentProgressTitle => 'Прогресс ребенка';

  @override
  String get parentOverviewBadge => 'обзор';

  @override
  String get parentLevelsLabel => 'Уровни';

  @override
  String parentLevelsValue(int completed, int total) {
    return '$completed из $total';
  }

  @override
  String get parentTodayLabel => 'Сегодня';

  @override
  String parentTodayValue(int done, int total) {
    return '$done из $total';
  }

  @override
  String get parentStarsLabel => 'Звезды';

  @override
  String get parentContentLabel => 'Контент';

  @override
  String parentContentValue(int done, int total) {
    return '$done из $total';
  }

  @override
  String get parentTodayPlanTitle => 'План на сегодня';

  @override
  String get parentTodayPlanBody =>
      'Короткая серия без давления: лучше 2-3 спокойных подхода, чем длинная усталая сессия.';

  @override
  String parentPuzzleMeta(String skill, int minutes) {
    return '$skill • $minutes мин';
  }

  @override
  String get parentAreasTitle => 'Зоны развития';

  @override
  String get parentBalanceBadge => 'баланс';

  @override
  String get parentAreasBody =>
      'Это внутренняя карта для взрослых: ребенку лучше видеть миссии и героев, а не сухие категории.';

  @override
  String get parentRecommendationDone =>
      'Сегодняшняя миссия закрыта. Хороший момент похвалить за старание, а не за скорость.';

  @override
  String parentRecommendationRemaining(int remaining) {
    return 'Сегодня уже есть прогресс: осталось $remaining заданий.';
  }

  @override
  String get parentRecommendationStart =>
      'Сегодня лучше начать с одной короткой миссии на 4-6 минут.';

  @override
  String get parentRecommendationsTitle => 'Рекомендации';

  @override
  String get parentHomeBadge => 'для дома';

  @override
  String get parentPaceLabel => 'Темп';

  @override
  String get parentWeekFocusLabel => 'Фокус недели';

  @override
  String parentFocusArea(String areaTitle, String areaSubtitle) {
    return 'Больше всего сейчас просится зона «$areaTitle»: $areaSubtitle.';
  }

  @override
  String get parentDiscussLabel => 'Как обсуждать';

  @override
  String get parentDiscussBody =>
      'После задания спросите: «Как ты понял правило?» Это развивает объяснение, а не угадывание.';

  @override
  String get parentFamilySecurityTitle => 'Семья и безопасность';

  @override
  String get parentStorageLabel => 'Хранение';

  @override
  String get parentStorageLocal => 'на устройстве';

  @override
  String get notificationDailyTitle => 'Новая миссия ждет';

  @override
  String notificationDailyBody(String name) {
    return '$name, реши одну маленькую головоломку и сохрани звездную серию.';
  }

  @override
  String get notificationEveningTitle => 'Один шаг перед сном?';

  @override
  String notificationEveningBody(String name) {
    return 'У $name осталась короткая миссия. Хватит 5 спокойных минут.';
  }

  @override
  String get parentRemindersTitle => 'Напоминания';

  @override
  String get parentReminderStatusOn => 'вкл';

  @override
  String get parentReminderStatusOff => 'выкл';

  @override
  String get parentRemindersBody =>
      'Мягкое ежедневное напоминание помогает вернуться к миссии без давления.';

  @override
  String get parentReminderDailyLabel => 'Миссия дня';

  @override
  String get parentReminderDailyValue => '18:30 каждый день';

  @override
  String get parentReminderFollowUpLabel => 'Вечерний повтор';

  @override
  String get parentReminderFollowUpValue => '20:15, если миссия ждет';

  @override
  String get parentReminderToggleLabel => 'Напоминать вернуться';

  @override
  String get parentReminderToggleOn =>
      'Logic Loka позовет ребенка на одну короткую миссию.';

  @override
  String get parentReminderToggleOff =>
      'Напоминания выключены. Приложение будет молчать.';

  @override
  String get parentAccountTitle => 'Аккаунт';

  @override
  String get parentAccountBody =>
      'Войдите, чтобы синхронизировать прогресс, открыть подписки и восстановить покупки на другом устройстве.';

  @override
  String get parentAccountStatusGuest => 'гость';

  @override
  String get parentAccountAction => 'Войти';

  @override
  String get accountTitle => 'Вход в аккаунт';

  @override
  String get accountHeroTitle => 'Семейный профиль рядом';

  @override
  String get accountHeroBody =>
      'Используйте Google, Apple или email, чтобы подготовить синхронизацию, покупки и безопасный родительский доступ.';

  @override
  String get accountStatusGuest => 'режим гостя';

  @override
  String get accountAppleButton => 'Продолжить с Apple';

  @override
  String get accountGoogleButton => 'Продолжить с Google';

  @override
  String get accountAuthLoading => 'Проверяем...';

  @override
  String get accountProviderGoogle => 'Google';

  @override
  String get accountProviderApple => 'Apple';

  @override
  String get accountProviderEmail => 'Email';

  @override
  String get accountSignedInTitle => 'Вход выполнен';

  @override
  String get accountSignOut => 'Выйти';

  @override
  String get accountGoogleSuccessSnack => 'Вход через Google выполнен.';

  @override
  String get accountGoogleCanceledSnack => 'Вход через Google отменен.';

  @override
  String get accountGoogleUnsupportedSnack =>
      'Вход через Google пока не поддерживается на этой платформе.';

  @override
  String get accountGoogleConfigSnack =>
      'Для входа через Google нужна OAuth-настройка этого приложения.';

  @override
  String accountGoogleErrorSnack(Object error) {
    return 'Ошибка входа через Google: $error';
  }

  @override
  String get accountBenefitGoogleTitle => 'Вход через Google';

  @override
  String get accountBenefitGoogleBody =>
      'Используйте Google-аккаунт для быстрого родительского доступа после настройки OAuth.';

  @override
  String get accountEmailTitle => 'Вход по email';

  @override
  String get accountSignInTab => 'Вход';

  @override
  String get accountCreateTab => 'Создать';

  @override
  String get accountEmailLabel => 'Email';

  @override
  String get accountPasswordLabel => 'Пароль';

  @override
  String get accountConfirmPasswordLabel => 'Повторите пароль';

  @override
  String get accountRememberDevice => 'Запомнить это устройство';

  @override
  String get accountSubmitSignIn => 'Войти';

  @override
  String get accountSubmitCreate => 'Создать аккаунт';

  @override
  String get accountForgotPassword => 'Забыли пароль';

  @override
  String get accountRestorePurchases => 'Восстановить покупки';

  @override
  String get accountPrivacyNote =>
      'Ребенок продолжает играть локально, пока сервисы аккаунта не подключены.';

  @override
  String get accountBenefitSyncTitle => 'Синхронизация прогресса';

  @override
  String get accountBenefitSyncBody =>
      'После входа профиль сможет переносить звезды и историю занятий между устройствами.';

  @override
  String get accountBenefitAppleTitle => 'Вход через Apple готов';

  @override
  String get accountBenefitAppleBody =>
      'Кнопка уже на месте для подключения нативной авторизации Apple.';

  @override
  String get accountBenefitPurchaseTitle => 'Покупки и подписки';

  @override
  String get accountBenefitPurchaseBody =>
      'Восстановление доступа после переустановки или смены устройства.';

  @override
  String get accountEmailError => 'Введите корректный email';

  @override
  String get accountPasswordError => 'Минимум 6 символов';

  @override
  String get accountPasswordMismatch => 'Пароли не совпадают';

  @override
  String get accountDemoSnack =>
      'Вход по email выполнен локально. Подключите backend, чтобы проверять пароль на сервере.';

  @override
  String get accountAppleSnack =>
      'Окно Apple-входа готово для нативного обработчика.';

  @override
  String get accountRestoreSnack =>
      'Окно восстановления покупок готово для StoreKit.';

  @override
  String get accountResetDialogTitle => 'Сброс пароля';

  @override
  String get accountResetDialogBody =>
      'Письма для сброса пароля будут отправляться после подключения backend аккаунтов.';

  @override
  String get accountResetDialogAction => 'Понятно';

  @override
  String get puzzleListenPrompt => 'Прослушать задание';

  @override
  String get puzzleStopNarration => 'Остановить озвучку';
}
