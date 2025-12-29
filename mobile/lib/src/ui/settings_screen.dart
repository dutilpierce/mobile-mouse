import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final s = state.settings;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(title: 'Control'),
          _SliderTile(
            label: 'Touch sensitivity',
            value: s.sensitivity,
            min: 0.5,
            max: 2.0,
            onChanged: s.setSensitivity,
          ),
          _SliderTile(
            label: 'Scroll speed',
            value: s.scrollSpeed,
            min: 0.5,
            max: 2.0,
            onChanged: s.setScrollSpeed,
          ),
          SwitchListTile(
            title: const Text('Haptic feedback'),
            value: s.haptics,
            onChanged: s.setHaptics,
          ),
          const SizedBox(height: 14),
          _Section(title: 'Gestures'),
          SwitchListTile(
            title: const Text('Tap = left click'),
            value: s.gestureTap,
            onChanged: s.toggleGestureTap,
          ),
          SwitchListTile(
            title: const Text('Two-finger tap = right click'),
            value: s.gestureRightClick,
            onChanged: s.toggleGestureRightClick,
          ),
          SwitchListTile(
            title: const Text('Scroll enabled'),
            value: s.gestureScroll,
            onChanged: s.toggleGestureScroll,
          ),
          SwitchListTile(
            title: const Text('Pinch-to-zoom (planned)'),
            value: s.gesturePinchZoom,
            onChanged: s.toggleGesturePinch,
          ),
          SwitchListTile(
            title: const Text('Three-finger swipe (planned)'),
            value: s.gestureThreeFinger,
            onChanged: s.toggleGestureThreeFinger,
          ),
          const SizedBox(height: 14),
          _Section(title: 'Theme'),
          ListTile(
            title: const Text('Theme mode'),
            subtitle: Text(s.themeMode.name),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final picked = await showModalBottomSheet<ThemeMode>(
                context: context,
                showDragHandle: true,
                builder: (_) => _ThemePicker(current: s.themeMode),
              );
              if (picked != null) s.setThemeMode(picked);
            },
          ),
          const SizedBox(height: 14),
          _Section(title: 'Device Manager'),
          ListTile(
            title: const Text('Disconnect'),
            subtitle: Text(state.client == null ? 'Not connected' : 'Connected to ${state.client!.device.name}'),
            trailing: const Icon(Icons.power_settings_new),
            onTap: () => state.disconnect(),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  const _Section({required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

class _SliderTile extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  const _SliderTile({required this.label, required this.value, required this.min, required this.max, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _ThemePicker extends StatelessWidget {
  final ThemeMode current;
  const _ThemePicker({required this.current});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile(
            title: const Text('System'),
            value: ThemeMode.system,
            groupValue: current,
            onChanged: (v) => Navigator.of(context).pop(v),
          ),
          RadioListTile(
            title: const Text('Light'),
            value: ThemeMode.light,
            groupValue: current,
            onChanged: (v) => Navigator.of(context).pop(v),
          ),
          RadioListTile(
            title: const Text('Dark'),
            value: ThemeMode.dark,
            groupValue: current,
            onChanged: (v) => Navigator.of(context).pop(v),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
