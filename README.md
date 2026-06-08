# LogicLike

LogicLike is a family-edtech mobile product for children aged 4-8.

The current product slice is a short daily task loop for a child and a
separate parent-facing area for family profile and subscription context.

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
