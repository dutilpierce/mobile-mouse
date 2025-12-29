# Desktop Companion (Python) — Mobile Mouse MVP

This companion runs on your computer and:
- advertises itself on your local network (mDNS)
- accepts a WebSocket connection from your phone
- applies mouse/keyboard events using `pyautogui`

## 1) Install (Windows)
1. Install Python 3.11+ from python.org (check **Add Python to PATH**)
2. Open **PowerShell**
3. Go into this folder:
   ```powershell
   cd path\to\mobile-mouse-suite\desktop
   ```
4. Create a virtual env and install:
   ```powershell
   python -m venv .venv
   .\.venv\Scripts\Activate.ps1
   pip install -r requirements.txt
   ```

## 2) Install (macOS)
```bash
cd path/to/mobile-mouse-suite/desktop
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## 3) Run
```bash
python server.py
```

Leave it running. You should see something like:
- `MobileMouse Companion listening on ws://0.0.0.0:8765`
- `Advertising as MobileMouse-<your-computer-name>.local`

## Permissions
- **macOS**: You must allow Accessibility permissions for Terminal/Python to control the mouse.
  System Settings → Privacy & Security → Accessibility → enable Terminal (or your Python IDE).

## Troubleshooting
- If the phone doesn't discover the computer, ensure phone + computer are on the **same Wi‑Fi**.
- If firewall blocks, allow incoming connections on port **8765**.
