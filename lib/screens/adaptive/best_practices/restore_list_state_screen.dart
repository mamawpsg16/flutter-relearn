import 'package:flutter/material.dart';

class RestoreListStateScreen extends StatelessWidget {
  const RestoreListStateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restore List State'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _CodeSection(
            label: 'BAD — scroll position lost on rebuild',
            labelColor: Colors.red,
            code: '''
ListView.builder(
  itemCount: items.length,
  itemBuilder: (_, i) => Text(items[i]),
)''',
          ),
          SizedBox(height: 12),
          _CodeSection(
            label: 'GOOD — scroll position preserved',
            labelColor: Colors.green,
            code: '''
ListView.builder(
  key: const PageStorageKey('my-list'),
  itemCount: items.length,
  itemBuilder: (_, i) => Text(items[i]),
)''',
          ),
          SizedBox(height: 16),
          _TipCard(
            tip: 'If the user was scrolled to item 50 and rotates the phone, '
                'they should still be at item 50. '
                'PageStorageKey preserves scroll position across rebuilds.',
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
      color: Colors.brown.shade50,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.lightbulb, color: Colors.brown.shade400, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(tip)),
          ],
        ),
      ),
    );
  }
}
