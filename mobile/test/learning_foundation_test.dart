import 'package:flutter_test/flutter_test.dart';
import 'package:logic_like/src/domain/learning_foundation.dart';

void main() {
  group('FoundationCatalog', () {
    test('starter courses expose twenty lessons', () {
      for (final course in FoundationCatalog.starterCourses) {
        expect(course.lessonIds.length, 20);
      }
    });

    test('expanded catalog contains sixty lessons', () {
      expect(FoundationCatalog.starterLessons.length, greaterThanOrEqualTo(60));
    });

    test('expanded lessons contain four ordered steps', () {
      for (var index = 1; index <= 60; index += 1) {
        final lessonId = 'lesson.${index.toString().padLeft(3, '0')}';
        final lesson = FoundationCatalog.lessonForId(lessonId);
        final steps = FoundationCatalog.stepsForLesson(lesson);

        expect(steps.length, 4);
        expect(steps.map((step) => step.order), [1, 2, 3, 4]);
      }

      expect(FoundationCatalog.starterLessonSteps.length, 240);
    });

    test('course lesson ids resolve to lessons with registered puzzle content',
        () {
      final lessonIds =
          FoundationCatalog.starterLessons.map((lesson) => lesson.id).toSet();
      final stepIds =
          FoundationCatalog.starterLessonSteps.map((step) => step.id).toSet();
      final puzzleIds =
          FoundationCatalog.starterPuzzles.map((puzzle) => puzzle.id).toSet();

      for (final course in FoundationCatalog.starterCourses) {
        for (final lessonId in course.lessonIds) {
          expect(lessonIds, contains(lessonId));
        }
      }

      for (final lesson in FoundationCatalog.starterLessons) {
        for (final stepId in lesson.stepIds) {
          expect(stepIds, contains(stepId));
        }
      }

      for (final step in FoundationCatalog.starterLessonSteps) {
        expect(puzzleIds, contains(step.puzzleId));
      }
    });

    test('lessons expose a stable warm-up core stretch structure', () {
      for (final lesson in FoundationCatalog.starterLessons) {
        final steps = FoundationCatalog.stepsForLesson(lesson);

        expect(FoundationCatalog.roleForStep(steps[0]), LessonStepRole.warmUp);
        expect(FoundationCatalog.roleForStep(steps[1]), LessonStepRole.core);
        expect(FoundationCatalog.roleForStep(steps[2]), LessonStepRole.core);
        expect(FoundationCatalog.roleForStep(steps[3]), LessonStepRole.stretch);
      }
    });

    test('course difficulty progresses in four balanced tiers', () {
      for (final course in FoundationCatalog.starterCourses) {
        final tiers = [
          for (final lessonId in course.lessonIds)
            FoundationCatalog.difficultyForCourseLesson(
              course,
              FoundationCatalog.lessonForId(lessonId),
            ),
        ];

        expect(tiers.where((tier) => tier == LessonDifficultyTier.starter),
            hasLength(5));
        expect(tiers.where((tier) => tier == LessonDifficultyTier.growing),
            hasLength(5));
        expect(tiers.where((tier) => tier == LessonDifficultyTier.confident),
            hasLength(5));
        expect(tiers.where((tier) => tier == LessonDifficultyTier.challenge),
            hasLength(5));
      }
    });

    test('lessons avoid back-to-back duplicate puzzle mechanics', () {
      for (final lesson in FoundationCatalog.starterLessons) {
        expect(
          FoundationCatalog.hasAdjacentDuplicateMechanics(lesson),
          isFalse,
          reason: '${lesson.id} should not repeat the same mechanic twice',
        );
      }
    });
  });
}
