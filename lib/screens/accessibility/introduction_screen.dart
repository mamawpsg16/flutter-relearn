import 'package:flutter/material.dart';

class AccessibilityIntroductionScreen extends StatefulWidget {
  const AccessibilityIntroductionScreen({super.key});

  @override
  State<AccessibilityIntroductionScreen> createState() =>
      _AccessibilityIntroductionScreenState();
}

class _AccessibilityIntroductionScreenState
    extends State<AccessibilityIntroductionScreen> {
  String _srOutput = '';

  void _simulateSR(String announcement) {
    setState(() => _srOutput = announcement);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _srOutput = '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Introduction'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Accessibility means making your app usable by everyone — including '
              'people who use screen readers (TalkBack on Android, VoiceOver on iOS), '
              'keyboard navigation, or switch access. Flutter builds a semantic tree '
              'alongside the widget tree that assistive technologies read.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 20),

            _CodeSection(
              label: 'BAD — no semantic information for screen readers',
              labelColor: Colors.red,
              code: '''GestureDetector(
  onTap: deleteItem,
  child: Icon(Icons.delete), // Screen reader says: "image"
)''',
            ),
            const SizedBox(height: 12),

            _CodeSection(
              label: 'GOOD — Semantics widget adds meaning and role',
              labelColor: Colors.green,
              code: '''Semantics(
  label: 'Delete item',
  button: true,
  child: GestureDetector(
    onTap: deleteItem,
    child: Icon(Icons.delete),
  ),
)
// Screen reader announces: "Delete item, button"''',
            ),
            const SizedBox(height: 24),

            const Text(
              'Live Demo — Screen Reader Simulation',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap each element. The blue bar shows what a real screen reader '
              'would announce.',
              style: TextStyle(height: 1.4),
            ),
            const SizedBox(height: 12),

            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: _srOutput.isNotEmpty
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade900,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.record_voice_over, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _srOutput,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 14, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              secondChild: const SizedBox.shrink(),
            ),
            if (_srOutput.isNotEmpty) const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Without Semantics:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children: [
                        _DemoItem(
                          label: 'Icon only',
                          child: GestureDetector(
                            onTap: () => _simulateSR('"image"'),
                            child: const Icon(Icons.delete,
                                size: 36, color: Colors.grey),
                          ),
                        ),
                        _DemoItem(
                          label: 'Colored box',
                          child: GestureDetector(
                            onTap: () => _simulateSR('(silence — skipped)'),
                            child: Container(
                                width: 36,
                                height: 36,
                                color: Colors.red),
                          ),
                        ),
                        _DemoItem(
                          label: 'Unlabeled btn',
                          child: ElevatedButton(
                            onPressed: () => _simulateSR('"button"'),
                            child: const Icon(Icons.add),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    const Text('With Semantics:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children: [
                        _DemoItem(
                          label: 'Icon + label',
                          child: Semantics(
                            label: 'Delete item',
                            button: true,
                            child: GestureDetector(
                              onTap: () =>
                                  _simulateSR('"Delete item, button"'),
                              child: const Icon(Icons.delete,
                                  size: 36, color: Colors.red),
                            ),
                          ),
                        ),
                        _DemoItem(
                          label: 'Described box',
                          child: Semantics(
                            label: 'Error status indicator',
                            child: GestureDetector(
                              onTap: () =>
                                  _simulateSR('"Error status indicator"'),
                              child: Container(
                                  width: 36,
                                  height: 36,
                                  color: Colors.red),
                            ),
                          ),
                        ),
                        _DemoItem(
                          label: 'Labeled btn',
                          child: Semantics(
                            label: 'Add new item',
                            button: true,
                            child: ElevatedButton(
                              onPressed: () =>
                                  _simulateSR('"Add new item, button"'),
                              child: const Icon(Icons.add),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tap any element above to see the difference',
                      style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            _TipCard(
              tip: 'Flutter automatically adds semantics to Material widgets like '
                  'ElevatedButton and TextField. For custom widgets built with '
                  'GestureDetector or Container — always add a Semantics wrapper '
                  'with a label and the correct role (button: true, image: true, etc.).',
            ),
          ],
        ),
      ),
    );
  }
}

class _DemoItem extends StatelessWidget {
  final String label;
  final Widget child;
  const _DemoItem({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}

class _CodeSection extends StatelessWidget {
  final String label;
  final Color labelColor;
  final String code;

  const _CodeSection({
    required this.label,
    required this.labelColor,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  color: labelColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12)),
          const SizedBox(height: 8),
          Text(code,
              style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'monospace',
                  fontSize: 12,
                  height: 1.5)),
        ],
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final String tip;
  const _TipCard({required this.tip});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lightbulb, color: Colors.purple),
            const SizedBox(width: 8),
            Expanded(
                child: Text(tip, style: const TextStyle(height: 1.5))),
          ],
        ),
      ),
    );
  }
}
