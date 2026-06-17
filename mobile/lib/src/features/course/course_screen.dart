import 'package:flutter/material.dart';

import '../../domain/family_profile.dart';
import '../../domain/learning_foundation.dart';
import '../../l10n/l10n.dart';
import '../home/home_screen.dart';

class AllLevelsScreen extends StatelessWidget {
  const AllLevelsScreen({
    required this.profile,
    required this.onStartLesson,
    required this.onBackHome,
    super.key,
  });

  final FamilyProfile profile;
  final ValueChanged<String> onStartLesson;
  final VoidCallback onBackHome;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const courses = FoundationCatalog.starterCourses;
    final allLessonIds = [
      for (final course in courses) ...course.lessonIds,
    ];
    final uniqueLessonIds = allLessonIds.toSet();
    final completedCount = uniqueLessonIds
        .where(profile.activeChild.completedLessonIds.contains)
        .length;
    final totalSteps = FoundationCatalog.starterLessonSteps.length;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF2),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 112),
          children: [
            _CourseHeader(
              title: l10n.courseCatalogTitle,
              subtitle: l10n.courseLessonMeta(totalSteps, totalSteps * 10),
              completedCount: completedCount,
              totalCount: uniqueLessonIds.length,
              stars: completedCount,
              xp: completedCount * 20,
              currentLessonIndex: completedCount,
              onBackHome: onBackHome,
            ),
            const SizedBox(height: 16),
            for (final course in courses) ...[
              _CourseSectionHeader(
                course: course,
                completedCount: course.lessonIds
                    .where(profile.activeChild.completedLessonIds.contains)
                    .length,
              ),
              const SizedBox(height: 10),
              for (var index = 0; index < course.lessonIds.length; index += 1)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _LessonCard(
                    lesson: FoundationCatalog.lessonForId(
                      course.lessonIds[index],
                    ),
                    course: course,
                    index: _lessonNumber(course.lessonIds[index]) - 1,
                    state: _stateForLesson(course.lessonIds[index]),
                    onStart: () => onStartLesson(course.lessonIds[index]),
                  ),
                ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }

  _CourseLessonState _stateForLesson(String lessonId) {
    if (profile.activeChild.completedLessonIds.contains(lessonId)) {
      return _CourseLessonState.completed;
    }

    String? nextLessonId;
    for (final lesson in FoundationCatalog.starterLessons) {
      if (!profile.activeChild.completedLessonIds.contains(lesson.id)) {
        nextLessonId = lesson.id;
        break;
      }
    }

    return lessonId == nextLessonId
        ? _CourseLessonState.current
        : _CourseLessonState.open;
  }

  int _lessonNumber(String lessonId) {
    return int.tryParse(lessonId.split('.').last) ?? 1;
  }
}

class _CourseSectionHeader extends StatelessWidget {
  const _CourseSectionHeader({
    required this.course,
    required this.completedCount,
  });

  final CourseDefinition course;
  final int completedCount;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.titleForCourse(course),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppPalette.ink,
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ),
          const SizedBox(width: 10),
          _StatusPill(
            label: l10n.courseProgress(completedCount, course.lessonIds.length),
            color: AppPalette.teal,
          ),
        ],
      ),
    );
  }
}

class CourseScreen extends StatelessWidget {
  const CourseScreen({
    required this.profile,
    required this.course,
    required this.onStartLesson,
    required this.onBackHome,
    super.key,
  });

  final FamilyProfile profile;
  final CourseDefinition course;
  final ValueChanged<String> onStartLesson;
  final VoidCallback onBackHome;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final lessons = [
      for (final lessonId in course.lessonIds)
        FoundationCatalog.lessonForId(lessonId),
    ];
    final progress = _CourseProgress.fromLessons(
      lessons: lessons,
      completedLessonIds: profile.activeChild.completedLessonIds,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF2),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 112),
          children: [
            _CourseHeader(
              title: l10n.titleForCourse(course),
              subtitle:
                  '${l10n.subtitleForCourse(course)}\n${l10n.courseArcSummary(course)}',
              completedCount: progress.completedCount,
              totalCount: lessons.length,
              stars: progress.completedCount,
              xp: progress.completedXp,
              currentLessonIndex: progress.currentIndex,
              onBackHome: onBackHome,
            ),
            const SizedBox(height: 16),
            for (var index = 0; index < lessons.length; index += 1)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _LessonCard(
                  lesson: lessons[index],
                  course: course,
                  index: index,
                  state: progress.stateFor(index),
                  onStart: () => onStartLesson(lessons[index].id),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CourseHeader extends StatelessWidget {
  const _CourseHeader({
    required this.title,
    required this.subtitle,
    required this.completedCount,
    required this.totalCount,
    required this.stars,
    required this.xp,
    required this.currentLessonIndex,
    required this.onBackHome,
  });

  final String title;
  final String subtitle;
  final int completedCount;
  final int totalCount;
  final int stars;
  final int xp;
  final int currentLessonIndex;
  final VoidCallback onBackHome;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final progress =
        totalCount == 0 ? 0.0 : (completedCount / totalCount).clamp(0.0, 1.0);
    final nextLessonLabel = completedCount >= totalCount
        ? l10n.courseCompletedState
        : l10n.courseLessonTitle(currentLessonIndex + 1);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppPalette.ink.withValues(alpha: 0.10),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton.filledTonal(
                onPressed: onBackHome,
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppPalette.ink,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
              const SizedBox(
                width: 72,
                height: 72,
                child: Image(
                  image: AssetImage('assets/images/generated/rocket.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppPalette.muted,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              color: AppPalette.teal,
              backgroundColor: const Color(0xFFDDF8F4),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.courseProgress(
                completedCount.clamp(0, totalCount), totalCount),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppPalette.muted,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _CourseMetric(
                  icon: Icons.flag_rounded,
                  label: l10n.courseNextMetricLabel,
                  value: nextLessonLabel,
                  color: AppPalette.coral,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _CourseMetric(
                  icon: Icons.star_rounded,
                  label: l10n.courseStarsMetricLabel,
                  value: '$stars',
                  color: const Color(0xFFFFC739),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _CourseMetric(
                  icon: Icons.bolt_rounded,
                  label: l10n.courseXpMetricLabel,
                  value: '$xp',
                  color: AppPalette.teal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  const _LessonCard({
    required this.lesson,
    required this.course,
    required this.index,
    required this.state,
    required this.onStart,
  });

  final Lesson lesson;
  final CourseDefinition course;
  final int index;
  final _CourseLessonState state;
  final VoidCallback? onStart;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final completed = state == _CourseLessonState.completed;
    final current = state == _CourseLessonState.current;
    final difficulty =
        FoundationCatalog.difficultyForCourseLesson(course, lesson);
    final skillTags = FoundationCatalog.primarySkillTagsForLesson(lesson);
    final color = completed
        ? AppPalette.teal
        : current
            ? AppPalette.coral
            : const Color(0xFF5C8EF7);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppPalette.ink.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: Icon(
              completed
                  ? Icons.star_rounded
                  : current
                      ? Icons.psychology_alt_rounded
                      : Icons.play_arrow_rounded,
              color: color,
              size: 31,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.titleForLesson(lesson, fallbackNumber: index + 1),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppPalette.ink,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.courseLessonMeta(lesson.stepIds.length, lesson.xpReward),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppPalette.muted,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                _StatusPill(
                  label: _labelForState(l10n, state),
                  color: color,
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _StatusPill(
                      label: l10n.lessonDifficultyLabel(difficulty),
                      color: AppPalette.coral,
                    ),
                    _StatusPill(
                      label: l10n.lessonSkillMixLabel(skillTags),
                      color: const Color(0xFF5C8EF7),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          FilledButton(
            onPressed: onStart,
            style: FilledButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              minimumSize: const Size(84, 46),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: Text(
              completed
                  ? l10n.courseRepeatButton
                  : l10n.courseStartLessonButton,
            ),
          ),
        ],
      ),
    );
  }

  String _labelForState(
    AppLocalizations l10n,
    _CourseLessonState state,
  ) {
    return switch (state) {
      _CourseLessonState.completed => l10n.courseCompletedState,
      _CourseLessonState.current => l10n.courseOpenState,
      _CourseLessonState.open => l10n.courseOpenState,
    };
  }
}

enum _CourseLessonState {
  completed,
  current,
  open,
}

class _CourseProgress {
  const _CourseProgress({
    required this.lessons,
    required this.completedLessonIds,
    required this.currentIndex,
  });

  final List<Lesson> lessons;
  final Set<String> completedLessonIds;
  final int currentIndex;

  int get completedCount {
    return lessons
        .where((lesson) => completedLessonIds.contains(lesson.id))
        .length;
  }

  int get completedXp {
    return lessons
        .where((lesson) => completedLessonIds.contains(lesson.id))
        .fold<int>(0, (total, lesson) => total + lesson.xpReward);
  }

  _CourseLessonState stateFor(int index) {
    final lesson = lessons[index];
    if (completedLessonIds.contains(lesson.id)) {
      return _CourseLessonState.completed;
    }
    if (index == currentIndex) {
      return _CourseLessonState.current;
    }
    return _CourseLessonState.open;
  }

  static _CourseProgress fromLessons({
    required List<Lesson> lessons,
    required List<String> completedLessonIds,
  }) {
    final completed = completedLessonIds.toSet();
    var currentIndex = lessons.length;
    for (var index = 0; index < lessons.length; index += 1) {
      if (!completed.contains(lessons[index].id)) {
        currentIndex = index;
        break;
      }
    }

    return _CourseProgress(
      lessons: lessons,
      completedLessonIds: completed,
      currentIndex: currentIndex,
    );
  }
}

class _CourseMetric extends StatelessWidget {
  const _CourseMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 82),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppPalette.ink,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppPalette.muted,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w900,
              ),
        ),
      ),
    );
  }
}
