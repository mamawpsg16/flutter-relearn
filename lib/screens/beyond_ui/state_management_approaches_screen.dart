import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// State Management Approaches Screen
// Mirrors: flutter.dev → "Approaches to state management"
// ---------------------------------------------------------------------------

class StateManagementApproachesScreen extends StatelessWidget {
  const StateManagementApproachesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Approaches to State Management'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _SectionHeader('General Overview'),
        _GeneralOverviewSection(),
        SizedBox(height: 24),
        _SectionHeader('Built-in: setState'),
        _SetStateSection(),
        SizedBox(height: 24),
        _SectionHeader('Built-in: ValueNotifier & InheritedNotifier'),
        _ValueNotifierSection(),
        SizedBox(height: 24),
        _SectionHeader('Built-in: InheritedWidget & InheritedModel'),
        _InheritedWidgetSection(),
        SizedBox(height: 24),
        _SectionHeader('Community-provided Packages'),
        _CommunityPackagesSection(),
        SizedBox(height: 32),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 1. General Overview
// ---------------------------------------------------------------------------
class _GeneralOverviewSection extends StatelessWidget {
  const _GeneralOverviewSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'State is any data that affects the UI. Flutter distinguishes two kinds: '
          'ephemeral state (local to one widget, e.g. a tab index) and app state '
          '(shared across widgets or sessions, e.g. a logged-in user or shopping cart). '
          'Choosing the right approach depends on how widely the state is shared.',
        ),
        const SizedBox(height: 12),
        _CodeSection(
          label: 'TWO KINDS OF STATE',
          labelColor: Colors.blue,
          code: '''// Ephemeral state — lives inside one widget
// ✓ Use setState, no need to share it
int _selectedTab = 0;
bool _isExpanded = false;

// App state — needed by multiple widgets / persisted
// ✓ Lift it up or use a state management solution
User currentUser;
List<CartItem> cartItems;''',
        ),
        const SizedBox(height: 12),
        _InfoCard(
          color: Colors.blue.shade50,
          icon: Icons.map_outlined,
          iconColor: Colors.blue,
          text: 'Decision rule: start with setState. Only reach for a heavier '
              'solution when you find yourself passing data through many widget '
              'layers just to share it — that\'s the signal to lift state up.',
        ),
        const SizedBox(height: 12),
        _TipCard(
          tip: 'There is no single "right" approach. Flutter is flexible by design. '
              'Pick the simplest tool that solves your problem and upgrade later if needed.',
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 2. setState
// ---------------------------------------------------------------------------
class _SetStateSection extends StatelessWidget {
  const _SetStateSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'setState is the simplest and most direct way to manage ephemeral state. '
          'It is built into StatefulWidget and triggers a rebuild of the widget and '
          'its subtree whenever you call it. No packages, no boilerplate.',
        ),
        const SizedBox(height: 12),
        _CodeSection(
          label: 'BAD — mutating state without setState',
          labelColor: Colors.red,
          code: '''// ❌ UI never updates because Flutter isn't notified
void _increment() {
  _counter++;          // direct mutation
}''',
        ),
        const SizedBox(height: 8),
        _CodeSection(
          label: 'GOOD — setState notifies Flutter',
          labelColor: Colors.green,
          code: '''// ✅ Flutter schedules a rebuild after the callback
void _increment() {
  setState(() {
    _counter++;
  });
}''',
        ),
        const SizedBox(height: 12),
        const _SetStateDemo(),
        const SizedBox(height: 12),
        _TipCard(
          tip: 'Keep setState calls small — only mutate state inside the callback. '
              'Avoid calling setState in build(), initState(), or dispose().',
        ),
      ],
    );
  }
}

class _SetStateDemo extends StatefulWidget {
  const _SetStateDemo();

  @override
  State<_SetStateDemo> createState() => _SetStateDemoState();
}

class _SetStateDemoState extends State<_SetStateDemo> {
  int _counter = 0;
  bool _liked = false;

  @override
  Widget build(BuildContext context) {
    return _DemoContainer(
      label: 'Live Demo — setState',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text('Counter: $_counter',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    onPressed: () => setState(() => _counter--),
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _counter++),
                    icon: const Icon(Icons.add_circle_outline),
                    color: Colors.deepPurple,
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              Text(_liked ? 'Liked!' : 'Not liked',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              IconButton(
                onPressed: () => setState(() => _liked = !_liked),
                icon: Icon(
                  _liked ? Icons.favorite : Icons.favorite_border,
                  color: _liked ? Colors.red : Colors.grey,
                  size: 32,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. ValueNotifier & InheritedNotifier
// ---------------------------------------------------------------------------
class _ValueNotifierSection extends StatelessWidget {
  const _ValueNotifierSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ValueNotifier<T> wraps a single value and notifies listeners whenever '
          'that value changes. It is a lightweight alternative to ChangeNotifier '
          'for simple, single-value state. Pair it with InheritedNotifier to '
          'propagate it down the widget tree without a third-party package.',
        ),
        const SizedBox(height: 12),
        _CodeSection(
          label: 'ValueNotifier — single reactive value',
          labelColor: Colors.green,
          code: '''// Create
final counter = ValueNotifier<int>(0);

// Mutate — automatically notifies listeners
counter.value++;

// Listen in a widget
ValueListenableBuilder<int>(
  valueListenable: counter,
  builder: (context, value, child) {
    return Text('Count: \$value');
  },
)

// Dispose when done
counter.dispose();''',
        ),
        const SizedBox(height: 8),
        _CodeSection(
          label: 'InheritedNotifier — share down the tree',
          labelColor: Colors.blue,
          code: '''class CounterNotifier extends InheritedNotifier<ValueNotifier<int>> {
  const CounterNotifier({
    super.key,
    required ValueNotifier<int> notifier,
    required super.child,
  }) : super(notifier: notifier);

  static int of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<CounterNotifier>()!
          .notifier!
          .value;
}

// Descendants call:
final count = CounterNotifier.of(context); // reactive!''',
        ),
        const SizedBox(height: 12),
        const _InheritedNotifierDemo(),
        const SizedBox(height: 12),
        const _ValueNotifierDemo(),
        const SizedBox(height: 12),
        _TipCard(
          tip: 'ValueNotifier is great for a single reactive value (selected tab, '
              'theme mode, volume). For multiple related values, prefer ChangeNotifier.',
        ),
      ],
    );
  }
}

// ── InheritedNotifier live demo ──────────────────────────────────────────────

// The actual InheritedNotifier — wraps a ValueNotifier<int> and shares it
// down the tree. Any descendant that calls CounterInherited.of(context)
// will automatically rebuild when the notifier changes.
class _CounterInherited extends InheritedNotifier<ValueNotifier<int>> {
  const _CounterInherited({
    required ValueNotifier<int> notifier,
    required super.child,
  }) : super(notifier: notifier);

  // Static helper so descendants don't need to know the type internals
  static int of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<_CounterInherited>()!
          .notifier!
          .value;
}

// The demo — creates the ValueNotifier at the top and injects via _CounterInherited
class _InheritedNotifierDemo extends StatefulWidget {
  const _InheritedNotifierDemo();

  @override
  State<_InheritedNotifierDemo> createState() => _InheritedNotifierDemoState();
}

class _InheritedNotifierDemoState extends State<_InheritedNotifierDemo> {
  // ValueNotifier lives here — passed into the InheritedNotifier
  final _counter = ValueNotifier<int>(0);

  @override
  void dispose() {
    _counter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _DemoContainer(
      label: 'Live Demo — InheritedNotifier sharing state down the tree',
      child: _CounterInherited(
        notifier: _counter,  // inject the ValueNotifier into the tree
        child: Column(
          children: [
            const Text(
              'The counter lives at the top. Both widgets below read it via '
              '_CounterInherited.of(context) — no prop drilling.',
              style: TextStyle(fontSize: 11, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            // Two separate descendants both reading from InheritedNotifier
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _CounterDisplay(),   // rebuilds when counter changes
                _CounterBadge(),     // also rebuilds when counter changes
              ],
            ),
            const SizedBox(height: 12),
            // Buttons mutate the ValueNotifier directly — no setState needed
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => _counter.value--,
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _counter.value++,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Descendant 1 — reads count via InheritedNotifier, no prop passed in
class _CounterDisplay extends StatelessWidget {
  const _CounterDisplay();

  @override
  Widget build(BuildContext context) {
    // dependOnInheritedWidgetOfExactType registers this widget as a listener
    final count = _CounterInherited.of(context);
    return Column(
      children: [
        const Text('Display widget', style: TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          '$count',
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

// Descendant 2 — also reads count, completely independent widget
class _CounterBadge extends StatelessWidget {
  const _CounterBadge();

  @override
  Widget build(BuildContext context) {
    final count = _CounterInherited.of(context);
    return Column(
      children: [
        const Text('Badge widget', style: TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 4),
        CircleAvatar(
          radius: 24,
          backgroundColor: count > 0 ? Colors.green : Colors.grey,
          child: Text(
            '$count',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

// ── ValueNotifier demo ───────────────────────────────────────────────────────
class _ValueNotifierDemo extends StatefulWidget {
  const _ValueNotifierDemo();

  @override
  State<_ValueNotifierDemo> createState() => _ValueNotifierDemoState();
}

class _ValueNotifierDemoState extends State<_ValueNotifierDemo> {
  final _counter = ValueNotifier<int>(0);
  final _isDark = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _counter.dispose();
    _isDark.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _DemoContainer(
      label: 'Live Demo — ValueNotifier + ValueListenableBuilder',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              const Text('Counter', style: TextStyle(fontSize: 12)),
              ValueListenableBuilder<int>(
                valueListenable: _counter,
                builder: (_, value, _) => Text(
                  '$value',
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => _counter.value--,
                    icon: const Icon(Icons.remove),
                  ),
                  IconButton(
                    onPressed: () => _counter.value++,
                    icon: const Icon(Icons.add),
                    color: Colors.deepPurple,
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              const Text('Dark mode', style: TextStyle(fontSize: 12)),
              ValueListenableBuilder<bool>(
                valueListenable: _isDark,
                builder: (_, dark, _) => Switch(
                  value: dark,
                  activeThumbColor: Colors.deepPurple,
                  onChanged: (v) => _isDark.value = v,
                ),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: _isDark,
                builder: (_, dark, _) => Icon(
                  dark ? Icons.dark_mode : Icons.light_mode,
                  color: dark ? Colors.indigo : Colors.orange,
                  size: 28,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 4. InheritedWidget & InheritedModel
// ---------------------------------------------------------------------------
class _InheritedWidgetSection extends StatelessWidget {
  const _InheritedWidgetSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'InheritedWidget is the low-level Flutter mechanism that all state '
          'management solutions (Provider, Riverpod, BLoC) are built on. It '
          'lets data propagate down the widget tree efficiently: descendants '
          'call dependOnInheritedWidgetOfExactType to subscribe and rebuild '
          'only when the data changes. InheritedModel adds fine-grained '
          'control by letting widgets subscribe to specific "aspects" of the data.',
        ),
        const SizedBox(height: 12),
        _CodeSection(
          label: 'InheritedWidget — basic pattern',
          labelColor: Colors.blue,
          code: '''class ThemeData extends InheritedWidget {
  final Color primaryColor;

  const ThemeData({
    super.key,
    required this.primaryColor,
    required super.child,
  });

  // How descendants access it
  static ThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ThemeData>()!;

  // Return true if descendants should rebuild
  @override
  bool updateShouldNotify(ThemeData old) =>
      primaryColor != old.primaryColor;
}

// Descendant reads it:
final theme = ThemeData.of(context);''',
        ),
        const SizedBox(height: 8),
        _CodeSection(
          label: 'InheritedModel — subscribe to aspects',
          labelColor: Colors.green,
          code: '''// Aspects let widgets opt-in to specific parts
class AppModel extends InheritedModel<String> {
  final Color accent;
  final double fontSize;
  ...
  @override
  bool updateShouldNotifyDependent(
      AppModel old, Set<String> dependencies) {
    if (dependencies.contains('accent'))
      return accent != old.accent;
    if (dependencies.contains('fontSize'))
      return fontSize != old.fontSize;
    return false;
  }
}

// Subscribe to only 'accent' changes — ignores fontSize rebuilds
InheritedModel.inheritFrom<AppModel>(context, aspect: 'accent');''',
        ),
        const SizedBox(height: 12),
        const _InheritedWidgetDemo(),
        const SizedBox(height: 12),
        _TipCard(
          tip: 'You rarely need to write InheritedWidget yourself — Provider wraps '
              'it for you. But understanding it explains why Provider works and '
              'helps you debug widget rebuild issues.',
        ),
      ],
    );
  }
}

// Simple InheritedWidget demo — custom theme propagation
class _AppAccent extends InheritedWidget {
  final Color color;
  const _AppAccent({required this.color, required super.child});

  static Color of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_AppAccent>()!.color;

  @override
  bool updateShouldNotify(_AppAccent old) => color != old.color;
}

class _InheritedWidgetDemo extends StatefulWidget {
  const _InheritedWidgetDemo();

  @override
  State<_InheritedWidgetDemo> createState() => _InheritedWidgetDemoState();
}

class _InheritedWidgetDemoState extends State<_InheritedWidgetDemo> {
  final _colors = [
    Colors.deepPurple,
    Colors.teal,
    Colors.orange,
    Colors.red,
    Colors.indigo,
  ];
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return _DemoContainer(
      label: 'Live Demo — InheritedWidget propagating accent color',
      child: _AppAccent(
        color: _colors[_index],
        child: Column(
          children: [
            const _AccentConsumer(label: 'Widget A reads accent'),
            const SizedBox(height: 4),
            const _AccentConsumer(label: 'Widget B reads accent'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () =>
                  setState(() => _index = (_index + 1) % _colors.length),
              child: const Text('Change accent (rebuilds consumers)'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccentConsumer extends StatelessWidget {
  final String label;
  const _AccentConsumer({required this.label});

  @override
  Widget build(BuildContext context) {
    final color = _AppAccent.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
    );
  }
}

// ---------------------------------------------------------------------------
// 5. Community-provided Packages
// ---------------------------------------------------------------------------
class _CommunityPackagesSection extends StatelessWidget {
  const _CommunityPackagesSection();

  static const _packages = [
    _PackageInfo(
      name: 'provider',
      tagline: 'Simple & recommended by Flutter team',
      description:
          'A wrapper around InheritedWidget. Gives you ChangeNotifierProvider, '
          'Consumer, and Provider.of. Best starting point for most apps.',
      icon: Icons.favorite,
      color: Colors.deepPurple,
    ),
    _PackageInfo(
      name: 'riverpod',
      tagline: 'Provider, reimagined — compile-safe',
      description:
          'Solves Provider\'s context dependency and adds compile-time safety. '
          'Supports async state out of the box with FutureProvider and StreamProvider.',
      icon: Icons.bolt,
      color: Colors.teal,
    ),
    _PackageInfo(
      name: 'flutter_bloc',
      tagline: 'BLoC / Cubit — events & states',
      description:
          'Enforces a strict event → state flow. Great for complex business logic '
          'and teams that want a predictable, testable state machine.',
      icon: Icons.account_tree_outlined,
      color: Colors.blue,
    ),
    _PackageInfo(
      name: 'get / getx',
      tagline: 'Minimal boilerplate, opinionated',
      description:
          'All-in-one: state, routing, and DI. Fast to prototype with, but '
          'ties you to its ecosystem. Not recommended for large teams.',
      icon: Icons.flash_on,
      color: Colors.orange,
    ),
    _PackageInfo(
      name: 'signals',
      tagline: 'Fine-grained reactivity',
      description:
          'Inspired by SolidJS signals. Only the widgets that read a signal '
          'rebuild — no Provider, no context required.',
      icon: Icons.cell_tower,
      color: Colors.red,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Flutter\'s ecosystem offers several community packages that build on '
          'InheritedWidget to provide ergonomic state management. Each has its '
          'own trade-offs — complexity, boilerplate, testability, and ecosystem size. '
          'There is no single "best" package; choose based on your team and app needs.',
        ),
        const SizedBox(height: 16),
        ..._packages.map((p) => _PackageCard(info: p)),
        const SizedBox(height: 12),
        _CodeSection(
          label: 'DECISION GUIDE',
          labelColor: Colors.blue,
          code: '''// Just one widget needs state?
→ setState

// One reactive value, no sharing?
→ ValueNotifier + ValueListenableBuilder

// Share state across a few screens?
→ provider (ChangeNotifier + Consumer)

// Async state, large app, safety matters?
→ riverpod

// Complex business logic, strict architecture?
→ flutter_bloc

// Maximum simplicity, small prototype?
→ get / getx (with caution)''',
        ),
        const SizedBox(height: 12),
        _TipCard(
          tip: 'Start simple. setState → ValueNotifier → provider is a '
              'natural upgrade path. Most apps never need to go past provider.',
        ),
      ],
    );
  }
}

class _PackageInfo {
  final String name;
  final String tagline;
  final String description;
  final IconData icon;
  final Color color;

  const _PackageInfo({
    required this.name,
    required this.tagline,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class _PackageCard extends StatelessWidget {
  final _PackageInfo info;
  const _PackageCard({required this.info});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: info.color,
          child: Icon(info.icon, color: Colors.white, size: 20),
        ),
        title: Row(
          children: [
            Text(info.name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: 'monospace')),
            const SizedBox(width: 8),
            Expanded(
              child: Text(info.tagline,
                  style: TextStyle(
                      fontSize: 11, color: Colors.grey.shade600),
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(info.description,
              style: const TextStyle(fontSize: 13)),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared private widgets
// ---------------------------------------------------------------------------
class _DemoContainer extends StatelessWidget {
  final String label;
  final Widget child;

  const _DemoContainer({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.deepPurple.shade200),
        borderRadius: BorderRadius.circular(8),
        color: Colors.deepPurple.shade50,
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade700,
                  fontSize: 12)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final Color iconColor;
  final String text;

  const _InfoCard({
    required this.color,
    required this.icon,
    required this.iconColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(text,
                  style: const TextStyle(color: Colors.black87)),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontWeight: FontWeight.bold),
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
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
                  fontSize: 12)),
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
              child: Text(tip,
                  style: const TextStyle(color: Colors.black87)),
            ),
          ],
        ),
      ),
    );
  }
}
