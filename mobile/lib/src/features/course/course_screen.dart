import 'package:flutter/material.dart';

import '../../domain/family_profile.dart';
import '../../domain/learning_foundation.dart';
import '../../l10n/l10n.dart';
import '../home/home_screen.dart';

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
    final completedCount = profile.activeChild.completedMapNodeIds.length
        .clamp(0, lessons.length);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF2),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 112),
          children: [
            _CourseHeader(
              title: l10n.titleForCourse(course),
              subtitle: l10n.subtitleForCourse(course),
              completedCount: completedCount,
              totalCount: lessons.length,
              onBackHome: onBackHome,
            ),
            const SizedBox(height: 16),
            for (var index = 0; index < lessons.length; index += 1)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _LessonCard(
                  lesson: lessons[index],
                  index: index,
                  completed: index < completedCount,
                  current: index == completedCount,
                  onStart: index <= completedCount
                      ? () => onStartLesson(lessons[index].id)
                      : null,
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
    required this.onBackHome,
  });

  final String title;
  final String subtitle;
  final int completedCount;
  final int totalCount;
  final VoidCallback onBackHome;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final progress = totalCount == 0 ? 0.0 : (completedCount / totalCount).clamp(0.0, 1.0);

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
            l10n.courseProgress(completedCount.clamp(0, totalCount), totalCount),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppPalette.muted,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  const _LessonCard({
    required this.lesson,
    required this.index,
    required this.completed,
    required this.current,
    required this.onStart,
  });

  final Lesson lesson;
  final int index;
  final bool completed;
  final bool current;
  final VoidCallback? onStart;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final color = completed
        ? AppPalette.teal
        : current
            ? AppPalette.coral
            : const Color(0xFFB9CACD);

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
              completed ? Icons.star_rounded : Icons.psychology_alt_rounded,
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
                  l10n.courseLessonTitle(index + 1),
                  maxLines: 1,
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
            child: Text(completed ? l10n.courseRepeatButton : l10n.courseStartLessonButton),
          ),
        ],
      ),
    );
  }
}
