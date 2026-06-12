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

class FamilyProfile {
  const FamilyProfile({
    required this.childName,
    required this.childAge,
    required this.createdAt,
    this.completedChallenges = 0,
    this.completedLevels = 0,
    this.lastChallengeDate,
  });

  final String childName;
  final ChildAge childAge;
  final DateTime createdAt;
  final int completedChallenges;
  final int completedLevels;
  final DateTime? lastChallengeDate;

  bool completedOn(DateTime date) {
    final lastDate = lastChallengeDate;
    if (lastDate == null) {
      return false;
    }

    return _dateOnly(lastDate) == _dateOnly(date);
  }

  FamilyProfile copyWith({
    String? childName,
    ChildAge? childAge,
    DateTime? createdAt,
    int? completedChallenges,
    int? completedLevels,
    DateTime? lastChallengeDate,
  }) {
    return FamilyProfile(
      childName: childName ?? this.childName,
      childAge: childAge ?? this.childAge,
      createdAt: createdAt ?? this.createdAt,
      completedChallenges: completedChallenges ?? this.completedChallenges,
      completedLevels: completedLevels ?? this.completedLevels,
      lastChallengeDate: lastChallengeDate ?? this.lastChallengeDate,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'childName': childName,
      'childAge': childAge.name,
      'createdAt': createdAt.toIso8601String(),
      'completedChallenges': completedChallenges,
      'completedLevels': completedLevels,
      'lastChallengeDate': lastChallengeDate?.toIso8601String(),
    };
  }

  factory FamilyProfile.fromJson(Map<String, Object?> json) {
    final lastChallengeDate = json['lastChallengeDate'] as String?;

    return FamilyProfile(
      childName: json['childName'] as String,
      childAge: ChildAge.fromName(json['childAge'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedChallenges: json['completedChallenges'] as int? ?? 0,
      completedLevels: json['completedLevels'] as int? ??
          json['completedChallenges'] as int? ??
          0,
      lastChallengeDate:
          lastChallengeDate == null ? null : DateTime.parse(lastChallengeDate),
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
            completedChallenges == other.completedChallenges &&
            completedLevels == other.completedLevels &&
            lastChallengeDate == other.lastChallengeDate;
  }

  @override
  int get hashCode {
    return Object.hash(
      childName,
      childAge,
      createdAt,
      completedChallenges,
      completedLevels,
      lastChallengeDate,
    );
  }
}
