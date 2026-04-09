import 'package:flutter/material.dart';

class TweenAnimationBuilderScreen extends StatefulWidget {
  const TweenAnimationBuilderScreen({super.key});

  @override
  State<TweenAnimationBuilderScreen> createState() =>
      _TweenAnimationBuilderScreenState();
}

class _TweenAnimationBuilderScreenState
    extends State<TweenAnimationBuilderScreen> {
  double _targetSize = 80;
  double _targetAngle = 0;
  Color _targetColor = Colors.blue;
  int _progressTarget = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TweenAnimationBuilder'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Concept ──────────────────────────────────────────────────────
            const Text(
              'Implicit = Flutter tweens for you (AnimatedContainer, AnimatedOpacity).\n'
              'Explicit = you drive it with AnimationController.\n'
              'TweenAnimationBuilder = implicit but for ANY value — '
              'you provide the Tween and Flutter rebuilds the child on every frame.',
              style: TextStyle(fontSize: 15, height: 1.6),
            ),
            const SizedBox(height: 8),
            // Quick comparison card
            Card(
              color: Colors.grey.shade100,
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Implicit  →  AnimatedContainer, AnimatedOpacity, AnimatedSwitcher',
                        style: TextStyle(fontSize: 12, fontFamily: 'monospace')),
                    SizedBox(height: 4),
                    Text('Explicit  →  AnimationController + Tween + AnimatedBuilder',
                        style: TextStyle(fontSize: 12, fontFamily: 'monospace')),
                    SizedBox(height: 4),
                    Text('Bridge    →  TweenAnimationBuilder  ← you are here',
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Code ─────────────────────────────────────────────────────────
            _CodeSection(
              label: 'PROBLEM — AnimatedContainer cannot animate a rotation',
              labelColor: Colors.red,
              code: '''// AnimatedContainer has no "angle" property
// You're stuck — need TweenAnimationBuilder or explicit animation''',
            ),
            const SizedBox(height: 12),
            _CodeSection(
              label: 'GOOD — TweenAnimationBuilder animates ANY value',
              labelColor: Colors.green,
              code: '''TweenAnimationBuilder<double>(
  tween: Tween(begin: 0, end: _targetAngle),
  duration: Duration(milliseconds: 600),
  curve: Curves.easeInOut,
  builder: (context, value, child) {
    return Transform.rotate(
      angle: value,   // value is the current tweened number
      child: child,
    );
  },
  child: Icon(Icons.star, size: 60), // rebuilt once, not every frame
)''',
            ),
            const SizedBox(height: 24),

            const Text(
              'Live Demos',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // ── Demo 1: rotation ─────────────────────────────────────────────
            const Text('1. Rotation (no AnimationController needed):',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: _targetAngle),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                      builder: (_, value, child) =>
                          Transform.rotate(angle: value, child: child),
                      child: const Icon(Icons.star,
                          size: 64, color: Colors.amber),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => setState(
                        () => _targetAngle =
                            _targetAngle == 0 ? 3.14159 : 0,
                      ),
                      child: const Text('Rotate 180°'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Demo 2: custom size ──────────────────────────────────────────
            const Text('2. Custom size animation:',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 80, end: _targetSize),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutBack,
                      builder: (_, value, __) => Container(
                        width: value,
                        height: value,
                        decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(value / 4),
                        ),
                        child: const Center(
                          child: Icon(Icons.flutter_dash,
                              color: Colors.white, size: 32),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      children: [80.0, 140.0, 200.0].map((s) {
                        return ElevatedButton(
                          onPressed: () =>
                              setState(() => _targetSize = s),
                          child: Text('${s.round()}px'),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Demo 3: color tween ──────────────────────────────────────────
            const Text('3. Color tween (ColorTween):',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TweenAnimationBuilder<Color?>(
                      tween: ColorTween(
                          begin: Colors.blue, end: _targetColor),
                      duration: const Duration(milliseconds: 600),
                      builder: (_, color, __) => Container(
                        width: double.infinity,
                        height: 70,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text('Color Tween',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      children: [
                        Colors.blue,
                        Colors.purple,
                        Colors.teal,
                        Colors.orange,
                        Colors.red,
                      ].map((c) {
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _targetColor = c),
                          child: CircleAvatar(
                            backgroundColor: c,
                            radius: 18,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Demo 4: progress bar ─────────────────────────────────────────
            const Text('4. Animated progress bar:',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(
                          begin: 0, end: _progressTarget.toDouble()),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeInOut,
                      builder: (_, value, __) => Column(
                        children: [
                          Text(
                            '${value.round()}%',
                            style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo),
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: value / 100,
                              minHeight: 16,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation(
                                Color.lerp(Colors.red, Colors.green,
                                    value / 100),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      children: [0, 25, 50, 75, 100].map((v) {
                        return ElevatedButton(
                          onPressed: () =>
                              setState(() => _progressTarget = v),
                          child: Text('$v%'),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            _TipCard(
              tip:
                  'Pass a static widget as the child parameter — it is built '
                  'once and passed into builder, so only the Transform/color '
                  'wrapper rebuilds each frame. This keeps performance good.',
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
