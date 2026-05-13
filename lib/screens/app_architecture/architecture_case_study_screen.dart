import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// COMMAND PATTERN
//
// In the previous screen, ViewModels passed a `refresh` callback so they could
// trigger a UI rebuild. That works but has problems:
//   - Every command needs its own isLoading flag
//   - Error state must be tracked separately per command
//   - Easy to forget to call refresh() after every state change
//
// The Command pattern solves this by wrapping async operations into a class
// that tracks its own running/error state and notifies listeners automatically.
// ═══════════════════════════════════════════════════════════════════════════════

class Command extends ChangeNotifier {
  Command(this._action);

  final Future<void> Function() _action;

  bool running = false;  // true while the async action is executing
  Exception? error;      // non-null if the last execution failed

  bool get hasError => error != null;

  Future<void> execute() async {
    if (running) return; // prevent double-tap
    running = true;
    error = null;
    notifyListeners(); // UI rebuilds → shows spinner

    try {
      await _action();
    } on Exception catch (e) {
      error = e;
    } finally {
      running = false;
      notifyListeners(); // UI rebuilds → shows result or error
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// DATA LAYER — Service + Repository
// ═══════════════════════════════════════════════════════════════════════════════

class _Trip {
  final int id;
  final String destination;
  final String dates;
  final bool isBooked;

  const _Trip({
    required this.id,
    required this.destination,
    required this.dates,
    required this.isBooked,
  });

  _Trip copyWith({bool? isBooked}) => _Trip(
        id: id,
        destination: destination,
        dates: dates,
        isBooked: isBooked ?? this.isBooked,
      );
}

class _TripService {
  Future<List<Map<String, dynamic>>> fetchTrips() async {
    await Future.delayed(const Duration(milliseconds: 900)); // simulate network
    return [
      {'id': 1, 'destination': 'Kyoto, Japan', 'dates': 'Mar 10–17', 'booked': true},
      {'id': 2, 'destination': 'Lisbon, Portugal', 'dates': 'Apr 3–10', 'booked': false},
      {'id': 3, 'destination': 'Cape Town, SA', 'dates': 'May 20–27', 'booked': false},
    ];
  }
}

class _TripRepository {
  final _TripService _service;
  _TripRepository(this._service);

  List<_Trip> _trips = [];
  List<_Trip> get trips => List.unmodifiable(_trips);

  Future<void> loadTrips() async {
    final raw = await _service.fetchTrips();
    _trips = raw
        .map((m) => _Trip(
              id: m['id'] as int,
              destination: m['destination'] as String,
              dates: m['dates'] as String,
              isBooked: m['booked'] as bool,
            ))
        .toList();
  }

  void deleteTrip(int id) {
    _trips = _trips.where((t) => t.id != id).toList();
  }

  void bookTrip(int id) {
    _trips = _trips
        .map((t) => t.id == id ? t.copyWith(isBooked: true) : t)
        .toList();
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// VIEW MODEL — extends ChangeNotifier
//
// ChangeNotifier is Flutter's built-in observable. When you call
// notifyListeners(), every widget listening via ListenableBuilder rebuilds.
//
// Commands are declared as fields. Each command is itself a ChangeNotifier,
// so the View can listen to individual commands for granular rebuilds.
// ═══════════════════════════════════════════════════════════════════════════════

class _TripViewModel extends ChangeNotifier {
  final _TripRepository _repository;

  _TripViewModel(this._repository) {
    // Wire up commands — each command wraps one async operation
    load = Command(_loadTrips);
    refresh = Command(_loadTrips);

    // Auto-load on creation — no manual call needed from the View
    load.execute();
  }

  // Commands — exposed to the View as named actions
  late final Command load;
  late final Command refresh;

  // Derived state for the View
  List<_Trip> get trips => _repository.trips;
  int get bookedCount => trips.where((t) => t.isBooked).length;
  bool get hasTrips => trips.isNotEmpty;

  Future<void> _loadTrips() async {
    await _repository.loadTrips();
    notifyListeners(); // tell all listeners the data changed
  }

  // Synchronous commands don't need the Command wrapper
  void deleteTrip(int id) {
    _repository.deleteTrip(id);
    notifyListeners();
  }

  void bookTrip(int id) {
    _repository.bookTrip(id);
    notifyListeners();
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// VIEW (UI LAYER)
// ═══════════════════════════════════════════════════════════════════════════════

class ArchitectureCaseStudyScreen extends StatefulWidget {
  const ArchitectureCaseStudyScreen({super.key});

  @override
  State<ArchitectureCaseStudyScreen> createState() =>
      _ArchitectureCaseStudyScreenState();
}

class _ArchitectureCaseStudyScreenState
    extends State<ArchitectureCaseStudyScreen> {
  late final _TripViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    final service = _TripService();
    final repository = _TripRepository(service);
    _viewModel = _TripViewModel(repository);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Architecture Case Study'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This case study walks through how a real Flutter app (the Compass app) '
              'implements MVVM. Four key concepts: the Command pattern, ChangeNotifier, '
              'package structure, and dependency injection.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 24),

            // ── Package structure ──────────────────────────────────────────
            const Text(
              'Package Structure',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Organize by TYPE in the data layer (repositories and services are '
              'shared across features). Organize by FEATURE in the UI layer '
              '(each feature has exactly one view + one view model).',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 12),
            _buildFolderTree(),
            const SizedBox(height: 24),

            // ── Command pattern ────────────────────────────────────────────
            const Text(
              'Command Pattern',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'A Command wraps an async action and tracks its own running/error '
              'state. Instead of passing setState as a callback, the View listens '
              'to the Command directly.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 12),

            _CodeSection(
              label: 'BAD — manual isLoading flags and refresh callbacks everywhere',
              labelColor: Colors.red,
              code: '''class TripViewModel {
  bool isLoadingTrips = false;  // manual flag per command
  bool isDeletingTrip = false;  // another manual flag
  String? loadError;

  Future<void> loadTrips(VoidCallback refresh) async {
    isLoadingTrips = true; refresh();   // easy to forget
    try { await _repo.loadTrips(); }
    catch (e) { loadError = e.toString(); }
    finally { isLoadingTrips = false; refresh(); } // easy to forget
  }
}''',
            ),
            const SizedBox(height: 12),

            _CodeSection(
              label: 'GOOD — Command class handles all of that automatically',
              labelColor: Colors.green,
              code: '''// Command is a ChangeNotifier — notifies listeners itself
class Command extends ChangeNotifier {
  Command(this._action);
  final Future<void> Function() _action;

  bool running = false;
  Exception? error;

  Future<void> execute() async {
    if (running) return;       // prevent double-tap
    running = true;
    error = null;
    notifyListeners();         // → spinner appears

    try { await _action(); }
    on Exception catch (e) { error = e; }
    finally {
      running = false;
      notifyListeners();       // → result or error shown
    }
  }
}

// In the ViewModel — clean and declarative
class TripViewModel extends ChangeNotifier {
  late final Command load = Command(_repo.loadTrips);
  late final Command refresh = Command(_repo.loadTrips);
}''',
            ),
            const SizedBox(height: 24),

            // ── ChangeNotifier ─────────────────────────────────────────────
            const Text(
              'ChangeNotifier + ListenableBuilder',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'ChangeNotifier is Flutter\'s built-in observable class. '
              'When you call notifyListeners(), every ListenableBuilder '
              'watching it rebuilds — no setState needed in the View.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 12),

            _CodeSection(
              label: 'ViewModel extends ChangeNotifier',
              labelColor: Colors.blue,
              code: '''class TripViewModel extends ChangeNotifier {
  final TripRepository _repo;

  // Commands are declared as fields
  late final Command load = Command(_loadTrips);

  Future<void> _loadTrips() async {
    await _repo.loadTrips();
    notifyListeners(); // tells all listeners: "data changed, rebuild"
  }

  void deleteTrip(int id) {
    _repo.deleteTrip(id);
    notifyListeners(); // synchronous — notifies immediately
  }
}''',
            ),
            const SizedBox(height: 12),

            _CodeSection(
              label: 'View uses ListenableBuilder — no setState anywhere',
              labelColor: Colors.green,
              code: '''// ListenableBuilder rebuilds its subtree when viewModel notifies
ListenableBuilder(
  listenable: viewModel.load, // listen to just this Command
  builder: (context, _) {
    if (viewModel.load.running) return CircularProgressIndicator();
    if (viewModel.load.hasError) return Text('Error loading trips');
    return TripList(trips: viewModel.trips);
  },
)

// Or listen to the whole ViewModel for simpler cases
ListenableBuilder(
  listenable: viewModel,
  builder: (context, _) => Text('\${viewModel.bookedCount} booked'),
)''',
            ),
            const SizedBox(height: 24),

            // ── Dependency Injection ───────────────────────────────────────
            const Text(
              'Dependency Injection',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'DI means: don\'t create dependencies inside a class — receive them '
              'from outside. This makes classes testable and swappable. '
              'In Flutter, Provider is the recommended DI container.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 12),

            _CodeSection(
              label: 'BAD — ViewModel creates its own dependencies (untestable)',
              labelColor: Colors.red,
              code: '''class TripViewModel extends ChangeNotifier {
  // Created internally — can't swap for a fake in tests
  final _repo = TripRepository(TripService(http.Client()));
}''',
            ),
            const SizedBox(height: 12),

            _CodeSection(
              label: 'GOOD — dependencies injected via constructor + Provider',
              labelColor: Colors.green,
              code: '''// ViewModel receives its dependency — doesn't create it
class TripViewModel extends ChangeNotifier {
  TripViewModel(this._repo);       // injected
  final TripRepository _repo;
}

// In main.dart — wire the layers once at the top
MultiProvider(
  providers: [
    Provider(create: (_) => TripService()),
    ProxyProvider<TripService, TripRepository>(
      update: (_, service, __) => TripRepository(service),
    ),
    ChangeNotifierProxyProvider<TripRepository, TripViewModel>(
      update: (_, repo, __) => TripViewModel(repo),
    ),
  ],
)

// In any widget — read without knowing how it was built
final vm = context.watch<TripViewModel>();''',
            ),
            const SizedBox(height: 24),

            // ── Live demo ──────────────────────────────────────────────────
            const Text(
              'Live Demo — ChangeNotifier + Command',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'ViewModel extends ChangeNotifier. View uses ListenableBuilder. '
              'No setState, no refresh callbacks.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            _buildDemo(),
            const SizedBox(height: 24),

            const _TipCard(
              tip:
                  'ListenableBuilder is more efficient than setState because it '
                  'only rebuilds the subtree inside its builder — not the whole '
                  'widget tree. Listen to individual Commands for the finest '
                  'granularity: only the spinner rebuilds, not the whole screen.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFolderTree() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        '''lib/
├── ui/                         ← organized by FEATURE
│   ├── core/
│   │   └── widgets/            ← shared widgets (buttons, cards)
│   └── home/                   ← one folder per feature
│       ├── view_models/
│       │   └── home_viewmodel.dart
│       └── widgets/
│           └── home_screen.dart
│
├── domain/
│   └── models/                 ← plain Dart data classes
│       └── trip.dart
│
├── data/                       ← organized by TYPE
│   ├── repositories/
│   │   └── trip_repository.dart
│   └── services/
│       └── trip_service.dart
│
└── main.dart                   ← wires DI (Provider setup)

test/                           ← mirrors lib/ structure
└── ui/home/
└── data/
testing/                        ← fake repos/services for tests
└── fakes/''',
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'monospace',
          fontSize: 11,
          height: 1.6,
        ),
      ),
    );
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
          // Header bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                // Refresh button — calls the refresh Command
                ListenableBuilder(
                  listenable: _viewModel.refresh,
                  builder: (context, _) => IconButton(
                    icon: _viewModel.refresh.running
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.refresh),
                    onPressed: _viewModel.refresh.running
                        ? null
                        : _viewModel.refresh.execute,
                    tooltip: 'Refresh trips',
                  ),
                ),
                const SizedBox(width: 8),
                // Trip count — listens to whole ViewModel
                ListenableBuilder(
                  listenable: _viewModel,
                  builder: (context, _) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Trips',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      Text(
                        '${_viewModel.bookedCount} booked · ${_viewModel.trips.length} total',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Trip list — listens to the load Command
          ListenableBuilder(
            listenable: _viewModel.load,
            builder: (context, _) {
              // While loading — show spinner
              if (_viewModel.load.running) {
                return const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              // If error — show message
              if (_viewModel.load.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Failed to load trips: ${_viewModel.load.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              // Data loaded — listen to ViewModel for mutations (delete/book)
              return ListenableBuilder(
                listenable: _viewModel,
                builder: (context, _) {
                  if (!_viewModel.hasTrips) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: Text('No trips saved.')),
                    );
                  }

                  return Column(
                    children: _viewModel.trips.map((trip) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: trip.isBooked
                              ? Colors.green.shade100
                              : Colors.grey.shade200,
                          child: Icon(
                            trip.isBooked
                                ? Icons.flight_takeoff
                                : Icons.bookmark_border,
                            color: trip.isBooked
                                ? Colors.green.shade700
                                : Colors.grey,
                            size: 18,
                          ),
                        ),
                        title: Text(trip.destination),
                        subtitle: Text(trip.dates),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!trip.isBooked)
                              TextButton(
                                onPressed: () => _viewModel.bookTrip(trip.id),
                                child: const Text('Book'),
                              ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.red),
                              onPressed: () => _viewModel.deleteTrip(trip.id),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─── Shared private widgets ───────────────────────────────────────────────────

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
