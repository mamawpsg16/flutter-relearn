import 'package:flutter/material.dart';

class SendDataScreen extends StatelessWidget {
  const SendDataScreen({super.key});

  static const _items = [
    _Product('Flutter Course', 'Learn Flutter from scratch', Icons.school, Colors.indigo),
    _Product('Dart Basics', 'Master the Dart language', Icons.code, Colors.teal),
    _Product('State Management', 'Riverpod, Bloc, Provider', Icons.storage, Colors.orange),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Data to a Screen'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Pass data to a new screen by adding parameters to the destination '
            'widget\'s constructor. When you call Navigator.push(), simply '
            'instantiate the screen with the values you want to send.',
            style: TextStyle(fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 24),

          const _CodeSection(
            label: 'BAD — using a global variable to share data',
            labelColor: Colors.red,
            code: '''// ❌ Global state — hard to track, causes bugs
String selectedItem = '';

// Screen A
selectedItem = 'Flutter Course';
Navigator.push(context, MaterialPageRoute(
  builder: (_) => const DetailScreen(),
));

// Screen B reads the global
Text(selectedItem)  // fragile — what if it changes?''',
          ),
          const SizedBox(height: 12),

          const _CodeSection(
            label: 'GOOD — exactly what the demo below does',
            labelColor: Colors.green,
            code: '''// ✅ Bundle related data into one class
class Product {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  const Product(this.title, this.description, this.icon, this.color);
}

// ✅ Destination screen takes the whole object
class DetailScreen extends StatelessWidget {
  final Product product;   // one parameter carries everything
  const DetailScreen({required this.product, super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: Text(product.description),
    );
  }
}

// ✅ Pass it when pushing — same pattern as the live demo
final item = Product('Flutter Course', 'Learn Flutter', Icons.school, Colors.indigo);

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => DetailScreen(product: item),
  ),
);''',
          ),
          const SizedBox(height: 24),

          const Text('Live Demo — tap any course to see its details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          ..._items.map((item) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: item.color,
                    child: Icon(item.icon, color: Colors.white),
                  ),
                  title: Text(item.title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(item.description),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => _DetailScreen(product: item),
                    ),
                  ),
                ),
              )),
          const SizedBox(height: 24),

          const _TipCard(
            tip: 'Always prefer typed constructor parameters over passing '
                'raw Maps or dynamic objects. The compiler catches mismatches '
                'immediately, and it is self-documenting — the destination '
                'screen declares exactly what it needs.',
          ),
        ],
      ),
    );
  }
}

// ── Detail screen (receives the data) ────────────────────────────────────────

class _DetailScreen extends StatelessWidget {
  final _Product product;
  const _DetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        backgroundColor: product.color,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 48,
                backgroundColor: product.color,
                child: Icon(product.icon, size: 48, color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            Text(product.title,
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(product.description,
                style: const TextStyle(fontSize: 16, color: Colors.black54)),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '// Data received via constructor:\n'
                'title: "${product.title}"\n'
                'description: "${product.description}"',
                style: const TextStyle(
                    color: Colors.greenAccent,
                    fontFamily: 'monospace',
                    fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Data class ────────────────────────────────────────────────────────────────

class _Product {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  const _Product(this.title, this.description, this.icon, this.color);
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
