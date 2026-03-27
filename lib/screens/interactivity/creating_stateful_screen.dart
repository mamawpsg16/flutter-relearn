import 'package:flutter/material.dart';

class CreatingStatefulScreen extends StatelessWidget {
  const CreatingStatefulScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Creating a Stateful Widget'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Creating a StatefulWidget requires exactly 5 steps. '
            'The widget class is immutable — all mutable data lives in '
            'a separate State class.',
          ),
          const SizedBox(height: 16),

          // Step 0
          _StepCard(
            step: 0,
            title: 'Get ready — decide what state you need',
            color: Colors.grey.shade700,
            description:
                'Identify what data will change. In this example: a star is tapped → '
                '_isFavorited toggles, _favoriteCount changes.',
            code: '''
// What changes in this widget?
bool _isFavorited = true;
int _favoriteCount = 41;''',
          ),
          const SizedBox(height: 12),

          // Step 1
          _StepCard(
            step: 1,
            title: 'Decide which object manages the state',
            color: Colors.blue,
            description:
                'The widget manages its own state when the state is local '
                '(e.g. a toggle). The parent manages state when siblings need '
                'to share or react to it.',
            code: '''
// Self-managed: FavoriteWidget owns _isFavorited
// → use State inside FavoriteWidget

// Parent-managed: pass a callback to the child
// → onChanged: (val) => setState(...)''',
          ),
          const SizedBox(height: 12),

          // Step 2
          _StepCard(
            step: 2,
            title: 'Subclass StatefulWidget',
            color: Colors.teal,
            description:
                'The widget class itself is immutable. It just calls createState().',
            code: '''
class FavoriteWidget extends StatefulWidget {
  const FavoriteWidget({super.key});

  @override
  State<FavoriteWidget> createState() => _FavoriteWidgetState();
}''',
          ),
          const SizedBox(height: 12),

          // Step 3
          _StepCard(
            step: 3,
            title: 'Subclass State',
            color: Colors.orange,
            description:
                'The State class holds the mutable data and the build method. '
                'Call setState() whenever data changes to trigger a rebuild.',
            code: '''
class _FavoriteWidgetState extends State<FavoriteWidget> {
  bool _isFavorited = true;
  int _favoriteCount = 41;

  void _toggleFavorite() {
    setState(() {
      if (_isFavorited) {
        _favoriteCount--;
        _isFavorited = false;
      } else {
        _favoriteCount++;
        _isFavorited = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      IconButton(
        icon: Icon(
          _isFavorited ? Icons.star : Icons.star_border,
          color: Colors.red,
        ),
        onPressed: _toggleFavorite,
      ),
      Text('\$_favoriteCount'),
    ]);
  }
}''',
          ),
          const SizedBox(height: 12),

          // Step 4
          _StepCard(
            step: 4,
            title: 'Plug the stateful widget into the tree',
            color: Colors.purple,
            description:
                'Use it just like any other widget. Its state is fully encapsulated.',
            code: '''
// In your parent widget's build():
const FavoriteWidget()

// That's it — no extra setup needed''',
          ),
          const SizedBox(height: 16),

          // ── Live demo of the exact FavoriteWidget from the docs ──────
          const Text('Live demo — the FavoriteWidget from the Flutter docs:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const Center(child: _FavoriteWidget()),
          const SizedBox(height: 16),

          const _TipCard(
            tip: 'The widget class is immutable — never put mutable fields '
                'directly on it. All mutable data belongs in the State class.',
          ),
        ],
      ),
    );
  }
}

// ── The actual FavoriteWidget demo ──────────────────────────────────────────
class _FavoriteWidget extends StatefulWidget {
  const _FavoriteWidget();

  @override
  State<_FavoriteWidget> createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<_FavoriteWidget> {
  bool _isFavorited = true;
  int _favoriteCount = 41;

  void _toggleFavorite() {
    setState(() {
      if (_isFavorited) {
        _favoriteCount--;
        _isFavorited = false;
      } else {
        _favoriteCount++;
        _isFavorited = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                _isFavorited ? Icons.star : Icons.star_border,
                color: Colors.red,
                size: 32,
              ),
              onPressed: _toggleFavorite,
            ),
            const SizedBox(width: 4),
            Text('$_favoriteCount',
                style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}

// ── Step card ────────────────────────────────────────────────────────────────
class _StepCard extends StatelessWidget {
  final int step;
  final String title;
  final Color color;
  final String description;
  final String code;

  const _StepCard({
    required this.step,
    required this.title,
    required this.color,
    required this.description,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.white24,
                  child: Text('$step',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(title,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(description),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(code,
                      style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'monospace',
                          fontSize: 12)),
                ),
              ],
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
