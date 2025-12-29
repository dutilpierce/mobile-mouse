import 'package:flutter/material.dart';
import 'connect_screen.dart';

class DisconnectScreen extends StatelessWidget {
  const DisconnectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.power_settings_new, size: 64),
              const SizedBox(height: 12),
              Text('Disconnected', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text('Your session has ended.', style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const ConnectScreen()),
                  (r) => false,
                ),
                child: const Text('Reconnect'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
