import 'dart:async';
import 'package:bonsoir/bonsoir.dart';
import 'package:flutter/foundation.dart';

class DiscoveredDevice {
  final String name;
  final String host;
  final int port;
  DiscoveredDevice({required this.name, required this.host, required this.port});
}

class DeviceDiscovery extends ChangeNotifier {
  final List<DiscoveredDevice> devices = [];
  BonsoirDiscovery? _discovery;
  StreamSubscription? _sub;

  bool running = false;

  Future<void> start() async {
    if (running) return;

    devices.clear();
    notifyListeners();

    _discovery = BonsoirDiscovery(type: '_mobilemouse._tcp');
    await _discovery!.ready;

    _sub = _discovery!.eventStream?.listen((event) async {
      if (event.type == BonsoirDiscoveryEventType.discoveryServiceFound) {
        await event.service!.resolve(_discovery!.serviceResolver);
      } else if (event.type == BonsoirDiscoveryEventType.discoveryServiceResolved) {
        final s = event.service!;

        // bonsoir_platform_interface 5.1.x does not expose host/ip/addresses.
        // We only rely on TXT attributes (which our desktop server can publish when mDNS is enabled).
        final host = (s.attributes?['host'] ?? '').toString().trim();
        if (host.isEmpty) return;

        final name = (s.attributes?['name'] ?? s.name ?? 'Computer').toString();
        final port = s.port ?? 8765;

        final exists = devices.any((d) => d.host == host && d.port == port);
        if (!exists) {
          devices.add(DiscoveredDevice(name: name, host: host, port: port));
          notifyListeners();
        }
      }
    });

    await _discovery!.start();
    running = true;
    notifyListeners();
  }

  Future<void> stop() async {
    if (!running) return;
    await _sub?.cancel();
    await _discovery?.stop();
    _sub = null;
    _discovery = null;
    running = false;
    notifyListeners();
  }
}
