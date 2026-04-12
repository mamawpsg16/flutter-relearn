import 'package:flutter/material.dart';

class AccessibilityTestingScreen extends StatefulWidget {
  const AccessibilityTestingScreen({super.key});

  @override
  State<AccessibilityTestingScreen> createState() =>
      _AccessibilityTestingScreenState();
}

class _AccessibilityTestingScreenState
    extends State<AccessibilityTestingScreen> {
  bool _showFixed = false;

  static const _checkItems = [
    _CheckItem(true, 'All interactive elements have semantic labels'),
    _CheckItem(true, 'Touch targets are at least 48×48dp'),
    _CheckItem(true, 'Text contrast ratio ≥ 4.5:1 (normal text)'),
    _CheckItem(true, 'Text contrast ratio ≥ 3:1 (large text / 18pt+)'),
    _CheckItem(true, 'App works with text scale up to 2×'),
    _CheckItem(true, 'All images have labels or are excluded from tree'),
    _CheckItem(true, 'Error messages are announced to screen readers'),
    _CheckItem(true, 'Focus order follows logical reading order'),
    _CheckItem(false, 'Relying on color alone to convey meaning'),
    _CheckItem(false, 'Tiny touch targets for secondary actions'),
    _CheckItem(false, 'Hardcoded pixel sizes that ignore text scale'),
    _CheckItem(false, 'Unlabeled icons used as interactive buttons'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accessibility Testing'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Flutter provides several tools for accessibility testing: the '
              'SemanticsDebugger overlay, Accessibility Inspector in DevTools, '
              'and automated widget tests using meetsGuideline(). Running these '
              'regularly catches issues before users do.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 20),

            _CodeSection(
              label: 'Automated widget test — WCAG guideline checks',
              labelColor: Colors.blue,
              code: '''testWidgets('passes accessibility guidelines', (tester) async {
  await tester.pumpWidget(MyApp());

  // WCAG colour contrast
  await expectLater(
    tester, meetsGuideline(textContrastGuideline));

  // Minimum tap target size
  await expectLater(
    tester, meetsGuideline(iOSTapTargetGuideline));
  await expectLater(
    tester, meetsGuideline(androidTapTargetGuideline));

  // Every tappable has a label
  await expectLater(
    tester, meetsGuideline(labeledTapTargetGuideline));
});''',
            ),
            const SizedBox(height: 12),
            _CodeSection(
              label: 'DevTools — live semantic tree inspector',
              labelColor: Colors.blue,
              code: '''// 1. Run your app
flutter run

// 2. Open DevTools in browser
flutter pub global activate devtools
flutter pub global run devtools

// 3. Go to "Flutter Inspector" tab
//    → click the accessibility icon
//    → browse the live semantic tree''',
            ),
            const SizedBox(height: 24),

            const Text('Live Demo — Spot the Issues',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Show:  '),
                ChoiceChip(
                  label: const Text('Broken'),
                  selected: !_showFixed,
                  selectedColor: Colors.red.shade100,
                  onSelected: (_) => setState(() => _showFixed = false),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Fixed'),
                  selected: _showFixed,
                  selectedColor: Colors.green.shade100,
                  onSelected: (_) => setState(() => _showFixed = true),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _showFixed
                  ? _buildFixed()
                  : _buildBroken(),
            ),
            const SizedBox(height: 24),

            const Text('Accessibility Checklist',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 8, horizontal: 4),
                child: Column(
                  children: _checkItems
                      .map((item) => ListTile(
                            dense: true,
                            leading: Icon(
                              item.passes
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: item.passes
                                  ? Colors.green
                                  : Colors.red,
                              size: 20,
                            ),
                            title: Text(item.text,
                                style: const TextStyle(fontSize: 13)),
                          ))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 24),

            _TipCard(
              tip: 'Add accessibility guideline tests to your test suite — they '
                  'run fast and catch regressions early. At minimum, test contrast, '
                  'tap target size, and labeled targets. Use the Flutter Accessibility '
                  'Scanner on a real Android device for a real-world audit.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBroken() {
    return Card(
      key: const ValueKey('broken'),
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: const [
              Icon(Icons.warning_amber, color: Colors.red, size: 18),
              SizedBox(width: 6),
              Text('Has Issues',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 14),

            // Issue 1: Low contrast
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              color: Colors.white,
              child: const Text(
                'Low contrast text — barely readable',
                style: TextStyle(color: Color(0xFFCCCCCC), fontSize: 15),
              ),
            ),
            const SizedBox(height: 10),

            // Issue 2: Tiny targets
            Row(
              children: [
                const Text('Actions: '),
                GestureDetector(
                  onTap: () {},
                  child: const Icon(Icons.edit,
                      size: 10, color: Colors.grey),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () {},
                  child: const Icon(Icons.delete,
                      size: 10, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Issue 3: Unlabeled icon button
            ElevatedButton(
              onPressed: () {},
              child: const Icon(Icons.arrow_forward),
            ),
            const SizedBox(height: 10),

            const Text(
              'Issues: low contrast · 10dp targets · unlabeled button',
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 11,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFixed() {
    return Card(
      key: const ValueKey('fixed'),
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: const [
              Icon(Icons.check_circle, color: Colors.green, size: 18),
              SizedBox(width: 6),
              Text('All Clear',
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 14),

            // Fix 1: High contrast
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              color: Colors.white,
              child: const Text(
                'High contrast text — clear and easy to read',
                style: TextStyle(color: Color(0xFF212121), fontSize: 15),
              ),
            ),
            const SizedBox(height: 10),

            // Fix 2: 48dp targets
            Row(
              children: [
                const Text('Actions: '),
                Tooltip(
                  message: 'Edit',
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit),
                  ),
                ),
                Tooltip(
                  message: 'Delete',
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.delete),
                  ),
                ),
              ],
            ),

            // Fix 3: Labeled button
            Tooltip(
              message: 'Go to next page',
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Next'),
              ),
            ),
            const SizedBox(height: 10),

            const Text(
              'Fixed: high contrast · 48dp targets · labeled button',
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 11,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckItem {
  final bool passes;
  final String text;
  const _CheckItem(this.passes, this.text);
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
