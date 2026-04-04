import 'package:flutter/material.dart';

class ResolutionAwareScreen extends StatelessWidget {
  const ResolutionAwareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.of(context).devicePixelRatio;
    final variantUsed = dpr >= 3.0 ? '3.0x' : dpr >= 2.0 ? '2.0x' : '1x (base)';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resolution-Aware Images'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Concept explanation ──────────────────────────────────────
          const Text(
            'Different devices have different pixel densities (1x for low-DPI, '
            '2x for Retina, 3x for high-end phones). Flutter automatically picks '
            'the best image variant — you just need to place your images in the '
            'right folder structure next to the base image.',
            style: TextStyle(fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 24),

          // ── BAD code ─────────────────────────────────────────────────
          const _CodeSection(
            label: 'BAD — one image for all screen densities',
            labelColor: Colors.red,
            code: '''images/
  logo.png       ← only 1x exists

# On a 3x screen Flutter scales up the 1x image → blurry!
Image.asset('images/logo.png')''',
          ),
          const SizedBox(height: 12),

          // ── GOOD code ────────────────────────────────────────────────
          const _CodeSection(
            label: 'GOOD — provide 1x, 2x, and 3x variants',
            labelColor: Colors.green,
            code: '''images/
  lake.jpg          ← base (1x)
  2.0x/
    lake.jpg        ← 2x variant
  3.0x/
    lake.jpg        ← 3x variant

# pubspec.yaml — only declare the base path once:
flutter:
  assets:
    - images/lake.jpg   # Flutter finds 2.0x/ and 3.0x/ automatically

# Dart code — unchanged, Flutter handles the rest:
Image.asset('images/lake.jpg')  // ✅ picks the right variant''',
          ),
          const SizedBox(height: 24),

          // ── Live demo ─────────────────────────────────────────────────
          const Text(
            'Live Demo — Your Device',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Device pixel ratio card
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.phone_android, color: Colors.blue),
                      const SizedBox(width: 8),
                      const Text(
                        'Device pixel ratio:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        dpr.toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Flutter would load the $variantUsed image on this device.',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Visual folder structure
          const Text(
            'Required folder structure:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _FolderStructure(devicePixelRatio: dpr),
          const SizedBox(height: 16),

          // Actual image loaded
          const Text(
            'Image loaded right now (images/lake.jpg):',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'images/lake.jpg',
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Flutter resolved to the $variantUsed variant (device DPR = ${dpr.toStringAsFixed(2)})',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),

          // ── Tip card ──────────────────────────────────────────────────
          const _TipCard(
            tip: 'Only declare the base image path in pubspec.yaml — Flutter '
                'automatically discovers 2.0x/ and 3.0x/ sub-directories. '
                'If a variant is missing, Flutter gracefully falls back to the '
                'next available resolution.',
          ),
        ],
      ),
    );
  }
}

class _FolderStructure extends StatelessWidget {
  final double devicePixelRatio;

  const _FolderStructure({required this.devicePixelRatio});

  @override
  Widget build(BuildContext context) {
    final items = [
      _FolderItem(path: 'images/', isFolder: true, isActive: false),
      _FolderItem(
        path: '  lake.jpg',
        isFolder: false,
        label: '1x  (base)',
        isActive: devicePixelRatio < 2.0,
      ),
      _FolderItem(path: '  2.0x/', isFolder: true, isActive: false),
      _FolderItem(
        path: '    lake.jpg',
        isFolder: false,
        label: '2x',
        isActive: devicePixelRatio >= 2.0 && devicePixelRatio < 3.0,
      ),
      _FolderItem(path: '  3.0x/', isFolder: true, isActive: false),
      _FolderItem(
        path: '    lake.jpg',
        isFolder: false,
        label: '3x',
        isActive: devicePixelRatio >= 3.0,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Icon(
                  item.isFolder ? Icons.folder : Icons.image,
                  size: 16,
                  color: item.isFolder ? Colors.amber : Colors.white54,
                ),
                const SizedBox(width: 6),
                Text(
                  item.path,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13,
                    color: item.isActive ? Colors.greenAccent : Colors.white,
                    fontWeight: item.isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (item.label != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: item.isActive ? Colors.green : Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item.isActive ? '${item.label!} ← loaded' : item.label!,
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _FolderItem {
  final String path;
  final bool isFolder;
  final String? label;
  final bool isActive;

  _FolderItem({
    required this.path,
    required this.isFolder,
    required this.isActive,
    this.label,
  });
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
