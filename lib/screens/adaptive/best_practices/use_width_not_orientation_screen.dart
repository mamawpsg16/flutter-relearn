import 'package:flutter/material.dart';

class UseWidthNotOrientationScreen extends StatelessWidget {
  const UseWidthNotOrientationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Use Width, Not Orientation'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _CodeSection(
            label: 'BAD — orientation does not tell you actual space',
            labelColor: Colors.red,
            code: '''
final o = MediaQuery.of(context).orientation;
if (o == Orientation.landscape)
  return Row(children: [sidebar, content]);''',
          ),
          const SizedBox(height: 12),
          const _CodeSection(
            label: 'GOOD — width is the real measure',
            labelColor: Colors.green,
            code: '''
final w = MediaQuery.of(context).size.width;
if (w >= 600)
  return Row(children: [sidebar, content]);
return Column(children: [content]);''',
          ),
          const SizedBox(height: 16),
          // Live demo
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isWide ? Colors.green.shade100 : Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isWide ? Colors.green : Colors.blue,
              ),
            ),
            child: Text(
              isWide
                  ? 'Wide layout (>= 600 dp) — width: ${width.toStringAsFixed(0)} dp'
                  : 'Narrow layout (< 600 dp) — width: ${width.toStringAsFixed(0)} dp',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isWide ? Colors.green.shade800 : Colors.blue.shade800,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const _TipCard(
            tip: 'A tablet in portrait is wider than a phone in landscape. '
                'Always branch on available width (breakpoints), '
                'never on Orientation.',
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
      color: Colors.teal.shade50,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lightbulb, color: Colors.teal, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(tip)),
          ],
        ),
      ),
    );
  }
}
