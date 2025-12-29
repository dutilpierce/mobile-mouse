import 'package:flutter/material.dart';

class TutorialScreen extends StatelessWidget {
  const TutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      _Step(
        icon: Icons.bluetooth_searching,
        title: 'Connect',
        body: 'Run the Desktop Companion on your computer, then select it from the device list.',
      ),
      _Step(
        icon: Icons.pan_tool_alt_outlined,
        title: 'Move & click',
        body: 'Drag to move the cursor. Tap to left click. Two-finger tap/right-click is supported on many devices.',
      ),
      _Step(
        icon: Icons.keyboard_outlined,
        title: 'Keyboard',
        body: 'Open the keyboard toolbar to type into your computer or send shortcuts.',
      ),
      _Step(
        icon: Icons.mic_none_outlined,
        title: 'Voice to type',
        body: 'Press and hold to dictate text (UI stub in MVP; wire in native speech-to-text next).',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Help & Tutorial')),
      body: PageView.builder(
        itemCount: pages.length,
        itemBuilder: (_, i) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(pages[i].icon, size: 80),
              const SizedBox(height: 14),
              Text(pages[i].title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(pages[i].body, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 24),
              Text('Swipe →', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

class _Step {
  final IconData icon;
  final String title;
  final String body;
  _Step({required this.icon, required this.title, required this.body});
}
