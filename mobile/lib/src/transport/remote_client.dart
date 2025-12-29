import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'device_discovery.dart';

class RemoteClient extends ChangeNotifier {
  final DiscoveredDevice device;

  WebSocketChannel? _ch;
  StreamSubscription? _sub;
  Timer? _heartbeat;

  bool connected = false;

  RemoteClient(this.device);

  Future<void> connect() async {
    // Clean any prior state
    await disconnect();

    final uri = Uri.parse('ws://${device.host}:${device.port}');
    final ch = WebSocketChannel.connect(uri);
    _ch = ch;

    // Listen so we can mark disconnected if the socket drops.
    _sub = ch.stream.listen(
      (_) {
        // We don't require server responses to stay "connected".
      },
      onError: (_) => _setDisconnected(),
      onDone: () => _setDisconnected(),
      cancelOnError: false,
    );

    // Send handshake; server may reply welcome/pong etc.
    ch.sink.add(jsonEncode({
      "type": "hello",
      "deviceId": "mobile-${Random().nextInt(999999)}",
      "appVersion": "0.1.0",
    }));

    // Mark connected immediately after open + hello send.
    connected = true;
    notifyListeners();

    // Heartbeat helps prevent idle disconnects.
    _heartbeat = Timer.periodic(const Duration(seconds: 10), (_) {
      send({"type": "ping", "t": DateTime.now().millisecondsSinceEpoch});
    });
  }

  void _setDisconnected() {
    if (!connected) return;
    connected = false;
    notifyListeners();
  }

  void send(Map<String, dynamic> msg) {
    if (!connected) return;
    try {
      _ch?.sink.add(jsonEncode(msg));
    } catch (_) {}
  }

  void mouseMove(double dx, double dy) =>
      send({"type": "mouse_move", "dx": dx, "dy": dy});

  void mouseClick(String button) =>
      send({"type": "mouse_click", "button": button, "action": "click"});

  void scroll(double dx, double dy) =>
      send({"type": "mouse_scroll", "dx": dx, "dy": dy});

  void keyText(String text) => send({"type": "key_text", "text": text});
  void keyPress(String key) => send({"type": "key_press", "key": key});
  void shortcut(List<String> keys) => send({"type": "shortcut", "keys": keys});

  Future<void> disconnect() async {
    try {
      _heartbeat?.cancel();
    } catch (_) {}
    _heartbeat = null;

    try {
      await _sub?.cancel();
    } catch (_) {}
    _sub = null;

    try {
      await _ch?.sink.close();
    } catch (_) {}

    _ch = null;
    connected = false;
    notifyListeners();
  }

  @override
  void dispose() {
    try {
      _heartbeat?.cancel();
    } catch (_) {}
    try {
      _sub?.cancel();
    } catch (_) {}
    try {
      _ch?.sink.close();
    } catch (_) {}
    super.dispose();
  }
}
