# LogicLoka Project Spec

## Product

LogicLoka is a family-edtech mobile product for children aged 4-8.

Product goal:

- Build a Duolingo-style learning engine for logic and math skills: short lessons,
  frequent repetition loops, adaptive difficulty, and visible progression.
- Combine game motivation (XP, streaks, hearts, stickers) with one main
  level-by-level map that parents can track and understand.
- Do not expose separate child-facing learning categories like Logic, Math,
  Memory, or Attention as independent tracks. These can exist internally as
  analytics tags, but the child progresses through one ordered map.

Current product slice:

- Duolingo-like learning loop: one child-facing lesson map, ordered level
  progression, mixed task types inside levels, and a reward loop for the child.
- Separate parent-facing area for family profile, progress summary, and weekly
  recommendations.
- Onboarding with child age selection limited to 4-8.
- Local family profile persistence and deterministic local progress model.

## Visual Style Lock

The current child-facing visual style is locked and must not be replaced during
feature or content work.

- Keep the soft 3D cartoon look with volumetric characters and playful
  children-focused cards.
- Preserve the home screen direction with the 3D lion avatar, astronaut mission
  hero, area character portraits, rounded white panels, teal/coral/pastel
  palette, large readable Russian copy, and bottom tab shell.
- Do not replace main characters, mission art, area portraits, or reward visuals
  with flat generic SVG icons.
- SVGs are allowed for small functional symbols only: arrows, stars, tabs,
  progress markers, and simple puzzle tokens when they do not replace the main
  3D character/art direction.
- New levels and puzzle content must be added inside this style, using matching
  volumetric/generated art where a character, hero object, or scene illustration
  is needed.
- Any proposed visual redesign must be explicitly approved by the user before
  implementation.

## Stack

- Flutter and Dart.
- Single codebase for Android and iOS.
- Local persistence currently uses `SharedPreferences`.
- App code lives in `mobile`.
- UI, domain models, storage, and feature screens should stay separated under `mobile/lib/src`.

## Puzzle Game Stack

Puzzle screens must move away from static Flutter card mockups and toward
small game scenes.

Primary stack:

- `flame` is the default engine for new interactive puzzle scenes.
- `flame_audio` is the default sound layer for puzzle feedback, taps, success,
  retry, reveals, and reward moments.
- `flutter_animate` is allowed for surrounding Flutter UI transitions when a
  full Flame scene is not needed.

Approved asset/animation direction:

- Use generated bitmap/WebP/PNG scene art for rich puzzles such as spot the
  difference, story scenes, jigsaw puzzles, and character-led tasks.
- Use Rive for future interactive character animation when `.riv` assets are
  available.
- Use Lottie for future reward/confetti/checkpoint animations when `.json`
  animation assets are available.
- Use Spine only for higher-production skeletal character animation where the
  project accepts the asset and licensing workflow.
- Use Forge2D through Flame only for physics-based puzzles such as balance,
  bridge, rolling objects, levers, or weight tasks.

Implementation rules:

- New puzzle visuals should be built as reusable `GameWidget`/Flame scenes
  under the challenge feature, not as rows of static icon buttons.
- Flutter remains responsible for navigation, localization, answer controls,
  parent screens, and app shell.
- Flame scenes own game-like rendering, timed reveal, object movement,
  particles, drag/tap interactions, and scene feedback.
- Keep the locked soft 3D/cartoon art direction; do not replace characters or
  illustrated scenes with flat generic SVG icons.
- Every converted puzzle type should keep deterministic answer rules and remain
  testable without requiring a running game loop for domain correctness.

## Platform Rules

- Primary local validation on this machine is Android emulator / Windows Flutter tooling.
- iOS must remain build-compatible, but final iPhone/iPad validation is done on macOS with Xcode.
- Do not introduce platform-specific behavior unless it is isolated behind a clear boundary.
- Any iOS-sensitive change should mention what still needs macOS/Xcode verification.

## Localization Rules

Localization must be planned from the start.

- New user-visible UI copy should be added through Flutter localization once l10n scaffolding is enabled.
- Use stable semantic keys, not copy-as-key strings.
- Preserve placeholders exactly and use ICU/library pluralization for counts.
- Use locale-aware formatting for dates, numbers, percentages, currency, and relative time.
- Avoid fixed text containers that break with longer translations.
- Target locales are `ar`, `de`, `en`, `es`, `fr`, `hi`, `it`, `ja`,
  `ko`, `pt`, `ru`, and `zh` unless a specific project decision explicitly
  replaces this list.
- Existing hard-coded strings should be migrated incrementally when touching related screens.

Recommended Flutter l10n direction:

- Add `flutter_localizations` and `intl`.
- Add `l10n.yaml`.
- Store ARB files under `mobile/lib/l10n`.
- Generate strongly typed localization accessors.
- Cover important localized screens with widget tests.

## Testing Rules

Every meaningful implementation task should include verification.

- Run `flutter analyze` from `mobile` when Flutter SDK is available.
- Run `flutter test` from `mobile` when Flutter SDK is available.
- Add or update focused tests for changed behavior.
- Backend/API changes, when introduced, must get their own focused tests.
- If a command cannot be run locally, state the exact reason and what should be checked elsewhere.

## Role Map

Use separate Codex threads for independent responsibility areas. Every role
must read this spec before doing work.

### Runner

Runner is the implementation thread.

- Read this spec before starting a task.
- Make scoped changes only.
- Prefer existing project structure and patterns.
- Keep Flutter Android/iOS compatibility in mind.
- Add localization and tests as part of the task, not as a later afterthought.
- Report what changed and which commands passed or could not be run.

### Watcher

Watcher is the review/control thread.

- Read this spec before reviewing.
- Inspect current git status and changed files.
- Check whether Runner followed the stack, platform, localization, and testing rules.
- Run `flutter analyze` and `flutter test` from `mobile` when available.
- Fix small, safe issues directly.
- For larger issues, report concrete findings with file references.
- Keep feedback focused on correctness, maintainability, localization readiness, iOS/Android compatibility, and test coverage.

### Spec Keeper

Spec Keeper owns the product and engineering spec.

- Keep `PROJECT_SPEC.md` aligned with current product decisions.
- Turn chat decisions into clear requirements, constraints, and acceptance criteria.
- Detect scope creep and contradictions.
- Keep the spec short enough to be useful during implementation.
- Do not silently change product direction; report decision points for the user.

### QA Tester

QA Tester owns verification.

- Run available checks from `mobile`, especially `flutter analyze` and `flutter test`.
- Review tests for the changed behavior, not just snapshot coverage.
- Create concise manual test checklists for Android emulator validation.
- Note what still needs iPhone/iPad validation on macOS.
- Prefer reproducible findings with exact steps and expected vs actual behavior.

### Localization Lead

Localization Lead owns i18n and copy readiness.

- Review new user-visible strings and push them toward Flutter l10n.
- Keep the required locale set as `ar`, `de`, `en`, `es`, `fr`, `hi`, `it`,
  `ja`, `ko`, `pt`, `ru`, and `zh` unless changed by an explicit product
  decision.
- Prefer stable semantic keys.
- Preserve placeholders and use ICU/library pluralization for counts.
- Check text expansion, mobile truncation risk, punctuation, tone, and terminology.
- Use locale-aware formatting for dates, numbers, percentages, currency, and relative time.

### iOS Gatekeeper

iOS Gatekeeper owns iOS compatibility from the Windows side.

- Inspect iOS project files, plugin choices, platform-specific code, and build assumptions.
- Flag anything that likely needs Xcode, CocoaPods, signing, or iPhone/iPad validation.
- Keep Android-first local testing from hiding iOS regressions.
- Do not claim iOS is fully verified unless it was checked on macOS with Xcode.

### UX Reviewer

UX Reviewer owns product usability and visual fit.

- Review whether the app is clear and appealing for children aged 4-8.
- Keep child flow and parent flow distinct.
- Prefer short, direct copy and obvious interactive states.
- Check touch target clarity, visual hierarchy, onboarding friction, and empty/error states.
- Call out places where a screen feels too adult, too dense, or unclear.

### Release Manager

Release Manager owns release readiness.

- Check versioning, release notes, test status, known risks, and platform handoff.
- Ensure Android local validation and iOS/macOS validation tasks are separated clearly.
- Summarize blockers before a release build.
- Do not let a task be marked release-ready when tests, localization, or platform checks are unresolved.

## Done Criteria

A task is done only when:

- The requested behavior is implemented.
- Relevant tests are added or updated.
- Available checks pass, or blockers are clearly documented.
- User-visible copy is localization-ready.
- iOS risks are called out when they cannot be tested on Windows.

## Current Product Roadmap

- See `GAME_ROADMAP.md` for the active roadmap and acceptance criteria.
- Stage 0 is the Foundation stage and is currently active.

### Stage 0 Scope

- Data architecture for a lesson-first learning model:
  - `LevelMap`
  - `MapNode`
  - `Lesson`
  - `LessonStep`
  - `PuzzleDefinition`
  - `PuzzleAttempt`
  - `Reward`
  - `ChildProgress`
  - `SkillTag` for internal analytics only
- Core learning rules:
  - lesson flow with immediate feedback,
  - adaptive difficulty hints/penalty rules,
  - hearts and streak mechanics,
  - ordered level unlocking logic,
  - mixed cognitive task types inside one progression map.
- Stable IDs and localization keys for all future content text.
- No platform-specific shortcuts in new game core logic.
