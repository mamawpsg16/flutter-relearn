import 'package:flutter/material.dart';

class SpecifyingAssetsScreen extends StatefulWidget {
  const SpecifyingAssetsScreen({super.key});

  @override
  State<SpecifyingAssetsScreen> createState() => _SpecifyingAssetsScreenState();
}

class _SpecifyingAssetsScreenState extends State<SpecifyingAssetsScreen> {
  bool _showDeclared = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Specifying Assets'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Concept explanation ──────────────────────────────────────
          const Text(
            'Flutter only bundles files you explicitly declare in pubspec.yaml '
            'under the flutter › assets key. At build time Flutter copies those '
            'files into the app bundle — if a file is missing from pubspec.yaml '
            'it cannot be loaded at runtime, even if it exists on disk.',
            style: TextStyle(fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 24),

          // ── BAD code ─────────────────────────────────────────────────
          const _CodeSection(
            label: 'BAD — file exists on disk but is NOT declared',
            labelColor: Colors.red,
            code: '''# pubspec.yaml  ← image is missing from here
flutter:
  uses-material-design: true
  # assets: section is empty!

# Dart code
Image.asset('images/lake.jpg')  // ❌ crashes at runtime''',
          ),
          const SizedBox(height: 12),

          // ── GOOD code ────────────────────────────────────────────────
          const _CodeSection(
            label: 'GOOD — file is declared in pubspec.yaml',
            labelColor: Colors.green,
            code: '''# pubspec.yaml
flutter:
  uses-material-design: true
  assets:
    - images/lake.jpg          # ✅ individual file
    - assets/                  # ✅ entire folder
    - assets/sample.txt        # ✅ or a specific text file

# Dart code
Image.asset('images/lake.jpg')  // ✅ works!''',
          ),
          const SizedBox(height: 24),

          // ── Live demo ─────────────────────────────────────────────────
          const Text(
            'Live Demo',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Toggle between loading a declared asset vs. an undeclared one:',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              ChoiceChip(
                label: const Text('Declared asset'),
                selected: _showDeclared,
                selectedColor: Colors.green.shade100,
                onSelected: (_) => setState(() => _showDeclared = true),
              ),
              ChoiceChip(
                label: const Text('Undeclared asset'),
                selected: !_showDeclared,
                selectedColor: Colors.red.shade100,
                onSelected: (_) => setState(() => _showDeclared = false),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _showDeclared ? _DeclaredDemo() : _UndeclaredDemo(),
          ),
          const SizedBox(height: 24),

          // ── Tip card ──────────────────────────────────────────────────
          const _TipCard(
            tip:
                'You can declare a whole folder with a trailing slash '
                '(e.g. assets/) — Flutter will include every file in it. '
                'Use individual paths to keep bundles lean.',
          ),
        ],
      ),
    );
  }
}

class _DeclaredDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('images/lake.jpg', fit: BoxFit.cover),
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '✅  images/lake.jpg — declared in pubspec.yaml',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UndeclaredDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(12),
        color: Colors.red.shade50,
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image, size: 48, color: Colors.red),
          SizedBox(height: 8),
          Text(
            'Unable to load asset: images/missing.jpg',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            'This file was never declared in pubspec.yaml.\nFlutter cannot load it at runtime.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// ── Shared private widgets ────────────────────────────────────────────────────

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
              fontSize: 13,
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
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lightbulb, color: Colors.purple),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                tip,
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
