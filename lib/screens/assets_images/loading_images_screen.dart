import 'package:flutter/material.dart';

class LoadingImagesScreen extends StatefulWidget {
  const LoadingImagesScreen({super.key});

  @override
  State<LoadingImagesScreen> createState() => _LoadingImagesScreenState();
}

class _LoadingImagesScreenState extends State<LoadingImagesScreen> {
  BoxFit _selectedFit = BoxFit.cover;
  bool _useAsset = true;

  static const _fits = [
    BoxFit.cover,
    BoxFit.contain,
    BoxFit.fill,
    BoxFit.fitWidth,
    BoxFit.fitHeight,
    BoxFit.none,
    BoxFit.scaleDown,
  ];

  static const _fitNames = {
    BoxFit.cover: 'cover',
    BoxFit.contain: 'contain',
    BoxFit.fill: 'fill',
    BoxFit.fitWidth: 'fitWidth',
    BoxFit.fitHeight: 'fitHeight',
    BoxFit.none: 'none',
    BoxFit.scaleDown: 'scaleDown',
  };

  static const _networkUrl =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1a/24701-nature-natural-beauty.jpg/1280px-24701-nature-natural-beauty.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loading Images'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Concept explanation ──────────────────────────────────────
          const Text(
            'Flutter provides Image.asset() for files bundled with your app '
            'and Image.network() for remote URLs. Both accept a fit parameter '
            'that controls how the image fills its box — just like CSS object-fit.',
            style: TextStyle(fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 24),

          // ── BAD code ─────────────────────────────────────────────────
          const _CodeSection(
            label: 'BAD — using a Container color instead of a real image',
            labelColor: Colors.red,
            code: '''// ❌ This is just a coloured box, not an image
Container(
  width: 300,
  height: 200,
  color: Colors.grey,
  child: Text('imagine an image here'),
)''',
          ),
          const SizedBox(height: 12),

          // ── GOOD code ────────────────────────────────────────────────
          const _CodeSection(
            label: 'GOOD — use Image.asset or Image.network',
            labelColor: Colors.green,
            code: '''// ✅ Bundled asset
Image.asset(
  'images/lake.jpg',
  width: double.infinity,
  height: 200,
  fit: BoxFit.cover,
)

// ✅ Remote image
Image.network(
  'https://example.com/photo.jpg',
  loadingBuilder: (ctx, child, progress) =>
    progress == null ? child : CircularProgressIndicator(),
)''',
          ),
          const SizedBox(height: 24),

          // ── Live demo ─────────────────────────────────────────────────
          const Text(
            'Live Demo',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Source toggle
          Row(
            children: [
              const Text('Source: ', style: TextStyle(color: Colors.black54)),
              ChoiceChip(
                label: const Text('Asset'),
                selected: _useAsset,
                selectedColor: Colors.blue.shade100,
                onSelected: (_) => setState(() => _useAsset = true),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Network'),
                selected: !_useAsset,
                selectedColor: Colors.blue.shade100,
                onSelected: (_) => setState(() => _useAsset = false),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // BoxFit selector
          const Text('BoxFit:', style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: _fits.map((fit) {
              return ChoiceChip(
                label: Text(_fitNames[fit]!),
                selected: _selectedFit == fit,
                selectedColor: Colors.orange.shade100,
                onSelected: (_) => setState(() => _selectedFit = fit),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          // Image preview
          Container(
            height: 220,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: _useAsset
                ? Image.asset(
                    'images/lake.jpg',
                    fit: _selectedFit,
                    width: double.infinity,
                    height: 220,
                  )
                : Image.network(
                    _networkUrl,
                    fit: _selectedFit,
                    width: double.infinity,
                    height: 220,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              value: progress.expectedTotalBytes != null
                                  ? progress.cumulativeBytesLoaded /
                                      progress.expectedTotalBytes!
                                  : null,
                            ),
                            const SizedBox(height: 8),
                            const Text('Loading from network…'),
                          ],
                        ),
                      );
                    },
                    errorBuilder: (_, error, stackTrace) => const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.wifi_off, size: 40, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Network image unavailable'),
                        ],
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 8),
          Text(
            _useAsset
                ? 'Image.asset(\'images/lake.jpg\', fit: BoxFit.${_fitNames[_selectedFit]})'
                : 'Image.network(url, fit: BoxFit.${_fitNames[_selectedFit]})',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 24),

          // ── Tip card ──────────────────────────────────────────────────
          const _TipCard(
            tip: 'Use BoxFit.cover for hero / banner images (fills the box, '
                'may crop). Use BoxFit.contain when you need the whole image '
                'visible without cropping. Always provide a loadingBuilder for '
                'network images so users see progress, not a blank space.',
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
