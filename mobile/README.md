# Mobile App (Flutter)

## Prereqs
- Install Flutter SDK: https://docs.flutter.dev/get-started/install
- Android Studio (for Android emulator + SDK) OR connect an Android phone via USB.

## Run
```bash
cd mobile
flutter pub get
flutter run
```

## What works in this MVP
- Full app flow & UI from the proposal:
  - Splash → Connect → Trackpad (gestures) → Keyboard overlay → Voice-to-type (local transcription UI stub)
  - Settings (sensitivity, gesture toggles, theme, haptics, device manager)
  - Help/Tutorial
- Device discovery on LAN via mDNS (`_mobilemouse._tcp.local`)
- WebSocket transport to the desktop companion
- Mouse move, left/right click, scroll, basic shortcuts, and text typing

## Notes
Bluetooth HID is not implemented in this MVP for cross-platform reasons. The UI is structured to add it later.
