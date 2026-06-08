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

  int get childProfileLimit {
    return isPaid ? 3 : 1;
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

class ChildProfile {
  const ChildProfile({
    required this.id,
    required this.name,
    required this.age,
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
  });

  final String id;
  final String name;
  final ChildAge age;
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

  ChildProfile copyWith({
    String? id,
    String? name,
    ChildAge? age,
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
  }) {
    return ChildProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
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
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age.name,
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
    };
  }

  factory ChildProfile.fromJson(Map<String, Object?> json) {
    final createdAt = DateTime.parse(json['createdAt'] as String);
    final name = json['name'] as String;
    final lastChallengeDate = json['lastChallengeDate'] as String?;
    final rawSessions = json['practiceSessions'] as List<Object?>? ?? const [];
    final practiceSessions = rawSessions
        .whereType<Map>()
        .map((session) => PracticeSession.fromJson(
              Map<String, Object?>.from(session),
            ))
        .toList(growable: false);

    return ChildProfile(
      id: json['id'] as String? ?? _childIdFromName(name, createdAt),
      name: name,
      age: ChildAge.fromName(json['age'] as String),
      createdAt: createdAt,
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
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ChildProfile &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            name == other.name &&
            age == other.age &&
            createdAt == other.createdAt &&
            learningGoal == other.learningGoal &&
            completedChallenges == other.completedChallenges &&
            currentStreak == other.currentStreak &&
            bestStreak == other.bestStreak &&
            totalPracticeMinutes == other.totalPracticeMinutes &&
            lastChallengeDate == other.lastChallengeDate &&
            lastChallengeId == other.lastChallengeId &&
            lastChallengeSkill == other.lastChallengeSkill &&
            _listEquals(practiceSessions, other.practiceSessions);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      age,
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
    this.childProfiles = const [],
    this.activeChildId,
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
  final List<ChildProfile> childProfiles;
  final String? activeChildId;
  final FamilySubscriptionPlan subscriptionPlan;
  final DateTime? subscriptionUpdatedAt;

  List<ChildProfile> get children {
    if (childProfiles.isNotEmpty) {
      return childProfiles;
    }

    return [_legacyChildProfile()];
  }

  ChildProfile get activeChild {
    final availableChildren = children;
    final selectedChildId = activeChildId;

    if (selectedChildId == null) {
      return availableChildren.first;
    }

    return availableChildren.firstWhere(
      (child) => child.id == selectedChildId,
      orElse: () => availableChildren.first,
    );
  }

  bool get canAddChild {
    return children.length < subscriptionPlan.childProfileLimit;
  }

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

  FamilyProfile withActiveChild(ChildProfile child) {
    final nextChildren = _upsertChild(children, child);
    return FamilyProfile(
      childName: child.name,
      childAge: child.age,
      createdAt: child.createdAt,
      learningGoal: child.learningGoal,
      completedChallenges: child.completedChallenges,
      currentStreak: child.currentStreak,
      bestStreak: child.bestStreak,
      totalPracticeMinutes: child.totalPracticeMinutes,
      lastChallengeDate: child.lastChallengeDate,
      lastChallengeId: child.lastChallengeId,
      lastChallengeSkill: child.lastChallengeSkill,
      practiceSessions: child.practiceSessions,
      childProfiles: nextChildren,
      activeChildId: child.id,
      subscriptionPlan: subscriptionPlan,
      subscriptionUpdatedAt: subscriptionUpdatedAt,
    );
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
    List<ChildProfile>? childProfiles,
    String? activeChildId,
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
      childProfiles: childProfiles ?? this.childProfiles,
      activeChildId: activeChildId ?? this.activeChildId,
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
      'childProfiles': [
        for (final child in children) child.toJson(),
      ],
      'activeChildId': activeChild.id,
      'subscriptionPlan': subscriptionPlan.name,
      'subscriptionUpdatedAt': subscriptionUpdatedAt?.toIso8601String(),
    };
  }

  factory FamilyProfile.fromJson(Map<String, Object?> json) {
    final childName = json['childName'] as String;
    final childAge = ChildAge.fromName(json['childAge'] as String);
    final createdAt = DateTime.parse(json['createdAt'] as String);
    final learningGoal = LearningGoal.fromName(json['learningGoal'] as String?);
    final lastChallengeDate = json['lastChallengeDate'] as String?;
    final subscriptionUpdatedAt = json['subscriptionUpdatedAt'] as String?;
    final rawSessions = json['practiceSessions'] as List<Object?>? ?? const [];
    final practiceSessions = rawSessions
        .whereType<Map>()
        .map((session) => PracticeSession.fromJson(
              Map<String, Object?>.from(session),
            ))
        .toList(growable: false);

    final rawChildren = json['childProfiles'] as List<Object?>? ?? const [];
    final parsedChildren = rawChildren
        .whereType<Map>()
        .map((child) => ChildProfile.fromJson(Map<String, Object?>.from(child)))
        .toList(growable: false);
    final fallbackChild = ChildProfile(
      id: _childIdFromName(childName, createdAt),
      name: childName,
      age: childAge,
      createdAt: createdAt,
      learningGoal: learningGoal,
      completedChallenges: _intFromJson(json['completedChallenges']),
      currentStreak: _intFromJson(json['currentStreak']),
      bestStreak: _intFromJson(json['bestStreak']),
      totalPracticeMinutes: _intFromJson(json['totalPracticeMinutes']),
      lastChallengeDate:
          lastChallengeDate == null ? null : DateTime.parse(lastChallengeDate),
      lastChallengeId: json['lastChallengeId'] as String?,
      lastChallengeSkill: json['lastChallengeSkill'] as String?,
      practiceSessions: practiceSessions,
    );
    final children = parsedChildren.isEmpty ? [fallbackChild] : parsedChildren;
    final activeChildId = json['activeChildId'] as String?;
    final activeChild = children.firstWhere(
      (child) => child.id == activeChildId,
      orElse: () => children.first,
    );

    return FamilyProfile(
      childName: activeChild.name,
      childAge: activeChild.age,
      createdAt: activeChild.createdAt,
      learningGoal: activeChild.learningGoal,
      completedChallenges: activeChild.completedChallenges,
      currentStreak: activeChild.currentStreak,
      bestStreak: activeChild.bestStreak,
      totalPracticeMinutes: activeChild.totalPracticeMinutes,
      lastChallengeDate: activeChild.lastChallengeDate,
      lastChallengeId: activeChild.lastChallengeId,
      lastChallengeSkill: activeChild.lastChallengeSkill,
      practiceSessions: activeChild.practiceSessions,
      childProfiles: children,
      activeChildId: activeChild.id,
      subscriptionPlan:
          FamilySubscriptionPlan.fromName(json['subscriptionPlan'] as String?),
      subscriptionUpdatedAt: subscriptionUpdatedAt == null
          ? null
          : DateTime.parse(subscriptionUpdatedAt),
    );
  }

  ChildProfile _legacyChildProfile() {
    return ChildProfile(
      id: _childIdFromName(childName, createdAt),
      name: childName,
      age: childAge,
      createdAt: createdAt,
      learningGoal: learningGoal,
      completedChallenges: completedChallenges,
      currentStreak: currentStreak,
      bestStreak: bestStreak,
      totalPracticeMinutes: totalPracticeMinutes,
      lastChallengeDate: lastChallengeDate,
      lastChallengeId: lastChallengeId,
      lastChallengeSkill: lastChallengeSkill,
      practiceSessions: practiceSessions,
    );
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
            _listEquals(children, other.children) &&
            activeChild.id == other.activeChild.id &&
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
      Object.hashAll(children),
      activeChild.id,
      subscriptionPlan,
      subscriptionUpdatedAt,
    );
  }
}

DateTime _dateOnly(DateTime value) {
  return DateTime(value.year, value.month, value.day);
}

List<ChildProfile> _upsertChild(
  List<ChildProfile> children,
  ChildProfile child,
) {
  var replaced = false;
  final nextChildren = [
    for (final existingChild in children)
      if (existingChild.id == child.id) ...[
        child,
      ] else ...[
        existingChild,
      ],
  ];

  replaced = children.any((existingChild) => existingChild.id == child.id);
  if (!replaced) {
    nextChildren.add(child);
  }

  return nextChildren;
}

String childProfileId({
  required String name,
  required DateTime createdAt,
}) {
  return _childIdFromName(name, createdAt);
}

String _childIdFromName(String name, DateTime createdAt) {
  final normalizedName = name.trim().toLowerCase();
  final checksum = normalizedName.codeUnits.fold<int>(
    0,
    (total, codeUnit) => total + codeUnit,
  );

  return 'child-${createdAt.millisecondsSinceEpoch}-$checksum';
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

bool _listEquals<T>(List<T> first, List<T> second) {
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
