import 'dart:ui';

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

enum AppLanguage {
  ar('ar', 'AR', 'العربية'),
  de('de', 'DE', 'Deutsch'),
  en('en', 'EN', 'English'),
  es('es', 'ES', 'Español'),
  fr('fr', 'FR', 'Français'),
  hi('hi', 'HI', 'हिन्दी'),
  it('it', 'IT', 'Italiano'),
  ja('ja', 'JA', '日本語'),
  ko('ko', 'KO', '한국어'),
  pt('pt', 'PT', 'Português'),
  ru('ru', 'RU', 'Русский'),
  zh('zh', 'ZH', '中文');

  const AppLanguage(this.code, this.shortLabel, this.label);

  final String code;
  final String shortLabel;
  final String label;

  Locale get locale => Locale(code);

  AppLanguage get next {
    const values = AppLanguage.values;
    final nextIndex = (values.indexOf(this) + 1) % values.length;
    return values[nextIndex];
  }

  static AppLanguage fromCode(String? code) {
    return AppLanguage.values.firstWhere(
      (language) => language.code == code,
      orElse: () => AppLanguage.ru,
    );
  }
}

class FamilyProfile {
  const FamilyProfile({
    required this.childName,
    required this.childAge,
    required this.createdAt,
    this.language = AppLanguage.ru,
    this.completedChallenges = 0,
    this.completedLevels = 0,
    this.dailyProgressDate,
    this.dailyCompletedPuzzleIds = const [],
    this.completedPracticePuzzleIds = const [],
    this.lastChallengeDate,
    this.remindersEnabled = true,
  });

  final String childName;
  final ChildAge childAge;
  final DateTime createdAt;
  final AppLanguage language;
  final int completedChallenges;
  final int completedLevels;
  final DateTime? dailyProgressDate;
  final List<String> dailyCompletedPuzzleIds;
  final List<String> completedPracticePuzzleIds;
  final DateTime? lastChallengeDate;
  final bool remindersEnabled;

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
    AppLanguage? language,
    int? completedChallenges,
    int? completedLevels,
    DateTime? dailyProgressDate,
    List<String>? dailyCompletedPuzzleIds,
    List<String>? completedPracticePuzzleIds,
    DateTime? lastChallengeDate,
    bool? remindersEnabled,
  }) {
    return FamilyProfile(
      childName: childName ?? this.childName,
      childAge: childAge ?? this.childAge,
      createdAt: createdAt ?? this.createdAt,
      language: language ?? this.language,
      completedChallenges: completedChallenges ?? this.completedChallenges,
      completedLevels: completedLevels ?? this.completedLevels,
      dailyProgressDate: dailyProgressDate ?? this.dailyProgressDate,
      dailyCompletedPuzzleIds:
          dailyCompletedPuzzleIds ?? this.dailyCompletedPuzzleIds,
      completedPracticePuzzleIds:
          completedPracticePuzzleIds ?? this.completedPracticePuzzleIds,
      lastChallengeDate: lastChallengeDate ?? this.lastChallengeDate,
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'childName': childName,
      'childAge': childAge.name,
      'createdAt': createdAt.toIso8601String(),
      'language': language.code,
      'completedChallenges': completedChallenges,
      'completedLevels': completedLevels,
      'dailyProgressDate': dailyProgressDate?.toIso8601String(),
      'dailyCompletedPuzzleIds': dailyCompletedPuzzleIds,
      'completedPracticePuzzleIds': completedPracticePuzzleIds,
      'lastChallengeDate': lastChallengeDate?.toIso8601String(),
      'remindersEnabled': remindersEnabled,
    };
  }

  factory FamilyProfile.fromJson(Map<String, Object?> json) {
    final lastChallengeDate = json['lastChallengeDate'] as String?;
    final dailyProgressDate = json['dailyProgressDate'] as String?;
    final dailyCompletedPuzzleIds =
        (json['dailyCompletedPuzzleIds'] as List<dynamic>?)
                ?.whereType<String>()
                .toList(growable: false) ??
            const <String>[];
    final completedPracticePuzzleIds =
        (json['completedPracticePuzzleIds'] as List<dynamic>?)
                ?.whereType<String>()
                .toList(growable: false) ??
            const <String>[];

    return FamilyProfile(
      childName: json['childName'] as String,
      childAge: ChildAge.fromName(json['childAge'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      language: AppLanguage.fromCode(json['language'] as String?),
      completedChallenges: json['completedChallenges'] as int? ?? 0,
      completedLevels: json['completedLevels'] as int? ??
          json['completedChallenges'] as int? ??
          0,
      dailyProgressDate:
          dailyProgressDate == null ? null : DateTime.parse(dailyProgressDate),
      dailyCompletedPuzzleIds: dailyCompletedPuzzleIds,
      completedPracticePuzzleIds: completedPracticePuzzleIds,
      lastChallengeDate:
          lastChallengeDate == null ? null : DateTime.parse(lastChallengeDate),
      remindersEnabled: json['remindersEnabled'] as bool? ?? true,
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
            language == other.language &&
            completedChallenges == other.completedChallenges &&
            completedLevels == other.completedLevels &&
            dailyProgressDate == other.dailyProgressDate &&
            _sameStringList(
              dailyCompletedPuzzleIds,
              other.dailyCompletedPuzzleIds,
            ) &&
            _sameStringList(
              completedPracticePuzzleIds,
              other.completedPracticePuzzleIds,
            ) &&
            lastChallengeDate == other.lastChallengeDate &&
            remindersEnabled == other.remindersEnabled;
  }

  @override
  int get hashCode {
    return Object.hash(
      childName,
      childAge,
      createdAt,
      language,
      completedChallenges,
      completedLevels,
      dailyProgressDate,
      Object.hashAll(dailyCompletedPuzzleIds),
      Object.hashAll(completedPracticePuzzleIds),
      lastChallengeDate,
      remindersEnabled,
    );
  }
}

bool _sameStringList(List<String> left, List<String> right) {
  if (left.length != right.length) {
    return false;
  }

  for (var i = 0; i < left.length; i++) {
    if (left[i] != right[i]) {
      return false;
    }
  }

  return true;
}
