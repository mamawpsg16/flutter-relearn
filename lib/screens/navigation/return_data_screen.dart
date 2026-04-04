import 'package:flutter/material.dart';

class ReturnDataScreen extends StatefulWidget {
  const ReturnDataScreen({super.key});

  @override
  State<ReturnDataScreen> createState() => _ReturnDataScreenState();
}

class _ReturnDataScreenState extends State<ReturnDataScreen> {
  String? _result;

  Future<void> _openPicker() async {
    // Navigator.push returns a Future — await it to get the popped value
    final picked = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const _PickerScreen()),
    );
    // picked is null if the user pressed the back button without selecting
    if (picked != null) {
      setState(() => _result = picked);

      // Show the result in a snackbar using the cascade operator
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text('You selected: $picked')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Return Data from a Screen'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Navigator.push() returns a Future. When the second screen calls '
            'Navigator.pop(context, value), that value becomes the result '
            'of the Future. Await it on the calling screen to get the data back.',
            style: TextStyle(fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 24),

          const _CodeSection(
            label: 'BAD — trying to get data back without awaiting',
            labelColor: Colors.red,
            code: '''// ❌ push() returns a Future — ignoring it loses the result
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const PickerScreen()),
);
// result is gone — you never captured it''',
          ),
          const SizedBox(height: 12),

          const _CodeSection(
            label: 'GOOD — await the push, pop with a value',
            labelColor: Colors.green,
            code: '''// ── Screen A (caller) ──────────────────────────────
// Mark the method async and await the push:
Future<void> _openPicker() async {
  final result = await Navigator.push<String>(
    context,
    MaterialPageRoute(builder: (_) => const PickerScreen()),
  );

  // result is null if user pressed back without selecting
  if (result != null) {
    setState(() => _selected = result);
  }
}

// ── Screen B (picker) ────────────────────────────────
// Pass the value to pop():
ElevatedButton(
  onPressed: () => Navigator.pop(context, 'Option A'),
  child: const Text('Choose Option A'),
)''',
          ),
          const SizedBox(height: 24),

          const Text('Live Demo',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.inbox, color: Colors.green),
                    const SizedBox(width: 8),
                    const Text('Result received here:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ]),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _result != null
                          ? Colors.green.shade50
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: _result != null
                              ? Colors.green
                              : Colors.grey.shade300),
                    ),
                    child: Text(
                      _result ?? 'Nothing selected yet',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _result != null ? Colors.green : Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('Open Picker Screen'),
                      onPressed: _openPicker,
                    ),
                  ),
                  if (_result != null) ...[
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => setState(() => _result = null),
                      child: const Text('Clear'),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          const _TipCard(
            tip: 'Type the push with a generic: Navigator.push<String>() '
                'so the compiler knows what type to expect back. '
                'Always handle the null case — the user might press the '
                'system back button instead of your selection buttons.',
          ),
        ],
      ),
    );
  }
}

// ── Picker screen (returns a value when popped) ───────────────────────────────

class _PickerScreen extends StatelessWidget {
  const _PickerScreen();

  static const _options = [
    ('🚀 Riverpod', Colors.indigo),
    ('🧱 Bloc', Colors.blue),
    ('🌿 Provider', Colors.green),
    ('🔄 GetX', Colors.orange),
    ('⚡ Signals', Colors.purple),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick a State Manager'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Select one — the result will be sent back to the previous screen.',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            child: ListView(
              children: _options
                  .map((opt) => ListTile(
                        leading: CircleAvatar(
                          backgroundColor: opt.$2,
                          child: Text(
                            opt.$1.substring(0, 2),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        title: Text(opt.$1),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () =>
                            Navigator.pop(context, opt.$1), // ✅ pop with value
                      ))
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton(
              onPressed: () =>
                  Navigator.pop(context), // pop with null — no selection
              child: const Text('Cancel (returns null)'),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

class _CodeSection extends StatelessWidget {
  final String label;
  final Color labelColor;
  final String code;
  const _CodeSection(
      {required this.label, required this.labelColor, required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade900, borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: TextStyle(
                color: labelColor, fontWeight: FontWeight.bold, fontSize: 12)),
        const SizedBox(height: 8),
        Text(code,
            style: const TextStyle(
                color: Colors.white,
                fontFamily: 'monospace',
                fontSize: 12,
                height: 1.5)),
      ]),
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
        padding: const EdgeInsets.all(16),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.lightbulb, color: Colors.purple),
          const SizedBox(width: 12),
          Expanded(
              child: Text(tip,
                  style: const TextStyle(fontSize: 14, height: 1.5))),
        ]),
      ),
    );
  }
}
