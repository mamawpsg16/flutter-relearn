// Haptic Feedback — trigger device vibration patterns from Flutter

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // HapticFeedback

class HapticFeedbackScreen extends StatefulWidget {
  const HapticFeedbackScreen({super.key});

  @override
  State<HapticFeedbackScreen> createState() => _HapticFeedbackScreenState();
}

class _HapticFeedbackScreenState extends State<HapticFeedbackScreen> {
  String _lastTriggered = 'None yet';

  void _trigger(String label, Future<void> Function() fn) async {
    await fn();
    setState(() => _lastTriggered = label);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Haptic Feedback'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Explanation ───────────────────────────────────────────────
            Card(
              color: Colors.deepOrange.shade50,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HapticFeedback from flutter/services.dart triggers the device\'s vibration motor.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• Works on real iOS and Android devices.\n'
                      '• Silently ignored on desktop/emulator with no haptics support.\n'
                      '• All methods return Future<void>.',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Last triggered ────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.deepOrange.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.vibration, color: Colors.deepOrange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Last triggered: $_lastTriggered',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Impact types ──────────────────────────────────────────────
            const _SectionTitle('Impact feedback'),
            const _Tip(
              'Used when a UI element snaps into place or a gesture completes.',
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _HapticButton(
                  label: 'lightImpact',
                  color: Colors.orange.shade200,
                  onPressed: () =>
                      _trigger('lightImpact', HapticFeedback.lightImpact),
                ),
                _HapticButton(
                  label: 'mediumImpact',
                  color: Colors.orange.shade400,
                  onPressed: () =>
                      _trigger('mediumImpact', HapticFeedback.mediumImpact),
                ),
                _HapticButton(
                  label: 'heavyImpact',
                  color: Colors.orange.shade700,
                  onPressed: () =>
                      _trigger('heavyImpact', HapticFeedback.heavyImpact),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Selection ─────────────────────────────────────────────────
            const _SectionTitle('selectionClick'),
            const _Tip(
              'A subtle tick. Used when a user moves between items — e.g. a picker wheel.',
            ),
            const SizedBox(height: 12),
            _HapticButton(
              label: 'selectionClick',
              color: Colors.blueAccent,
              onPressed: () =>
                  _trigger('selectionClick', HapticFeedback.selectionClick),
            ),

            const SizedBox(height: 24),

            // ── Vibrate ───────────────────────────────────────────────────
            const _SectionTitle('vibrate'),
            const _Tip(
              'A longer standard vibration. More noticeable than impact feedback.',
            ),
            const SizedBox(height: 12),
            _HapticButton(
              label: 'vibrate',
              color: Colors.red,
              onPressed: () => _trigger('vibrate', HapticFeedback.vibrate),
            ),

            const SizedBox(height: 24),

            // ── Real-world usage ──────────────────────────────────────────
            const _SectionTitle('Real-world usage example'),
            const _Tip(
              'Haptics are commonly triggered on button press, swipe to delete, '
              'or long press. Here\'s a delete-style demo:',
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onLongPress: () {
                HapticFeedback.heavyImpact();
                setState(() => _lastTriggered = 'heavyImpact (long press)');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Long press detected — heavy haptic fired'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.delete_outline, color: Colors.red),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Long press me to delete (feel the heavy haptic)',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Key takeaways ─────────────────────────────────────────────
            Card(
              color: Colors.deepOrange.shade50,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Key takeaways',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• import flutter/services.dart to access HapticFeedback.\n'
                      '• lightImpact < mediumImpact < heavyImpact in intensity.\n'
                      '• selectionClick is subtle — for picker/selection changes.\n'
                      '• vibrate is the most noticeable — use sparingly.\n'
                      '• All methods are no-ops on platforms without haptics.',
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

class _HapticButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _HapticButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: color),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  );
}

class _Tip extends StatelessWidget {
  final String text;
  const _Tip(this.text);
  @override
  Widget build(BuildContext context) =>
      Text(text, style: const TextStyle(color: Colors.black54, fontSize: 12));
}
