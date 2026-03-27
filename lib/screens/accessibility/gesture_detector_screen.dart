// GestureDetector — tap, double tap, long press, drag, pan, scale

import 'package:flutter/material.dart';

class GestureDetectorScreen extends StatefulWidget {
  const GestureDetectorScreen({super.key});

  @override
  State<GestureDetectorScreen> createState() => _GestureDetectorScreenState();
}

class _GestureDetectorScreenState extends State<GestureDetectorScreen> {
  String _lastGesture = 'none';
  Offset _position = const Offset(150, 100);
  double _scale = 1.0;
  double _baseScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GestureDetector'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Explanation ───────────────────────────────────────────────
            Card(
              color: Colors.pink.shade50,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GestureDetector wraps any widget and listens for touch gestures.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• onTap → single tap\n'
                      '• onDoubleTap → two taps quickly\n'
                      '• onLongPress → held for ~500ms\n'
                      '• onPanUpdate → finger dragging\n'
                      '• onScaleUpdate → pinch-to-zoom (2 fingers)\n'
                      '• InkWell → like GestureDetector but with Material ripple',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Last gesture indicator ────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.pink.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.touch_app, color: Colors.pink),
                  const SizedBox(width: 8),
                  Text(
                    'Last gesture: $_lastGesture',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Basic gestures ────────────────────────────────────────────
            const _SectionTitle('Basic gestures'),
            const _Tip('Tap, double tap, and long press on each box.'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _lastGesture = 'onTap'),
                    child: _GestureBox(label: 'Tap me', color: Colors.blue),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onDoubleTap: () =>
                        setState(() => _lastGesture = 'onDoubleTap'),
                    child: _GestureBox(
                        label: 'Double tap', color: Colors.green),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onLongPress: () =>
                        setState(() => _lastGesture = 'onLongPress'),
                    child: _GestureBox(
                        label: 'Long press', color: Colors.orange),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Pan / drag ────────────────────────────────────────────────
            const _SectionTitle('onPanUpdate — draggable box'),
            const _Tip('Drag the circle around inside the container.'),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                  ),
                  Positioned(
                    left: _position.dx.clamp(0, 250),
                    top: _position.dy.clamp(0, 140),
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          _position = _position + details.delta;
                          _lastGesture =
                              'onPanUpdate Δ(${details.delta.dx.toStringAsFixed(1)}, ${details.delta.dy.toStringAsFixed(1)})';
                        });
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: Colors.purple,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.drag_indicator,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Scale / pinch ─────────────────────────────────────────────
            const _SectionTitle('onScaleUpdate — pinch to zoom'),
            const _Tip(
                'Use two fingers to pinch-zoom the box. '
                'On desktop/emulator: Ctrl + scroll or spread two fingers.'),
            const SizedBox(height: 8),
            Center(
              child: GestureDetector(
                onScaleStart: (_) => _baseScale = _scale,
                onScaleUpdate: (details) {
                  setState(() {
                    _scale = (_baseScale * details.scale).clamp(0.5, 3.0);
                    _lastGesture =
                        'onScaleUpdate scale=${_scale.toStringAsFixed(2)}';
                  });
                },
                child: Transform.scale(
                  scale: _scale,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text('Pinch me',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── InkWell ───────────────────────────────────────────────────
            const _SectionTitle('InkWell — Material ripple'),
            const _Tip(
                'InkWell is the Material version of GestureDetector. '
                'It adds a ripple ink splash on tap.'),
            const SizedBox(height: 8),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => setState(() => _lastGesture = 'InkWell onTap'),
                onLongPress: () =>
                    setState(() => _lastGesture = 'InkWell onLongPress'),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.indigo.shade200),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.water_drop, color: Colors.indigo),
                      SizedBox(width: 8),
                      Text('InkWell — tap for ripple effect'),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Key takeaways ─────────────────────────────────────────────
            Card(
              color: Colors.pink.shade50,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Key takeaways',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text(
                      '• GestureDetector wraps any widget — no visual change.\n'
                      '• InkWell adds Material ripple — use for tappable cards/items.\n'
                      '• onPanUpdate gives you delta movement for dragging.\n'
                      '• onScaleUpdate gives you scale (pinch) and rotation.\n'
                      '• Only one gesture wins per touch — Flutter has a gesture arena.',
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

class _GestureBox extends StatelessWidget {
  final String label;
  final Color color;
  const _GestureBox({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Center(
        child: Text(label,
            style: TextStyle(color: color, fontWeight: FontWeight.bold)),
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
