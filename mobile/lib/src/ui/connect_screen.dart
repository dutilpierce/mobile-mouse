import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../transport/device_discovery.dart';
import 'trackpad_screen.dart';

class ConnectScreen extends StatefulWidget {
  const ConnectScreen({super.key});

  @override
  State<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  final _ip = TextEditingController(text: '192.168.1.3');
  final _port = TextEditingController(text: '8765');

  bool _connecting = false;
  String? _error;

  Future<void> _manualConnect() async {
    final host = _ip.text.trim();
    final port = int.tryParse(_port.text.trim()) ?? 8765;

    setState(() {
      _connecting = true;
      _error = null;
    });

    try {
      final state = context.read<AppState>();

      // Construct a device manually (since mDNS discovery is disabled).
      final d = DiscoveredDevice(
        name: 'This PC ($host)',
        host: host,
        port: port,
      );

      await state.connectTo(d);

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const TrackpadScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Connect failed to $host:$port\n$e';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _connecting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connect')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFF4B3C79), Color(0xFF2C2545)],
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Manual connection',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'mDNS is disabled on desktop, so enter your computer IP and connect manually.',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _ip,
              decoration: const InputDecoration(
                labelText: 'IP address',
                hintText: '192.168.1.3',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _port,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Port', hintText: '8765'),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Colors.redAccent)),
            ],
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _connecting ? null : _manualConnect,
                child: _connecting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Connect'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
