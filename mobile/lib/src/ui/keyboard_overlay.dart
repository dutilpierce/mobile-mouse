import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

class KeyboardOverlay extends StatefulWidget {
  const KeyboardOverlay({super.key});

  @override
  State<KeyboardOverlay> createState() => _KeyboardOverlayState();
}

class _KeyboardOverlayState extends State<KeyboardOverlay> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final client = state.client;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 6,
        bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Keyboard', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Type to send',
              border: OutlineInputBorder(),
            ),
            minLines: 1,
            maxLines: 3,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: client == null
                      ? null
                      : () {
                          final text = _controller.text;
                          if (text.isEmpty) return;
                          client.keyText(text);
                          _controller.clear();
                        },
                  icon: const Icon(Icons.send),
                  label: const Text('Send'),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: client == null ? null : () => client.keyPress("enter"),
                child: const Text('Enter'),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: client == null ? null : () => client.keyPress("backspace"),
                child: const Text('⌫'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _ShortcutRow(
            onShortcut: (keys) => client?.shortcut(keys),
          ),
          const SizedBox(height: 8),
          Text(
            'Shortcuts: Ctrl/Cmd/Alt/Shift combos (mapped as-is on desktop).',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.outline),
          ),
        ],
      ),
    );
  }
}

class _ShortcutRow extends StatelessWidget {
  final void Function(List<String>) onShortcut;
  const _ShortcutRow({required this.onShortcut});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _chip(context, 'Copy', ['ctrl', 'c']),
        _chip(context, 'Paste', ['ctrl', 'v']),
        _chip(context, 'Save', ['ctrl', 's']),
        _chip(context, 'Undo', ['ctrl', 'z']),
        _chip(context, 'Redo', ['ctrl', 'shift', 'z']),
        _chip(context, 'Tab', ['tab']),
      ],
    );
  }

  Widget _chip(BuildContext context, String label, List<String> keys) {
    return ActionChip(
      label: Text(label),
      onPressed: () => onShortcut(keys),
    );
  }
}
