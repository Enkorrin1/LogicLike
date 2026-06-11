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

Status: started.

Goal:
Grow from starter content into a usable educational catalog.

Targets:

- 60+ MVP puzzle definitions,
- age bands for 4-5, 6-7, and 8+,
- hints and explanations for every puzzle,
- stable localization keys for every user-visible text.

Current implementation:

- added `shadow-match` spatial outline task,
- added `balance-scale` comparison/math task,
- added `shape-rotation` spatial rotation task,
- connected new tasks to starter lessons and visual renderers.
- expanded starter courses to at least 4 lessons each,
- added lessons `lesson.009` through `lesson.012` with 4 ordered steps each.

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

Status: started.

Goal:
Give parents a clear picture of progress and weak areas.

Parent data:

- completed missions and courses,
- weekly activity,
- accuracy,
- hard puzzle families,
- internal skill tag trends,
- recommended next practice.

Current implementation:

- weekly skill insights panel,
- strongest practiced area,
- focus area based on least-practiced weekly skill,
- parent-facing next-practice recommendation.

## Stage 7 - Adaptive Difficulty

Status: started.

Goal:
Adjust difficulty inside courses based on attempts.

Rules:

- several correct answers raise difficulty gradually,
- repeated mistakes trigger hints or easier variants,
- recommendations use skill tags and age band,
- adaptation stays explainable for parents.

Current implementation:

- course progress now uses concrete completed lesson ids instead of only map node count,
- course lessons show completed/current/locked states,
- course header highlights the next recommended lesson, earned stars, and completed XP,
- finishing a course lesson records that exact lesson id and avoids duplicate completion rewards on repeats,
- legacy saved map progress migrates into lesson progress.

## Stage 8 - Localization And QA

Status: started.

Scope:

- all visible text through l10n,
- Android emulator smoke checks,
- Flutter analyze/test/build checks,
- iOS handoff checklist for macOS/Xcode.

Current implementation:

- added widget coverage for concrete course lesson progress states,
- split course progress metric/status copy into dedicated localized keys,
- verified `flutter analyze`,
- verified full Flutter test suite,
- built debug APK,
- installed and launched the app on Android Emulator,
- captured an emulator smoke screenshot.

## Stage 9 - Collection And Rewards

Status: started.

Goal:
Turn rewards into a visible child motivation loop instead of a static home card.

Scope:

- collection screen opened from the home hub,
- unlocked and locked sticker cards,
- reward thresholds based on earned stars,
- localized reward titles, descriptions, and locked states,
- widget coverage for opening the collection from home.

Current implementation:

- added a sticker collection screen,
- made the home collection summary card tappable,
- added six starter rewards with star unlock thresholds,
- added localized RU/EN collection copy,
- added widget coverage for the collection flow.

## Stage 10 - Accuracy And Attempts

Status: started.

Goal:
Make lesson completion useful for parent analytics and future adaptive
difficulty, not only for unlocking rewards.

Scope:

- track correct answers and total questions per lesson session,
- track wrong attempts during a lesson,
- track hint usage per lesson step,
- show weekly accuracy and hint usage in the parent analytics screen,
- keep legacy saved profiles compatible with the new session fields.

Current implementation:

- extended practice sessions with quality metrics,
- lesson flow now reports completed questions, hints, and wrong attempts,
- parent analytics includes weekly accuracy and hints,
- added RU/EN localization keys for the new metrics,
- added model/controller tests for session quality data and migration.

## Stage 11 - Adaptive Recommendations

Status: started.

Goal:
Use lesson quality data to explain what the child should practice next.

Scope:

- rank practiced skills by quality, not only by session count,
- detect low accuracy, hint reliance, and repeated wrong attempts,
- show parent-facing recommendations with a concrete reason,
- localize adaptive recommendation copy,
- keep the recommendation explainable and gentle.

Current implementation:

- skill insights now score each skill with accuracy, hints, wrong attempts, and practice volume,
- focus area uses the lowest quality score,
- parent recommendation changes when accuracy is low, hints are high, or wrong attempts repeat,
- added localized EN/RU adaptive recommendation messages,
- added widget coverage for an accuracy-based recommendation.

## Stage 12 - Recommended Lesson Route

Status: started.

Goal:
Turn recommendations into an immediate child-facing action on the home screen.

Scope:

- show the next recommended lesson on the home screen,
- pick the first unfinished lesson from the child's learning goal route,
- fall back to the first unfinished starter lesson,
- open the recommended lesson directly without forcing the child through the catalog,
- keep the route localized and covered by widget tests.

Current implementation:

- added a home recommended lesson card under the daily mission,
- wired the card to open a concrete `LessonScreen`,
- added RU/EN copy for the recommended lesson card,
- added widget coverage for opening the recommended lesson from home.
