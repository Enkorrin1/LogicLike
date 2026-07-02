# LogicLoka Mobile

Flutter implementation of the LogicLoka family-edtech app.

## First product slice

- onboarding for a child profile
- age selection limited to 4-8
- local family profile persistence through `SharedPreferences`
- home/challenge/parent shell
- focused model and storage tests

## Commands

```powershell
flutter pub get
flutter analyze
flutter test
```

## iOS

The iOS runner is generated in `ios` with bundle id `com.logicx.mobile`.

On macOS with Xcode and CocoaPods installed:

```bash
flutter pub get
cd ios
pod install
cd ..
flutter run -d ios
```

iOS builds cannot be produced on Windows because Apple's toolchain requires
macOS and Xcode.
