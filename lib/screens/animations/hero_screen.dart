import 'package:flutter/material.dart';

class HeroScreen extends StatelessWidget {
  const HeroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _Item('Flutter', Icons.flutter_dash, Colors.blue, '1'),
      _Item('Dart', Icons.code, Colors.indigo, '2'),
      _Item('Firebase', Icons.local_fire_department, Colors.orange, '3'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hero Animations'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hero animations fly a shared widget between two screens. '
              'Both screens wrap the same widget in a Hero with matching tags — '
              'Flutter interpolates the size and position automatically.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 20),

            _CodeSection(
              label: 'Source screen — wrap with Hero',
              labelColor: Colors.green,
              code: '''// Screen 1 (list)
Hero(
  tag: 'avatar-\${item.id}', // unique tag
  child: CircleAvatar(
    backgroundImage: NetworkImage(item.imageUrl),
  ),
)''',
            ),
            const SizedBox(height: 12),

            _CodeSection(
              label: 'Destination screen — same tag',
              labelColor: Colors.green,
              code: '''// Screen 2 (detail)
Hero(
  tag: 'avatar-\${item.id}', // must match!
  child: CircleAvatar(
    radius: 80,
    backgroundImage: NetworkImage(item.imageUrl),
  ),
)''',
            ),
            const SizedBox(height: 24),

            const Text(
              'Live Demo — tap a card to see the Hero fly',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    leading: Hero(
                      tag: 'icon-${item.tag}',
                      child: CircleAvatar(
                        backgroundColor: item.color,
                        child: Icon(item.icon, color: Colors.white),
                      ),
                    ),
                    title: Text(item.title,
                        style:
                            const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Tap to see Hero animation'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => _HeroDetailScreen(item: item),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            _TipCard(
              tip:
                  'The Hero tag must be unique per page. Use a combination like '
                  '"item-\${id}" to avoid tag collisions when multiple Heroes '
                  'are on screen at the same time.',
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroDetailScreen extends StatelessWidget {
  final _Item item;
  const _HeroDetailScreen({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
        backgroundColor: item.color,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Hero lands here — same tag, bigger size
          Container(
            color: item.color.withValues(alpha: 0.1),
            width: double.infinity,
            padding: const EdgeInsets.all(40),
            child: Center(
              child: Hero(
                tag: 'icon-${item.tag}',
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: item.color,
                  child: Icon(item.icon, color: Colors.white, size: 64),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            item.title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'The icon flew from the list to here!',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }
}

class _Item {
  final String title;
  final IconData icon;
  final Color color;
  final String tag;
  const _Item(this.title, this.icon, this.color, this.tag);
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
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: labelColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            code,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'monospace',
              fontSize: 12,
              height: 1.5,
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
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lightbulb, color: Colors.purple),
            const SizedBox(width: 8),
            Expanded(
              child: Text(tip, style: const TextStyle(height: 1.5)),
            ),
          ],
        ),
      ),
    );
  }
}
