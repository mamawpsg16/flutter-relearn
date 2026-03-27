// Use MediaQuery when you need raw screen/device information

import 'package:flutter/material.dart';

class MediaQueryScreen extends StatelessWidget {
  const MediaQueryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final width = mq.size.width;
    final height = mq.size.height;
    final dpr = mq.devicePixelRatio;
    final textScale = mq.textScaler.scale(1.0);
    final orientation = mq.orientation;
    final brightness = mq.platformBrightness;
    final topPadding = mq.padding.top;
    final bottomPadding = mq.padding.bottom;

    // Breakpoint logic: blue for narrow, green for wide
    final isWide = width >= 600;
    final breakpointColor = isWide ? Colors.green : Colors.blue;
    final breakpointLabel = isWide
        ? 'Wide layout (>= 600px) — tablet/desktop breakpoint'
        : 'Narrow layout (< 600px) — mobile breakpoint';

    return Scaffold(
      appBar: AppBar(
        title: const Text('MediaQuery'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Info section ─────────────────────────────────────────────
            const Text(
              'What MediaQuery exposes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _InfoRow('Screen width', '${width.toStringAsFixed(1)} dp'),
                    _InfoRow('Screen height', '${height.toStringAsFixed(1)} dp'),
                    _InfoRow('Device pixel ratio', dpr.toStringAsFixed(2)),
                    _InfoRow('Text scale factor', textScale.toStringAsFixed(2)),
                    _InfoRow(
                      'Orientation',
                      orientation == Orientation.portrait
                          ? 'Portrait'
                          : 'Landscape',
                    ),
                    _InfoRow(
                      'Platform brightness',
                      brightness == Brightness.dark ? 'Dark' : 'Light',
                    ),
                    _InfoRow(
                      'Top padding (status bar)',
                      '${topPadding.toStringAsFixed(1)} dp',
                    ),
                    _InfoRow(
                      'Bottom padding (home bar)',
                      '${bottomPadding.toStringAsFixed(1)} dp',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Breakpoint visual ─────────────────────────────────────────
            const Text(
              'Breakpoint visualiser',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'The container below changes colour depending on the screen '
              'width. Resize the window (or rotate the device) to see it change.',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: breakpointColor,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                breakpointLabel,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Usage tip ─────────────────────────────────────────────────
            Card(
              color: Colors.indigo.shade50,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'When to use MediaQuery',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• You need the actual screen dimensions.\n'
                      '• You need safe-area insets (padding).\n'
                      '• You need to react to orientation or brightness.\n\n'
                      'Prefer LayoutBuilder when you only need to respond '
                      'to the size of a specific parent widget.',
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

// ── Helper widget ─────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
