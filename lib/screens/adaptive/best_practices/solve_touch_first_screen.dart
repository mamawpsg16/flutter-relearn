import 'package:flutter/material.dart';

class SolveTouchFirstScreen extends StatelessWidget {
  const SolveTouchFirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solve Touch First'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _CodeSection(
            label: 'BAD — tiny tap target',
            labelColor: Colors.red,
            code: '''
GestureDetector(
  onTap: () {},
  child: Icon(Icons.delete, size: 16),
)''',
          ),
          SizedBox(height: 12),
          _CodeSection(
            label: 'GOOD — meets minimum 48×48 touch target',
            labelColor: Colors.green,
            code: '''
IconButton(
  icon: const Icon(Icons.delete),
  iconSize: 24, // IconButton adds padding → 48×48
  onPressed: () {},
)''',
          ),
          SizedBox(height: 16),
          _TipCard(
            tip: 'Design for fingers first. Touch is the hardest constraint — '
                'adapting to mouse/keyboard is easy once touch works well. '
                'Minimum tap target: 48×48 logical pixels.',
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
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: labelColor,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            code,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'monospace',
              fontSize: 13,
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
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lightbulb, color: Colors.orange, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(tip)),
          ],
        ),
      ),
    );
  }
}
