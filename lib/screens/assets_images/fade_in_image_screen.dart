import 'package:flutter/material.dart';

class FadeInImageScreen extends StatefulWidget {
  const FadeInImageScreen({super.key});

  @override
  State<FadeInImageScreen> createState() => _FadeInImageScreenState();
}

class _FadeInImageScreenState extends State<FadeInImageScreen> {
  // Changing this key forces FadeInImage to reload so the user sees the fade
  int _reloadKey = 0;
  _DemoMode _mode = _DemoMode.assetNetwork;

  static const _networkUrl =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1a/24701-nature-natural-beauty.jpg/1280px-24701-nature-natural-beauty.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fade In Images'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Concept explanation ──────────────────────────────────────
          const Text(
            'When loading a remote image there is a delay before the pixels '
            'arrive. FadeInImage shows a placeholder (a local asset or a '
            'transparent image) while loading, then smoothly fades in the '
            'real image — avoiding the jarring "pop" of a sudden appearance.',
            style: TextStyle(fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 24),

          // ── BAD code ─────────────────────────────────────────────────
          const _CodeSection(
            label: 'BAD — image pops in with no transition',
            labelColor: Colors.red,
            code: '''// ❌ Image appears abruptly — bad UX on slow connections
Image.network(
  'https://example.com/photo.jpg',
  height: 200,
  fit: BoxFit.cover,
)''',
          ),
          const SizedBox(height: 12),

          // ── GOOD code ────────────────────────────────────────────────
          const _CodeSection(
            label: 'GOOD — fade in with a placeholder',
            labelColor: Colors.green,
            code: '''// ✅ Option A: asset placeholder (bundled image or gif)
FadeInImage.assetNetwork(
  placeholder: 'assets/loading.gif',   // shown while loading
  image: 'https://example.com/photo.jpg',
  height: 200,
  fit: BoxFit.cover,
)

// ✅ Option B: transparent memory placeholder (no extra asset needed)
FadeInImage.memoryNetwork(
  placeholder: kTransparentImage,      // from transparent_image package
  image: 'https://example.com/photo.jpg',
  height: 200,
  fit: BoxFit.cover,
)

// ✅ Option C: custom widget placeholder (Flutter 3+)
Image.network(
  'https://example.com/photo.jpg',
  frameBuilder: (ctx, child, frame, loaded) {
    if (loaded) return child;
    return AnimatedOpacity(
      opacity: frame == null ? 0 : 1,
      duration: const Duration(milliseconds: 500),
      child: child,
    );
  },
  loadingBuilder: (ctx, child, progress) =>
    progress == null
      ? child
      : const Center(child: CircularProgressIndicator()),
)''',
          ),
          const SizedBox(height: 24),

          // ── Live demo ─────────────────────────────────────────────────
          const Text(
            'Live Demo',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: _DemoMode.values.map((m) {
              return ChoiceChip(
                label: Text(m.label),
                selected: _mode == m,
                selectedColor: Colors.blue.shade100,
                onSelected: (_) {
                  PaintingBinding.instance.imageCache.clear();
                  PaintingBinding.instance.imageCache.clearLiveImages();
                  setState(() {
                    _mode = m;
                    _reloadKey++;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 8),

          ElevatedButton.icon(
            onPressed: () {
              // Clear the image cache so the network image is re-fetched
              // and the fade-in animation plays again from scratch
              PaintingBinding.instance.imageCache.clear();
              PaintingBinding.instance.imageCache.clearLiveImages();
              setState(() => _reloadKey++);
            },
            icon: const Icon(Icons.replay),
            label: const Text('Replay fade-in'),
          ),
          const SizedBox(height: 12),

          // The demo widget — key forces a fresh load on every replay
          KeyedSubtree(
            key: ValueKey(_reloadKey),
            child: _buildDemo(_mode, _networkUrl),
          ),
          const SizedBox(height: 8),
          Text(
            _mode.codeHint,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),

          // ── How it works ──────────────────────────────────────────────
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue, size: 18),
                      SizedBox(width: 6),
                      Text(
                        'What happens under the hood',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  _Step(n: '1', text: 'Placeholder is rendered immediately'),
                  _Step(n: '2', text: 'Network request starts in the background'),
                  _Step(n: '3', text: 'Image bytes arrive and are decoded'),
                  _Step(
                      n: '4',
                      text:
                          'FadeInImage cross-fades from placeholder → real image'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ── Tip card ──────────────────────────────────────────────────
          const _TipCard(
            tip: 'Hit "Replay fade-in" above to watch the transition again. '
                'On a real device the fade is more noticeable because network '
                'latency is higher. For a zero-dependency placeholder use '
                'frameBuilder on Image.network instead of FadeInImage.',
          ),
        ],
      ),
    );
  }

  Widget _buildDemo(_DemoMode mode, String url) {
    const height = 220.0;
    switch (mode) {
      case _DemoMode.assetNetwork:
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: FadeInImage.assetNetwork(
            placeholder: 'images/lake.jpg',
            image: url,
            height: height,
            width: double.infinity,
            fit: BoxFit.cover,
            fadeInDuration: const Duration(milliseconds: 800),
          ),
        );
      case _DemoMode.frameBuilder:
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            url,
            height: height,
            width: double.infinity,
            fit: BoxFit.cover,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded) return child;
              return AnimatedOpacity(
                opacity: frame == null ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeIn,
                child: child,
              );
            },
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return Container(
                height: height,
                color: Colors.grey.shade200,
                child: Center(
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
                      const Text('Loading image…',
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              );
            },
          ),
        );
    }
  }
}

enum _DemoMode {
  assetNetwork(
    'FadeInImage.assetNetwork',
    'FadeInImage.assetNetwork(placeholder: \'images/lake.jpg\', image: url)',
  ),
  frameBuilder(
    'frameBuilder + loadingBuilder',
    'Image.network(url, frameBuilder: ..., loadingBuilder: ...)',
  );

  final String label;
  final String codeHint;

  const _DemoMode(this.label, this.codeHint);
}

// ── Small helpers ─────────────────────────────────────────────────────────────

class _Step extends StatelessWidget {
  final String n;
  final String text;

  const _Step({required this.n, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: Colors.blue,
            child: Text(n,
                style:
                    const TextStyle(color: Colors.white, fontSize: 11)),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
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
