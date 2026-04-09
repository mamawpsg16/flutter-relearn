import 'package:flutter/material.dart';

class AnimatedOpacityScreen extends StatefulWidget {
  const AnimatedOpacityScreen({super.key});

  @override
  State<AnimatedOpacityScreen> createState() => _AnimatedOpacityScreenState();
}

class _AnimatedOpacityScreenState extends State<AnimatedOpacityScreen> {
  bool _visible = true;
  double _opacity = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnimatedOpacity'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AnimatedOpacity fades a widget in or out smoothly. '
              'The widget stays in the layout even at opacity 0 — '
              'use Visibility or remove from tree if you need it gone entirely.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 20),

            _CodeSection(
              label: 'BAD — instant show/hide with if/else',
              labelColor: Colors.red,
              code: '''if (_visible)
  MyWidget()
// Widget pops in/out with no transition''',
            ),
            const SizedBox(height: 12),

            _CodeSection(
              label: 'GOOD — smooth fade with AnimatedOpacity',
              labelColor: Colors.green,
              code: '''AnimatedOpacity(
  opacity: _visible ? 1.0 : 0.0,
  duration: Duration(milliseconds: 500),
  curve: Curves.easeInOut,
  child: MyWidget(),
)''',
            ),
            const SizedBox(height: 24),

            const Text(
              'Live Demo',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Demo 1: toggle visible
            const Text('Toggle fade (bool):',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            AnimatedOpacity(
              opacity: _visible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.indigo.shade400,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'I fade in and out!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => setState(() => _visible = !_visible),
              child: Text(_visible ? 'Fade Out' : 'Fade In'),
            ),
            const SizedBox(height: 24),

            // Demo 2: slider
            const Text('Fine-tune opacity with a slider:',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(milliseconds: 100),
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.teal.shade400,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Opacity: ${(_opacity * 100).round()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Slider(
              value: _opacity,
              onChanged: (v) => setState(() => _opacity = v),
            ),
            const SizedBox(height: 24),

            _TipCard(
              tip:
                  'AnimatedOpacity keeps the widget in the layout tree at opacity 0 '
                  '(it still occupies space). If you need it completely removed, '
                  'wrap with Visibility(maintainSize: false) or conditionally include it.',
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
