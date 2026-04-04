import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoadingTextAssetsScreen extends StatefulWidget {
  const LoadingTextAssetsScreen({super.key});

  @override
  State<LoadingTextAssetsScreen> createState() =>
      _LoadingTextAssetsScreenState();
}

class _LoadingTextAssetsScreenState extends State<LoadingTextAssetsScreen> {
  // Three ways to load text assets — toggle between them
  _LoadMethod _method = _LoadMethod.rootBundle;
  Future<String>? _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    setState(() {
      switch (_method) {
        case _LoadMethod.rootBundle:
          _future = rootBundle.loadString('assets/sample.txt');
        case _LoadMethod.defaultBundle:
          // DefaultAssetBundle.of(context) isn't available here yet,
          // so we trigger the load in the build via FutureBuilder key trick.
          _future = null;
        case _LoadMethod.hardcoded:
          _future = Future.value(
            '// ❌ Hardcoded in Dart source — not a real asset load\n'
            'const greeting = "Hello from Flutter assets!";\n'
            'const info = "This file was loaded using rootBundle.";\n'
            'const note = "Flutter bundles this file at build time.";\n',
          );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // DefaultAssetBundle method — resolved here where context is available
    final activeFuture = _method == _LoadMethod.defaultBundle
        ? DefaultAssetBundle.of(context).loadString('assets/sample.txt')
        : _future;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Loading Text Assets'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Concept explanation ──────────────────────────────────────
          const Text(
            'Flutter can bundle any file — JSON, CSV, plain text — as an asset. '
            'Use rootBundle.loadString() from package:flutter/services.dart to '
            'read them at runtime. The result is a Future<String>, so wrap your '
            'UI in a FutureBuilder to handle loading and error states cleanly.',
            style: TextStyle(fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 24),

          // ── BAD code ─────────────────────────────────────────────────
          const _CodeSection(
            label: 'BAD — hardcoding content directly in Dart',
            labelColor: Colors.red,
            code: '''// ❌ Hard to maintain, can't update without a new release
const appTerms = """
Welcome to our app.
By using this app you agree to...
[500 more lines of legal text]
""";''',
          ),
          const SizedBox(height: 12),

          // ── GOOD code ────────────────────────────────────────────────
          const _CodeSection(
            label: 'GOOD — load from a bundled asset file',
            labelColor: Colors.green,
            code: '''// ✅ assets/terms.txt is declared in pubspec.yaml
import 'package:flutter/services.dart';

// Option 1: rootBundle (global, always available)
final text = await rootBundle.loadString('assets/terms.txt');

// Option 2: DefaultAssetBundle (respects widget tree overrides,
//            preferred in tests and packages)
final text = await DefaultAssetBundle.of(context)
    .loadString('assets/terms.txt');

// Show it in the UI with FutureBuilder:
FutureBuilder<String>(
  future: rootBundle.loadString('assets/sample.txt'),
  builder: (context, snapshot) {
    if (snapshot.connectionState != ConnectionState.done) {
      return const CircularProgressIndicator();
    }
    if (snapshot.hasError) {
      return Text('Error: \${snapshot.error}');
    }
    return Text(snapshot.requireData);
  },
)''',
          ),
          const SizedBox(height: 24),

          // ── Live demo ─────────────────────────────────────────────────
          const Text(
            'Live Demo — Load assets/sample.txt',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Switch between the three approaches:',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: _LoadMethod.values.map((m) {
              return ChoiceChip(
                label: Text(m.label),
                selected: _method == m,
                selectedColor: Colors.purple.shade100,
                onSelected: (_) {
                  setState(() => _method = m);
                  _load();
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          // Result card
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.terminal, color: Colors.greenAccent, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      _method.label,
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                FutureBuilder<String>(
                  key: ValueKey(_method),
                  future: activeFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Loading asset…',
                              style: TextStyle(color: Colors.white54),
                            ),
                          ],
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      );
                    }
                    return Text(
                      snapshot.data ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'monospace',
                        fontSize: 13,
                        height: 1.6,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _method.codeSnippet,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),

          // ── What's in the file ─────────────────────────────────────
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue, size: 18),
                      SizedBox(width: 6),
                      Text(
                        'assets/sample.txt',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'This is a real file bundled with this app.\n'
                    'It was declared in pubspec.yaml and is read\n'
                    'at runtime — no hardcoding needed.',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ── Tip card ──────────────────────────────────────────────────
          const _TipCard(
            tip: 'Prefer DefaultAssetBundle.of(context).loadString() over '
                'rootBundle in widgets and packages — it can be overridden in '
                'tests. Use rootBundle only at the top level where no context '
                'is available (e.g. main()).',
          ),
        ],
      ),
    );
  }
}

enum _LoadMethod {
  rootBundle('rootBundle', 'rootBundle.loadString(\'assets/sample.txt\')'),
  defaultBundle(
    'DefaultAssetBundle',
    'DefaultAssetBundle.of(context).loadString(\'assets/sample.txt\')',
  ),
  hardcoded('Hardcoded (bad)', '/* hardcoded in Dart source */');

  final String label;
  final String codeSnippet;

  const _LoadMethod(this.label, this.codeSnippet);
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
