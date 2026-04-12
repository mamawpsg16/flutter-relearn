import 'package:flutter/material.dart';

class WebAccessibilityScreen extends StatefulWidget {
  const WebAccessibilityScreen({super.key});

  @override
  State<WebAccessibilityScreen> createState() =>
      _WebAccessibilityScreenState();
}

class _WebAccessibilityScreenState extends State<WebAccessibilityScreen> {
  int _focusedIndex = -1;
  bool _showSkipLink = false;

  static const _navItems = [
    _NavEntry('Home', Icons.home),
    _NavEntry('Products', Icons.shopping_bag),
    _NavEntry('About', Icons.info_outline),
    _NavEntry('Contact', Icons.mail_outline),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Web Accessibility'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Flutter Web generates semantic HTML that assistive technologies '
              'can read. Key concerns are keyboard focus order, skip-navigation '
              'links, ARIA-equivalent semantics via the Semantics widget, and '
              'ensuring every interaction works without a mouse.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 20),

            _CodeSection(
              label: 'BAD — focus order is unpredictable',
              labelColor: Colors.red,
              code: '''// Widgets laid out visually left-to-right
// but added to the tree in a different order.
// Tab key jumps around unpredictably.
Stack(children: [saveBtn, cancelBtn, titleField])''',
            ),
            const SizedBox(height: 12),
            _CodeSection(
              label: 'GOOD — explicit traversal order with FocusTraversalGroup',
              labelColor: Colors.green,
              code: '''FocusTraversalGroup(
  policy: OrderedTraversalPolicy(),
  child: Column(children: [
    FocusTraversalOrder(
      order: NumericFocusOrder(1),
      child: TextField(
        decoration: InputDecoration(label: Text("First name")),
      ),
    ),
    FocusTraversalOrder(
      order: NumericFocusOrder(2),
      child: TextField(
        decoration: InputDecoration(label: Text("Last name")),
      ),
    ),
    FocusTraversalOrder(
      order: NumericFocusOrder(3),
      child: ElevatedButton(
        onPressed: submit,
        child: Text("Submit"),
      ),
    ),
  ]),
)''',
            ),
            const SizedBox(height: 24),

            const Text('Live Demo — Keyboard Focus Order',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              'Click any nav item, then use Tab / Shift+Tab to move focus. '
              'The selected item is highlighted — this is what a keyboard-only '
              'user sees.',
              style: TextStyle(height: 1.4),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Nav bar with ordered focus traversal:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 12),
                    FocusTraversalGroup(
                      policy: OrderedTraversalPolicy(),
                      child: Row(
                        children:
                            List.generate(_navItems.length, (i) {
                          return Expanded(
                            child: FocusTraversalOrder(
                              order: NumericFocusOrder(i.toDouble()),
                              child: _NavButton(
                                entry: _navItems[i],
                                isFocused: _focusedIndex == i,
                                onFocus: () =>
                                    setState(() => _focusedIndex = i),
                                onBlur: () => setState(() {
                                  if (_focusedIndex == i) _focusedIndex = -1;
                                }),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 8),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: _focusedIndex >= 0
                          ? Text(
                              'Focused: ${_navItems[_focusedIndex].label}',
                              key: ValueKey(_focusedIndex),
                              style: const TextStyle(
                                  color: Colors.indigo,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 12),
                            )
                          : const SizedBox.shrink(key: ValueKey(-1)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text('Skip Navigation Link',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              'Keyboard users must Tab through every nav link on every page '
              'unless you provide a "Skip to content" link at the top.',
              style: TextStyle(height: 1.4),
            ),
            const SizedBox(height: 8),
            _CodeSection(
              label: 'Skip link — visible only on focus',
              labelColor: Colors.blue,
              code: '''Focus(
  child: Builder(builder: (context) {
    final hasFocus = Focus.of(context).hasFocus;
    return AnimatedOpacity(
      opacity: hasFocus ? 1.0 : 0.0,
      duration: Duration(milliseconds: 150),
      child: ElevatedButton(
        onPressed: () => mainFocusNode.requestFocus(),
        child: Text("Skip to main content"),
      ),
    );
  }),
)''',
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SwitchListTile(
                      title: const Text('Simulate skip link visible'),
                      subtitle: const Text(
                          'In real apps this only appears on keyboard focus'),
                      value: _showSkipLink,
                      onChanged: (v) =>
                          setState(() => _showSkipLink = v),
                    ),
                    if (_showSkipLink) ...[
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Skip to main content'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            _CodeSection(
              label: 'Enable semantic rendering on Flutter Web',
              labelColor: Colors.blue,
              code: '''// main.dart — call this before runApp for better
// screen reader support on web:
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SemanticsBinding.instance.ensureSemantics();
  runApp(MyApp());
}

// Or run with:
// flutter run -d chrome --web-renderer html''',
            ),
            const SizedBox(height: 24),

            _TipCard(
              tip: 'Test with keyboard only — if you cannot complete every '
                  'action without a mouse, neither can keyboard users. Also '
                  'run ChromeVox (built into ChromeOS) or NVDA on your '
                  'Flutter Web build to hear exactly what screen reader users hear.',
            ),
          ],
        ),
      ),
    );
  }
}

class _NavEntry {
  final String label;
  final IconData icon;
  const _NavEntry(this.label, this.icon);
}

class _NavButton extends StatefulWidget {
  final _NavEntry entry;
  final bool isFocused;
  final VoidCallback onFocus;
  final VoidCallback onBlur;

  const _NavButton({
    required this.entry,
    required this.isFocused,
    required this.onFocus,
    required this.onBlur,
  });

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.entry.label,
      child: Focus(
        onFocusChange: (hasFocus) {
          if (hasFocus) {
            widget.onFocus();
          } else {
            widget.onBlur();
          }
        },
        child: GestureDetector(
          onTap: widget.onFocus,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            decoration: BoxDecoration(
              color: widget.isFocused
                  ? Colors.indigo
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: widget.isFocused
                    ? Colors.indigo
                    : Colors.grey.shade300,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.entry.icon,
                  color: widget.isFocused
                      ? Colors.white
                      : Colors.grey.shade600,
                  size: 20,
                ),
                const SizedBox(height: 3),
                Text(
                  widget.entry.label,
                  style: TextStyle(
                    color: widget.isFocused
                        ? Colors.white
                        : Colors.grey.shade700,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
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
