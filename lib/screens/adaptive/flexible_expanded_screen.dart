// Expanded always fills available space. Flexible can be smaller if the child doesn't need it.

import 'package:flutter/material.dart';

class FlexibleExpandedScreen extends StatelessWidget {
  const FlexibleExpandedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flexible & Expanded'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Section 1: Expanded equal sharing ─────────────────────────
            _SectionTitle('Expanded — equal sharing (flex: 1 each)'),
            const SizedBox(height: 8),
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  Expanded(child: _Box('Expanded', Colors.red)),
                  const SizedBox(width: 4),
                  Expanded(child: _Box('Expanded', Colors.orange)),
                  const SizedBox(width: 4),
                  Expanded(child: _Box('Expanded', Colors.yellow)),
                ],
              ),
            ),
            const _Tip(
              'Each Expanded fills 1/3 of the row. '
              'They all share space equally when flex is not set (defaults to 1).',
            ),

            const SizedBox(height: 24),

            // ── Section 2: Expanded with custom flex ──────────────────────
            _SectionTitle('Expanded — weighted sharing (flex: 1 / 2 / 3)'),
            const SizedBox(height: 8),
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: _Box('flex:1', Colors.blue.shade200),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    flex: 2,
                    child: _Box('flex:2', Colors.blue.shade400),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    flex: 3,
                    child: _Box('flex:3', Colors.blue.shade700),
                  ),
                ],
              ),
            ),
            const _Tip(
              'Total flex = 1+2+3 = 6. '
              'flex:1 gets 1/6, flex:2 gets 2/6, flex:3 gets 3/6 of the space.',
            ),

            const SizedBox(height: 24),

            // ── Section 3: Flexible vs Expanded ───────────────────────────
            _SectionTitle('Flexible vs Expanded'),
            const SizedBox(height: 8),

            // Expanded example — always fills
            const Text(
              'Expanded — always fills remaining space:',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  _Box('Fixed 80dp', Colors.grey, width: 80),
                  const SizedBox(width: 4),
                  // Expanded forces the child to fill ALL remaining space
                  Expanded(child: _Box('Expanded\n(fills rest)', Colors.purple)),
                  const SizedBox(width: 4),
                  _Box('Fixed 80dp', Colors.grey, width: 80),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Flexible example — can be smaller
            const Text(
              'Flexible — only takes what its child needs (fit: loose):',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  _Box('Fixed 80dp', Colors.grey, width: 80),
                  const SizedBox(width: 4),
                  // Flexible with FlexFit.loose lets the child be smaller than available space
                  Flexible(
                    child: _Box('Flexible\n(only 120dp)', Colors.teal, width: 120),
                  ),
                  const SizedBox(width: 4),
                  _Box('Fixed 80dp', Colors.grey, width: 80),
                ],
              ),
            ),

            const _Tip(
              'Expanded = Flexible with FlexFit.tight (must fill).\n'
              'Flexible with FlexFit.loose = child picks its own size, '
              'up to the available space.',
            ),

            const SizedBox(height: 24),

            // ── Section 4: Expanded in a Column ───────────────────────────
            _SectionTitle('Expanded in a Column'),
            const SizedBox(height: 8),
            Container(
              height: 260,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.purple.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Box('Fixed height header', Colors.purple.shade200, height: 50),
                  // Expanded fills all space between fixed-height siblings
                  Expanded(
                    child: _Box(
                      'Expanded\n(fills remaining column space)',
                      Colors.purple,
                    ),
                  ),
                  _Box('Fixed height footer', Colors.purple.shade200, height: 50),
                ],
              ),
            ),
            const _Tip(
              'Expanded works in both Row and Column. '
              'It fills the leftover space after fixed-size siblings are laid out.',
            ),

            const SizedBox(height: 24),

            // ── Summary card ──────────────────────────────────────────────
            Card(
              color: Colors.purple.shade50,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick reference',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Expanded     → always fill all available space (FlexFit.tight)\n'
                      'Flexible     → fill up to available space (FlexFit.loose by default)\n'
                      'flex: N      → relative weight when multiple Expanded/Flexible share space\n\n'
                      'Use inside: Row, Column, or Flex widgets only.',
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

// ── Helper widgets ─────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}

class _Tip extends StatelessWidget {
  final String text;
  const _Tip(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(text, style: const TextStyle(color: Colors.black54, fontSize: 12)),
    );
  }
}

class _Box extends StatelessWidget {
  final String label;
  final Color color;
  final double? width;
  final double? height;

  const _Box(this.label, this.color, {this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
