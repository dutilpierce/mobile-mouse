# Mobile Mouse

A two-part MVP:
- Flutter mobile app (trackpad/keyboard/controls) connects over WebSocket to
- Python desktop companion server which controls the desktop mouse/keyboard.

## Dev quickstart
Desktop:
- cd desktop
- .\.venv\Scripts\Activate.ps1
- $env:MOBILE_MOUSE_DISABLE_MDNS="1"
- python server.py

Mobile:
- cd mobile
- flutter run
