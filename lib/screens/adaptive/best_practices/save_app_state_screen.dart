import 'package:flutter/material.dart';

class SaveAppStateScreen extends StatelessWidget {
  const SaveAppStateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Save App State'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _CodeSection(
            label: 'BAD — text lost when widget rebuilds on rotation',
            labelColor: Colors.red,
            code: '''
class _FormState extends State<MyForm> {
  // controller created here gets disposed
  // and recreated on every rebuild
  final ctrl = TextEditingController();
}''',
          ),
          SizedBox(height: 12),
          _CodeSection(
            label: 'GOOD — state survives rebuilds',
            labelColor: Colors.green,
            code: '''
class _FormState extends State<MyForm> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose(); // only disposed when truly leaving
    super.dispose();
  }
}''',
          ),
          SizedBox(height: 16),
          _TipCard(
            tip: "Don't lose form data or selections on rotation or resize. "
                'Keep state in a StatefulWidget or state management solution '
                'that lives above the layout widget.',
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
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lightbulb, color: Colors.green, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(tip)),
          ],
        ),
      ),
    );
  }
}
