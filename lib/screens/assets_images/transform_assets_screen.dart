import 'package:flutter/material.dart';

class TransformAssetsScreen extends StatefulWidget {
  const TransformAssetsScreen({super.key});

  @override
  State<TransformAssetsScreen> createState() => _TransformAssetsScreenState();
}

class _TransformAssetsScreenState extends State<TransformAssetsScreen> {
  _TransformType _selected = _TransformType.resize;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transform Assets at Build Time'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Concept explanation ──────────────────────────────────────
          const Text(
            'Flutter can automatically transform assets at build time using '
            'transformers declared in pubspec.yaml. Instead of manually '
            'pre-processing files, you configure a Dart package as a '
            'transformer and Flutter runs it every time you build.',
            style: TextStyle(fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 24),

          // ── BAD code ─────────────────────────────────────────────────
          const _CodeSection(
            label: 'BAD — manually pre-processing assets before every build',
            labelColor: Colors.red,
            code: '''# ❌ You run this by hand before every flutter build
magick convert images/hero.png -resize 800x images/hero_resized.png
pngquant --quality=65-80 images/hero_resized.png

# Then commit the generated file to git — hard to maintain,
# easy to forget, diff noise in pull requests''',
          ),
          const SizedBox(height: 12),

          // ── GOOD code ────────────────────────────────────────────────
          const _CodeSection(
            label: 'GOOD — declare a transformer in pubspec.yaml',
            labelColor: Colors.green,
            code: '''# pubspec.yaml
flutter:
  assets:
    - path: images/hero.png
      transformers:
        - package: flutter_gen_runner   # or any transformer package
          args:
            - "--width=800"
            - "--quality=80"

# Flutter runs the transformer automatically during:
#   flutter build   →  release build
#   flutter run     →  debug build
#
# The original file stays untouched — only the built artifact
# is transformed. No generated files to commit.''',
          ),
          const SizedBox(height: 24),

          // ── How it works diagram ──────────────────────────────────────
          const Text(
            'How build-time transformation works',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _PipelineDiagram(),
          const SizedBox(height: 24),

          // ── Common transformers ───────────────────────────────────────
          const Text(
            'Common use cases',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: _TransformType.values.map((t) {
              return ChoiceChip(
                label: Text(t.label),
                selected: _selected == t,
                selectedColor: Colors.teal.shade100,
                onSelected: (_) => setState(() => _selected = t),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          _TransformCard(type: _selected),
          const SizedBox(height: 24),

          // ── Important note ────────────────────────────────────────────
          Card(
            color: Colors.orange.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.warning_amber, color: Colors.orange),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Transformers are a relatively new Flutter feature '
                      '(added in Flutter 3.22). The transformer package must '
                      'implement the AssetTransformer interface. Not all '
                      'pub.dev packages support it yet — check the package docs.',
                      style: TextStyle(fontSize: 13, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ── Tip card ──────────────────────────────────────────────────
          const _TipCard(
            tip: 'Transformers run in isolation — each input produces one '
                'output. They cannot read other assets or network resources. '
                'For complex multi-file generation (e.g. icon sprites), '
                'use a build_runner step instead.',
          ),
        ],
      ),
    );
  }
}

// ── Pipeline diagram ──────────────────────────────────────────────────────────

class _PipelineDiagram extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          _PipelineStep(
            icon: Icons.insert_drive_file,
            color: Colors.blue,
            title: 'Source asset',
            subtitle: 'images/hero.png\n(original, committed to git)',
          ),
          const _PipelineArrow(),
          _PipelineStep(
            icon: Icons.settings,
            color: Colors.orange,
            title: 'Transformer runs',
            subtitle: 'e.g. resize to 800px, compress to WebP',
          ),
          const _PipelineArrow(),
          _PipelineStep(
            icon: Icons.inventory_2,
            color: Colors.green,
            title: 'App bundle',
            subtitle: 'Transformed file is bundled\n(not the original)',
          ),
          const _PipelineArrow(),
          _PipelineStep(
            icon: Icons.phone_android,
            color: Colors.purple,
            title: 'Runtime',
            subtitle: 'Image.asset(\'images/hero.png\') loads\nthe transformed version',
          ),
        ],
      ),
    );
  }
}

class _PipelineStep extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const _PipelineStep({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: color,
          radius: 20,
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.black54)),
            ],
          ),
        ),
      ],
    );
  }
}

class _PipelineArrow extends StatelessWidget {
  const _PipelineArrow();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 19, top: 2, bottom: 2),
      child: Icon(Icons.arrow_downward, size: 18, color: Colors.grey),
    );
  }
}

// ── Transform use-case cards ──────────────────────────────────────────────────

enum _TransformType {
  resize('Image resize'),
  webp('Convert to WebP'),
  svg('SVG → PNG'),
  json('JSON minify');

  final String label;
  const _TransformType(this.label);
}

class _TransformCard extends StatelessWidget {
  final _TransformType type;

  const _TransformCard({required this.type});

  @override
  Widget build(BuildContext context) {
    final (title, why, code) = switch (type) {
      _TransformType.resize => (
          'Resize images to a max dimension',
          'Ship smaller files for faster downloads — no need to store multiple sizes in git.',
          '''flutter:
  assets:
    - path: images/hero.png
      transformers:
        - package: image_resizer_transformer
          args: ["--max-width=1200"]''',
        ),
      _TransformType.webp => (
          'Convert PNG/JPEG → WebP',
          'WebP is ~30% smaller than JPEG at the same quality — faster loads on Android & Chrome.',
          '''flutter:
  assets:
    - path: images/photo.jpg
      transformers:
        - package: webp_converter_transformer
          args: ["--quality=80"]
# Image.asset('images/photo.jpg') still works —
# Flutter loads the WebP under the hood''',
        ),
      _TransformType.svg => (
          'Rasterise SVG to PNG at build time',
          'SVG rendering at runtime is CPU-heavy. Pre-rasterise at the exact size you need.',
          '''flutter:
  assets:
    - path: assets/icon.svg
      transformers:
        - package: svg_to_png_transformer
          args: ["--width=48", "--height=48"]''',
        ),
      _TransformType.json => (
          'Minify JSON config files',
          'Strip whitespace from large JSON bundles to shrink app size without changing the data.',
          '''flutter:
  assets:
    - path: assets/config.json
      transformers:
        - package: json_minifier_transformer
# The bundled file is minified; dart:convert still parses it normally''',
        ),
    };

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
            title,
            style: const TextStyle(
              color: Colors.tealAccent,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            why,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 10),
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
              child: Text(tip, style: const TextStyle(fontSize: 14, height: 1.5)),
            ),
          ],
        ),
      ),
    );
  }
}
