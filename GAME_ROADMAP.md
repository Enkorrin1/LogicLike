# LogicLike Game Roadmap

## Master Improvement Plan

Goal:
Build a best-in-class children's learning app with short playful lessons,
strong puzzle variety, adaptive difficulty, visible progress, rewards, and a
useful parent dashboard.

Working principles:

- Keep the app child-first: short tasks, clear visuals, soft feedback, no
  overloaded text.
- Keep the content original: use LogicLike as a product benchmark, not as a
  source to copy protected content or assets.
- Every puzzle must have matching visuals, localized text, a correct answer,
  a hint, and an explanation.
- Parent-facing analytics should explain progress in practical language, not
  only show counters.
- Every stage should leave tests behind so regressions are caught early.

### Phase 1 - Content Audit And Quality Map

Status: done.

Goal:
Create a reliable inventory of the current learning bank and expose weak spots
before adding more content.

Scope:

- List every lesson, step, puzzle family, skill tag, answer type, visual id, and
  generated data source.
- Mark repeated or too-similar tasks.
- Mark missing or weak visual coverage.
- Mark localization gaps and broken/garbled text.
- Mark difficulty level for each step: easy, medium, hard.
- Produce a prioritized fix list.

Acceptance criteria:

- The audit covers all 60 lessons and 240 lesson steps.
- Each puzzle family has a visible quality status.
- The next content tasks are concrete enough to implement one by one.

### Phase 2 - Puzzle Mechanics Expansion

Status: in progress.

Completed:

- Added the first new expansion mechanic: Path and maze task.
- Connected it to lesson coverage in lessons 56 and 60.
- Added generated variants, direction choices, a dedicated lesson renderer,
  RU/EN dynamic labels, content audit support, and regression tests.

Goal:
Add more genuinely different puzzle mechanics so the app feels rich instead of
repeating the same few templates.

Priority mechanics:

- Odd one out.
- Continue the sequence.
- Missing item or number.
- Pair match.
- Quantity comparison.
- Shadow match.
- Shape rotation.
- Simple balance scale.
- Path and maze task.
- Category sorting.
- Memory reveal-and-choose task.
- Table/grid rule.
- Analogy task.
- Visual attention search.
- Multi-step reasoning challenge.

Acceptance criteria:

- At least 12 puzzle families have dedicated renderers.
- Each new family has RU/EN localization, visual assets, tests, and sample
  lesson coverage.

### Phase 3 - Lesson Progression And Difficulty

Status: in progress.

Completed:

- Added explicit lesson difficulty tiers: starter, growing, confident,
  challenge.
- Added lesson step roles: warm-up, core, stretch, review.
- Exposed course skill arcs and per-lesson skill mixes in the course UI.
- Added regression tests for balanced course progression and duplicate
  mechanic prevention.

Goal:
Make the content feel like a designed learning program.

Scope:

- Define difficulty tiers for ages 4-5, 6, 7-8.
- Sequence lessons from simple recognition to multi-step reasoning.
- Add warm-up, core challenge, and stretch challenge structure.
- Prevent back-to-back duplicate mechanics in a lesson.
- Ensure every course has a clear learning arc.

Acceptance criteria:

- Each course has 20 lessons with visible progression.
- Each lesson mixes skills without feeling random.
- Parent analytics can explain what the course trains.

### Phase 4 - Adaptive Difficulty

Status: in progress.

Completed:

- Added an `AdaptiveLessonPlan` that reads recent accuracy, hints, mistakes,
  and breaks in practice.
- Lesson generation now supports warm-up, steady, and stretch modes.
- Numeric puzzles become lighter or harder predictably, and route puzzles can
  reduce distractors in support mode.
- Lesson and parent screens explain the current adaptive mode.
- Added tests for adaptive mode selection and generated puzzle changes.

Goal:
Respond to the child's performance.

Rules:

- Fast correct answers gradually unlock harder variants.
- Wrong answers trigger retry state, clearer hint, or easier follow-up.
- Frequent hint usage creates review recommendations.
- Returning after inactivity starts with a lighter warm-up.
- Parent screen explains why a recommendation appears.

Acceptance criteria:

- Lesson generation reads recent performance.
- Adaptation remains predictable and testable.
- Parent recommendations match actual mistakes and hints.

### Phase 5 - Visual Polish And Animation

Status: in progress.

Completed:

- Added animated answer selection states with scale, shadow, and smoother
  correctness icons.
- Added animated lesson feedback transitions for correct and retry states.
- Added a pop-in reward moment for the sticker completion visual.
- Added animated reward tiles on the lesson completion screen.
- Added widget regression checks so the polish layer stays present.

Goal:
Make every lesson feel like a polished children's product.

Scope:

- Dedicated SVG scenes for every puzzle family.
- More 3D-like characters and reward assets.
- Correct/wrong answer micro-interactions.
- Sticker unlock animation.
- Better answer cards for children: larger, clearer, more tactile.
- Visual QA for text-image mismatches.

Acceptance criteria:

- No puzzle shows a visual that contradicts its text.
- No puzzle falls back to generic text-only visuals unless intentionally
  designed.
- Main screens pass visual checks on emulator.

### Phase 6 - Motivation And Retention

Status: in progress.

Completed:

- Added a `MotivationPlan` that computes the daily practice goal, current
  daily progress, next collection reward, and next streak milestone.
- Added a Daily Bonus card to the home screen with progress and reward chips.
- Connected the card to existing practice sessions, stars, and streak data.
- Added domain and widget tests for the motivation loop.

Goal:
Make daily practice rewarding without hiding learning clarity.

Scope:

- Daily mission.
- Streaks.
- Stars, XP, and hearts.
- Sticker collection.
- Weekly chest or bonus.
- Character growth or unlockable accessories.
- Replay/review missions.

Acceptance criteria:

- Rewards are connected to lesson completion and practice quality.
- Collection has enough unlocks to support repeated play.
- Daily loop does not hide the full level catalog.

### Phase 7 - Parent Dashboard Upgrade

Status: in progress.

Completed:

- Added a `ParentWeeklyReport` that classifies the week as getting started,
  support needed, steady, or strong.
- Added a parent weekly action plan with three concrete next steps.
- Connected the action plan to weekly sessions, minutes, accuracy, hints, and
  mistakes.
- Added domain and widget tests for the parent report.

Goal:
Make the parent screen a reason to trust the app.

Scope:

- Weekly time and session summary.
- Strongest skill.
- Skill needing practice.
- Accuracy and mistake trends.
- Recent lesson history.
- Child profile management.
- Language settings.
- Subscription/settings panel.
- Practical recommendations for the next week.

Acceptance criteria:

- Key parent controls are visible near the top.
- Analytics are understandable without technical skill names.
- Recommendations are backed by recorded practice data.

### Phase 8 - Localization And Text Quality

Goal:
Keep the app shippable in Russian and English.

Status: implemented.

Scope:

- Audit all strings for RU/EN coverage.
- Remove garbled encoding anywhere visible.
- Keep child-facing text short and warm.
- Keep parent-facing text clear and specific.
- Add tests for required localization keys.

Acceptance criteria:

- No visible string bypasses localization.
- All new content is localized before it is merged.
- Tests catch missing lesson titles and puzzle text.

Current implementation:

- added `LOCALIZATION_GUIDE.md` with voice, glossary, engineering rules, and
  QA checklist,
- added `dart run tool/localization_audit.dart` to compare RU/EN ARB keys,
  placeholder sets, and suspicious mojibake patterns,
- added localization quality tests for ARB parity, placeholders, mojibake, and
  RU/EN model helper copy,
- confirmed the codebase should treat PowerShell mojibake as terminal display
  noise unless UTF-8 file reads show real corrupt bytes.

### Phase 9 - Reliability, QA, And Release Prep

Goal:
Prepare the app for real device testing and eventual store packaging.

Status: implemented.

Scope:

- Widget tests for navigation and core lesson flows.
- Content consistency tests.
- Visual smoke screenshots on emulator.
- Android debug/release build hygiene.
- App icon and splash screen.
- Privacy policy and store screenshot plan.
- GitHub repository publishing flow.

Acceptance criteria:

- Full test suite passes before every handoff.
- APK builds cleanly.
- Main screens are manually checked on emulator.

Current implementation:

- added `mobile/tool/release_qa.dart` as a single automated QA gate for
  localization audit, content audit, analyze, tests, and optional APK builds,
- added `RELEASE_QA_CHECKLIST.md` for Android emulator smoke, iOS handoff, and
  store-prep checks,
- added `PRIVACY_POLICY_DRAFT.md` documenting the current local-only data model,
- added widget coverage for Russian quest navigation into a lesson,
- added widget coverage for parent reset returning to onboarding,
- replaced the plain white Android launch background with a branded sky color.

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

## Content Production Plan

Goal:
Turn the app from a working learning shell into a rich children's puzzle product
with many high-quality, individual, visual tasks. Every puzzle should feel like
a small scene, not a duplicated template with swapped words.

Quality rules:

- each puzzle has unique content, not repeated generic text,
- every puzzle has matching visuals for the exact objects, colors, quantities,
  and answer choices mentioned in the text,
- all child-facing and parent-facing copy is localized RU/EN,
- each puzzle has a prompt, question, answer choices, hint, and explanation,
- puzzle visuals use app-style SVG/illustration assets, not standard icons,
- lessons mix puzzle mechanics and avoid repeated mechanics back-to-back,
- content audits must catch missing assets, missing localization, invalid
  answers, visual/text mismatches, and suspicious encoding.

### Phase 10 - Content Architecture

Goal:
Create a scalable content system for many unique puzzle scenes.

Status: implemented.

Scope:

- design a richer `PuzzleContent` model,
- include puzzle type, age, difficulty, skill tags, world/theme, character,
  scene asset, answer assets, animation hints, localization keys, correct
  answer, hint, and explanation,
- update lesson assembly so lessons can draw from the richer puzzle model,
- extend content audit for required assets and RU/EN parity,
- migrate the current puzzle catalog into the new structure.

Acceptance criteria:

- new puzzles can be added without changing screen logic,
- every visible text comes from localization or localized puzzle content,
- every puzzle can declare exact scene and answer visuals,
- audit fails when text and visuals are incomplete.

Current implementation:

- added `PuzzleContentCatalog` with content type, world, character, pose,
  difficulty, skill tags, scene asset, supporting assets, required objects,
  color metadata, number slots, localization keys, and animation cues,
- mapped all 17 current starter puzzle families into rich content metadata,
- added asset resolution for visual answer choices, numeric answers, expression
  answers, and path-direction answers,
- extended content audit to validate content metadata, localization keys,
  scene/supporting assets, character assets, and answer-choice assets,
- added tests proving every starter puzzle family has content metadata and that
  referenced assets exist,
- added RU/EN path-maze localization keys for future direct content use.

### Phase 11 - Puzzle Type Library

Goal:
Build 12-15 reusable puzzle mechanics with strong visual presentation.

Status: implemented.

Puzzle types:

- `pattern_sequence`: continue a visual row,
- `odd_one_out`: find the item that does not belong,
- `counting`: count objects in a scene,
- `comparison`: compare groups, quantities, or details,
- `pair_matching`: match objects that belong together,
- `shadow_match`: match an object to its silhouette,
- `spatial_rotation`: choose the same rotated shape,
- `path_logic`: choose a path or direction,
- `memory_recall`: remember and choose a hidden/missing object,
- `sorting_rule`: sort by shared rule,
- `visual_math_story`: solve a small illustrated math story,
- `logic_deduction`: infer the answer from clues,
- `detail_search`: find a specific detail in a busy scene,
- `missing_piece`: choose the missing part of an image,
- `symbol_code`: solve a color/shape/number code.

Acceptance criteria:

- each type has renderer support,
- each type has at least 5 seed puzzles,
- each type supports RU/EN prompt, hint, and explanation,
- answer choices can show SVG visuals.

Current implementation:

- added four new reusable puzzle families: `memory-recall`, `sorting-rule`,
  `missing-piece`, and `logic-deduction`,
- added lesson generation logic for each new family with unique tokens,
  answer choices, correct answer, hint, and explanation paths,
- added visual renderers for hidden-card recall, rule-box sorting, missing
  picture part, and two-clue deduction,
- wired the new mechanics into the mid-course lesson route while keeping early
  onboarding and first-lesson smoke flows stable,
- added RU/EN localization keys for the new mechanics and answer label support,
- extended `PuzzleContentCatalog`, content audit, and tests to cover the new
  types and their SVG answer assets.

### Phase 12 - Thematic Worlds

Goal:
Make puzzles varied by placing them inside recognizable worlds.

Status: implemented.

Worlds:

- Space: rockets, planets, stars, astronaut,
- Forest: paths, berries, mushrooms, woodland scenes,
- Sea: fish, shells, islands, boat,
- Toy City: blocks, cars, robots, shelves,
- Magic School: keys, chests, crystals, potions,
- Laboratory: buttons, tubes, machines, code panels,
- Farm: animals, baskets, harvest, fences.

Each world includes:

- 1-2 recurring characters,
- object asset pack,
- background/scene patterns,
- 10-30 puzzles,
- lightweight animations.

Acceptance criteria:

- each world has a consistent asset style,
- puzzles from different worlds feel visually different,
- lessons can mix worlds or stay inside one mini-story.

Implemented:

- added reusable world theme metadata with gradients, accent colors, and ambient
  assets,
- surfaced world and guide character labels in the lesson header with RU/EN
  localization,
- connected world themes to the puzzle visual scene container,
- added world and character distribution to the content audit,
- added tests for world theme coverage and ambient asset availability.

### Phase 13 - Content Pack 1: 100 Unique Puzzles

Goal:
Create the first large content pack with real variety.

Status: implemented.

Target distribution:

- 20 pattern puzzles,
- 15 odd-one-out puzzles,
- 15 counting puzzles,
- 10 comparison puzzles,
- 10 pair matching puzzles,
- 10 shadow matching puzzles,
- 10 path logic puzzles,
- 10 memory/detail puzzles.

Acceptance criteria:

- 100 puzzle definitions pass audit,
- no puzzle uses a mismatched scene,
- no answer choice lacks a visual,
- all puzzles have RU/EN text, hint, and explanation.

Implemented:

- added `ContentPackCatalog.phase13Items` with 100 unique puzzle definitions,
- matched the planned distribution across pattern, odd-one-out, counting,
  comparison, pair matching, shadow matching, path logic, and memory/detail
  puzzles,
- connected lesson generation to phase 13 variants by matching puzzle family,
- extended content audit with phase 13 item counts, uniqueness, family
  distribution, category distribution, and visual answer checks,
- added automated tests for pack size, uniqueness, distribution, assets, and
  lesson generation coverage.

### Phase 14 - Content Pack 2: 300+ Levels

Goal:
Scale from a good demo catalog to a deep learning product.

Scope:

- 60 easy tasks,
- 120 medium tasks,
- 80 hard tasks,
- 40 mixed review tasks,
- boss lessons after major blocks.

Boss lesson format:

- 4-6 tasks in one mini-adventure,
- one character guides the child,
- final reward or sticker,
- mixed mechanics with a clear difficulty curve.

Acceptance criteria:

- at least 300 level-ready puzzle steps,
- difficulty rises smoothly,
- lessons avoid mechanical repetition,
- review/boss lessons feel special.

### Phase 15 - Animation And Delight

Goal:
Make puzzles feel alive without making the UI noisy.

Animations:

- correct answer bounces or glows,
- wrong answer gently shakes,
- character celebrates success,
- character thinks during hint,
- stars fly into the counter,
- sticker reveal animation,
- hint appears as a lightbulb moment,
- path puzzles animate the character moving.

Acceptance criteria:

- animations are short and lightweight,
- animations do not block reading,
- no layout jumps on small screens,
- reduced-motion mode can disable nonessential motion later.

### Phase 16 - Character System

Goal:
Create recurring helpers that make content emotionally memorable.

Characters:

- Leo the lion: main helper,
- Nick the astronaut: space puzzles,
- Robi the robot: code and logic,
- Mia the fox: focus and memory,
- Captain Whale: sea puzzles,
- Owl Coach: hints and explanations.

Each character needs:

- idle pose,
- happy pose,
- thinking pose,
- hint pose,
- holding object pose,
- victory pose.

Acceptance criteria:

- puzzle definitions can reference a character and pose,
- characters appear in lesson and reward moments,
- character visuals match the app's soft 3D/SVG style.

### Phase 17 - Content QA Automation

Goal:
Prevent duplicated, broken, or mismatched content from entering the app.

Checks:

- every puzzle has RU/EN text,
- every puzzle has prompt, question, hint, explanation,
- every answer choice exists and has a visual,
- correct answer exists among choices,
- scene asset exists,
- visual object/color/count metadata matches localized text,
- no unsupported standard icons are used as puzzle art,
- no suspicious mojibake,
- no duplicate puzzle shown too close to itself,
- lesson difficulty progression is smooth.

Acceptance criteria:

- content audit fails on missing or mismatched puzzle data,
- audit report explains exactly what to fix,
- release QA includes content QA by default.

### Phase 18 - Product Integration

Goal:
Use the expanded content system throughout the app.

Application:

- home daily mission selects one bright puzzle or mini-lesson,
- course lessons pull balanced tasks from the content library,
- recommended lesson targets weak skills,
- collection rewards unlock after content blocks,
- parent dashboard reports skill strengths and weak spots by puzzle type,
- weekly recommendations can say what to practice next.

Acceptance criteria:

- content is visible in home, course, lesson, collection, and parent analytics,
- every lesson has a clear mini-story or theme,
- parent recommendations are backed by actual puzzle performance data.

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
- expanded starter courses to 8 lessons each,
- added lessons `lesson.013` through `lesson.024` with 4 ordered steps each,
- connected 24 starter lessons to 96 registered lesson steps.
- expanded starter courses to 12 lessons each,
- added lessons `lesson.025` through `lesson.036` with 4 ordered steps each,
- added localized RU/EN lesson titles for the full 36-lesson catalog,
- connected 36 starter lessons to 144 registered lesson steps.
- expanded starter courses to 20 lessons each,
- added lessons `lesson.037` through `lesson.060` with 4 ordered steps each,
- added localized RU/EN lesson titles for the full 60-lesson catalog,
- connected 60 starter lessons to 240 registered lesson steps.
- replaced repeated lesson payload reuse with per-step generated variants,
- each lesson step now has a unique challenge id, generated numbers/items, localized question, hint, and explanation,
- added test coverage that catches repeated/under-specified generated lesson content.

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

## Stage 13 - Lesson Review Summary

Status: started.

Goal:
Make the end of a lesson more informative for the child and useful for the
quality loop introduced in earlier stages.

Scope:

- show a friendly lesson summary on the completion screen,
- surface questions, hints, and mistakes without making it feel punitive,
- keep the reward moment visible,
- localize the new summary copy,
- cover the summary in widget tests.

Current implementation:

- lesson completion now receives total questions, hint count, and wrong attempts,
- added a child-friendly lesson summary card before reward tiles,
- summary copy changes for perfect runs versus supported runs,
- added RU/EN localization for summary labels and messages,
- extended the reward completion widget test.

## Stage 14 - Continue After Lesson

Status: started.

Goal:
Let the child continue learning from the completion screen without returning to
the home catalog first.

Scope:

- show a next-lesson action when another lesson is available,
- prefer the next unfinished lesson in the same course route,
- fall back to any unfinished starter lesson,
- reset lesson state correctly when moving from one lesson to another,
- keep the home action available as a secondary choice.

Current implementation:

- completion screen now shows a localized next lesson button when possible,
- `LessonScreen` computes the next unfinished lesson from starter courses,
- `FamilyShell` can switch directly to the next lesson,
- lesson screen instances are keyed by lesson id so state resets correctly,
- widget coverage now verifies continuation from the reward screen.

## Stage 15 - Parent Practice History

Status: started.

Goal:
Give parents a concrete recent-lesson timeline, not only aggregate weekly
metrics.

Scope:

- show recent completed sessions in the parent area,
- include date, minutes, accuracy, hints, and mistakes,
- keep the panel compact with the latest five lessons,
- provide an empty state for new profiles,
- localize all visible copy.

Current implementation:

- added a practice history panel below skill recommendations,
- recent sessions are sorted newest first and capped to five rows,
- each row shows localized skill, date/minutes, accuracy, hints, and mistakes,
- added RU/EN localization for history copy,
- added widget coverage for parent practice history.
