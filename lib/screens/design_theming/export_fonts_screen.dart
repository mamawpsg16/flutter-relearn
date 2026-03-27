import 'package:flutter/material.dart';

class ExportFontsScreen extends StatelessWidget {
  const ExportFontsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Export Fonts from a Package'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'A Flutter package can bundle fonts and export them for other apps to use. '
            'The consuming app references the font with a package: prefix '
            'in pubspec.yaml — no need to copy font files manually.',
          ),
          const SizedBox(height: 16),

          // Inside the package
          const _CodeSection(
            label: 'Inside the package — declare fonts in the package\'s pubspec.yaml',
            labelColor: Colors.blue,
            code: '''
# my_font_package/pubspec.yaml
flutter:
  fonts:
    - family: PackageFont
      fonts:
        - asset: lib/fonts/PackageFont-Regular.ttf
        - asset: lib/fonts/PackageFont-Bold.ttf
          weight: 700''',
          ),
          const SizedBox(height: 12),

          // In the consuming app
          const _CodeSection(
            label: 'In the consuming app — reference with package: prefix',
            labelColor: Colors.green,
            code: '''
# app/pubspec.yaml
dependencies:
  my_font_package: ^1.0.0

flutter:
  fonts:
    - family: PackageFont
      fonts:
        - asset: packages/my_font_package/lib/fonts/PackageFont-Regular.ttf
        - asset: packages/my_font_package/lib/fonts/PackageFont-Bold.ttf
          weight: 700''',
          ),
          const SizedBox(height: 12),

          const _CodeSection(
            label: 'Use the font — same as a local font',
            labelColor: Colors.green,
            code: '''
Text(
  'Hello from a package font!',
  style: TextStyle(fontFamily: 'PackageFont'),
)

// Or apply globally:
ThemeData(fontFamily: 'PackageFont')''',
          ),
          const SizedBox(height: 16),

          // Visual comparison of the path pattern
          const Text('Path anatomy:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _PathBreakdown(),
          const SizedBox(height: 16),

          // How it differs from local fonts
          const _CodeSection(
            label: 'BAD — trying to use a package font without the prefix',
            labelColor: Colors.red,
            code: '''
# This won't find the font — missing packages/ prefix
asset: lib/fonts/PackageFont-Regular.ttf''',
          ),
          const SizedBox(height: 12),
          const _CodeSection(
            label: 'GOOD — correct path with packages/ prefix',
            labelColor: Colors.green,
            code: '''
asset: packages/my_font_package/lib/fonts/PackageFont-Regular.ttf
#       ^^^^^^^^^^^^^^^^^^^^^^^^^
#       packages/<package_name>/  prefix is required''',
          ),
          const SizedBox(height: 16),

          const _TipCard(
            tip: 'The packages/<name>/ prefix tells Flutter\'s asset loader '
                'to look inside the named package\'s bundle instead of the app\'s '
                'own assets. Forgetting this prefix is the most common mistake.',
          ),
        ],
      ),
    );
  }
}

class _PathBreakdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const segments = [
      ('packages/', Colors.orange, 'Flutter prefix for package assets'),
      ('my_font_package/', Colors.blue, 'The package name'),
      ('lib/fonts/', Colors.green, 'Path inside the package'),
      ('PackageFont-Regular.ttf', Colors.purple, 'The font file'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Wrap(
            children: segments
                .map((s) => Text(s.$1,
                    style: TextStyle(
                        color: s.$2,
                        fontFamily: 'monospace',
                        fontSize: 13,
                        fontWeight: FontWeight.bold)))
                .toList(),
          ),
        ),
        const SizedBox(height: 8),
        ...segments.map((s) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                        color: s.$2, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  Text(s.$1,
                      style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: s.$2)),
                  const SizedBox(width: 8),
                  Text('— ${s.$3}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            )),
      ],
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
