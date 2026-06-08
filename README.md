# LogicLike

LogicLike is a Flutter family-edtech mobile app for children aged 4-12.

The current direction is a LogicLike-style learning hub: daily missions, puzzle
courses, short explainable tasks, rewards, progress, and parent analytics. The
project uses LogicLike as a public product benchmark, but all UI, content,
assets, and implementation must remain original.

See `PROJECT_SPEC.md` for product, platform, localization, testing, Runner, and
Watcher rules. See `GAME_ROADMAP.md` for the active development roadmap.

## Mobile

The Flutter app lives in `mobile`.

```powershell
cd mobile
flutter pub get
flutter analyze
flutter test
```

If platform folders are not present yet, generate them after installing the
Flutter SDK:

```powershell
cd mobile
flutter create . --platforms=android,ios
```
