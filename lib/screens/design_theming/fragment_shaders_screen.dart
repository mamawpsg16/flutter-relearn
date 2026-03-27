import 'dart:math' as math;
import 'package:flutter/material.dart';

class FragmentShadersScreen extends StatefulWidget {
  const FragmentShadersScreen({super.key});

  @override
  State<FragmentShadersScreen> createState() => _FragmentShadersScreenState();
}

class _FragmentShadersScreenState extends State<FragmentShadersScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _running = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleAnimation() {
    setState(() {
      _running = !_running;
      _running ? _controller.repeat() : _controller.stop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Fragment Shaders'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Fragment shaders (GLSL) run on the GPU and paint each pixel '
            'of a widget individually. Flutter loads them via FragmentProgram '
            'and paints them with a CustomPainter. Great for animated effects, '
            'gradients, and post-processing.',
          ),
          const SizedBox(height: 16),

          // Shader file setup
          const _CodeSection(
            label: 'Step 1 — write a GLSL fragment shader (.frag)',
            labelColor: Colors.blue,
            code: r'''
// assets/shaders/wave.frag
#include <flutter/runtime_effect.glsl>

uniform float uTime;
uniform vec2  uSize;
out vec4 fragColor;

void main() {
  vec2 uv = FlutterFragCoord().xy / uSize;
  float wave = sin(uv.x * 10.0 + uTime * 4.0) * 0.5 + 0.5;
  fragColor = mix(
    vec4(0.2, 0.4, 0.9, 1.0),   // blue
    vec4(0.6, 0.2, 0.8, 1.0),   // purple
    uv.y + wave * 0.2
  );
}''',
          ),
          const SizedBox(height: 12),

          const _CodeSection(
            label: 'Step 2 — declare in pubspec.yaml',
            labelColor: Colors.blue,
            code: '''
flutter:
  shaders:
    - assets/shaders/wave.frag''',
          ),
          const SizedBox(height: 12),

          const _CodeSection(
            label: 'Step 3 — load and paint in Dart',
            labelColor: Colors.green,
            code: r'''
// Load once (e.g. in initState or a FutureBuilder)
final program = await FragmentProgram.fromAsset(
  'assets/shaders/wave.frag',
);
final shader = program.fragmentShader();

// In a CustomPainter:
@override
void paint(Canvas canvas, Size size) {
  shader
    ..setFloat(0, time)       // uTime
    ..setFloat(1, size.width) // uSize.x
    ..setFloat(2, size.height);// uSize.y

  canvas.drawRect(
    Offset.zero & size,
    Paint()..shader = shader,
  );
}''',
          ),
          const SizedBox(height: 16),

          // Dart-side simulation (no real GLSL — simulated with CustomPaint)
          const Text(
            'Live demo — GPU-style animated gradient (simulated in Dart):',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 180,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (_, _) => CustomPaint(
                  painter: _WaveShaderPainter(_controller.value),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: ElevatedButton.icon(
              onPressed: _toggleAnimation,
              icon: Icon(_running ? Icons.pause : Icons.play_arrow),
              label: Text(_running ? 'Pause' : 'Play'),
            ),
          ),
          const SizedBox(height: 16),

          // When to use
          const _CodeSection(
            label: 'Good use cases for fragment shaders',
            labelColor: Colors.orange,
            code: '''
// ✓ Animated backgrounds / gradients
// ✓ Image effects (blur, color grading, vignette)
// ✓ Loading animations
// ✓ Game-like visual effects
// ✗ Simple UI widgets — use Flutter widgets instead
// ✗ Logic or layout — shaders only paint pixels''',
          ),
          const SizedBox(height: 16),

          const _TipCard(
            tip: 'Fragment shaders run entirely on the GPU, so they\'re very '
                'efficient for per-pixel effects. But they can\'t read back pixel '
                'values or do layout — they only output colors.',
          ),
        ],
      ),
    );
  }
}

/// Simulates a wave shader using Canvas drawing (no real GLSL required)
class _WaveShaderPainter extends CustomPainter {
  final double time;
  _WaveShaderPainter(this.time);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // Base gradient (simulates the mix() in GLSL)
    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.lerp(const Color(0xFF3366FF), const Color(0xFF9933CC),
              (math.sin(time * math.pi * 2) * 0.5 + 0.5))!,
          Color.lerp(const Color(0xFF9933CC), const Color(0xFF33CCFF),
              (math.cos(time * math.pi * 2) * 0.5 + 0.5))!,
        ],
      ).createShader(rect);
    canvas.drawRect(rect, bgPaint);

    // Wave layers
    for (int i = 0; i < 4; i++) {
      final path = Path();
      final offset = i * 0.25;
      final waveHeight = size.height * 0.06;
      final yBase = size.height * (0.3 + i * 0.15);

      path.moveTo(0, yBase);
      for (double x = 0; x <= size.width; x += 2) {
        final y = yBase +
            math.sin((x / size.width * 2 * math.pi * 2) +
                    time * math.pi * 2 +
                    offset * math.pi) *
                waveHeight;
        path.lineTo(x, y);
      }
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();

      final wavePaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.08 + i * 0.04)
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, wavePaint);
    }

    // Shimmer dots
    final dotPaint = Paint()..color = Colors.white.withValues(alpha: 0.3);
    for (int i = 0; i < 20; i++) {
      final x = (math.sin(i * 1.3 + time * math.pi * 2) * 0.5 + 0.5) * size.width;
      final y = (math.cos(i * 0.9 + time * math.pi * 1.5) * 0.5 + 0.5) * size.height;
      final r = 2.0 + math.sin(i + time * math.pi * 3) * 1.5;
      canvas.drawCircle(Offset(x, y), r, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_WaveShaderPainter old) => old.time != time;
}

class _CodeSection extends StatelessWidget {
  final String label;
  final Color labelColor;
  final String code;
  const _CodeSection(
      {required this.label, required this.labelColor, required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.grey.shade900, borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  color: labelColor, fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          Text(code,
              style: const TextStyle(
                  color: Colors.white, fontFamily: 'monospace', fontSize: 13)),
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
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lightbulb, color: Colors.purple, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(tip)),
          ],
        ),
      ),
    );
  }
}
