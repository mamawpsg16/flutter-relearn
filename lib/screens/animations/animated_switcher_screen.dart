import 'package:flutter/material.dart';

class AnimatedSwitcherScreen extends StatefulWidget {
  const AnimatedSwitcherScreen({super.key});

  @override
  State<AnimatedSwitcherScreen> createState() => _AnimatedSwitcherScreenState();
}

class _AnimatedSwitcherScreenState extends State<AnimatedSwitcherScreen> {
  int _count = 0;
  int _iconIndex = 0; // separate state for icon switcher
  bool _showA = true;
  final _icons = [
    Icons.favorite,
    Icons.star,
    Icons.bolt,
    Icons.rocket_launch,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnimatedSwitcher'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AnimatedSwitcher plays a transition whenever its child changes. '
              'The old child animates out while the new child animates in. '
              'Each child must have a unique Key for Flutter to detect the change.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 20),

            _CodeSection(
              label: 'BAD — child swaps instantly with no transition',
              labelColor: Colors.red,
              code: '''// Just replacing the widget — no animation
child: _showA ? WidgetA() : WidgetB()''',
            ),
            const SizedBox(height: 12),

            _CodeSection(
              label: 'GOOD — AnimatedSwitcher transitions between children',
              labelColor: Colors.green,
              code: '''AnimatedSwitcher(
  duration: Duration(milliseconds: 300),
  transitionBuilder: (child, animation) =>
      FadeTransition(opacity: animation, child: child),
  child: Text(
    '\$_count',
    key: ValueKey(_count), // ← KEY is required!
  ),
)''',
            ),
            const SizedBox(height: 24),

            const Text(
              'Live Demo',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Demo 1: counter
            const Text('Counter with fade transition:',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () => setState(() => _count--),
                    ),
                    const SizedBox(width: 16),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(scale: animation, child: child),
                      ),
                      child: Text(
                        '$_count',
                        key: ValueKey(_count),
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => setState(() => _count++),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Demo 2: icon switcher
            const Text('Icon switcher with slide transition:',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (child, animation) => SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.5),
                          end: Offset.zero,
                        ).animate(animation),
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      ),
                      child: Icon(
                        _icons[_iconIndex % _icons.length],
                        key: ValueKey(_iconIndex), // always unique per tap
                        size: 64,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => setState(() => _iconIndex++),
                      child: const Text('Next Icon'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Demo 3: widget swap
            const Text('Widget swap (A ↔ B):',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: _showA
                          ? Container(
                              key: const ValueKey('A'),
                              height: 80,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade400,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Text('Widget A',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                              ),
                            )
                          : Container(
                              key: const ValueKey('B'),
                              height: 80,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.orange.shade400,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Text('Widget B',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                              ),
                            ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => setState(() => _showA = !_showA),
                      child: const Text('Swap Widgets'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            _TipCard(
              tip:
                  'Always give each child a unique Key (ValueKey, ObjectKey, etc.). '
                  'Without it, AnimatedSwitcher cannot detect the child changed '
                  'and will NOT play any animation.',
            ),
          ],
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
          Text(
            label,
            style: TextStyle(
              color: labelColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            code,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'monospace',
              fontSize: 12,
              height: 1.5,
            ),
          ),
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
              child: Text(tip, style: const TextStyle(height: 1.5)),
            ),
          ],
        ),
      ),
    );
  }
}
