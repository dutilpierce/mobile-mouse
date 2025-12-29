import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../app_state.dart';
import 'keyboard_overlay.dart';
import 'settings_screen.dart';
import 'voice_overlay.dart';
import 'disconnect_screen.dart';

class TrackpadScreen extends StatefulWidget {
  const TrackpadScreen({super.key});

  @override
  State<TrackpadScreen> createState() => _TrackpadScreenState();
}

class _TrackpadScreenState extends State<TrackpadScreen> {
  Offset? _last;
  double _velocity = 0;

  void _haptic() async {
    final state = context.read<AppState>();
    if (!state.settings.haptics) return;
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final client = state.client;

    // If the app state thinks we're not connected, show a safe screen.
    if (client == null || client.connected != true) {
      return const DisconnectScreen();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Trackpad'),
        actions: [
          IconButton(
            tooltip: 'Keyboard',
            icon: const Icon(Icons.keyboard_alt_outlined),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const KeyboardOverlay(),
              );
            },
          ),
          IconButton(
            tooltip: 'Voice',
            icon: const Icon(Icons.mic_none_outlined),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const VoiceOverlay(),
              );
            },
          ),
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // TRACKPAD AREA
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.deepPurple.shade700.withOpacity(0.55),
                        Colors.black.withOpacity(0.95),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.10),
                      width: 1,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,

                          // IMPORTANT: Use ONLY scale callbacks.
                          // Scale is a superset of pan, so having both causes a red-screen crash.
                          onScaleStart: (details) {
                            _last = details.focalPoint;
                            _velocity = 0;
                          },
                          onScaleUpdate: (details) {
                            final cur = details.focalPoint;
                            if (_last != null) {
                              final delta = cur - _last!;
                              // Optional sensitivity multiplier
                              final sensitivity = state.settings.sensitivity;
                              final dx = delta.dx * sensitivity;
                              final dy = delta.dy * sensitivity;

                              client.mouseMove(dx, dy);
                              _velocity = delta.distance;
                            }
                            _last = cur;
                          },
                          onScaleEnd: (_) {
                            _last = null;
                            _velocity = 0;
                          },

                          // Tap = left click
                          onTap: () {
                            _haptic();
                            client.mouseClick("left");
                          },

                          // Long press = right click
                          onLongPress: () {
                            _haptic();
                            client.mouseClick("right");
                          },

                          // Two-finger vertical drag for scroll (handled by scale pointer count via details)
                          // If you want advanced scroll later, we can add pointer tracking.
                        ),
                      ),

                      // Hint + status overlay
                      Positioned(
                        left: 14,
                        right: 14,
                        top: 14,
                        child: Opacity(
                          opacity: 0.85,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.35),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.10),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.touch_app_outlined, size: 18),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Move: drag • Left click: tap • Right click: long-press',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.90),
                                      fontSize: 12.5,
                                    ),
                                  ),
                                ),
                                if (_velocity > 0)
                                  Text(
                                    'v:${_velocity.toStringAsFixed(1)}',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.65),
                                      fontSize: 12,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // BOTTOM CONTROLS
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    label: 'Left',
                    icon: Icons.mouse_outlined,
                    onTap: () {
                      _haptic();
                      client.mouseClick("left");
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ActionButton(
                    label: 'Right',
                    icon: Icons.ads_click_outlined,
                    onTap: () {
                      _haptic();
                      client.mouseClick("right");
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ActionButton(
                    label: 'Scroll ↓',
                    icon: Icons.swipe_down_alt_outlined,
                    onTap: () {
                      _haptic();
                      // Negative vs positive can vary by OS preference; adjust if needed.
                      client.scroll(0, -120);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ActionButton(
                    label: 'Disconnect',
                    icon: Icons.power_settings_new,
                    danger: true,
                    onTap: () async {
                      await state.disconnect();
                      if (!mounted) return;
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const DisconnectScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool danger;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = danger ? Colors.redAccent.withOpacity(0.18) : Colors.white.withOpacity(0.08);
    final border = danger ? Colors.redAccent.withOpacity(0.35) : Colors.white.withOpacity(0.12);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.90),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
