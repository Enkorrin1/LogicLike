# LogicX

LogicX is a family-edtech mobile product for children aged 4-8.

The current product direction is Duolingo-style cognitive training focused on logic
and math through short lessons, repetition loops, and one clear level-by-level
map. Cognitive skill tags are used internally for analytics, not as separate
child-facing tracks.

See `PROJECT_SPEC.md` for the working product, platform, localization, testing,
Runner, and Watcher rules.

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
