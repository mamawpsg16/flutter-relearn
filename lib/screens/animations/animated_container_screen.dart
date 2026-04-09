import 'package:flutter/material.dart';

class AnimatedContainerScreen extends StatefulWidget {
  const AnimatedContainerScreen({super.key});

  @override
  State<AnimatedContainerScreen> createState() =>
      _AnimatedContainerScreenState();
}

class _AnimatedContainerScreenState extends State<AnimatedContainerScreen> {
  bool _expanded = false;
  Color _color = Colors.blue;
  double _borderRadius = 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnimatedContainer'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Concept explanation
            const Text(
              'AnimatedContainer automatically animates between old and new values '
              'whenever its properties change — no AnimationController needed. '
              'Just call setState() and Flutter handles the tweening.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 20),

            // BAD example
            _CodeSection(
              label: 'BAD — instant jump, no animation',
              labelColor: Colors.red,
              code: '''Container(
  width: _expanded ? 200 : 80,
  height: _expanded ? 200 : 80,
  color: _color,
  // No animation — changes instantly
)''',
            ),
            const SizedBox(height: 12),

            // GOOD example
            _CodeSection(
              label: 'GOOD — smooth implicit animation',
              labelColor: Colors.green,
              code: '''AnimatedContainer(
  duration: Duration(milliseconds: 400),
  curve: Curves.easeInOut,
  width: _expanded ? 200 : 80,
  height: _expanded ? 200 : 80,
  decoration: BoxDecoration(
    color: _color,
    borderRadius: BorderRadius.circular(_borderRadius),
  ),
)''',
            ),
            const SizedBox(height: 24),

            // Live demo
            const Text(
              'Live Demo',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                width: _expanded ? 220 : 80,
                height: _expanded ? 220 : 80,
                decoration: BoxDecoration(
                  color: _color,
                  borderRadius: BorderRadius.circular(_borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: _color.withValues(alpha: 0.4),
                      blurRadius: _expanded ? 20 : 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.touch_app, color: Colors.white, size: 32),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Controls
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => _expanded = !_expanded),
                  child: Text(_expanded ? 'Shrink' : 'Expand'),
                ),
                ElevatedButton(
                  onPressed: () => setState(
                    () => _color =
                        _color == Colors.blue ? Colors.purple : Colors.blue,
                  ),
                  child: const Text('Toggle Color'),
                ),
                ElevatedButton(
                  onPressed: () => setState(
                    () => _borderRadius = _borderRadius == 8 ? 60 : 8,
                  ),
                  child: const Text('Toggle Shape'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Tip
            _TipCard(
              tip:
                  'AnimatedContainer animates ANY combination of width, height, color, '
                  'padding, decoration, and more — all at once. '
                  'Always set a duration and optionally a curve.',
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
