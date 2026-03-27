import 'package:flutter/material.dart';

/// NOTE: This screen teaches the google_fonts package concept using simulated
/// demos, since google_fonts is not yet in pubspec.yaml.
/// To enable real Google Fonts, add to pubspec.yaml:
///   dependencies:
///     google_fonts: ^6.0.0
/// Then replace the TextStyle examples with GoogleFonts.roboto() etc.

class GoogleFontsScreen extends StatefulWidget {
  const GoogleFontsScreen({super.key});

  @override
  State<GoogleFontsScreen> createState() => _GoogleFontsScreenState();
}

class _GoogleFontsScreenState extends State<GoogleFontsScreen> {
  int _selectedFont = 0;

  // Simulate font personalities with system fonts + styling
  static const _fonts = [
    _FontDemo(
      name: 'Roboto',
      description: 'Clean, modern sans-serif — Material default',
      fontFamily: null,
      weight: FontWeight.w400,
    ),
    _FontDemo(
      name: 'Lato',
      description: 'Humanist sans-serif, warm and friendly',
      fontFamily: null,
      weight: FontWeight.w300,
    ),
    _FontDemo(
      name: 'Playfair Display',
      description: 'Elegant serif — great for headings',
      fontFamily: null,
      weight: FontWeight.w700,
    ),
    _FontDemo(
      name: 'Source Code Pro',
      description: 'Monospace — perfect for code snippets',
      fontFamily: 'monospace',
      weight: FontWeight.w400,
    ),
    _FontDemo(
      name: 'Nunito',
      description: 'Rounded sans-serif, friendly UI feel',
      fontFamily: null,
      weight: FontWeight.w600,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final selected = _fonts[_selectedFont];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Fonts Package'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'The google_fonts package lets you use any of the 1,000+ fonts from '
            'fonts.google.com in your Flutter app — downloaded at runtime or '
            'bundled as assets. No manual font file management needed.',
          ),
          const SizedBox(height: 16),

          // Setup
          const _CodeSection(
            label: 'Step 1 — add to pubspec.yaml',
            labelColor: Colors.blue,
            code: '''
dependencies:
  google_fonts: ^6.0.0''',
          ),
          const SizedBox(height: 12),

          const _CodeSection(
            label: 'Step 2 — use in a TextStyle',
            labelColor: Colors.green,
            code: '''
import 'package:google_fonts/google_fonts.dart';

// Single widget
Text(
  'Hello World',
  style: GoogleFonts.lato(fontSize: 24),
)

// With extra styling
Text(
  'Hello World',
  style: GoogleFonts.playfairDisplay(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: Colors.indigo,
  ),
)''',
          ),
          const SizedBox(height: 12),

          const _CodeSection(
            label: 'Step 3 — apply globally via ThemeData',
            labelColor: Colors.green,
            code: '''
ThemeData(
  textTheme: GoogleFonts.latoTextTheme(),
  // ↑ replaces ALL TextTheme roles with Lato variants
)

// Or mix: keep M3 defaults but override body
ThemeData(
  textTheme: GoogleFonts.latoTextTheme(
    Theme.of(context).textTheme,
  ),
)''',
          ),
          const SizedBox(height: 16),

          // Font picker demo
          const Text('Font showcase (simulated):',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: List.generate(_fonts.length, (i) {
              final f = _fonts[i];
              final sel = i == _selectedFont;
              return ChoiceChip(
                label: Text(f.name),
                selected: sel,
                onSelected: (_) => setState(() => _selectedFont = i),
              );
            }),
          ),
          const SizedBox(height: 12),

          // Preview card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selected.name,
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  selected.description,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const Divider(height: 20),
                Text(
                  'The quick brown fox',
                  style: TextStyle(
                    fontSize: 32,
                    fontFamily: selected.fontFamily,
                    fontWeight: selected.weight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'jumps over the lazy dog.\n'
                  'ABCDEFGHIJKLMNOPQRSTUVWXYZ\n'
                  'abcdefghijklmnopqrstuvwxyz\n'
                  '0123456789 !@#\$%^&*()',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: selected.fontFamily,
                    fontWeight: selected.weight,
                    height: 1.7,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Caching note
          const _CodeSection(
            label: 'Bundle fonts as assets (avoid runtime download)',
            labelColor: Colors.orange,
            code: '''
// Add to pubspec.yaml to bundle the font file:
flutter:
  assets:
    - packages/google_fonts/fonts/

// Then GoogleFonts will use the bundled file
// instead of downloading from the web.''',
          ),
          const SizedBox(height: 16),

          const _TipCard(
            tip: 'For production apps, bundle the font files as assets '
                'so the app works offline and loads instantly. '
                'Runtime download is fine for prototyping.',
          ),
        ],
      ),
    );
  }
}

class _FontDemo {
  final String name;
  final String description;
  final String? fontFamily;
  final FontWeight weight;

  const _FontDemo({
    required this.name,
    required this.description,
    required this.fontFamily,
    required this.weight,
  });
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
