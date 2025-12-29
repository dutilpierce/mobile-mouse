import 'dart:async';

import 'package:flutter/foundation.dart';
import 'settings/settings_model.dart';
import 'transport/device_discovery.dart';
import 'transport/remote_client.dart';

class AppState extends ChangeNotifier {
  final settings = SettingsModel();
  final discovery = DeviceDiscovery();
  RemoteClient? client;

  bool initializing = true;

  Future<void> init() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    initializing = false;
    notifyListeners();
  }

  Future<void> startDiscovery() async {
    await discovery.start();
    notifyListeners();
  }

  Future<void> stopDiscovery() async {
    await discovery.stop();
    notifyListeners();
  }

  Future<void> connectTo(DiscoveredDevice d) async {
    client?.dispose();
    client = RemoteClient(d);
    await client!.connect();
    notifyListeners();
  }

  Future<void> disconnect() async {
    await client?.disconnect();
    client?.dispose();
    client = null;
    notifyListeners();
  }
}
