# LogicLike Release QA Checklist

## Automated Gate

Run from `mobile/`:

```powershell
$env:TEMP='D:\Project\LogicLike\.tmp'
$env:TMP='D:\Project\LogicLike\.tmp'
$env:PUB_CACHE='D:\Project\LogicLike\.pub-cache'
$env:GRADLE_USER_HOME='D:\Project\LogicLike\.gradle-home'
& 'D:\Program Files\flutter\bin\dart.bat' run tool/release_qa.dart --build-debug --build-release
```

Pass criteria:

- localization audit: 0 issues,
- content audit: 0 issues,
- `flutter analyze`: no issues,
- `flutter test`: all tests pass,
- debug APK builds,
- release APK builds.

## Android Emulator Smoke

Use an installed debug APK on `emulator-5554` or another attached device.

1. Launch app: `adb shell am start -n com.logiclike.logic_like/.MainActivity`.
2. Home: check greeting, hearts, stars, course grid, bottom tabs.
3. Quest tab: open full level catalog and start one available lesson.
4. Lesson: select wrong answer, see hint/retry, then select correct answer.
5. Reward: finish lesson and confirm summary, XP/sticker/reward copy.
6. Collection: open sticker collection from home and return.
7. Parent: open analytics, weekly plan, history, subscription/settings.
8. Language: switch RU to EN and back; verify bottom nav and parent settings.
9. Restart app; verify saved profile, language, progress remain.
10. Capture screenshots for home, quest catalog, lesson, reward, collection,
    parent dashboard, and language settings.

## iOS Handoff

Needs macOS/Xcode owner validation:

- build on iPhone simulator,
- build on iPad simulator,
- test RU/EN language switching,
- check safe areas, keyboard, and bottom navigation,
- verify icons and launch screen,
- capture iPhone and iPad screenshots.

## Store Prep

- Final app icon in all required Android/iOS sizes.
- Privacy policy URL ready.
- Store screenshots selected from real app screens.
- Short and full descriptions localized RU/EN.
- Confirm analytics/storage wording matches actual implementation.
- Replace debug signing with production signing before store upload.
