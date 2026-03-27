// Use LayoutBuilder when you need to respond to the PARENT widget's constraints, not the screen

import 'package:flutter/material.dart';

class LayoutBuilderScreen extends StatefulWidget {
  const LayoutBuilderScreen({super.key});

  @override
  State<LayoutBuilderScreen> createState() => _LayoutBuilderScreenState();
}

class _LayoutBuilderScreenState extends State<LayoutBuilderScreen> {
  // Fraction of the available width the resizable container occupies
  double _widthFraction = 0.5;

  static const _items = [
    ('Item 1', Colors.red),
    ('Item 2', Colors.orange),
    ('Item 3', Colors.yellow),
    ('Item 4', Colors.green),
    ('Item 5', Colors.blue),
    ('Item 6', Colors.purple),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LayoutBuilder'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Explanation ───────────────────────────────────────────────
            Card(
              color: Colors.teal.shade50,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'LayoutBuilder gives you the constraints of the PARENT '
                  'widget — not the whole screen.\n\n'
                  'Drag the slider to resize the container below and watch '
                  'the layout switch between 1, 2, and 3 columns.',
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Slider to resize container ────────────────────────────────
            const Text(
              'Resize the container',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            // LayoutBuilder here lets us base the slider max on available width
            LayoutBuilder(
              builder: (context, constraints) {
                final containerWidth = constraints.maxWidth * _widthFraction;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Slider(
                      value: _widthFraction,
                      min: 0.15,
                      max: 1.0,
                      divisions: 17,
                      label: '${containerWidth.toInt()} dp',
                      onChanged: (v) => setState(() => _widthFraction = v),
                    ),
                    Text(
                      'Container width: ${containerWidth.toInt()} dp  '
                      '(${(_widthFraction * 100).toInt()}% of available)',
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 16),

                    // ── Resizable container with inner LayoutBuilder ───────
                    Container(
                      width: containerWidth,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.teal, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: LayoutBuilder(
                        builder: (context, innerConstraints) {
                          final w = innerConstraints.maxWidth;

                          // Determine layout mode from parent width
                          final String mode;
                          final int columns;
                          if (w < 300) {
                            mode = 'Compact — 1 column  (< 300 dp)';
                            columns = 1;
                          } else if (w <= 500) {
                            mode = 'Medium — 2 columns  (300–500 dp)';
                            columns = 2;
                          } else {
                            mode = 'Expanded — 3 columns  (> 500 dp)';
                            columns = 3;
                          }

                          return Column(
                            children: [
                              // Mode banner
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.teal.shade700,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(6),
                                  ),
                                ),
                                child: Text(
                                  mode,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              // Grid / list of items
                              columns == 1 ? _buildList() : _buildGrid(columns),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            // ── Usage tip ─────────────────────────────────────────────────
            Card(
              color: Colors.teal.shade50,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LayoutBuilder vs MediaQuery',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• Use LayoutBuilder inside reusable widgets that '
                      'don\'t know how much space they\'ll get.\n'
                      '• Use MediaQuery at the top level when you need '
                      'actual screen dimensions or device info.',
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

  Widget _buildList() {
    return Column(
      children: _items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.all(6),
              child: _ItemBox(label: item.$1, color: item.$2),
            ),
          )
          .toList(),
    );
  }

  Widget _buildGrid(int columns) {
    return GridView.count(
      crossAxisCount: columns,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(6),
      mainAxisSpacing: 6,
      crossAxisSpacing: 6,
      children: _items
          .map((item) => _ItemBox(label: item.$1, color: item.$2))
          .toList(),
    );
  }
}

class _ItemBox extends StatelessWidget {
  final String label;
  final Color color;

  const _ItemBox({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
