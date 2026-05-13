import 'package:flutter/material.dart';

// ─── DATA LAYER ──────────────────────────────────────────────────────────────
// Responsible for storing and managing raw data.
// The UI never touches this layer directly.

// _UserModel is a plain data class — just holds values, no logic.
// Think of it like a row in a database table.
class _UserModel {
  final String name;
  final String role;
  final int loginCount;

  // Constructor: requires all three fields when creating a _UserModel
  const _UserModel({
    required this.name,
    required this.role,
    required this.loginCount,
  });

  // copyWith: creates a new _UserModel with some fields changed.
  // Uses ?? so if you don't pass a value, it keeps the existing one.
  // e.g. user.copyWith(name: 'Alice') → keeps same role and loginCount
  _UserModel copyWith({String? name, String? role, int? loginCount}) =>
      _UserModel(
        name: name ?? this.name,
        role: role ?? this.role,
        loginCount: loginCount ?? this.loginCount,
      );
}

// _UserRepository is the SINGLE SOURCE OF TRUTH for user data.
// Only this class can read or change _user — no one else stores a copy.
class _UserRepository {
  // Private field — only this class can access it directly
  _UserModel _user = const _UserModel(
    name: 'Kevin',
    role: 'Developer',
    loginCount: 1,
  );

  // Expose the current user to whoever asks (ViewModel will call this)
  _UserModel getUser() => _user;

  // Replace the stored user with a new one (ViewModel calls this to save changes)
  void updateUser(_UserModel updated) {
    _user = updated;
  }

  // Increment login count using copyWith — keeps name/role the same
  void recordLogin() {
    _user = _user.copyWith(loginCount: _user.loginCount + 1);
  }
}

// ─── LOGIC LAYER ─────────────────────────────────────────────────────────────
// Sits between UI and data. Transforms raw data into UI-ready values,
// and translates UI actions into data layer operations.

class _UserViewModel {
  // Holds a reference to the repository — this is how it reads/writes data.
  // The field is declared here but assigned via the constructor below.
  final _UserRepository _repository;

  // Constructor — Dart shorthand: takes one argument and assigns it to _repository.
  // Equivalent to: _UserViewModel(_UserRepository repo) { _repository = repo; }
  // The UI creates this ViewModel and passes in the repository it should use.
  _UserViewModel(this._repository);

  // Convenience getter — asks the repository for the current user
  _UserModel get user => _repository.getUser();

  // Derived/transformed values for the UI — UI just reads these, never calculates itself
  String get displayName => user.name.toUpperCase();          // "kevin" → "KEVIN"
  String get badge => '${user.role} • ${user.loginCount} logins'; // "Developer • 3 logins"
  Color get roleColor =>
      user.role == 'Developer' ? Colors.blue : Colors.orange; // drives avatar colour

  // Commands the UI can call — ViewModel decides how to update the repository
  void updateName(String name) =>
      _repository.updateUser(user.copyWith(name: name)); // keep role/count, change name

  void updateRole(String role) =>
      _repository.updateUser(user.copyWith(role: role)); // keep name/count, change role

  void login() => _repository.recordLogin(); // delegate to repository
}

// ─── UI LAYER ─────────────────────────────────────────────────────────────────
// Only job: display data from ViewModel and call ViewModel methods on user actions.
// Never talks to _UserRepository directly.

class ArchitectureConceptsScreen extends StatefulWidget {
  const ArchitectureConceptsScreen({super.key});

  @override
  State<ArchitectureConceptsScreen> createState() =>
      _ArchitectureConceptsScreenState();
}

class _ArchitectureConceptsScreenState
    extends State<ArchitectureConceptsScreen> {
  late final _UserRepository _repository;
  late final _UserViewModel _viewModel;
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Create the repository first — it owns the data
    _repository = _UserRepository();
    // Pass the repository into the ViewModel — ViewModel depends on it
    _viewModel = _UserViewModel(_repository);
    // Seed the text field with the current name from ViewModel
    _nameController.text = _viewModel.user.name;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _applyName() {
    setState(() => _viewModel.updateName(_nameController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Architecture Concepts'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Intro ──────────────────────────────────────────────────────
            const Text(
              'Good app architecture separates your code into layers so each part '
              'has one job. The UI shows data. The logic transforms it. '
              'The data layer stores and fetches it. '
              'Layers only talk to the layer directly next to them.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 24),

            // ── Layer diagram ──────────────────────────────────────────────
            const Text(
              'Layered Architecture',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildLayerDiagram(),
            const SizedBox(height: 24),

            // ── Separation of concerns ─────────────────────────────────────
            const Text(
              'Separation of Concerns',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            _CodeSection(
              label: 'BAD — business logic crammed into a widget',
              labelColor: Colors.red,
              code: '''// Widget fetches, transforms, AND displays data
class ProfileWidget extends StatefulWidget { ... }
  Future<void> loadUser() async {
    final raw = await http.get('/api/user');
    final json = jsonDecode(raw.body);
    // formatting logic mixed with UI
    setState(() => _name = json['name'].toUpperCase());
  }
}''',
            ),
            const SizedBox(height: 12),

            _CodeSection(
              label: 'GOOD — each class has one job',
              labelColor: Colors.green,
              code: '''// Data layer: fetches raw data
class UserRepository {
  Future<UserModel> getUser() async { ... }
}

// Logic layer: transforms for UI
class UserViewModel {
  String get displayName => user.name.toUpperCase();
}

// UI layer: just displays what ViewModel exposes
class ProfileWidget extends StatelessWidget {
  Widget build(ctx) => Text(viewModel.displayName);
}''',
            ),
            const SizedBox(height: 24),

            // ── SSOT ──────────────────────────────────────────────────────
            const Text(
              'Single Source of Truth (SSOT)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Only one class owns each piece of data — the Repository. '
              'No other class stores a copy. This prevents data getting out of sync.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 12),

            _CodeSection(
              label: 'BAD — data duplicated across widgets, gets out of sync',
              labelColor: Colors.red,
              code: '''class HomeScreen { String userName = 'Kevin'; }
class ProfileScreen { String userName = 'Kevin'; } // duplicate!
// User updates name in Profile → HomeScreen still shows old name''',
            ),
            const SizedBox(height: 12),

            _CodeSection(
              label: 'GOOD — Repository is the only owner of user data',
              labelColor: Colors.green,
              code: '''class UserRepository {
  UserModel _user = UserModel(name: 'Kevin');  // one copy
  UserModel getUser() => _user;
  void updateUser(UserModel u) => _user = u;   // only place it changes
}
// All screens read from the same repository → always in sync''',
            ),
            const SizedBox(height: 24),

            // ── UDF ───────────────────────────────────────────────────────
            const Text(
              'Unidirectional Data Flow (UDF)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Data flows one way: Data Layer → Logic Layer → UI. '
              'User events flow the opposite way: UI → Logic → Data. '
              'This makes bugs easy to trace — data always moves in one direction.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 12),
            _buildUDFDiagram(),
            const SizedBox(height: 24),

            // ── UI = f(state) ──────────────────────────────────────────────
            const Text(
              'UI is a Function of State',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Flutter rebuilds widgets whenever state changes. '
              'Your widgets should be "dumb" — just read state and display it. '
              'All logic lives in the ViewModel.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 12),

            _CodeSection(
              label: 'UI = f(state) — widget just renders what ViewModel gives it',
              labelColor: Colors.green,
              code: '''// State changes → UI automatically reflects it
Text(viewModel.displayName)   // "KEVIN"
Text(viewModel.badge)         // "Developer • 3 logins"
Container(color: viewModel.roleColor)  // blue or orange''',
            ),
            const SizedBox(height: 24),

            // ── Live demo ──────────────────────────────────────────────────
            const Text(
              'Live Demo — All Three Layers Working Together',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'UI calls ViewModel → ViewModel calls Repository → setState rebuilds UI',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            _buildDemo(),
            const SizedBox(height: 24),

            // ── Extensibility ──────────────────────────────────────────────
            const Text(
              'Extensibility',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'If your ViewModel depends on a concrete class, you are locked to it. '
              'Use an abstract class (interface) instead — then you can swap the '
              'implementation without touching the ViewModel at all.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 12),

            _CodeSection(
              label: 'BAD — ViewModel is locked to one specific repository',
              labelColor: Colors.red,
              code: '''class UserViewModel {
  // Hardcoded to SupabaseUserRepository
  // Want to switch to Firebase? You must change this class too.
  final SupabaseUserRepository _repository;
  UserViewModel(this._repository);
}''',
            ),
            const SizedBox(height: 12),

            _CodeSection(
              label: 'GOOD — ViewModel depends on an interface, not a concrete class',
              labelColor: Colors.green,
              code: '''// Step 1: define the contract (what any repository must do)
abstract class UserRepository {
  UserModel getUser();
  void updateUser(UserModel user);
}

// Step 2: implement it for Supabase
class SupabaseUserRepository implements UserRepository {
  UserModel getUser() { /* fetch from Supabase */ }
  void updateUser(UserModel u) { /* save to Supabase */ }
}

// Step 3: ViewModel only knows about the interface
class UserViewModel {
  final UserRepository _repository; // accepts ANY implementation
  UserViewModel(this._repository);
}

// Swap to Firebase later — ViewModel code doesn't change at all
UserViewModel(FirebaseUserRepository());
UserViewModel(SupabaseUserRepository());''',
            ),
            const SizedBox(height: 24),

            // ── Testability ────────────────────────────────────────────────
            const Text(
              'Testability',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Because the ViewModel depends on an interface, you can pass in a '
              'fake repository during tests — no real database needed. '
              'You test only the ViewModel logic in isolation.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 12),

            _CodeSection(
              label: 'Fake repository for tests — implements the same interface',
              labelColor: Colors.blue,
              code: '''// Fake returns hardcoded data — no Supabase, no network
class FakeUserRepository implements UserRepository {
  UserModel getUser() =>
      UserModel(name: 'Test', role: 'Admin', loginCount: 5);
  void updateUser(UserModel u) {} // do nothing
}''',
            ),
            const SizedBox(height: 12),

            _CodeSection(
              label: 'Test — pass the fake, assert on ViewModel output',
              labelColor: Colors.green,
              code: '''void main() {
  test('displayName is uppercased', () {
    // Inject fake instead of real Supabase repository
    final vm = UserViewModel(FakeUserRepository());

    expect(vm.displayName, 'TEST');       // "Test" → "TEST"
    expect(vm.badge, 'Admin • 5 logins'); // derived value is correct
  });
}
// No Flutter widgets, no database, no network — fast and reliable''',
            ),
            const SizedBox(height: 24),

            const _TipCard(
              tip:
                  'The UI layer should never import the data layer directly. '
                  'If a widget needs to call supabase.from(...) or http.get(...), '
                  'that logic belongs in a Repository, not in build().',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLayerDiagram() {
    return Column(
      children: [
        _LayerTile(
          label: 'UI Layer',
          sublabel: 'Widgets — display data, handle taps',
          color: Colors.blue.shade400,
          icon: Icons.phone_android,
        ),
        _arrowDown(),
        _LayerTile(
          label: 'Logic Layer (ViewModel)',
          sublabel: 'Transforms data, exposes commands to UI',
          color: Colors.orange.shade400,
          icon: Icons.settings,
        ),
        _arrowDown(),
        _LayerTile(
          label: 'Data Layer (Repository)',
          sublabel: 'Single source of truth — fetch, store, update',
          color: Colors.green.shade500,
          icon: Icons.storage,
        ),
      ],
    );
  }

  Widget _arrowDown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Icon(Icons.arrow_downward, color: Colors.grey.shade500, size: 18),
              Text(
                'data flows down',
                style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
              ),
              Icon(Icons.arrow_upward, color: Colors.grey.shade400, size: 18),
              Text(
                'events flow up',
                style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUDFDiagram() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _UDFBox(
                  label: '1. User taps button',
                  color: Colors.blue.shade100,
                  layer: 'UI',
                ),
              ),
              const Icon(Icons.arrow_forward, size: 18),
              Expanded(
                child: _UDFBox(
                  label: '2. ViewModel.login()',
                  color: Colors.orange.shade100,
                  layer: 'Logic',
                ),
              ),
              const Icon(Icons.arrow_forward, size: 18),
              Expanded(
                child: _UDFBox(
                  label: '3. Repository updates data',
                  color: Colors.green.shade100,
                  layer: 'Data',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_downward, size: 16),
              SizedBox(width: 4),
              Text(
                'new state flows back up to UI',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDemo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // UI Layer — profile card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'UI LAYER',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: _viewModel.roleColor,
                      child: Text(
                        _viewModel.user.name[0],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _viewModel.displayName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          _viewModel.badge,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Logic Layer — ViewModel actions
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LOGIC LAYER — ViewModel commands',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            setState(() => _viewModel.login()),
                        icon: const Icon(Icons.login, size: 16),
                        label: const Text('Record Login'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => setState(
                          () => _viewModel.updateRole(
                            _viewModel.user.role == 'Developer'
                                ? 'Designer'
                                : 'Developer',
                          ),
                        ),
                        icon: const Icon(Icons.swap_horiz, size: 16),
                        label: const Text('Toggle Role'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _applyName(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _applyName,
                      child: const Text('Update'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Data Layer — repository state
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DATA LAYER — Repository (single source of truth)',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'name: "${_viewModel.user.name}"\n'
                  'role: "${_viewModel.user.role}"\n'
                  'loginCount: ${_viewModel.user.loginCount}',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shared private widgets ───────────────────────────────────────────────────

class _LayerTile extends StatelessWidget {
  final String label;
  final String sublabel;
  final Color color;
  final IconData icon;

  const _LayerTile({
    required this.label,
    required this.sublabel,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  sublabel,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UDFBox extends StatelessWidget {
  final String label;
  final Color color;
  final String layer;

  const _UDFBox({
    required this.label,
    required this.color,
    required this.layer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Text(
            layer,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11), textAlign: TextAlign.center),
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
