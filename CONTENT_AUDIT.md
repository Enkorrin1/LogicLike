# Content Audit

This file tracks Phase 1 of the product improvement plan: audit the current
learning catalog before expanding it further.

## Current Catalog Snapshot

Last updated: 2026-06-13.

- Courses: 6 starter courses.
- Lessons: 60 unique lessons.
- Lesson steps: 240 registered lesson steps.
- Puzzle definitions: 16 registered families.
- Lesson format: mostly 4 steps per lesson.
- Localization: RU and EN are present for lesson titles and dynamic challenge
  text.
- Visual mode: SVG-based puzzle visuals and answer visuals are active.
- Catalog visibility: the Quest tab opens the full level catalog, while the
  daily mission remains a separate entry point.

## First Automated Audit Run

Status: complete.

Generated artifact:

- `CONTENT_AUDIT.json`

Result:

- Audited lesson steps: 240.
- Baseline structural issues: 0.
- Lesson title localization presence: passed for RU and EN.
- Correct answer appears in choices: passed.
- Supported visual family coverage: passed.

Initial finding:

- The first audit run found that `lesson.001`, `lesson.002`, and `lesson.004`
  had only 3 steps each.

Fix applied:

- Added `step.001.4` as a memory-pair step.
- Added `step.002.4` as a fruit-pattern step.
- Added `step.004.4` as a number-bridge step.
- Updated tests so every lesson from `lesson.001` to `lesson.060` must contain
  exactly 4 ordered steps.

## Current Puzzle Families

| Family | Current Status | Main Skill | Audit Notes |
| --- | --- | --- | --- |
| `shape-path` | Active | Pattern | Needs difficulty tiers beyond 2-item alternation. |
| `fruit-pattern` | Active | Pattern | Needs more item sets and less repetition. |
| `toy-count` | Active | Arithmetic | Good starter counting family; needs richer scenes. |
| `odd-card` | Active | Classification | Visual/text mismatch was fixed; needs more categories. |
| `memory-pairs` | Active | Memory | Needs true reveal-and-recall mechanics later. |
| `lock-key` | Active | Pairing | Works, but overlaps heavily with memory-pairs. |
| `shadow-match` | Active | Spatial | Needs more object-specific shadow assets. |
| `logic-train` | Active | Pattern | Needs more pattern rules than A-B-B repeat. |
| `sticker-sum` | Active | Arithmetic | Good starter sum mechanic; needs harder variants. |
| `balance-scale` | Active | Reasoning/math | Needs object diversity and multi-object balance. |
| `code-grid` | Active | Reasoning | Needs more rule types than simple increments. |
| `number-bridge` | Active | Arithmetic | Needs subtraction/missing addend variants. |
| `detail-count` | Active | Attention | Visual count now follows generated numbers. |
| `shape-rotation` | Active | Spatial | Needs answer choices showing actual rotations. |
| `space-sequence` | Active | Pattern | Needs more space objects and rule variety. |
| `shape-stack` | Active | Pattern/spatial | Needs stack/layer-specific visuals later. |

## Quality Checklist Per Lesson Step

Every step should pass these checks:

- Has a unique generated challenge id.
- Has a localized question in RU and EN.
- Has localized answer labels in RU and EN.
- Has a hint that teaches the rule.
- Has an explanation that confirms the reasoning.
- Has a matching visual generated from the same data as the text.
- Has a correct answer that exists in the visible choices.
- Has an age-appropriate difficulty level.
- Does not repeat the same puzzle family too often inside one lesson.
- Does not rely on a generic fallback visual unless intentionally designed.

## Known Product Risks

1. Puzzle variety is still shallow inside several families.
   Example: many pattern tasks are variations of two-item alternation.

2. Some families overlap too much.
   Example: `memory-pairs` and `lock-key` currently feel similar because both
   ask for object pairing.

3. Difficulty is implicit, not designed.
   The generator creates variants, but the catalog does not yet have a clear
   easy/medium/hard progression.

4. Some visual families are still symbolic.
   Example: `shape-rotation` and `shadow-match` need stronger object-specific
   illustrations.

5. Parent analytics can improve.
   Current panels are useful, but recommendations should connect more directly
   to concrete mistakes, hints, and puzzle families.

6. Content QA is not yet comprehensive.
   Tests catch important regressions, but there is no full automated report for
   every lesson-step combination yet.

## Phase 1 Work Items

### 1. Generate A Lesson-Step Inventory

Create a reviewed inventory with:

- lesson id,
- step id,
- puzzle id,
- puzzle family,
- skill tag,
- generated sample question,
- correct answer,
- choices,
- visual id,
- difficulty estimate.

Output:

- `CONTENT_AUDIT.md` summary table updates.
- Optional machine-readable `content_audit.json` for tests and future tooling.

### 2. Add Consistency Tests

Add automated tests that check:

- every registered lesson has steps,
- every step resolves to a puzzle definition,
- every generated challenge has non-empty choices,
- every correct answer appears in choices,
- every generated challenge has a supported visual family,
- every supported visual family has an asset/rendering path.

### 3. Mark Repetition Hotspots

Find lessons where:

- the same puzzle family repeats too often,
- the same answer pattern repeats,
- generated token sets are too similar,
- arithmetic values are too narrow.

### 4. Define Difficulty Tiers

Introduce a simple difficulty label:

- `easy`: recognition, 2-item patterns, counting up to 5.
- `medium`: 3-item rules, mixed choices, counting up to 10.
- `hard`: multi-step reasoning, grids, missing addends, rotations.

### 5. Prioritize Next Puzzle Mechanics

Next mechanics to implement after the audit:

1. Path/maze task.
2. Category sorting.
3. Visual attention search.
4. True memory reveal-and-choose.
5. Analogy task.
6. Missing addend/subtraction bridge.
7. Multi-object balance scale.

## Immediate Next Step

Build the automated lesson-step inventory and use it to identify the first
batch of weak/repetitive lessons.
