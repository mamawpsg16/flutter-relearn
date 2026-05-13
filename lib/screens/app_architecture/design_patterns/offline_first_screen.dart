import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// OFFLINE-FIRST SUPPORT
//
// An offline-first app works even without a network connection by:
// 1. Serving cached data immediately (fast, always works)
// 2. Fetching fresh data in the background when online
// 3. Updating the UI when fresh data arrives
//
// Strategy: Cache-first
//   → Return cache immediately
//   → Fetch from network in background
//   → Update cache and notify UI when network responds
// ═══════════════════════════════════════════════════════════════════════════════

class _Article {
  final int id;
  final String title;
  final String source; // 'cache' or 'network'
  const _Article({required this.id, required this.title, required this.source});
}

// ─── Simulated local cache ────────────────────────────────────────────────────
class _LocalCache {
  List<_Article> _data = [
    const _Article(id: 1, title: 'Flutter 3.0 release notes', source: 'cache'),
    const _Article(id: 2, title: 'MVVM best practices', source: 'cache'),
  ];

  List<_Article> read() => List.unmodifiable(_data);
  bool get isEmpty => _data.isEmpty;

  void write(List<_Article> articles) => _data = articles;
}

// ─── Simulated remote API ─────────────────────────────────────────────────────
class _RemoteApi {
  Future<List<_Article>> fetchArticles() async {
    await Future.delayed(const Duration(seconds: 2)); // simulate network latency
    return const [
      _Article(id: 1, title: 'Flutter 3.27 is here', source: 'network'),
      _Article(id: 2, title: 'MVVM best practices (updated)', source: 'network'),
      _Article(id: 3, title: 'Supabase realtime channels', source: 'network'),
    ];
  }
}

// ─── Repository — cache-first strategy ───────────────────────────────────────
class _ArticleRepository extends ChangeNotifier {
  final _LocalCache _cache;
  final _RemoteApi _api;
  final bool Function() _isOnline; // injected so demo can toggle it

  _ArticleRepository(this._cache, this._api, this._isOnline);

  List<_Article> _articles = [];
  bool isFetchingFromNetwork = false;
  String status = 'idle';

  List<_Article> get articles => _articles;
  bool get hasCachedData => _cache.read().isNotEmpty;

  Future<void> loadArticles() async {
    // Step 1: serve cache immediately — zero wait time
    if (hasCachedData) {
      _articles = _cache.read();
      status = 'Showing cached data';
      notifyListeners();
    }

    // Step 2: if online, fetch fresh data in the background
    if (_isOnline()) {
      isFetchingFromNetwork = true;
      status = 'Fetching fresh data...';
      notifyListeners();

      try {
        final fresh = await _api.fetchArticles();
        _cache.write(fresh); // update the cache
        _articles = fresh;
        status = 'Up to date';
      } catch (_) {
        status = 'Network failed — showing cached data';
      } finally {
        isFetchingFromNetwork = false;
        notifyListeners();
      }
    } else {
      // Offline — cache is all we have
      status = _articles.isEmpty
          ? 'Offline — no cached data available'
          : 'Offline — showing cached data';
      notifyListeners();
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SCREEN
// ═══════════════════════════════════════════════════════════════════════════════

class OfflineFirstScreen extends StatefulWidget {
  const OfflineFirstScreen({super.key});

  @override
  State<OfflineFirstScreen> createState() => _OfflineFirstScreenState();
}

class _OfflineFirstScreenState extends State<OfflineFirstScreen> {
  bool _isOnline = true;
  late final _ArticleRepository _repository;

  @override
  void initState() {
    super.initState();
    _repository = _ArticleRepository(
      _LocalCache(),
      _RemoteApi(),
      () => _isOnline, // passes a getter so repository always reads current value
    );
    _repository.loadArticles();
  }

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline-First'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'An offline-first app shows cached data immediately, then updates '
              'silently in the background when network is available. '
              'Users never see a blank screen or loading spinner just to view data '
              'they\'ve seen before.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 20),

            _CodeSection(
              label: 'BAD — network-first: blank screen when offline',
              labelColor: Colors.red,
              code: '''Future<void> loadArticles() async {
  // Always hits network — nothing to show if offline
  setState(() => _isLoading = true);
  final articles = await api.fetchArticles(); // 💥 throws when offline
  setState(() { _articles = articles; _isLoading = false; });
}''',
            ),
            const SizedBox(height: 12),

            _CodeSection(
              label: 'GOOD — cache-first: instant data, background refresh',
              labelColor: Colors.green,
              code: '''Future<void> loadArticles() async {
  // Step 1: serve cache immediately — no wait
  if (cache.isNotEmpty) {
    _articles = cache.read();
    notifyListeners(); // UI shows cached data right away
  }

  // Step 2: fetch fresh data in background (if online)
  if (isOnline) {
    try {
      final fresh = await api.fetchArticles();
      cache.write(fresh);   // update cache for next time
      _articles = fresh;
      notifyListeners();    // UI silently updates
    } catch (_) {
      // network failed — cached data is still showing, no crash
    }
  }
}''',
            ),
            const SizedBox(height: 24),

            const Text(
              'Live Demo',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Toggle offline mode and tap Reload to see how the app behaves',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),

            // Controls
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      _isOnline ? Icons.wifi : Icons.wifi_off,
                      color: _isOnline ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(_isOnline ? 'Online' : 'Offline',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _isOnline ? Colors.green : Colors.red,
                        )),
                    Switch(
                      value: _isOnline,
                      onChanged: (v) => setState(() => _isOnline = v),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: _repository.loadArticles,
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('Reload'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Repository state
            ListenableBuilder(
              listenable: _repository,
              builder: (context, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status bar
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: _repository.isFetchingFromNetwork
                            ? Colors.blue.shade50
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          if (_repository.isFetchingFromNetwork)
                            const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2),
                            ),
                          if (_repository.isFetchingFromNetwork)
                            const SizedBox(width: 8),
                          Text(
                            _repository.status,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Articles list
                    if (_repository.articles.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Text('No data available'),
                        ),
                      )
                    else
                      ..._repository.articles.map((article) {
                        final fromNetwork =
                            article.source == 'network';
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: Icon(
                              fromNetwork
                                  ? Icons.cloud_done_outlined
                                  : Icons.storage_outlined,
                              color: fromNetwork
                                  ? Colors.blue
                                  : Colors.orange,
                            ),
                            title: Text(article.title),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: fromNetwork
                                    ? Colors.blue.shade50
                                    : Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                article.source,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: fromNetwork
                                      ? Colors.blue.shade700
                                      : Colors.orange.shade700,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),

            const _TipCard(
              tip:
                  'Cache-first is the most user-friendly strategy: data appears '
                  'instantly from cache, then silently updates. '
                  'Always show users whether they\'re seeing cached or live data '
                  'so they know when the data was last refreshed.',
            ),
          ],
        ),
      ),
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
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  color: labelColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12)),
          const SizedBox(height: 8),
          Text(code,
              style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'monospace',
                  fontSize: 12,
                  height: 1.5)),
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
                child: Text(tip, style: const TextStyle(height: 1.5))),
          ],
        ),
      ),
    );
  }
}
