import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

class VoiceOverlay extends StatefulWidget {
  const VoiceOverlay({super.key});

  @override
  State<VoiceOverlay> createState() => _VoiceOverlayState();
}

class _VoiceOverlayState extends State<VoiceOverlay> {
  bool listening = false;
  String transcript = '';
  Timer? _fakeTimer;

  @override
  void dispose() {
    _fakeTimer?.cancel();
    super.dispose();
  }

  void _start() {
    setState(() {
      listening = true;
      transcript = '';
    });

    // MVP: UI stub. Replace with native speech-to-text plugin later.
    _fakeTimer?.cancel();
    _fakeTimer = Timer.periodic(const Duration(milliseconds: 350), (t) {
      setState(() {
        transcript += (transcript.isEmpty ? '' : ' ') + '…';
      });
    });
  }

  void _stopAndSend() {
    final state = context.read<AppState>();
    final client = state.client;
    _fakeTimer?.cancel();
    setState(() => listening = false);

    // In a real implementation, transcript would be actual speech-to-text.
    if (client != null && transcript.trim().isNotEmpty) {
      client.keyText(transcript.replaceAll('…', '').trim());
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Voice to Type', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Press and hold to dictate (UI stub in MVP).',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
            ),
            child: Text(
              transcript.isEmpty ? '…' : transcript,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onLongPressStart: (_) => _start(),
            onLongPressEnd: (_) => _stopAndSend(),
            child: Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(listening ? Icons.mic : Icons.mic_none, color: Theme.of(context).colorScheme.onPrimary, size: 28),
            ),
          ),
          const SizedBox(height: 8),
          Text(listening ? 'Listening… release to send' : 'Hold to speak', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
