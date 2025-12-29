import asyncio
import json
import os
import socket
from dataclasses import dataclass

import websockets

# Mouse/keyboard control
import pyautogui

# Optional mDNS (disabled by env var)
try:
    from zeroconf import Zeroconf, ServiceInfo
except Exception:
    Zeroconf = None
    ServiceInfo = None


PORT = int(os.environ.get("MOBILE_MOUSE_PORT", "8765"))
SERVICE_TYPE = "_mobilemouse._tcp.local."
SERVICE_NAME = "MobileMouse Companion._mobilemouse._tcp.local."

pyautogui.FAILSAFE = False


def get_local_ip() -> str:
    """Best-effort LAN IP discovery."""
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        ip = s.getsockname()[0]
        s.close()
        return ip
    except Exception:
        return "127.0.0.1"


@dataclass
class ClientState:
    peer: tuple[str, int] | None = None


async def handle(ws: websockets.WebSocketServerProtocol):
    state = ClientState(peer=getattr(ws, "remote_address", None))
    print(f"[+] client connected: {state.peer}")

    try:
        async for msg in ws:
            # Accept either text JSON or ignore invalid frames safely
            try:
                data = json.loads(msg)
            except Exception:
                continue

            t = data.get("type")

            # --- NEW: handshake + keepalive handling ---
            if t == "hello":
                # Immediately acknowledge so the mobile client doesn't time out and drop.
                await ws.send(json.dumps({"type": "welcome", "serverVersion": "0.1.0"}))
                continue

            if t == "ping":
                # Mobile heartbeat
                await ws.send(json.dumps({"type": "pong"}))
                continue
            # -------------------------------------------

            # Mouse / keyboard actions
            if t == "mouse_move":
                dx = float(data.get("dx", 0))
                dy = float(data.get("dy", 0))
                pyautogui.moveRel(dx, dy, duration=0)

            elif t == "mouse_click":
                button = str(data.get("button", "left")).lower()
                action = str(data.get("action", "click")).lower()

                if button not in ("left", "right", "middle"):
                    button = "left"

                if action == "down":
                    pyautogui.mouseDown(button=button)
                elif action == "up":
                    pyautogui.mouseUp(button=button)
                else:
                    pyautogui.click(button=button)

            elif t == "mouse_scroll":
                dx = float(data.get("dx", 0))
                dy = float(data.get("dy", 0))
                # pyautogui.scroll expects int "clicks"
                if dy:
                    pyautogui.scroll(int(dy))
                if dx:
                    # Horizontal scroll is supported as hscroll on many platforms
                    try:
                        pyautogui.hscroll(int(dx))
                    except Exception:
                        pass

            elif t == "key_text":
                text = str(data.get("text", ""))
                if text:
                    pyautogui.write(text, interval=0)

            elif t == "key_press":
                key = str(data.get("key", ""))
                if key:
                    pyautogui.press(key)

            elif t == "shortcut":
                keys = data.get("keys", [])
                if isinstance(keys, list) and keys:
                    # pyautogui.hotkey expects args
                    keys = [str(k) for k in keys]
                    pyautogui.hotkey(*keys)

            else:
                # Unknown type: respond but don't crash
                try:
                    await ws.send(json.dumps({"type": "error", "message": f"unknown type: {t}"}))
                except Exception:
                    pass

    except Exception as e:
        # Prevent noisy tracebacks for normal mobile disconnect patterns on Windows
        print(f"! client connection ended: {state.peer} ({e})")
    finally:
        print(f"[-] client disconnected: {state.peer}")


def mdns_disabled() -> bool:
    return os.environ.get("MOBILE_MOUSE_DISABLE_MDNS", "").strip() == "1"


def build_service_info(ip: str) -> ServiceInfo:
    # TXT records for discovery; host is included so the mobile side can connect.
    props = {
        b"host": ip.encode("utf-8"),
        b"port": str(PORT).encode("utf-8"),
        b"name": b"MobileMouse Companion",
    }
    return ServiceInfo(
        type_=SERVICE_TYPE,
        name=SERVICE_NAME,
        addresses=[socket.inet_aton(ip)],
        port=PORT,
        properties=props,
        server="mobilemouse.local.",
    )


async def main():
    ip = get_local_ip()

    if mdns_disabled() or Zeroconf is None or ServiceInfo is None:
        print("mDNS discovery is DISABLED. (Manual IP connect mode)")
        print(f"MobileMouse Companion listening on ws://0.0.0.0:{PORT}")
        print(f"Connect from phone to: ws://{ip}:{PORT}")

        # --- NEW: disable websocket keepalive pings/timeouts to avoid Windows/mobile churn ---
        async with websockets.serve(
            handle,
            "0.0.0.0",
            PORT,
            ping_interval=None,
            ping_timeout=None,
            max_size=2**20,
        ):
            await asyncio.Future()  # run forever
    else:
        zc = Zeroconf()
        info = build_service_info(ip)

        try:
            zc.register_service(info)
            print("mDNS discovery is ENABLED.")
            print(f"MobileMouse Companion listening on ws://0.0.0.0:{PORT}")
            print(f"Connect from phone to: ws://{ip}:{PORT}")

            async with websockets.serve(
                handle,
                "0.0.0.0",
                PORT,
                ping_interval=None,
                ping_timeout=None,
                max_size=2**20,
            ):
                await asyncio.Future()
        finally:
            try:
                zc.unregister_service(info)
            except Exception:
                pass
            try:
                zc.close()
            except Exception:
                pass


if __name__ == "__main__":
    asyncio.run(main())
