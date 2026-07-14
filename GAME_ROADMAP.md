# LogicLoka Game Roadmap

## Product Direction

LogicLoka is a Duolingo-style learning app for children aged 4-8.

The child follows one main level map. The map is not split into child-facing
categories like Logic, Math, Memory, or Attention. Each level contains mixed
cognitive tasks: logic, math, patterns, comparison, attention, memory, spatial
reasoning, and simple deduction.

Skill tags may exist internally for analytics, parent reports, and difficulty
balancing, but the child-facing journey is a single ordered progression.

## Core Child Loop

1. The child opens the app and sees the current point on the map.
2. The child starts the next available level.
3. The level contains a short lesson with 3-6 mixed puzzle steps.
4. Each step gives immediate feedback: correct, retry, hint, or explanation.
5. The level ends with rewards: XP, stars, streak progress, and possible sticker.
6. The next map node unlocks.

## Core Parent Loop

1. The parent sees completed levels and weekly activity.
2. The parent sees internal skill analytics, not separate child-facing tracks.
3. The parent gets a recommendation for the next practice area.
4. The parent can check pace, time, and weak task types.

## Stage 0 - Foundation

Goal:
Create the product and engineering base for a single Duolingo-like level map.

Scope:
- `LevelMap`
- `MapNode`
- `Lesson`
- `LessonStep`
- `PuzzleDefinition`
- `PuzzleAttempt`
- `Reward`
- `ChildProgress`
- `SkillTag` as internal analytics only

Rules:
- One ordered child-facing map.
- No separate child-facing development categories.
- Levels may mix different cognitive task types.
- Unlocking is based on previous map nodes, stars, streak, or parent settings.
- All future visible copy must be localization-ready.

Acceptance criteria:
- Spec clearly says the app is one map, not multiple skill tracks.
- Data model can support ordered levels and mixed puzzle types.
- Skill tags are clearly marked as internal-only.
- Next implementation can build the map screen without changing direction again.

## Stage 1 - Level Map Screen

Status: started.

Goal:
Build the child-facing Duolingo-style map.

What it should look like:
- Vertical or winding path of level nodes.
- Current level is bright and tappable.
- Completed levels show stars.
- Locked levels are visible but subdued.
- Top bar shows streak, hearts, XP/stars.
- Visual tone stays soft, 3D, child-friendly, and playful.

Acceptance criteria:
- Child can see where they are and what to do next.
- There is no visible category switcher for Logic/Math/Memory.
- The screen supports future expansion to many levels.

Current implementation order:
- Replace the home experience with the first level map.
- Seed 8 starter map nodes.
- Keep the current lesson entry connected to the existing challenge screen until
  the full lesson runner is ready.
- Then replace the temporary challenge route with the reusable lesson flow.

## Stage 2 - Lesson Flow

Goal:
Create the reusable lesson runner.

What it should look like:
- A progress indicator at the top.
- One puzzle step per screen.
- Large touch targets.
- Minimal text.
- Feedback states: correct, retry, hint, explanation, level complete.

Acceptance criteria:
- Lesson flow supports 3-6 steps.
- Puzzle steps can be mixed inside one lesson.
- Rewards are shown at the end of the lesson.

## Stage 3 - First Puzzle Types

Goal:
Add the first practical content set.

Puzzle types:
- Find the odd item.
- Continue the pattern.
- Match the pair.
- Sort by rule.
- Count and choose.
- Choose the path.

Acceptance criteria:
- At least 20 first-map steps exist.
- Every level mixes at least 2 task types after the first few onboarding levels.
- Puzzle text uses localization keys.

## Stage 4 - Motivation

Goal:
Make the daily loop sticky without making mistakes feel punishing.

Mechanics:
- Streak.
- Hearts.
- XP/stars.
- Stickers or collection rewards.
- Gentle hints after repeated mistakes.

Acceptance criteria:
- Child is encouraged to retry.
- Rewards are visible after level completion.
- Hearts do not block learning too aggressively.

## Stage 5 - Parent Analytics

Goal:
Give parents useful progress without turning the child UI into a dashboard.

Parent data:
- Levels completed.
- Weekly activity.
- Accuracy.
- Hard task types.
- Internal skill tag trends.
- Recommended next practice.

Acceptance criteria:
- Parent can understand progress in under 30 seconds.
- Internal categories stay in parent/reporting context only.

## Stage 6 - Adaptive Difficulty

Goal:
Adjust task difficulty based on performance.

Rules:
- Multiple correct answers raise difficulty gradually.
- Repeated mistakes trigger hints or easier variants.
- Difficulty changes happen inside the same map, not by sending the child into a separate category.

Acceptance criteria:
- The child remains on the same visible path.
- Parent analytics can explain why easier or harder tasks appeared.

## Stage 7 - Localization And QA

Goal:
Prepare the product for Russian and English from the start.

Scope:
- All visible text through l10n.
- No hardcoded visible lesson copy.
- Android emulator smoke check.
- iOS handoff checklist for macOS/Xcode.

Acceptance criteria:
- Russian and English copy can be maintained safely.
- Screens tolerate longer localized text.
- iOS risks are documented when not validated on macOS.

## Stage 8 - Game-Quality Puzzle Scenes

Status: started.

Goal:
Replace static card-like puzzle previews with small interactive game scenes.

Technology stack:
- Flame for puzzle scenes and game loop.
- Flame Audio for tactile puzzle sounds.
- Flutter Animate for surrounding Flutter transitions.
- Generated bitmap/WebP/PNG art for rich scene-based puzzles.
- Rive/Lottie/Spine as asset-backed upgrades when production animation files
  are available.
- Forge2D for future physics puzzles.

First conversion order:
1. Secret cards: timed reveal, card flip, replay control, animated stage.
2. Spot the difference: generated paired scenes with hit targets.
3. Jigsaw puzzle: draggable pieces with snapping.
4. Word search and words-from-word: interactive board, path tracing, feedback.
5. Math crossword: grid entry, animated validation, reward state.
6. Logic/ordering scenes: object movement instead of static icon rows.

Acceptance criteria:
- Converted puzzles feel like mini-games, not button rows.
- Each scene has visible motion or interaction before the answer is chosen.
- The child's actions inside the scene determine correctness. A decorative
  animation followed by the shared three-answer picker does not count as a
  converted puzzle.
- Every puzzle family has its own primary interaction: tracing, dragging,
  sorting, assembling, timing, matching, drawing, balancing, routing, or
  manipulating a simulated object. Reusing the same interaction requires a
  meaningfully different rule and play rhythm.
- Wrong actions produce immediate visual feedback inside the scene without
  ending the attempt or shaming the child.
- Game state and answer keys remain locale-independent. Text-heavy puzzles use
  locale-specific board data for all 12 supported locales, including RTL.
- Puzzle answer rules stay deterministic and covered by existing rule tests.
- The locked soft 3D/cartoon visual direction remains intact.

Current audit baseline:
- 60 puzzle ids in the catalog.
- 28 currently submit an answer from their scene.
- 32 still depend on the shared answer picker and require conversion or a
  scene-state integration pass.

Priority conversion backlog:
1. `memory-pairs`: flip and match all pairs on a real card grid.
2. `sound-order`: replay a Simon-style light and sound sequence.
3. `beacon-signal`: react when a moving beam reaches the requested sector.
4. `story-order`: drag illustrated events into the correct timeline.
5. `route-maze`: navigate to the goal and finish from the board state.
6. `shape-tangram`: drag, rotate, and snap pieces into a silhouette.
7. `two-differences`: mark differences directly on paired illustrations.
8. `word-grid`: trace adjacent locale-specific letters or symbols.
9. `what-changed`: restore a changed object in an animated scene.
10. `final-orbit`: rotate route tiles and launch the rocket through them.
