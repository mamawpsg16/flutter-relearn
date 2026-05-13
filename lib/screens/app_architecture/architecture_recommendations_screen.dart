import 'package:flutter/material.dart';

class ArchitectureRecommendationsScreen extends StatelessWidget {
  const ArchitectureRecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommendations'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'These are the Flutter team\'s official architecture recommendations. '
              'They are guidelines, not rules — adapt them to your needs.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 16),

            // ── Priority legend ────────────────────────────────────────────
            _buildLegend(),
            const SizedBox(height: 24),

            // ── Separation of concerns ─────────────────────────────────────
            _SectionHeader(title: 'Separation of Concerns'),
            const SizedBox(height: 12),
            _RecommendationCard(
              priority: Priority.stronglyRecommend,
              title: 'Use clearly defined UI and data layers',
              description:
                  'Data layer exposes app data and holds business logic. '
                  'UI layer displays data and listens for user events. '
                  'Neither layer reaches into the other.',
            ),
            _RecommendationCard(
              priority: Priority.stronglyRecommend,
              title: 'Use the repository pattern in the data layer',
              description:
                  'Create Repository classes and Service classes. '
                  'Repository = source of truth, caching, error handling. '
                  'Service = thin wrapper around one external data source.',
            ),
            _RecommendationCard(
              priority: Priority.stronglyRecommend,
              title: 'Use ViewModels and Views in the UI layer (MVVM)',
              description:
                  'Views are "dumb" widgets — they only display. '
                  'ViewModels hold all UI logic, state, and commands. '
                  'One ViewModel per View — one-to-one relationship.',
            ),
            _RecommendationCard(
              priority: Priority.stronglyRecommend,
              title: 'Do not put logic in widgets',
              description:
                  'Only allowed in views: simple if-statements, animation logic, '
                  'layout logic (screen size), simple routing. '
                  'Everything else belongs in the ViewModel.',
            ),
            _RecommendationCard(
              priority: Priority.conditional,
              title: 'Use ChangeNotifier and Listenables',
              description:
                  'ChangeNotifier is convenient and built into Flutter. '
                  'But it\'s a choice — Riverpod, flutter_bloc, and streams '
                  'are all valid. Pick what your team knows.',
            ),
            _RecommendationCard(
              priority: Priority.conditional,
              title: 'Use a domain layer (use-cases)',
              description:
                  'Only needed when: ViewModels have too much complexity, '
                  'logic is repeated across ViewModels, or merging data '
                  'from multiple repositories. Adds overhead in simple apps.',
            ),
            const SizedBox(height: 24),

            // ── Handling data ──────────────────────────────────────────────
            _SectionHeader(title: 'Handling Data'),
            const SizedBox(height: 12),
            _RecommendationCard(
              priority: Priority.stronglyRecommend,
              title: 'Use unidirectional data flow',
              description:
                  'Data flows one way: data layer → UI layer. '
                  'User events flow the other way: UI → data layer. '
                  'Never let the UI mutate data directly.',
            ),
            _RecommendationCard(
              priority: Priority.recommend,
              title: 'Use Commands to handle user interaction events',
              description:
                  'Commands prevent rendering errors and standardize how '
                  'the UI sends events to the data layer. '
                  'Each command tracks its own running/error state.',
            ),
            _RecommendationCard(
              priority: Priority.stronglyRecommend,
              title: 'Use immutable data models',
              description:
                  'Immutable models can only change in one place — the data layer. '
                  'They prevent accidental UI mutations and support clean UDF. '
                  'Use copyWith() to create modified copies.',
            ),
            const SizedBox(height: 8),
            _CodeSection(
              label: 'BAD — mutable model, anyone can change it anywhere',
              labelColor: Colors.red,
              code: '''class Trip {
  String destination; // mutable — widget can accidentally change this
  bool isBooked;
  Trip({required this.destination, required this.isBooked});
}

// In a widget — BAD: directly mutating data
trip.destination = 'Paris'; // changes data outside the data layer!''',
            ),
            const SizedBox(height: 12),
            _CodeSection(
              label: 'GOOD — immutable model, changes only via copyWith',
              labelColor: Colors.green,
              code: '''class Trip {
  final String destination; // final — cannot be changed after creation
  final bool isBooked;
  const Trip({required this.destination, required this.isBooked});

  // To "change" it, create a new copy — original is untouched
  Trip copyWith({String? destination, bool? isBooked}) => Trip(
    destination: destination ?? this.destination,
    isBooked: isBooked ?? this.isBooked,
  );
}

// In repository — GOOD: create a new instance
void bookTrip(Trip trip) {
  _trips = _trips.map((t) =>
    t == trip ? t.copyWith(isBooked: true) : t
  ).toList();
}''',
            ),
            const SizedBox(height: 12),
            _RecommendationCard(
              priority: Priority.recommend,
              title: 'Use freezed or built_value for data models',
              description:
                  'These packages auto-generate copyWith, equality (==), '
                  'toString, and JSON serialization. Saves boilerplate. '
                  'Trade-off: adds build time with many models.',
            ),
            const SizedBox(height: 8),
            _CodeSection(
              label: 'freezed — generates copyWith, ==, toJson automatically',
              labelColor: Colors.blue,
              code: '''// You write this:
@freezed
class Trip with _\$Trip {
  const factory Trip({
    required String destination,
    required bool isBooked,
  }) = _Trip;

  factory Trip.fromJson(Map<String, dynamic> json) => _\$TripFromJson(json);
}

// freezed generates:
// - trip.copyWith(isBooked: true)
// - trip == otherTrip  (deep equality)
// - trip.toJson()
// Run: dart run build_runner build''',
            ),
            const SizedBox(height: 24),

            // ── App structure ──────────────────────────────────────────────
            _SectionHeader(title: 'App Structure'),
            const SizedBox(height: 12),
            _RecommendationCard(
              priority: Priority.stronglyRecommend,
              title: 'Use dependency injection',
              description:
                  'Never create dependencies inside a class — receive them. '
                  'Use the provider package as a DI container. '
                  'Prevents global state and makes classes testable.',
            ),
            _RecommendationCard(
              priority: Priority.stronglyRecommend,
              title: 'Use abstract repository classes',
              description:
                  'Abstract classes let you swap implementations for dev, '
                  'staging, and production without touching ViewModels. '
                  'Also essential for passing fake repos into tests.',
            ),
            const SizedBox(height: 8),
            _CodeSection(
              label: 'Abstract repository — swap implementations freely',
              labelColor: Colors.green,
              code: '''// Step 1: define the contract
abstract class TripRepository {
  Future<List<Trip>> getTrips();
  Future<void> deleteTrip(int id);
}

// Step 2: real implementation (talks to Supabase)
class SupabaseTripRepository implements TripRepository {
  Future<List<Trip>> getTrips() async {
    final data = await supabase.from('trips').select();
    return data.map(Trip.fromJson).toList();
  }
  Future<void> deleteTrip(int id) =>
      supabase.from('trips').delete().eq('id', id);
}

// Step 3: ViewModel only knows about the abstract class
class TripViewModel extends ChangeNotifier {
  TripViewModel(this._repo); // accepts ANY implementation
  final TripRepository _repo;
}

// In main.dart — swap just this one line for dev vs prod
Provider<TripRepository>(
  create: (_) => SupabaseTripRepository(), // prod
  // create: (_) => FakeTripRepository(),  // dev / tests
)''',
            ),
            const SizedBox(height: 12),
            _RecommendationCard(
              priority: Priority.recommend,
              title: 'Use go_router for navigation',
              description:
                  'Preferred for 90% of Flutter apps. Handles deep linking, '
                  'web URLs, and nested navigation. Fall back to Navigator '
                  'API directly for edge cases.',
            ),
            _RecommendationCard(
              priority: Priority.recommend,
              title: 'Use standardised naming conventions',
              description:
                  'Name classes for their architectural role. '
                  'Avoid names that clash with Flutter SDK classes. '
                  'See the table below.',
            ),
            const SizedBox(height: 8),
            _buildNamingTable(),
            const SizedBox(height: 24),

            // ── Testing ────────────────────────────────────────────────────
            _SectionHeader(title: 'Testing'),
            const SizedBox(height: 12),
            _RecommendationCard(
              priority: Priority.stronglyRecommend,
              title: 'Test architectural components separately',
              description:
                  'Unit test every Service, Repository, and ViewModel. '
                  'Widget test every View. '
                  'Test routing and dependency injection specifically.',
            ),
            _RecommendationCard(
              priority: Priority.stronglyRecommend,
              title: 'Make fakes for testing',
              description:
                  'A fake implements the same abstract class as the real one '
                  'but returns hardcoded data. No network, no database. '
                  'Forces you to write modular classes with clean interfaces.',
            ),
            const SizedBox(height: 8),
            _CodeSection(
              label: 'Fake repository — implements same abstract class',
              labelColor: Colors.blue,
              code: '''// Fake implements the abstract class — same interface, fake data
class FakeTripRepository implements TripRepository {
  // Return predictable data — no network, no Supabase
  Future<List<Trip>> getTrips() async => const [
    Trip(destination: 'Kyoto', isBooked: true),
    Trip(destination: 'Lisbon', isBooked: false),
  ];

  Future<void> deleteTrip(int id) async {} // do nothing
}

// Unit test — no Flutter widgets, no database needed
void main() {
  test('bookedCount returns correct count', () {
    final vm = TripViewModel(FakeTripRepository());
    await vm.load.execute();

    expect(vm.bookedCount, 1); // only Kyoto is booked
    expect(vm.trips.length, 2);
  });
}''',
            ),
            const SizedBox(height: 24),

            const _TipCard(
              tip:
                  'The "Strongly recommend" items are the foundation — '
                  'UI/data separation, repository pattern, MVVM, immutable models, '
                  'and DI. Get these right first. '
                  'Commands, ChangeNotifier, and freezed are improvements '
                  'you layer on top as your app grows.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _PriorityChip(priority: Priority.stronglyRecommend),
        _PriorityChip(priority: Priority.recommend),
        _PriorityChip(priority: Priority.conditional),
      ],
    );
  }

  Widget _buildNamingTable() {
    const h = TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
    const c = TextStyle(fontFamily: 'monospace', fontSize: 12);

    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(3)},
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade100),
          children: const [
            Padding(padding: EdgeInsets.all(8), child: Text('Role', style: h)),
            Padding(padding: EdgeInsets.all(8), child: Text('Class name', style: h)),
          ],
        ),
        _nameRow('View', 'HomeScreen, LoginScreen', c),
        _nameRow('ViewModel', 'HomeViewModel, LoginViewModel', c),
        _nameRow('Repository', 'TripRepository, UserRepository', c),
        _nameRow('Service', 'ApiService, LocationService', c),
        _nameRow('Use-case', 'GetFilteredFeedUseCase', c),
        _nameRow('Shared widgets', 'Put in ui/core/ — not /widgets', c),
      ],
    );
  }

  TableRow _nameRow(String role, String example, TextStyle style) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.all(8),
        child: Text(role, style: style.copyWith(fontWeight: FontWeight.w500)),
      ),
      Padding(padding: const EdgeInsets.all(8), child: Text(example, style: style)),
    ]);
  }
}

// ─── Priority enum ────────────────────────────────────────────────────────────

enum Priority { stronglyRecommend, recommend, conditional }

extension PriorityX on Priority {
  String get label {
    switch (this) {
      case Priority.stronglyRecommend: return 'Strongly Recommend';
      case Priority.recommend:         return 'Recommend';
      case Priority.conditional:       return 'Conditional';
    }
  }

  Color get color {
    switch (this) {
      case Priority.stronglyRecommend: return Colors.green.shade700;
      case Priority.recommend:         return Colors.blue.shade700;
      case Priority.conditional:       return Colors.orange.shade700;
    }
  }

  Color get bg {
    switch (this) {
      case Priority.stronglyRecommend: return Colors.green.shade50;
      case Priority.recommend:         return Colors.blue.shade50;
      case Priority.conditional:       return Colors.orange.shade50;
    }
  }
}

// ─── Shared private widgets ───────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        Expanded(child: Divider(color: Colors.grey.shade300)),
      ],
    );
  }
}

class _PriorityChip extends StatelessWidget {
  final Priority priority;
  const _PriorityChip({required this.priority});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: priority.bg,
        border: Border.all(color: priority.color.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        priority.label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: priority.color,
        ),
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final Priority priority;
  final String title;
  final String description;

  const _RecommendationCard({
    required this.priority,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: priority.color, width: 3),
        ),
        color: priority.bg.withValues(alpha: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _PriorityChip(priority: priority),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(description, style: const TextStyle(fontSize: 13, height: 1.5)),
        ],
      ),
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
