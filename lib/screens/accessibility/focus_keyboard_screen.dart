// Focus & Keyboard Navigation — FocusNode, FocusScope, keyboard traversal

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FocusKeyboardScreen extends StatefulWidget {
  const FocusKeyboardScreen({super.key});

  @override
  State<FocusKeyboardScreen> createState() => _FocusKeyboardScreenState();
}

class _FocusKeyboardScreenState extends State<FocusKeyboardScreen> {
  final _field1 = FocusNode();
  final _field2 = FocusNode();
  final _field3 = FocusNode();

  bool _field1Focused = false;
  bool _field2Focused = false;
  bool _field3Focused = false;

  @override
  void initState() {
    super.initState();
    _field1.addListener(() => setState(() => _field1Focused = _field1.hasFocus));
    _field2.addListener(() => setState(() => _field2Focused = _field2.hasFocus));
    _field3.addListener(() => setState(() => _field3Focused = _field3.hasFocus));
  }

  @override
  void dispose() {
    _field1.dispose();
    _field2.dispose();
    _field3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus & Keyboard Navigation'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Explanation ───────────────────────────────────────────────
            Card(
              color: Colors.cyan.shade50,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'FocusNode lets you programmatically control which widget has keyboard focus.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• FocusNode → attach to a TextField to observe/control focus\n'
                      '• FocusScope.of(context).requestFocus() → move focus programmatically\n'
                      '• autofocus: true → grab focus as soon as the widget appears\n'
                      '• KeyboardListener / Focus → respond to raw key events',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── FocusNode on TextFields ───────────────────────────────────
            const _SectionTitle('FocusNode — observe & move focus'),
            const _Tip(
                'Each field has its own FocusNode. '
                'The colored indicator shows which one currently has focus. '
                'Tap "Next" to move focus programmatically.'),
            const SizedBox(height: 12),

            _FocusField(
              label: 'Field 1',
              focusNode: _field1,
              nextFocus: _field2,
              isFocused: _field1Focused,
              color: Colors.blue,
            ),
            const SizedBox(height: 12),
            _FocusField(
              label: 'Field 2',
              focusNode: _field2,
              nextFocus: _field3,
              isFocused: _field2Focused,
              color: Colors.green,
            ),
            const SizedBox(height: 12),
            _FocusField(
              label: 'Field 3 (last)',
              focusNode: _field3,
              nextFocus: null, // dismiss keyboard
              isFocused: _field3Focused,
              color: Colors.orange,
            ),

            const SizedBox(height: 24),

            // ── autofocus ─────────────────────────────────────────────────
            const _SectionTitle('autofocus: true'),
            const _Tip(
                'Setting autofocus: true on a widget means it grabs focus '
                'immediately when it first appears on screen.'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber),
              ),
              child: const Text(
                'TextField(autofocus: true) → keyboard opens automatically\n\n'
                'ElevatedButton(autofocus: true) → button is pre-focused '
                'for keyboard/gamepad users',
                style: TextStyle(fontSize: 13),
              ),
            ),

            const SizedBox(height: 24),

            // ── Focus widget + KeyboardListener ───────────────────────────
            const _SectionTitle('Focus widget — raw key events'),
            const _Tip(
                'Wrap any widget in Focus to listen for keyboard input even if it\'s not a text field.'),
            const SizedBox(height: 8),
            _KeyPressDemo(),

            const SizedBox(height: 24),

            // ── FocusScope ────────────────────────────────────────────────
            const _SectionTitle('FocusScope — useful methods'),
            const _Tip('FocusScope.of(context) gives you common focus actions.'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.cyan.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'FocusScope.of(context).unfocus()       // dismiss keyboard\n'
                'FocusScope.of(context).nextFocus()     // move to next focusable\n'
                'FocusScope.of(context).previousFocus() // move to previous\n'
                'FocusScope.of(context).requestFocus(node) // jump to specific node',
                style: TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => FocusScope.of(context).unfocus(),
              child: const Text('Dismiss keyboard (unfocus)'),
            ),

            const SizedBox(height: 24),

            // ── Key takeaways ─────────────────────────────────────────────
            Card(
              color: Colors.cyan.shade50,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Key takeaways',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text(
                      '• FocusNode attaches to a TextField to observe hasFocus.\n'
                      '• FocusScope.of(context).requestFocus(node) moves focus programmatically.\n'
                      '• autofocus: true grabs focus on widget appearance.\n'
                      '• Focus widget lets non-text widgets receive keyboard events.\n'
                      '• Always dispose() FocusNodes in dispose().',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helper widgets ─────────────────────────────────────────────────────────────

class _FocusField extends StatelessWidget {
  final String label;
  final FocusNode focusNode;
  final FocusNode? nextFocus;
  final bool isFocused;
  final Color color;

  const _FocusField({
    required this.label,
    required this.focusNode,
    required this.nextFocus,
    required this.isFocused,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 6,
          height: 48,
          decoration: BoxDecoration(
            color: isFocused ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            focusNode: focusNode,
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
            ),
            textInputAction: nextFocus != null
                ? TextInputAction.next
                : TextInputAction.done,
            onEditingComplete: () {
              if (nextFocus != null) {
                FocusScope.of(context).requestFocus(nextFocus);
              } else {
                FocusScope.of(context).unfocus();
              }
            },
          ),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: () {
            if (nextFocus != null) {
              FocusScope.of(context).requestFocus(nextFocus);
            } else {
              FocusScope.of(context).unfocus();
            }
          },
          child: Text(nextFocus != null ? 'Next' : 'Done'),
        ),
      ],
    );
  }
}

class _KeyPressDemo extends StatefulWidget {
  @override
  State<_KeyPressDemo> createState() => _KeyPressDemoState();
}

class _KeyPressDemoState extends State<_KeyPressDemo> {
  String _lastKey = 'none';

  @override
  Widget build(BuildContext context) {
    return Focus(
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          setState(() => _lastKey = event.logicalKey.keyLabel);
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTap: () => Focus.of(context).requestFocus(),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.cyan),
            borderRadius: BorderRadius.circular(8),
            color: Colors.cyan.shade50,
          ),
          child: Column(
            children: [
              const Text('Tap here then press a key (physical keyboard)'),
              const SizedBox(height: 8),
              Text('Last key: $_lastKey',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
}

class _Tip extends StatelessWidget {
  final String text;
  const _Tip(this.text);
  @override
  Widget build(BuildContext context) =>
      Text(text, style: const TextStyle(color: Colors.black54, fontSize: 12));
}
