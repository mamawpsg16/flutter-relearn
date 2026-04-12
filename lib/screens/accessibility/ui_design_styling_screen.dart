import 'package:flutter/material.dart';

class UiDesignStylingScreen extends StatefulWidget {
  const UiDesignStylingScreen({super.key});

  @override
  State<UiDesignStylingScreen> createState() => _UiDesignStylingScreenState();
}

class _UiDesignStylingScreenState extends State<UiDesignStylingScreen> {
  double _textScale = 1.0;
  int _smallTaps = 0;
  int _bigTaps = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UI Design & Styling'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(_textScale),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Accessible UI design covers three core rules: sufficient color contrast '
                '(WCAG AA), minimum 48×48dp touch targets, and text that scales with '
                'the user\'s system font size. Getting these right helps users with '
                'low vision, motor impairments, and cognitive differences.',
                style: TextStyle(fontSize: 15, height: 1.5),
              ),
              const SizedBox(height: 24),

              // ── Section 1: Touch targets ──────────────────────────
              const Text('1. Touch Target Size (min 48×48dp)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _CodeSection(
                label: 'BAD — tiny tap target',
                labelColor: Colors.red,
                code: '''GestureDetector(
  onTap: onDelete,
  child: Icon(Icons.close, size: 14), // only 14dp hit area
)''',
              ),
              const SizedBox(height: 8),
              _CodeSection(
                label: 'GOOD — padding expands the hit area to 48dp+',
                labelColor: Colors.green,
                code: '''// Option 1: padding around the icon
GestureDetector(
  onTap: onDelete,
  child: Padding(
    padding: EdgeInsets.all(17), // 14 + 17*2 = 48dp
    child: Icon(Icons.close, size: 14),
  ),
)
// Option 2: use IconButton — already 48dp by default
IconButton(onPressed: onDelete, icon: Icon(Icons.close))''',
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.red, width: 2),
                                  color: Colors.red.shade50,
                                ),
                                child: GestureDetector(
                                  onTap: () =>
                                      setState(() => _smallTaps++),
                                  child: const Icon(Icons.close, size: 14),
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text('Too small',
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.red)),
                              Text('hits: $_smallTaps',
                                  style: const TextStyle(fontSize: 11)),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.green, width: 2),
                                  color: Colors.green.shade50,
                                ),
                                child: GestureDetector(
                                  onTap: () => setState(() => _bigTaps++),
                                  child: const Center(
                                      child: Icon(Icons.close, size: 14)),
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text('48×48dp',
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.green)),
                              Text('hits: $_bigTaps',
                                  style: const TextStyle(fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Try tapping both quickly — the right one is much easier to hit',
                        style: TextStyle(
                            fontSize: 12, fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Section 2: Text scaling ───────────────────────────
              const Text('2. Text Scaling',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _CodeSection(
                label: 'BAD — opt out of text scaling',
                labelColor: Colors.red,
                code: '''Text(
  'Hello',
  textScaler: TextScaler.noScaling, // ignores user preference
)''',
              ),
              const SizedBox(height: 8),
              _CodeSection(
                label: 'GOOD — respect scale, but cap where layout would break',
                labelColor: Colors.green,
                code: '''// Default: just don\'t override textScaler
Text('Body text') // scales automatically

// Cap display-size text so layout stays intact
Text(
  'Hero Title',
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
  // still scales, but won\'t overflow the card
)''',
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('Scale: '),
                          Expanded(
                            child: Slider(
                              value: _textScale,
                              min: 0.8,
                              max: 2.0,
                              divisions: 12,
                              label: '${_textScale.toStringAsFixed(1)}×',
                              onChanged: (v) =>
                                  setState(() => _textScale = v),
                            ),
                          ),
                          SizedBox(
                            width: 36,
                            child: Text('${_textScale.toStringAsFixed(1)}×',
                                style: const TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Product Name',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            const Text(
                                'Description text that wraps gracefully when '
                                'the user increases font size.'),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text('Add to Cart'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _textScale > 1.5
                            ? '⚠ Check for overflow at this scale'
                            : '✓ Layout looks good',
                        style: TextStyle(
                            fontSize: 12,
                            color: _textScale > 1.5
                                ? Colors.orange
                                : Colors.green),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Section 3: Color contrast ─────────────────────────
              const Text('3. Color Contrast',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                'WCAG AA requires 4.5:1 contrast for normal text, 3:1 for large '
                'text (18pt+ or 14pt bold). Below are real-world examples.',
                style: TextStyle(height: 1.4),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: const [
                      _ContrastRow(
                        ratio: '1.6:1',
                        bg: Color(0xFFFFFFFF),
                        fg: Color(0xFFDDDDDD),
                        passes: false,
                      ),
                      SizedBox(height: 8),
                      _ContrastRow(
                        ratio: '2.3:1',
                        bg: Color(0xFFFFFFFF),
                        fg: Color(0xFFAAAAAA),
                        passes: false,
                      ),
                      SizedBox(height: 8),
                      _ContrastRow(
                        ratio: '4.6:1',
                        bg: Color(0xFFFFFFFF),
                        fg: Color(0xFF767676),
                        passes: true,
                      ),
                      SizedBox(height: 8),
                      _ContrastRow(
                        ratio: '7.0:1',
                        bg: Color(0xFFFFFFFF),
                        fg: Color(0xFF595959),
                        passes: true,
                      ),
                      SizedBox(height: 8),
                      _ContrastRow(
                        ratio: '21:1',
                        bg: Color(0xFFFFFFFF),
                        fg: Color(0xFF000000),
                        passes: true,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              _TipCard(
                tip: 'Use Material 3\'s color system — it\'s built with contrast '
                    'in mind. Avoid light text on light backgrounds. Always test '
                    'your layout at 1.5× and 2× text scale so nothing clips or '
                    'overflows for users who need larger text.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContrastRow extends StatelessWidget {
  final String ratio;
  final Color bg;
  final Color fg;
  final bool passes;

  const _ContrastRow({
    required this.ratio,
    required this.bg,
    required this.fg,
    required this.passes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(
            color: passes ? Colors.green : Colors.red, width: 2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text('Sample text — $ratio',
                style: TextStyle(color: fg, fontSize: 15)),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: passes ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              passes ? 'PASS' : 'FAIL',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
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
