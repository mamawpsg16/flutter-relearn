import 'package:flutter/material.dart';

class MigrateMaterial3Screen extends StatefulWidget {
  const MigrateMaterial3Screen({super.key});

  @override
  State<MigrateMaterial3Screen> createState() => _MigrateMaterial3ScreenState();
}

class _MigrateMaterial3ScreenState extends State<MigrateMaterial3Screen> {
  bool _useMaterial3 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Migrate to Material 3'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Material 3 (M3) is the latest version of Material Design. '
            'Flutter enables it with useMaterial3: true in ThemeData. '
            'M3 brings updated shapes, color roles, and component styles compared to M2.',
          ),
          const SizedBox(height: 16),

          const _CodeSection(
            label: 'Enable Material 3',
            labelColor: Colors.green,
            code: '''
MaterialApp(
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
    useMaterial3: true,   // <-- this is the switch
  ),
)''',
          ),
          const SizedBox(height: 16),

          // Toggle
          Row(
            children: [
              const Text('useMaterial3:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 12),
              Switch(
                value: _useMaterial3,
                onChanged: (v) => setState(() => _useMaterial3 = v),
              ),
              Text(_useMaterial3 ? 'true (M3)' : 'false (M2)',
                  style: TextStyle(
                      color: _useMaterial3 ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),

          // Live side-by-side widget comparison
          Theme(
            data: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
              useMaterial3: _useMaterial3,
            ),
            child: Builder(builder: (ctx) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SectionHeader(
                      _useMaterial3 ? 'Material 3 components' : 'Material 2 components'),
                  const SizedBox(height: 8),

                  // Buttons
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
                  const SizedBox(height: 12),

                  // Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Card',
                              style: Theme.of(ctx).textTheme.titleMedium),
                          const Text('Notice the corner radius difference between M2 and M3.'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // AppBar preview
                  Material(
                    elevation: 2,
                    child: AppBar(
                      automaticallyImplyLeading: false,
                      title: const Text('AppBar preview'),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // TextField
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'TextField',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // NavigationBar vs BottomNavigationBar
                  if (_useMaterial3)
                    NavigationBar(
                      selectedIndex: 0,
                      destinations: const [
                        NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
                        NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
                        NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
                      ],
                    )
                  else
                    BottomNavigationBar(
                      currentIndex: 0,
                      items: const [
                        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
                        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
                      ],
                    ),
                ],
              );
            }),
          ),
          const SizedBox(height: 16),

          const _CodeSection(
            label: 'Key M3 changes to know',
            labelColor: Colors.blue,
            code: '''
// M3 color roles (new names)
scheme.primary         // main brand color
scheme.primaryContainer // softer tinted surface
scheme.surface         // replaces background
scheme.surfaceVariant  // slightly tinted surface

// M3 uses NavigationBar instead of BottomNavigationBar
// M3 uses FilledButton as the primary action button
// M3 shapes are more rounded (corner radius increased)''',
          ),
          const SizedBox(height: 16),

          const _TipCard(
            tip: 'Toggle useMaterial3 above and compare. '
                'Notice rounder corners on cards/buttons in M3, '
                'and NavigationBar replacing BottomNavigationBar.',
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer)),
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
