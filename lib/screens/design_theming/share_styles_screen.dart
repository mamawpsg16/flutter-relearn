import 'package:flutter/material.dart';

class ShareStylesScreen extends StatefulWidget {
  const ShareStylesScreen({super.key});

  @override
  State<ShareStylesScreen> createState() => _ShareStylesScreenState();
}

class _ShareStylesScreenState extends State<ShareStylesScreen> {
  Color _seedColor = Colors.indigo;

  static const _seeds = [
    (label: 'Indigo', color: Colors.indigo),
    (label: 'Red', color: Colors.red),
    (label: 'Green', color: Colors.green),
    (label: 'Orange', color: Colors.orange),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Styles with Themes'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Explanation ──────────────────────────────────────────────
          const Text(
            'ThemeData is a single object that holds all style decisions for your app. '
            'Any widget calls Theme.of(context) to read those values — '
            'you change the theme once and every widget updates automatically.',
          ),
          const SizedBox(height: 16),

          // ── Code: how to set a theme ─────────────────────────────────
          const _CodeSection(
            label: 'Set a theme in MaterialApp',
            labelColor: Colors.green,
            code: '''
MaterialApp(
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.indigo,
    ),
    useMaterial3: true,
  ),
  home: MyHomePage(),
)''',
          ),
          const SizedBox(height: 12),

          const _CodeSection(
            label: 'Read the theme anywhere in the tree',
            labelColor: Colors.blue,
            code: '''
// Any widget, anywhere in the tree:
final color = Theme.of(context).colorScheme.primary;
final style = Theme.of(context).textTheme.titleLarge;''',
          ),
          const SizedBox(height: 16),

          // ── Live demo ────────────────────────────────────────────────
          const Text(
            'Live demo — change the seed color and watch every widget update:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // Seed color picker
          Wrap(
            spacing: 8, // horizontal gap between children
            runSpacing: 6, // vertical gap between rows
            children: _seeds.map((s) {
              final selected = _seedColor == s.color;
              return ChoiceChip(
                label: Text(s.label),
                selected: selected,
                selectedColor: s.color,
                labelStyle: TextStyle(
                  color: selected ? Colors.white : null,
                  fontWeight: selected ? FontWeight.bold : null,
                ),
                onSelected: (_) => setState(() => _seedColor = s.color),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // All child widgets share the same nested theme
          Theme(
            data: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: _seedColor),
              useMaterial3: true,
            ),
            // creates a child context that starts its search from inside the Theme.
            child: Builder(
              builder: (ctx) {
                final scheme = Theme.of(ctx).colorScheme;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Color swatch
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: scheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'primaryContainer',
                        style: TextStyle(color: scheme.onPrimaryContainer),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: scheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'secondaryContainer',
                        style: TextStyle(color: scheme.onSecondaryContainer),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('ElevatedButton'),
                    ),
                    const SizedBox(height: 8),
                    FilledButton(
                      onPressed: () {},
                      child: const Text('FilledButton'),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('OutlinedButton'),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(value: 0.6),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // ── Nested override ──────────────────────────────────────────
          const _CodeSection(
            label: 'Override theme for one subtree',
            labelColor: Colors.orange,
            code: '''
Theme(
  data: Theme.of(context).copyWith(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
  ),
  child: ElevatedButton(...), // uses red scheme
)''',
          ),
          const SizedBox(height: 16),

          const _TipCard(
            tip:
                'Never hardcode Colors.blue — always read from the theme. '
                'That way switching from light to dark (or changing the seed) '
                'updates your whole UI in one place.',
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
