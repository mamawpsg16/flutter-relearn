import 'package:flutter/material.dart';

class StatefulStatelessScreen extends StatefulWidget {
  const StatefulStatelessScreen({super.key});

  @override
  State<StatefulStatelessScreen> createState() =>
      _StatefulStatelessScreenState();
}

class _StatefulStatelessScreenState extends State<StatefulStatelessScreen> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stateful & Stateless Widgets'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Explanation ──────────────────────────────────────────────
          const Text(
            'A StatelessWidget never changes after it is built — '
            'it has no internal state. A StatefulWidget can rebuild '
            'itself over time in response to events by calling setState().',
          ),
          const SizedBox(height: 16),

          // ── Stateless ────────────────────────────────────────────────
          const _CodeSection(
            label: 'StatelessWidget — no mutable state',
            labelColor: Colors.blue,
            code: '''
class GreetingCard extends StatelessWidget {
  final String name;
  const GreetingCard({required this.name});

  @override
  Widget build(BuildContext context) {
    // 'name' never changes — this widget just displays it
    return Text('Hello, \$name!');
  }
}''',
          ),
          const SizedBox(height: 12),

          // ── Stateful ─────────────────────────────────────────────────
          const _CodeSection(
            label: 'StatefulWidget — owns mutable state',
            labelColor: Colors.green,
            code: '''
class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _count = 0; // mutable state lives here

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text('\$_count'),
      ElevatedButton(
        onPressed: () => setState(() => _count++),
        child: const Text('Increment'),
      ),
    ]);
  }
}''',
          ),
          const SizedBox(height: 16),

          // ── Decision guide ───────────────────────────────────────────
          const Text(
            'Which one do I need?',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          _DecisionTable(),
          const SizedBox(height: 16),

          // ── Live demo ────────────────────────────────────────────────
          const Text(
            'Live demo — tap the button to trigger setState:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Stateless card (never rebuilds on its own)
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lock_outline,
                        color: Colors.blue.shade700,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'StatelessWidget',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const _StaticGreeting(name: 'Flutter Dev'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Stateful card (rebuilds when setState called)
          Card(
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.refresh,
                        color: Colors.green.shade700,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'StatefulWidget',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Count: $_counter',
                        style: const TextStyle(fontSize: 20),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => setState(() => _counter++),
                        icon: const Icon(Icons.add),
                        label: const Text('setState'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          const _TipCard(
            tip:
                'Default to StatelessWidget. Only upgrade to StatefulWidget '
                'when the widget itself needs to track something that changes '
                '(animation, form input, toggle, counter).',
          ),
        ],
      ),
    );
  }
}

// A truly stateless widget — no rebuild possible
class _StaticGreeting extends StatelessWidget {
  final String name;
  const _StaticGreeting({required this.name});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Hello, $name! I never change.',
      style: const TextStyle(fontSize: 16),
    );
  }
}

class _DecisionTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const rows = [
      ('Display-only data passed as params', 'Stateless'),
      ('User taps / toggles something', 'Stateful'),
      ('Animations', 'Stateful'),
      ('Text field input', 'Stateful'),
      ('Data from a parent prop, never changes', 'Stateless'),
      ('Timer / countdown', 'Stateful'),
    ];
    return Table(
      border: TableBorder.all(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(6),
      ),
      columnWidths: const {0: FlexColumnWidth(3), 1: FlexColumnWidth(2)},
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade100),
          children: const [
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Scenario',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text('Use', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        ...rows.map(
          (r) => TableRow(
            children: [
              Padding(padding: const EdgeInsets.all(8), child: Text(r.$1)),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  r.$2,
                  style: TextStyle(
                    color: r.$2 == 'Stateless' ? Colors.blue : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
              fontSize: 12,
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
      color: Colors.purple.shade50,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lightbulb, color: Colors.purple, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(tip)),
          ],
        ),
      ),
    );
  }
}
