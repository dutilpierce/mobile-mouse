# Event protocol (WebSocket JSON)

Client → Server messages:
- `{"type":"hello","deviceId":"...","appVersion":"0.1.0"}`
- `{"type":"mouse_move","dx":1.2,"dy":-0.8}`  (relative)
- `{"type":"mouse_click","button":"left"|"right","action":"down"|"up"|"click"}`
- `{"type":"mouse_scroll","dx":0,"dy":-120}`
- `{"type":"key_text","text":"hello world"}`
- `{"type":"key_press","key":"enter"|"backspace"|"tab"|"esc"|"left"|"right"|"up"|"down"}`
- `{"type":"shortcut","keys":["ctrl","shift","s"]}`
- `{"type":"ping","t":123}`

Server → Client:
- `{"type":"welcome","serverVersion":"0.1.0","name":"<computerName>"}`
- `{"type":"error","message":"..."}`
- `{"type":"pong","t":123}`
