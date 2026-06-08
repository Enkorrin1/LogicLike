# LogicLike Game Roadmap

## Product Direction

LogicLike is a family-edtech mobile app inspired by the public LogicLike product
model: short logic puzzles, themed courses, daily missions, hints, explanations,
progress, rewards, and parent-visible analytics.

The child-facing experience is not a Duolingo-style single road anymore. The
home screen is a colorful learning hub with:

- today's mission,
- course/category cards,
- progress summary,
- collection/rewards,
- parent entry point.

The app must not copy proprietary LogicLike brand assets, exact UI, exact task
texts, or protected content. We use the product structure as a benchmark and
build original visuals, content, wording, and implementation.

## Core Child Loop

1. The child opens the app and sees the daily mission plus available courses.
2. The child starts a short mission or a course lesson.
3. A lesson contains 3-6 puzzle steps with mixed cognitive tasks.
4. Each step gives immediate feedback, hint, retry state, and explanation.
5. The lesson ends with stars, XP, streak progress, and possible sticker reward.
6. Parent analytics updates internal skill tags and next-practice suggestions.

## Puzzle Families

MVP puzzle families:

- find the odd item,
- continue the pattern,
- match the pair,
- sort by rule,
- count and choose,
- compare quantities,
- remember details,
- simple deduction,
- spatial shape rotation/position,
- beginner rebuses and visual riddles.

Internal skill tags can track logic, math, attention, memory, spatial reasoning,
patterns, and comparison. These tags are for analytics and balancing; course
cards can be child-friendly labels rather than diagnostic categories.

## Stage 1 - Home Learning Hub

Status: active.

Goal:
Replace the Duolingo map with a LogicLike-style dashboard.

What it should look like:

- Top greeting with avatar, stars, hearts, and streak.
- Large daily mission card with playful 3D character/space visual.
- Course cards for logic, math, attention, memory, spatial tasks, and rebuses.
- Compact cards for progress and collection.
- Soft 3D child-friendly visual tone.

Acceptance criteria:

- Child immediately sees one obvious task to start.
- Courses are visible from the first screen.
- No vertical level-map path is shown.
- All visible text goes through localization.

## Stage 2 - Course Catalog

Goal:
Create a real course catalog data model and connect cards to lessons.

Scope:

- `Course`, `CourseSection`, `Lesson`, `LessonStep`, `PuzzleDefinition`.
- Course progress: completed lessons, stars, accuracy, recommended next lesson.
- Course cards with lock/open/completed states.
- First 6 starter courses with 3-5 lessons each.

## Stage 3 - Puzzle Renderers

Status: started.

Goal:
Move beyond simple text choices and create visual puzzle components.

Renderers:

- pattern row,
- odd item grid,
- counting scene,
- pair matching,
- rule sorting,
- memory cards,
- spatial choice grid,
- rebus card.

Current implementation:

- visual pattern row for sequence tasks,
- counting scene for toy-count tasks,
- odd-item card row,
- logic train row,
- sticker sum scene,
- memory-pair key scene,
- number/code grid,
- number bridge,
- detail comparison scene.
- visual answer cards with selected/correct/wrong states,
- child-controlled hint button before answer checking.

## Stage 4 - Content Expansion

Goal:
Grow from starter content into a usable educational catalog.

Targets:

- 60+ MVP puzzle definitions,
- age bands for 4-5, 6-7, and 8+,
- hints and explanations for every puzzle,
- stable localization keys for every user-visible text.

## Stage 5 - Rewards And Motivation

Status: started.

Goal:
Make daily practice feel rewarding without hiding learning clarity.

Mechanics:

- streak,
- hearts,
- stars/XP,
- sticker collection,
- daily mission completion,
- gentle retry and hint system.

Current implementation:

- lesson completion reward moment,
- sticker unlock card,
- star and XP reward tiles,
- collection and streak reward tiles.

## Stage 6 - Parent Analytics

Goal:
Give parents a clear picture of progress and weak areas.

Parent data:

- completed missions and courses,
- weekly activity,
- accuracy,
- hard puzzle families,
- internal skill tag trends,
- recommended next practice.

## Stage 7 - Adaptive Difficulty

Goal:
Adjust difficulty inside courses based on attempts.

Rules:

- several correct answers raise difficulty gradually,
- repeated mistakes trigger hints or easier variants,
- recommendations use skill tags and age band,
- adaptation stays explainable for parents.

## Stage 8 - Localization And QA

Scope:

- all visible text through l10n,
- Android emulator smoke checks,
- Flutter analyze/test/build checks,
- iOS handoff checklist for macOS/Xcode.
