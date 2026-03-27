import 'package:flutter/material.dart';

class MaterialDesignScreen extends StatefulWidget {
  const MaterialDesignScreen({super.key});

  @override
  State<MaterialDesignScreen> createState() => _MaterialDesignScreenState();
}

class _MaterialDesignScreenState extends State<MaterialDesignScreen> {
  Color _seed = Colors.blue;
  double _elevation = 2;

  static const _seeds = [
    (label: 'Blue', color: Colors.blue),
    (label: 'Purple', color: Colors.purple),
    (label: 'Pink', color: Colors.pink),
    (label: 'Teal', color: Colors.teal),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material Design'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Material Design is Google\'s design system built into Flutter. '
            'It provides pre-built widgets (buttons, cards, dialogs) that '
            'automatically use your ColorScheme for consistent, accessible color.',
          ),
          const SizedBox(height: 16),

          const _CodeSection(
            label: 'ColorScheme.fromSeed — generate a full palette from one color',
            labelColor: Colors.blue,
            code: '''
ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  useMaterial3: true,
)''',
          ),
          const SizedBox(height: 16),

          const Text('Pick a seed color:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _seeds.map((s) {
              final selected = _seed == s.color;
              return ChoiceChip(
                label: Text(s.label),
                selected: selected,
                selectedColor: s.color,
                labelStyle: TextStyle(
                    color: selected ? Colors.white : null,
                    fontWeight: selected ? FontWeight.bold : null),
                onSelected: (_) => setState(() => _seed = s.color),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          Theme(
            data: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: _seed),
              useMaterial3: true,
            ),
            child: Builder(builder: (ctx) {
              final scheme = Theme.of(ctx).colorScheme;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Color role grid
                  const Text('Color roles:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _ColorRoleRow('primary', scheme.primary, scheme.onPrimary),
                  _ColorRoleRow('secondary', scheme.secondary, scheme.onSecondary),
                  _ColorRoleRow('tertiary', scheme.tertiary, scheme.onTertiary),
                  _ColorRoleRow('error', scheme.error, scheme.onError),
                  _ColorRoleRow('surface', scheme.surface, scheme.onSurface),
                  const SizedBox(height: 16),

                  // Elevation demo
                  Text(
                    'Elevation: ${_elevation.toInt()} dp',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: _elevation,
                    min: 0,
                    max: 24,
                    divisions: 8,
                    label: '${_elevation.toInt()} dp',
                    onChanged: (v) => setState(() => _elevation = v),
                  ),
                  Center(
                    child: Card(
                      elevation: _elevation,
                      child: const SizedBox(
                        width: 200,
                        height: 80,
                        child: Center(child: Text('Card elevation demo')),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Widget showcase
                  const Text('Material widgets:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ElevatedButton(onPressed: () {}, child: const Text('Elevated')),
                      FilledButton(onPressed: () {}, child: const Text('Filled')),
                      OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
                      TextButton(onPressed: () {}, child: const Text('Text')),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Text field',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 16),

          const _TipCard(
            tip: 'ColorScheme.fromSeed generates a harmonious 30+ color palette '
                'from a single seed. You never need to manually define every color role.',
          ),
        ],
      ),
    );
  }
}

class _ColorRoleRow extends StatelessWidget {
  final String name;
  final Color bg;
  final Color fg;
  const _ColorRoleRow(this.name, this.bg, this.fg);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(name, style: TextStyle(color: fg, fontWeight: FontWeight.w500)),
    );
  }
}

class _CodeSection extends StatelessWidget {
  final String label;
  final Color labelColor;
  final String code;
  const _CodeSection(
      {required this.label, required this.labelColor, required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.grey.shade900, borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  color: labelColor, fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          Text(code,
              style: const TextStyle(
                  color: Colors.white, fontFamily: 'monospace', fontSize: 13)),
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
