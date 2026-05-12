# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this app is

**Lingo Snack (codename: zingo)** — a Flutter mobile app for English speaking practice. Users practice bite-size AI-generated dialogs turn-by-turn: AI speaks (TTS), user records their response, on-device STT transcribes it, the backend scores pronunciation/fluency/grammar and returns per-turn feedback. Gamified with streaks, XP, and badges.

## Commands

```bash
# Run on a connected device/simulator
flutter run

# Analyze (lint)
flutter analyze

# Run tests
flutter test

# Run a single test file
flutter test test/path/to/file_test.dart

# Code generation (run after editing any @JsonSerializable model)
# --force-jit required: Dart 3.10 rejects dart compile aot-snapshot when
# objective_c (via google_fonts→path_provider) has native build hooks
dart run build_runner build --delete-conflicting-outputs --force-jit

# Watch mode for code generation during development
dart run build_runner watch --delete-conflicting-outputs --force-jit
```

## Architecture

**State management:** BLoC (`flutter_bloc`). Every feature gets its own bloc in `lib/blocs/`. Screens consume blocs via `BlocProvider` / `BlocBuilder`.

**Routing:** GoRouter (`lib/routes/init.dart`). All routes are declared there. Navigation uses `context.go()` / `context.push()`.

**Networking:** Dio (`lib/services/`). API calls go through service classes; raw Dio is never called directly from screens or blocs.

**Serialization:** `json_serializable` + `json_annotation`. All DTOs in `lib/dtos/` carry `@JsonSerializable()`. After editing a DTO, run `build_runner`.

**Directory intent:**

| Directory | Purpose |
|---|---|
| `lib/config/` | Design system — colors, text styles, theme. Do not put logic here. |
| `lib/constants/` | App-wide string/enum constants |
| `lib/interfaces/` | Abstract service contracts (interfaces/abstract classes) |
| `lib/services/` | Concrete implementations of interfaces (Dio calls, Firebase, etc.) |
| `lib/blocs/` | BLoC classes — one subdirectory per feature |
| `lib/models/` | Domain models (pure Dart, no serialization annotations) |
| `lib/dtos/` | API request/response objects with `@JsonSerializable()` |
| `lib/widgets/` | Shared/reusable widgets only — no screen-specific widgets here |
| `lib/screens/` | One subdirectory per feature; each screen owns its local widgets |
| `assets/` | Static assets (SVG logo, images). Referenced in code as `'assets/filename'`. |

## Design system

All styling comes from `lib/config/`. Never hardcode colors, font sizes, or font weights inline.

```dart
// Colors
AppColors.primary          // ocean teal #0891B2
AppColors.accent           // deep orange #FF7043 — CTAs, streak flame
AppColors.highlight        // warm gold #FFB800 — XP, rewards
AppColors.scoreHigh/Mid/Low  // traffic-light for score bars
AppColors.streak / .xp / .badge  // gamification-specific

// Text styles (Plus Jakarta Sans throughout)
AppTextStyles.scoreNumber   // 28px w800 — per-turn score display
AppTextStyles.dialogLine    // 17px, height 1.7 — dialog turn text
AppTextStyles.streakCounter / .xpCounter  // gamification badges
AppTextStyles.feedbackQuote // italic feedback tip
AppTextStyles.callToAction  // motivational action labels

// Theme
AppTheme.light  // passed to MaterialApp.router — do not create a second ThemeData
```

Prefer `Theme.of(context).textTheme.*` for standard M3 text roles; use `AppTextStyles.*` only for the specialised styles that have no M3 equivalent (score numbers, dialog lines, counters).

## Environment

The app uses `flutter_dotenv`. Secrets (API base URL, keys) live in a `.env` file at the project root (not committed). Load with `await dotenv.load()` in `main()` before `runApp`.
