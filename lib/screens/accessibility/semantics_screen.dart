// Semantics — help screen readers understand your UI

import 'package:flutter/material.dart';

class SemanticsScreen extends StatefulWidget {
  const SemanticsScreen({super.key});

  @override
  State<SemanticsScreen> createState() => _SemanticsScreenState();
}

class _SemanticsScreenState extends State<SemanticsScreen> {
  bool _liked = false;
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Semantics'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Explanation ───────────────────────────────────────────────
            Card(
              color: Colors.indigo.shade50,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Semantics tells screen readers (TalkBack on Android, VoiceOver on iOS) '
                      'what a widget means and how to interact with it.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• Semantics() → add a label, hint, or value to any widget\n'
                      '• ExcludeSemantics() → hide decorative widgets from screen readers\n'
                      '• MergeSemantics() → merge child semantics into one node\n'
                      '• Tooltip() → shows a label on long press + reads it to screen reader',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Semantics label ───────────────────────────────────────────
            const _SectionTitle('Semantics — label & hint'),
            const _Tip(
                'Without a label, a screen reader just says "button". '
                'With a label + hint it says exactly what it does.'),
            const SizedBox(height: 12),

            Row(
              children: [
                // WITHOUT semantics label
                Expanded(
                  child: Column(
                    children: [
                      const Text('Without label',
                          style: TextStyle(fontSize: 12, color: Colors.black54)),
                      const SizedBox(height: 4),
                      IconButton(
                        icon: Icon(
                          _liked ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onPressed: () => setState(() => _liked = !_liked),
                      ),
                    ],
                  ),
                ),

                // WITH semantics label
                Expanded(
                  child: Column(
                    children: [
                      const Text('With label',
                          style: TextStyle(fontSize: 12, color: Colors.black54)),
                      const SizedBox(height: 4),
                      Semantics(
                        label: _liked ? 'Unlike post' : 'Like post',
                        hint: 'Double tap to toggle',
                        button: true,
                        child: IconButton(
                          icon: Icon(
                            _liked ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red,
                          ),
                          onPressed: () => setState(() => _liked = !_liked),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── ExcludeSemantics ──────────────────────────────────────────
            const _SectionTitle('ExcludeSemantics'),
            const _Tip(
                'Decorative images or icons should be hidden from the accessibility tree. '
                'Wrap them in ExcludeSemantics.'),
            const SizedBox(height: 12),
            Row(
              children: [
                ExcludeSemantics(
                  child: Icon(Icons.star, color: Colors.amber, size: 32),
                ),
                const SizedBox(width: 8),
                const Flexible(
                  child: Text(
                    'The star icon above is excluded from semantics — '
                    'a screen reader skips it entirely.',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── MergeSemantics ────────────────────────────────────────────
            const _SectionTitle('MergeSemantics'),
            const _Tip(
                'Merges the semantic info of all children into a single node. '
                'Useful for a card with an icon + label — reads as one item.'),
            const SizedBox(height: 12),
            MergeSemantics(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.indigo.shade200),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.notifications, color: Colors.indigo),
                    SizedBox(width: 12),
                    Text('You have 3 new notifications'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Tooltip ───────────────────────────────────────────────────
            const _SectionTitle('Tooltip'),
            const _Tip(
                'Long press shows a tooltip label. '
                'Screen readers also announce the tooltip message.'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Tooltip(
                  message: 'Add a new item',
                  child: FloatingActionButton.small(
                    heroTag: 'add',
                    onPressed: () => setState(() => _counter++),
                    child: const Icon(Icons.add),
                  ),
                ),
                Text(
                  'Count: $_counter',
                  style: const TextStyle(fontSize: 16),
                ),
                Tooltip(
                  message: 'Remove last item',
                  child: FloatingActionButton.small(
                    heroTag: 'remove',
                    onPressed: _counter > 0
                        ? () => setState(() => _counter--)
                        : null,
                    child: const Icon(Icons.remove),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Semantics value ───────────────────────────────────────────
            const _SectionTitle('Semantics — value (live region)'),
            const _Tip(
                'Use value to describe the current state of a widget — '
                'e.g. a slider\'s current value or a counter.'),
            const SizedBox(height: 12),
            Semantics(
              label: 'Item counter',
              value: '$_counter items',
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Counter: $_counter  (screen reader reads: "$_counter items")',
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Key takeaways ─────────────────────────────────────────────
            Card(
              color: Colors.indigo.shade50,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Key takeaways',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text(
                      '• Semantics(label:, hint:, button:) adds accessibility info.\n'
                      '• ExcludeSemantics removes decorative widgets from the tree.\n'
                      '• MergeSemantics groups children into one accessible node.\n'
                      '• Tooltip announces its message to screen readers.\n'
                      '• Most Material widgets already have built-in semantics.',
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
