# Laboratory Work 11 — Offline-First Notes & Settings Vault

Flutter app demonstrating local persistence with `SharedPreferences`.

## Run

```bash
flutter pub get
flutter run
```

## Included

- Loads the saved dark-mode preference before `runApp()` to avoid a light-theme flash.
- Persists the username and a JSON-encoded `List<NoteItem>` locally.
- Supports adding, completing, and deleting notes with immediate persistence.
- All data remains available offline and survives an app process restart.

## Cold restart demonstration

1. Save a name, turn on dark mode, and add two notes.
2. Force-quit the app from the simulator/emulator or device app switcher.
3. Reopen it and show that the name, theme, and notes have been restored.
