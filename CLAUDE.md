# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project state

`ilac_takip` ("medication tracking" in Turkish) is a Flutter app. Implemented so far: login / register / temporary home screens backed by **Firebase Authentication** (email/password). drift, notifications, Firestore and Storage are not added yet. Update this file as real structure is introduced.

## Architecture

- `lib/constants/app_info.dart`: app name (currently "Saatinde") and slogan. Never hard-code the name. If it changes, also update `android:label` in `AndroidManifest.xml` and `CFBundleDisplayName` in `ios/Runner/Info.plist` (they can't read Dart constants).
- `lib/theme/app_theme.dart`: single source of colors (`AppColors`), sizes (`AppSizes`: min touch target 56, button height 64) and `AppTheme.light`. Use these and don't hard-code colors or sizes in screens.
- `lib/services/`: `AuthService` is an interface (`auth_service.dart`). `auth_providers.dart` exposes it through Riverpod (`authServiceProvider`), and `authStateProvider` (a stream of `AppUser?`) drives navigation. The app uses `FirebaseAuthService` (name stored in the Firebase profile's `displayName`; it listens to `userChanges()` so the name shows up right after sign-up; Firebase error codes → Turkish via `authErrorMessage`). `FakeAuthService` (waits 1 s, always succeeds) is used **only in tests** via `authServiceProvider.overrideWithValue(...)`, because tests can't reach Firebase. Services throw `AuthException` with a user-facing Turkish message. `validators.dart` holds form rules + Turkish messages.
- `lib/screens/auth_gate.dart`: root widget. It shows `LoginScreen` or `HomeScreen` based on `authStateProvider`. Screens never navigate on login/logout themselves. The exception is `RegisterScreen`, which is pushed and therefore pops itself (`popUntil(isFirst)`) after sign-up.
- `lib/widgets/`: shared form pieces. Field errors are not Flutter's default `errorText`. They're shown in a `MessageBox` (icon + large text) below the field, and only after the first submit attempt. `AnimatedMessage` animates them in and out, honoring the OS "disable animations" setting.
- Visual style: dark teal primary (`#00574B`). Screens use a `HeaderBand` (gradient top band, rounded bottom) with an `AppCard` overlapping it via `Transform.translate`.
- Font: the bundled **Atkinson Hyperlegible Next** (`assets/fonts/`, OFL). `ThemeData.fontFamily` does *not* reach `ButtonStyle.textStyle`, so any `TextStyle` passed to a button style must set `fontFamily: AppTheme.fontFamily` (the theme's `textTheme` styles already do).
- Firebase: project `ilactakip-f2ec7`, set up with `flutterfire configure` (`lib/firebase_options.dart`, `android/app/google-services.json`). `main()` calls `Firebase.initializeApp` before `runApp`. `GoogleService-Info.plist` for iOS was **not** generated (it can't be on Windows); `firebase_options.dart` covers iOS for now. Re-run `flutterfire configure` on a Mac before shipping iOS. The FlutterFire CLI isn't on PATH: run it as `%LOCALAPPDATA%\Pub\Cacheinlutterfire.bat`.
- Tests: `test/auth_screens_test.dart` drives the real app through `IlacTakipApp` with the fake auth override, and needs `pump(Duration(seconds: 1))` to get past the fake delay (`pumpAndSettle` alone hangs while a spinner is visible). After an error disappears, call `pumpAndSettle` before counting messages, because the fading-out box is still in the tree for a moment. `MaterialApp` is localized to Turkish via `flutter_localizations`.

Package / bundle ID is **`com.canerkutluk.ilactakip`** (Android `applicationId` + `namespace`, iOS `PRODUCT_BUNDLE_IDENTIFIER`). It is deliberately independent of the display name, and Firebase apps are registered under it, so don't change it.

Target platforms are **Android and iOS only**. The web, windows, linux and macos folders were deliberately removed, so don't re-add them (e.g. avoid a bare `flutter create .`, which regenerates every platform).

## Commands

```bash
flutter pub get                      # install dependencies
flutter run                          # run on the default device (Android emulator/device; pick one with -d <id>, list with `flutter devices`)
flutter analyze                      # lint (flutter_lints via analysis_options.yaml)
flutter test                         # run all tests
flutter test test/widget_test.dart   # run a single test file
flutter test --plain-name "Counter increments smoke test"  # run a single test by name
dart format .                        # format
```

## Conventions

- Dart SDK constraint is `^3.12.2`, and the code already uses **dot shorthands** (e.g. `colorScheme: .fromSeed(...)`, `mainAxisAlignment: .center`). Keep this style, and don't "fix" it as a syntax error.
- Lints: the default `package:flutter_lints/flutter.yaml` set with no custom rules.

## Proje bağlamı
- Bitirme projesi: yaşlılar ve kronik hastalar için Flutter ilaç takip uygulaması. Android öncelikli, Windows'ta geliştiriliyor.
- Özellikler: ilaç ekleme (kutu fotoğrafı → TFLite modeli, yedek: karekod / adla arama), doz hatırlatma, "içtim/atladım" takibi, stok ve SKT, aile paneli, prospektüs (Kullanma Talimatı) modülü.
- Uygulama doz önermez, tıbbi tavsiye vermez.
- Teknoloji: Riverpod, drift (yerel veritabanı), flutter_local_notifications, Firebase (yalnızca auth, firestore, storage).
- Tasarım: büyük yazı, büyük butonlar (en az 56 px), yüksek kontrast. Renk tek başına anlam taşımaz (ikon + yazı kullanılır).
- Arayüz metinleri Türkçe, kod ve dosya adları İngilizce.

## Benimle çalışma şekli
- Ben öğrenciyim, bu benim bitirme projem. Bana her zaman Türkçe cevap ver.
- Her değişiklikten sonra ne yaptığını ve nedenini kısaca, sade bir dille açıkla.
- Büyük bir işe başlamadan önce planını göster.
