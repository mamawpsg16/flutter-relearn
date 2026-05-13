import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// SERVICE LAYER (lowest layer)
// Wraps a data source — HTTP, local DB, platform API, etc.
// Only job: fetch/send raw data. Holds NO state.
// In a real app this would be: await http.get('/api/posts')
// ═══════════════════════════════════════════════════════════════════════════════

class _PostService {
  // Simulates a network call — returns raw unstructured data (like JSON)
  Future<List<Map<String, dynamic>>> fetchRawPosts() async {
    await Future.delayed(const Duration(milliseconds: 800)); // fake network delay
    return [
      {'id': 1, 'title': 'Getting started with Flutter', 'likes': 42, 'saved': false},
      {'id': 2, 'title': 'Understanding MVVM architecture', 'likes': 87, 'saved': true},
      {'id': 3, 'title': 'Supabase with Flutter', 'likes': 31, 'saved': false},
      {'id': 4, 'title': 'State management in 2025', 'likes': 63, 'saved': true},
      {'id': 5, 'title': 'Building adaptive UIs', 'likes': 19, 'saved': false},
    ];
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// DOMAIN MODEL
// Plain Dart class representing data in a format the app understands.
// Not raw JSON, not a database row — shaped for the app's needs.
// ═══════════════════════════════════════════════════════════════════════════════

class _Post {
  final int id;
  final String title;
  final int likes;
  final bool saved;

  const _Post({
    required this.id,
    required this.title,
    required this.likes,
    required this.saved,
  });

  _Post copyWith({bool? saved}) =>
      _Post(id: id, title: title, likes: likes, saved: saved ?? this.saved);
}

// ═══════════════════════════════════════════════════════════════════════════════
// REPOSITORY LAYER
// - Calls the service to get raw data
// - Transforms raw data into domain models (_Post)
// - Caches data so the service isn't called unnecessarily
// - Single source of truth for posts
// ═══════════════════════════════════════════════════════════════════════════════

class _PostRepository {
  final _PostService _service; // injected — repository depends on the service
  _PostRepository(this._service);

  // Cache — once loaded, views don't wait for the network again
  List<_Post> _cache = [];

  // Converts raw Map data from the service into typed _Post objects
  List<_Post> get posts => List.unmodifiable(_cache);

  Future<void> loadPosts() async {
    final raw = await _service.fetchRawPosts(); // get raw data from service
    _cache = raw
        .map((m) => _Post(
              id: m['id'] as int,
              title: m['title'] as String,
              likes: m['likes'] as int,
              saved: m['saved'] as bool,
            ))
        .toList(); // transform into domain models
  }

  // Only this repository can mutate posts — SSOT principle
  void toggleSave(int postId) {
    _cache = _cache
        .map((p) => p.id == postId ? p.copyWith(saved: !p.saved) : p)
        .toList();
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// VIEW MODEL LAYER
// - Retrieves data from repository
// - Transforms it into UI-ready state (filtered list, loading flag, etc.)
// - Exposes COMMANDS — functions the view calls in response to user actions
// - The view knows nothing about repositories or services
// ═══════════════════════════════════════════════════════════════════════════════

enum _Filter { all, saved }

class _PostViewModel {
  final _PostRepository _repository; // injected — viewmodel depends on repository
  _PostViewModel(this._repository);

  bool isLoading = false;
  _Filter activeFilter = _Filter.all;

  // Derived state — view reads this, never accesses _repository directly
  List<_Post> get visiblePosts {
    final all = _repository.posts;
    return activeFilter == _Filter.saved
        ? all.where((p) => p.saved).toList()
        : all;
  }

  bool get isEmpty => visiblePosts.isEmpty;
  int get savedCount => _repository.posts.where((p) => p.saved).length;

  // ── Commands ────────────────────────────────────────────────────────────────
  // Commands are functions exposed to the view so it can trigger logic
  // without knowing HOW the logic works.

  // Command: load posts (view calls this once on init)
  Future<void> loadCommand(VoidCallback refresh) async {
    isLoading = true;
    refresh(); // tell the view to rebuild (show spinner)
    await _repository.loadPosts();
    isLoading = false;
    refresh(); // rebuild again with data
  }

  // Command: toggle saved status of a post
  void toggleSaveCommand(int postId, VoidCallback refresh) {
    _repository.toggleSave(postId);
    refresh();
  }

  // Command: change the active filter
  void setFilterCommand(_Filter filter, VoidCallback refresh) {
    activeFilter = filter;
    refresh();
  }

  // Command: refresh (re-fetch from service)
  Future<void> refreshCommand(VoidCallback refresh) async {
    await loadCommand(refresh);
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// VIEW (UI LAYER)
// - Displays state from ViewModel
// - Calls ViewModel commands on user actions
// - Contains NO business logic — only layout and simple conditionals
// ═══════════════════════════════════════════════════════════════════════════════

class ArchitectureGuideScreen extends StatefulWidget {
  const ArchitectureGuideScreen({super.key});

  @override
  State<ArchitectureGuideScreen> createState() =>
      _ArchitectureGuideScreenState();
}

class _ArchitectureGuideScreenState extends State<ArchitectureGuideScreen> {
  // Wire the layers together: Service → Repository → ViewModel
  late final _PostViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    final service = _PostService();
    final repository = _PostRepository(service);
    _viewModel = _PostViewModel(repository);
    // Call the load command — ViewModel handles the rest
    _viewModel.loadCommand(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Architecture Guide'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Intro ──────────────────────────────────────────────────────
            const Text(
              'Flutter recommends MVVM (Model-View-ViewModel). '
              'Your app splits into a UI layer (View + ViewModel) and a Data layer '
              '(Repository + Service). Each piece has one job and clean boundaries.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 20),

            // ── MVVM diagram ───────────────────────────────────────────────
            const Text(
              'MVVM — Full Stack Diagram',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildMVVMDiagram(),
            const SizedBox(height: 24),

            // ── Views ──────────────────────────────────────────────────────
            const Text(
              'Views',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Views are your widget classes. They display data and forward user '
              'actions to the ViewModel via commands. They should contain no '
              'business logic — only layout, animation, and simple conditionals.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 12),
            _CodeSection(
              label: 'BAD — View contains business logic',
              labelColor: Colors.red,
              code: '''// View is sorting, filtering, AND fetching — not its job
class PostsView extends StatelessWidget {
  Widget build(ctx) {
    final sorted = posts..sort((a, b) => b.likes - a.likes); // logic in view!
    final filtered = sorted.where((p) => p.saved);           // logic in view!
    return ListView(children: filtered.map((p) => Text(p.title)).toList());
  }
}''',
            ),
            const SizedBox(height: 12),
            _CodeSection(
              label: 'GOOD — View just renders what ViewModel exposes',
              labelColor: Colors.green,
              code: '''class PostsView extends StatelessWidget {
  final PostViewModel viewModel; // receives ViewModel

  Widget build(ctx) {
    // View reads pre-filtered, pre-sorted data — no logic needed
    return ListView(
      children: viewModel.visiblePosts  // already filtered by ViewModel
          .map((p) => PostCard(post: p))
          .toList(),
    );
  }
}''',
            ),
            const SizedBox(height: 24),

            // ── ViewModels ─────────────────────────────────────────────────
            const Text(
              'View Models',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'The ViewModel is the brain of each feature. It holds UI state, '
              'transforms repository data for display, and exposes commands '
              '— functions the view calls when the user does something.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 12),
            _CodeSection(
              label: 'Commands — named functions the view calls on user actions',
              labelColor: Colors.blue,
              code: '''class PostViewModel {
  // UI state
  bool isLoading = false;
  Filter activeFilter = Filter.all;

  // Derived data — pre-processed for the view
  List<Post> get visiblePosts => activeFilter == Filter.saved
      ? _repository.posts.where((p) => p.saved).toList()
      : _repository.posts;

  // Command: view calls this when user taps the save button
  void toggleSaveCommand(int postId, VoidCallback refresh) {
    _repository.toggleSave(postId); // delegate to repository
    refresh();                       // tell view to rebuild
  }

  // Command: view calls this on init
  Future<void> loadCommand(VoidCallback refresh) async {
    isLoading = true;  refresh();
    await _repository.loadPosts();
    isLoading = false; refresh();
  }
}''',
            ),
            const SizedBox(height: 24),

            // ── Repositories ───────────────────────────────────────────────
            const Text(
              'Repositories',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Repositories are the single source of truth for your data. '
              'They call services to get raw data, transform it into domain models, '
              'and handle caching, retries, and error logic.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 12),
            _CodeSection(
              label: 'Repository — transforms raw service data into domain models',
              labelColor: Colors.blue,
              code: '''class PostRepository {
  final PostService _service; // depends on the service
  List<Post> _cache = [];     // in-memory cache

  Future<void> loadPosts() async {
    final raw = await _service.fetchRawPosts(); // List<Map<String,dynamic>>
    _cache = raw.map((m) => Post(             // transform into typed objects
      id: m['id'],
      title: m['title'],
      likes: m['likes'],
    )).toList();
  }

  List<Post> get posts => List.unmodifiable(_cache); // read-only to outside
  void toggleSave(int id) { /* only repo mutates data */ }
}''',
            ),
            const SizedBox(height: 24),

            // ── Services ───────────────────────────────────────────────────
            const Text(
              'Services',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Services are the lowest layer. They wrap a single data source '
              '(REST API, local DB, platform plugin) and return raw data. '
              'They hold no state and do no transformation.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 12),
            _CodeSection(
              label: 'Service — thin wrapper around one data source',
              labelColor: Colors.blue,
              code: '''// One service per data source
class PostService {
  final http.Client _client;
  PostService(this._client);

  // Returns raw data — no transformation, no caching
  Future<List<Map<String, dynamic>>> fetchRawPosts() async {
    final response = await _client.get(Uri.parse('/api/posts'));
    return jsonDecode(response.body) as List<Map<String, dynamic>>;
  }
}

// Platform plugin example
class LocationService {
  Future<Map<String, double>> getCurrentPosition() async {
    final position = await Geolocator.getCurrentPosition();
    return {'lat': position.latitude, 'lng': position.longitude};
  }
}''',
            ),
            const SizedBox(height: 24),

            // ── Domain layer ───────────────────────────────────────────────
            const Text(
              'Optional: Domain Layer (Use-Cases)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add a domain layer when you have complex logic that would bloat '
              'the ViewModel — like merging data from two repositories, or '
              'logic that is reused across multiple ViewModels.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 12),
            _CodeSection(
              label: 'Use-case — encapsulates complex cross-repository logic',
              labelColor: Colors.blue,
              code: '''// Without use-case: ViewModel does too much
class FeedViewModel {
  // Merging posts + user preferences in the ViewModel — gets messy
  List<Post> get feed {
    final posts = _postRepo.posts;
    final prefs = _prefsRepo.preferences;
    return posts.where((p) => !prefs.blockedIds.contains(p.id))
                .sorted((a, b) => prefs.sortByLikes
                    ? b.likes - a.likes : b.date.compareTo(a.date))
                .toList();
  }
}

// With use-case: logic moves out of ViewModel into its own class
class GetFilteredFeedUseCase {
  final PostRepository _postRepo;
  final PreferencesRepository _prefsRepo;

  List<Post> execute() { /* same logic, but reusable and testable */ }
}

class FeedViewModel {
  final GetFilteredFeedUseCase _getFeed; // clean and simple
  List<Post> get feed => _getFeed.execute();
}''',
            ),
            const SizedBox(height: 12),
            _buildDomainLayerTable(),
            const SizedBox(height: 24),

            // ── Live demo ──────────────────────────────────────────────────
            const Text(
              'Live Demo — Full MVVM Stack',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'PostService → PostRepository → PostViewModel → View',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            _buildDemo(),
            const SizedBox(height: 24),

            const _TipCard(
              tip:
                  'Views and ViewModels have a one-to-one relationship — one per feature. '
                  'But Repositories and Services are many-to-many: a ViewModel can use '
                  'multiple repositories, and a repository can serve multiple ViewModels.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMVVMDiagram() {
    return Column(
      children: [
        _DiagramRow(
          layer: 'UI LAYER',
          layerColor: Colors.blue.shade700,
          items: const [
            _DiagramBox(label: 'View', sublabel: 'Widgets\n(display + events)', color: Colors.blue),
            _DiagramBox(label: 'ViewModel', sublabel: 'State + Commands\n(logic)', color: Colors.blue),
          ],
        ),
        _arrowDown('data flows down  /  events flow up'),
        _DiagramRow(
          layer: 'DATA LAYER',
          layerColor: Colors.green.shade700,
          items: const [
            _DiagramBox(label: 'Repository', sublabel: 'Domain models\n(SSOT + cache)', color: Colors.green),
            _DiagramBox(label: 'Service', sublabel: 'Raw data\n(API / DB / plugin)', color: Colors.teal),
          ],
        ),
      ],
    );
  }

  Widget _arrowDown(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.arrow_downward, size: 16, color: Colors.grey),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(width: 6),
          const Icon(Icons.arrow_upward, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildDomainLayerTable() {
    const h = TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
    const c = TextStyle(fontSize: 12);

    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      columnWidths: const {0: FlexColumnWidth(3), 1: FlexColumnWidth(2)},
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade100),
          children: const [
            Padding(padding: EdgeInsets.all(8), child: Text('Condition', style: h)),
            Padding(padding: EdgeInsets.all(8), child: Text('Add use-case?', style: h)),
          ],
        ),
        _tRow('Simple CRUD — ViewModel reads one repo', 'No — use repo directly', c),
        _tRow('Logic merges data from 2+ repositories', 'Yes', c),
        _tRow('Same logic used by multiple ViewModels', 'Yes — avoids duplication', c),
        _tRow('ViewModel becoming too large / complex', 'Yes — extract use-case', c),
        _tRow('Logic needs its own unit tests', 'Yes', c),
      ],
    );
  }

  TableRow _tRow(String condition, String answer, TextStyle style) {
    return TableRow(children: [
      Padding(padding: const EdgeInsets.all(8), child: Text(condition, style: style)),
      Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          answer,
          style: style.copyWith(
            color: answer.startsWith('Yes') ? Colors.green.shade700 : Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ]);
  }

  Widget _buildDemo() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Layer legend
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 12,
              children: [
                _LegendDot(color: Colors.blue.shade200, label: 'View (UI)'),
                _LegendDot(color: Colors.orange.shade200, label: 'ViewModel'),
                _LegendDot(color: Colors.green.shade200, label: 'Repository'),
                _LegendDot(color: Colors.teal.shade200, label: 'Service'),
              ],
            ),
          ),
          const Divider(height: 1),

          // VIEW — filter bar
          _DemoSection(
            layerLabel: 'VIEW',
            color: Colors.blue.shade50,
            borderColor: Colors.blue.shade200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Filter:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                SegmentedButton<_Filter>(
                  segments: const [
                    ButtonSegment(value: _Filter.all, label: Text('All')),
                    ButtonSegment(value: _Filter.saved, label: Text('Saved')),
                  ],
                  selected: {_viewModel.activeFilter},
                  onSelectionChanged: (v) => _viewModel.setFilterCommand(
                    v.first,
                    () => setState(() {}),
                  ),
                ),
              ],
            ),
          ),

          // VIEW MODEL — state summary
          _DemoSection(
            layerLabel: 'VIEW MODEL STATE',
            color: Colors.orange.shade50,
            borderColor: Colors.orange.shade200,
            child: Text(
              'isLoading: ${_viewModel.isLoading}\n'
              'activeFilter: ${_viewModel.activeFilter.name}\n'
              'visiblePosts: ${_viewModel.visiblePosts.length}\n'
              'savedCount: ${_viewModel.savedCount}',
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12, height: 1.6),
            ),
          ),

          // REPOSITORY — cached data
          _DemoSection(
            layerLabel: 'REPOSITORY (cache)',
            color: Colors.green.shade50,
            borderColor: Colors.green.shade200,
            child: _viewModel.isLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Column(
                    children: _viewModel.visiblePosts.isEmpty
                        ? [
                            const Padding(
                              padding: EdgeInsets.all(8),
                              child: Text('No posts match the current filter.'),
                            ),
                          ]
                        : _viewModel.visiblePosts.map((post) {
                            return ListTile(
                              dense: true,
                              title: Text(post.title, style: const TextStyle(fontSize: 13)),
                              subtitle: Text('${post.likes} likes'),
                              trailing: IconButton(
                                icon: Icon(
                                  post.saved ? Icons.bookmark : Icons.bookmark_border,
                                  color: post.saved ? Colors.orange : Colors.grey,
                                ),
                                // VIEW calls ViewModel COMMAND — no logic in the view
                                onPressed: () => _viewModel.toggleSaveCommand(
                                  post.id,
                                  () => setState(() {}),
                                ),
                              ),
                            );
                          }).toList(),
                  ),
          ),

          // SERVICE — raw data indicator
          _DemoSection(
            layerLabel: 'SERVICE (raw API)',
            color: Colors.teal.shade50,
            borderColor: Colors.teal.shade200,
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'fetchRawPosts() → List<Map<String,dynamic>>\n'
                    '[{id:1, title:..., likes:42}, ...]',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 11, height: 1.5),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () =>
                      _viewModel.refreshCommand(() => setState(() {})),
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Refresh'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Helper widgets ───────────────────────────────────────────────────────────

class _DiagramRow extends StatelessWidget {
  final String layer;
  final Color layerColor;
  final List<_DiagramBox> items;

  const _DiagramRow({
    required this.layer,
    required this.layerColor,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: layerColor.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            layer,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: layerColor,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: items
                .map((b) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: b)))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _DiagramBox extends StatelessWidget {
  final String label;
  final String sublabel;
  final Color color;

  const _DiagramBox({
    required this.label,
    required this.sublabel,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            sublabel,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _DemoSection extends StatelessWidget {
  final String layerLabel;
  final Color color;
  final Color borderColor;
  final Widget child;

  const _DemoSection({
    required this.layerLabel,
    required this.color,
    required this.borderColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            layerLabel,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: borderColor,
            ),
          ),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}

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
      width: double.infinity,
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
              fontSize: 12,
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
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lightbulb, color: Colors.purple),
            const SizedBox(width: 8),
            Expanded(child: Text(tip, style: const TextStyle(height: 1.5))),
          ],
        ),
      ),
    );
  }
}
