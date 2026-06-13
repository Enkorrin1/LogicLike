# LogicLike Localization Guide

## Locales

- Source locale: `ru`
- Supported locales: `ru`, `en`
- Product: children's learning app for ages 4-8 plus parent dashboard.

## Voice

- Child-facing copy: short, warm, playful, clear.
- Parent-facing copy: practical, calm, specific, trust-building.
- Buttons: action verbs, 1-3 words when possible.
- Avoid long explanations inside compact cards.

## Glossary

- `LogicLike` stays unchanged.
- `Quest`: short child-facing mission or lesson flow.
- `Lesson`: structured 4-step learning activity.
- `Sticker collection`: reward collection.
- `Parent` / `Family hub`: parent-facing area.
- `XP`: keep as `XP`.

## Engineering Rules

- Preserve placeholders exactly: `{childName}`, `{count}`, `{minutes}`.
- Preserve ICU plural blocks in ARB files.
- Use locale-aware formatting for dates, percentages, and lists.
- Add RU and EN text together.
- New visible copy should go through `AppLocalizations` or
  `LocalizedModels`, not raw screen literals.
- Run `dart run tool/localization_audit.dart` before handoff.

## QA Checklist

- RU and EN have matching keys.
- Placeholder sets match for each key.
- No suspicious mojibake patterns such as `Ð`, `Ñ`, `Ã`, `Â`, `â`,
  `вЂ`, or replacement characters.
- Child text fits mobile cards.
- Parent text remains specific and actionable.
