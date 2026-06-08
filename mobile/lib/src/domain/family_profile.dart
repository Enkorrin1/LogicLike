enum ChildAge {
  four(4, '4 года'),
  five(5, '5 лет'),
  six(6, '6 лет'),
  seven(7, '7 лет'),
  eight(8, '8 лет');

  const ChildAge(this.years, this.label);

  final int years;
  final String label;

  static ChildAge fromName(String name) {
    return ChildAge.values.firstWhere(
      (age) => age.name == name,
      orElse: () => throw FormatException('Unsupported child age: $name'),
    );
  }
}

enum LearningGoal {
  logic(
    'Логика',
    'Закономерности, рассуждение и поиск правил.',
  ),
  math(
    'Математика',
    'Числа, счет и аккуратные решения.',
  ),
  attention(
    'Внимание',
    'Фокус, память и сравнение деталей.',
  );

  const LearningGoal(this.label, this.description);

  final String label;
  final String description;

  static LearningGoal fromName(String? name) {
    if (name == null) {
      return LearningGoal.logic;
    }

    return LearningGoal.values.firstWhere(
      (goal) => goal.name == name,
      orElse: () => LearningGoal.logic,
    );
  }
}

enum FamilySubscriptionPlan {
  starter(
    'Стартовый',
    '0 ₽',
    '1 детский профиль',
    'Короткий daily loop и локальный прогресс.',
  ),
  monthly(
    'Семейный месяц',
    '399 ₽/мес',
    'до 3 детских профилей',
    'Полный доступ, семейные профили и родительская аналитика.',
  ),
  annual(
    'Семейный год',
    '2990 ₽/год',
    'до 3 детских профилей',
    'То же, но выгоднее при оплате за год.',
  );

  const FamilySubscriptionPlan(
    this.label,
    this.priceLabel,
    this.capacityLabel,
    this.description,
  );

  final String label;
  final String priceLabel;
  final String capacityLabel;
  final String description;

  bool get isPaid {
    return this != FamilySubscriptionPlan.starter;
  }

  String get statusLabel {
    return isPaid ? 'Активна' : 'Не оформлена';
  }

  static FamilySubscriptionPlan fromName(String? name) {
    if (name == null) {
      return FamilySubscriptionPlan.starter;
    }

    return FamilySubscriptionPlan.values.firstWhere(
      (plan) => plan.name == name,
      orElse: () => FamilySubscriptionPlan.starter,
    );
  }
}

class PracticeSession {
  const PracticeSession({
    required this.completedAt,
    required this.challengeId,
    required this.challengeTitle,
    required this.skill,
    required this.minutes,
  });

  final DateTime completedAt;
  final String challengeId;
  final String challengeTitle;
  final String skill;
  final int minutes;

  bool completedOn(DateTime date) {
    return _dateOnly(completedAt) == _dateOnly(date);
  }

  Map<String, Object?> toJson() {
    return {
      'completedAt': completedAt.toIso8601String(),
      'challengeId': challengeId,
      'challengeTitle': challengeTitle,
      'skill': skill,
      'minutes': minutes,
    };
  }

  factory PracticeSession.fromJson(Map<String, Object?> json) {
    return PracticeSession(
      completedAt: DateTime.parse(json['completedAt'] as String),
      challengeId: json['challengeId'] as String,
      challengeTitle: json['challengeTitle'] as String? ?? 'Задание дня',
      skill: json['skill'] as String? ?? 'Логика',
      minutes: _intFromJson(json['minutes']),
    );
  }

  static DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PracticeSession &&
            runtimeType == other.runtimeType &&
            completedAt == other.completedAt &&
            challengeId == other.challengeId &&
            challengeTitle == other.challengeTitle &&
            skill == other.skill &&
            minutes == other.minutes;
  }

  @override
  int get hashCode {
    return Object.hash(
      completedAt,
      challengeId,
      challengeTitle,
      skill,
      minutes,
    );
  }
}

class FamilyProfile {
  const FamilyProfile({
    required this.childName,
    required this.childAge,
    required this.createdAt,
    this.learningGoal = LearningGoal.logic,
    this.completedChallenges = 0,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.totalPracticeMinutes = 0,
    this.lastChallengeDate,
    this.lastChallengeId,
    this.lastChallengeSkill,
    this.practiceSessions = const [],
    this.subscriptionPlan = FamilySubscriptionPlan.starter,
    this.subscriptionUpdatedAt,
  });

  final String childName;
  final ChildAge childAge;
  final DateTime createdAt;
  final LearningGoal learningGoal;
  final int completedChallenges;
  final int currentStreak;
  final int bestStreak;
  final int totalPracticeMinutes;
  final DateTime? lastChallengeDate;
  final String? lastChallengeId;
  final String? lastChallengeSkill;
  final List<PracticeSession> practiceSessions;
  final FamilySubscriptionPlan subscriptionPlan;
  final DateTime? subscriptionUpdatedAt;

  PracticeSession? get lastSession {
    return practiceSessions.isEmpty ? null : practiceSessions.last;
  }

  bool completedOn(DateTime date) {
    final lastDate = lastChallengeDate;
    if (lastDate == null) {
      return false;
    }

    return _dateOnly(lastDate) == _dateOnly(date);
  }

  List<PracticeSession> sessionsInLastDays({
    required int days,
    required DateTime now,
  }) {
    if (days <= 0) {
      return const [];
    }

    final today = _dateOnly(now);
    final firstDay = today.subtract(Duration(days: days - 1));

    return practiceSessions.where((session) {
      final completedAt = _dateOnly(session.completedAt);
      return !completedAt.isBefore(firstDay) && !completedAt.isAfter(today);
    }).toList(growable: false);
  }

  FamilyProfile copyWith({
    String? childName,
    ChildAge? childAge,
    DateTime? createdAt,
    LearningGoal? learningGoal,
    int? completedChallenges,
    int? currentStreak,
    int? bestStreak,
    int? totalPracticeMinutes,
    DateTime? lastChallengeDate,
    String? lastChallengeId,
    String? lastChallengeSkill,
    List<PracticeSession>? practiceSessions,
    FamilySubscriptionPlan? subscriptionPlan,
    DateTime? subscriptionUpdatedAt,
  }) {
    return FamilyProfile(
      childName: childName ?? this.childName,
      childAge: childAge ?? this.childAge,
      createdAt: createdAt ?? this.createdAt,
      learningGoal: learningGoal ?? this.learningGoal,
      completedChallenges: completedChallenges ?? this.completedChallenges,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      totalPracticeMinutes: totalPracticeMinutes ?? this.totalPracticeMinutes,
      lastChallengeDate: lastChallengeDate ?? this.lastChallengeDate,
      lastChallengeId: lastChallengeId ?? this.lastChallengeId,
      lastChallengeSkill: lastChallengeSkill ?? this.lastChallengeSkill,
      practiceSessions: practiceSessions ?? this.practiceSessions,
      subscriptionPlan: subscriptionPlan ?? this.subscriptionPlan,
      subscriptionUpdatedAt:
          subscriptionUpdatedAt ?? this.subscriptionUpdatedAt,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'childName': childName,
      'childAge': childAge.name,
      'createdAt': createdAt.toIso8601String(),
      'learningGoal': learningGoal.name,
      'completedChallenges': completedChallenges,
      'currentStreak': currentStreak,
      'bestStreak': bestStreak,
      'totalPracticeMinutes': totalPracticeMinutes,
      'lastChallengeDate': lastChallengeDate?.toIso8601String(),
      'lastChallengeId': lastChallengeId,
      'lastChallengeSkill': lastChallengeSkill,
      'practiceSessions': [
        for (final session in practiceSessions) session.toJson(),
      ],
      'subscriptionPlan': subscriptionPlan.name,
      'subscriptionUpdatedAt': subscriptionUpdatedAt?.toIso8601String(),
    };
  }

  factory FamilyProfile.fromJson(Map<String, Object?> json) {
    final lastChallengeDate = json['lastChallengeDate'] as String?;
    final subscriptionUpdatedAt = json['subscriptionUpdatedAt'] as String?;
    final rawSessions = json['practiceSessions'] as List<Object?>? ?? const [];
    final practiceSessions = rawSessions
        .whereType<Map>()
        .map((session) => PracticeSession.fromJson(
              Map<String, Object?>.from(session),
            ))
        .toList(growable: false);

    return FamilyProfile(
      childName: json['childName'] as String,
      childAge: ChildAge.fromName(json['childAge'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      learningGoal: LearningGoal.fromName(json['learningGoal'] as String?),
      completedChallenges: _intFromJson(json['completedChallenges']),
      currentStreak: _intFromJson(json['currentStreak']),
      bestStreak: _intFromJson(json['bestStreak']),
      totalPracticeMinutes: _intFromJson(json['totalPracticeMinutes']),
      lastChallengeDate:
          lastChallengeDate == null ? null : DateTime.parse(lastChallengeDate),
      lastChallengeId: json['lastChallengeId'] as String?,
      lastChallengeSkill: json['lastChallengeSkill'] as String?,
      practiceSessions: practiceSessions,
      subscriptionPlan:
          FamilySubscriptionPlan.fromName(json['subscriptionPlan'] as String?),
      subscriptionUpdatedAt: subscriptionUpdatedAt == null
          ? null
          : DateTime.parse(subscriptionUpdatedAt),
    );
  }

  static DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is FamilyProfile &&
            runtimeType == other.runtimeType &&
            childName == other.childName &&
            childAge == other.childAge &&
            createdAt == other.createdAt &&
            learningGoal == other.learningGoal &&
            completedChallenges == other.completedChallenges &&
            currentStreak == other.currentStreak &&
            bestStreak == other.bestStreak &&
            totalPracticeMinutes == other.totalPracticeMinutes &&
            lastChallengeDate == other.lastChallengeDate &&
            lastChallengeId == other.lastChallengeId &&
            lastChallengeSkill == other.lastChallengeSkill &&
            _listEquals(practiceSessions, other.practiceSessions) &&
            subscriptionPlan == other.subscriptionPlan &&
            subscriptionUpdatedAt == other.subscriptionUpdatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      childName,
      childAge,
      createdAt,
      learningGoal,
      completedChallenges,
      currentStreak,
      bestStreak,
      totalPracticeMinutes,
      lastChallengeDate,
      lastChallengeId,
      lastChallengeSkill,
      Object.hashAll(practiceSessions),
      subscriptionPlan,
      subscriptionUpdatedAt,
    );
  }

  static bool _listEquals<T>(List<T> first, List<T> second) {
    if (first.length != second.length) {
      return false;
    }

    for (var index = 0; index < first.length; index += 1) {
      if (first[index] != second[index]) {
        return false;
      }
    }

    return true;
  }
}

int _intFromJson(Object? value) {
  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.toInt();
  }

  return 0;
}
