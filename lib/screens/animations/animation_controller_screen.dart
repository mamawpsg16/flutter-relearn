import 'package:flutter/material.dart';

class AnimationControllerScreen extends StatefulWidget {
  const AnimationControllerScreen({super.key});

  @override
  State<AnimationControllerScreen> createState() =>
      _AnimationControllerScreenState();
}

class _AnimationControllerScreenState extends State<AnimationControllerScreen>
    with TickerProviderStateMixin {
  // ── Demo 1: basic forward/reverse ────────────────────────────────────────
  late final AnimationController _basicCtrl;
  late final Animation<double> _basicAnim;

  // ── Demo 2: looping pulse ────────────────────────────────────────────────
  late final AnimationController _loopCtrl;
  late final Animation<double> _pulseAnim;

  // ── Demo 3: chained sequence ─────────────────────────────────────────────
  late final AnimationController _chainCtrl;
  late final Animation<double> _slideAnim;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    // Demo 1
    _basicCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _basicAnim = CurvedAnimation(
      parent: _basicCtrl,
      curve: Curves.easeInOut,
    );

    // Demo 2 — loop forever
    _loopCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _loopCtrl, curve: Curves.easeInOut),
    );

    // Demo 3 — 3 stages in one controller using Interval
    _chainCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _slideAnim = Tween<double>(begin: -60, end: 0).animate(
      CurvedAnimation(
        parent: _chainCtrl,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _chainCtrl,
        curve: const Interval(0.2, 0.6, curve: Curves.easeIn),
      ),
    );
    _scaleAnim = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(
        parent: _chainCtrl,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOutBack),
      ),
    );
  }

  @override
  void dispose() {
    _basicCtrl.dispose();
    _loopCtrl.dispose();
    _chainCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnimationController'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Concept ────────────────────────────────────────────────────
            const Text(
              'AnimationController is the explicit approach — you control '
              'start, stop, reverse, and repeat manually. '
              'Pair it with a Tween to produce values, and AnimatedBuilder '
              'to rebuild only the widgets that need updating.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 20),

            _CodeSection(
              label: 'Core pattern',
              labelColor: Colors.green,
              code: '''// 1. Mixin gives the controller a vsync ticker
class _MyState extends State<My> with SingleTickerProviderStateMixin {

  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,                        // prevents off-screen animation
      duration: Duration(milliseconds: 600),
    );
    _anim = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
          parent: _ctrl,
          curve: Curves.easeInOut,        // apply a curve
        ));
  }

  @override
  void dispose() {
    _ctrl.dispose();                      // always dispose!
    super.dispose();
  }

  // 2. AnimatedBuilder rebuilds only its subtree
  Widget build(_) => AnimatedBuilder(
    animation: _anim,
    builder: (_, child) => Opacity(
      opacity: _anim.value,
      child: child,
    ),
    child: const MyWidget(),              // built once, not every frame
  );
}''',
            ),
            const SizedBox(height: 24),

            // ── Demo 1: forward / reverse ───────────────────────────────────
            const Text(
              '1. Forward & Reverse',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    AnimatedBuilder(
                      animation: _basicAnim,
                      builder: (_, child) => Opacity(
                        opacity: _basicAnim.value,
                        child: Transform.scale(
                          scale: 0.5 + _basicAnim.value * 0.5,
                          child: child,
                        ),
                      ),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.star,
                            color: Colors.white, size: 48),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      children: [
                        ElevatedButton(
                          onPressed: () => _basicCtrl.forward(),
                          child: const Text('Forward'),
                        ),
                        ElevatedButton(
                          onPressed: () => _basicCtrl.reverse(),
                          child: const Text('Reverse'),
                        ),
                        ElevatedButton(
                          onPressed: () => _basicCtrl.reset(),
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Progress bar showing controller value
                    AnimatedBuilder(
                      animation: _basicCtrl,
                      builder: (_, __) => Column(
                        children: [
                          Text(
                            'value: ${_basicCtrl.value.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontFamily: 'monospace', fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                              value: _basicCtrl.value),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Demo 2: looping ─────────────────────────────────────────────
            const Text(
              '2. Looping (repeat)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            _CodeSection(
              label: 'repeat(reverse: true) loops back and forth forever',
              labelColor: Colors.blue,
              code: '''_ctrl = AnimationController(vsync: this, duration: ...)
  ..repeat(reverse: true); // starts immediately, loops''',
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Pulse scale
                    AnimatedBuilder(
                      animation: _pulseAnim,
                      builder: (_, child) =>
                          Transform.scale(scale: _pulseAnim.value, child: child),
                      child: const CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.red,
                        child: Icon(Icons.favorite,
                            color: Colors.white, size: 36),
                      ),
                    ),
                    // Spinning
                    AnimatedBuilder(
                      animation: _loopCtrl,
                      builder: (_, child) => Transform.rotate(
                        angle: _loopCtrl.value * 6.28318, // 2π
                        child: child,
                      ),
                      child: const Icon(Icons.settings,
                          size: 64, color: Colors.grey),
                    ),
                    // Opacity blink
                    AnimatedBuilder(
                      animation: _loopCtrl,
                      builder: (_, child) =>
                          Opacity(opacity: _loopCtrl.value, child: child),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Demo 3: chained with Interval ───────────────────────────────
            const Text(
              '3. Chained sequence with Interval',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            _CodeSection(
              label: 'Interval splits one controller into multiple stages',
              labelColor: Colors.purple,
              code: '''// Slide: plays during 0%–40% of the total duration
_slideAnim = Tween(...).animate(CurvedAnimation(
  parent: _ctrl,
  curve: Interval(0.0, 0.4, curve: Curves.easeOut),
));
// Fade: plays during 20%–60%
_fadeAnim = Tween(...).animate(CurvedAnimation(
  parent: _ctrl,
  curve: Interval(0.2, 0.6, curve: Curves.easeIn),
));
// Scale: plays during 50%–100%
_scaleAnim = Tween(...).animate(CurvedAnimation(
  parent: _ctrl,
  curve: Interval(0.5, 1.0, curve: Curves.easeOutBack),
));''',
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 120,
                      child: AnimatedBuilder(
                        animation: _chainCtrl,
                        builder: (_, child) => Transform.translate(
                          offset: Offset(_slideAnim.value, 0),
                          child: Opacity(
                            opacity: _fadeAnim.value.clamp(0.0, 1.0),
                            child: Transform.scale(
                              scale: _scaleAnim.value,
                              child: child,
                            ),
                          ),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.purple.shade400,
                                Colors.pink.shade400
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Text(
                              'Slide → Fade → Scale',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _chainCtrl.reset();
                            _chainCtrl.forward();
                          },
                          child: const Text('Play'),
                        ),
                        ElevatedButton(
                          onPressed: () => _chainCtrl.reset(),
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            _TipCard(
              tip:
                  'Always call _ctrl.dispose() in dispose(). '
                  'Use TickerProviderStateMixin (not Single...) when you need '
                  'more than one AnimationController in the same State.',
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
