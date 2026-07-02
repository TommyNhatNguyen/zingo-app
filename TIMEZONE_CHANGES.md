# Timezone Handoff — Flutter Changes

## Why

Backend now computes streak "days" using the user's local calendar (IANA timezone) instead of UTC.
Without a timezone, a user in UTC+7 practicing after local midnight was recorded on the wrong day.

---

## Files Changed

### 1. `pubspec.yaml`

Added `flutter_timezone: ^3.0.0`.

> The `timezone` package already in the project is a timezone *data* library — it cannot read the device's current IANA zone. `flutter_timezone` uses native platform channels to return the IANA name (e.g. `Asia/Ho_Chi_Minh`).

---

### 2. `lib/domain/dtos/user-profile/user_profile_create_dto.dart`

Added optional `timezone` field to `UserProfileCreateDto`.

```dart
// before
UserProfileCreateDto({
  ...,
  this.notification_time,
  this.favorite_topics,
});

// after
UserProfileCreateDto({
  ...,
  this.notification_time,
  this.timezone,        // NEW
  this.favorite_topics,
});
```

---

### 3. `lib/domain/dtos/user-profile/user_profile_create_dto.g.dart`

Updated generated JSON serialization to include `timezone` in both `fromJson` and `toJson`.

---

### 4. `lib/domain/dtos/user-configuration/user_configuration_update_dto.dart`

Added optional `timezone` field to `UserConfigurationProfileDto`.

```dart
// before
class UserConfigurationProfileDto {
  final String? display_name;
  final String? mother_language;
}

// after
class UserConfigurationProfileDto {
  final String? display_name;
  final String? mother_language;
  final String? timezone;   // NEW
}
```

Uses `@JsonSerializable(includeIfNull: false)` — `timezone` is only sent when non-null (omitting it never overwrites the saved value on the server).

---

### 5. `lib/domain/dtos/user-configuration/user_configuration_update_dto.g.dart`

Updated generated JSON serialization for `UserConfigurationProfileDto`.

---

### 6. `lib/ui/onboarding/widgets/onboarding_screen.dart`

`onSubmit` is now `async`. It reads the device timezone before dispatching the bloc event.

```dart
// before
void onSubmit() {
  context.read<UserProfileCreateBloc>().add(
    UserProfileCreateTrigger(payload: UserProfileCreateDto(...)),
  );
}

// after
Future<void> onSubmit() async {
  String? tz;
  try {
    tz = await FlutterTimezone.getLocalTimezone();
  } catch (_) {}

  if (!context.mounted) return;
  context.read<UserProfileCreateBloc>().add(
    UserProfileCreateTrigger(
      payload: UserProfileCreateDto(..., timezone: tz),
    ),
  );
}
```

If `getLocalTimezone()` throws, `tz` stays null and the server defaults to UTC — no crash.

---

### 7. `lib/main.dart`

Three additions:

**a) `WidgetsBindingObserver` mixin** on `_MainAppState` to detect app resume.

**b) `_syncTimezone()`** — called right after a successful login. Sends the current device timezone to the backend via `PUT /v1/user-configuration`.

```dart
Future<void> _syncTimezone() async {
  try {
    final tz = await FlutterTimezone.getLocalTimezone();
    _lastSyncedTimezone = tz;
    await _userConfigurationRepository.updateUserConfiguration(
      UserConfigurationUpdateDto(
        profile: UserConfigurationProfileDto(timezone: tz),
      ),
    );
  } catch (_) {}
}
```

**c) `_syncTimezoneIfChanged()`** — called on every `AppLifecycleState.resumed`. Compares against `_lastSyncedTimezone` (in-memory) and only syncs if the zone actually changed (e.g. user traveled across timezones).

---

## When Timezone Is Sent


| Trigger                   | Method                                                  | Endpoint                     |
| ------------------------- | ------------------------------------------------------- | ---------------------------- |
| Onboarding submit         | In `UserProfileCreateDto`                               | `POST /v1/onboarding`        |
| Login (any method)        | `_syncTimezone()` in `BlocListener<AuthBloc>`           | `PUT /v1/user-configuration` |
| App resume (zone changed) | `_syncTimezoneIfChanged()` via `WidgetsBindingObserver` | `PUT /v1/user-configuration` |


---

## Setup After This PR

```bash
flutter pub get
cd ios && pod install  # flutter_timezone has a native iOS component
```

