import 'package:flutter/material.dart';

class TabsScreen extends StatelessWidget {
  const TabsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Tabs'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.info), text: 'Concept'),
              Tab(icon: Icon(Icons.code), text: 'Code'),
              Tab(icon: Icon(Icons.play_arrow), text: 'Demo'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _ConceptTab(),
            _CodeTab(),
            _DemoTab(),
          ],
        ),
      ),
    );
  }
}

// ── Tab 1: Concept ────────────────────────────────────────────────────────────

class _ConceptTab extends StatelessWidget {
  const _ConceptTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Tabs let users switch between related views at the same level '
          'of the hierarchy. Flutter uses DefaultTabController to manage '
          'the selected tab, TabBar to show the tab labels, and TabBarView '
          'to display the content — they all stay in sync automatically.',
          style: TextStyle(fontSize: 15, height: 1.5),
        ),
        const SizedBox(height: 20),
        _InfoCard(
          icon: Icons.sync,
          color: Colors.indigo,
          title: 'DefaultTabController',
          body: 'Sits above TabBar and TabBarView in the widget tree. '
              'Set length to the number of tabs. No controller object needed.',
        ),
        const SizedBox(height: 12),
        _InfoCard(
          icon: Icons.tab,
          color: Colors.teal,
          title: 'TabBar',
          body: 'Usually placed in the AppBar\'s bottom slot. '
              'Each Tab() can have an icon, text, or both.',
        ),
        const SizedBox(height: 12),
        _InfoCard(
          icon: Icons.view_carousel,
          color: Colors.orange,
          title: 'TabBarView',
          body: 'Fills the body. Children must match length in '
              'DefaultTabController. Swiping also switches tabs.',
        ),
        const SizedBox(height: 20),
        const _TipCard(
          tip: 'The order of children in TabBar and TabBarView must match. '
              'DefaultTabController.of(context) gives you the controller '
              'anywhere below it in the tree if you need programmatic control.',
        ),
      ],
    );
  }
}

// ── Tab 2: Code ───────────────────────────────────────────────────────────────

class _CodeTab extends StatelessWidget {
  const _CodeTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _CodeSection(
          label: 'BAD — building tabs without DefaultTabController',
          labelColor: Colors.red,
          code: '''// ❌ TabBar and TabBarView are not connected
Scaffold(
  appBar: AppBar(
    bottom: TabBar(tabs: [...]),  // needs a controller
  ),
  body: TabBarView(children: [...]), // also needs one
  // Both crash: "No TabController found"
)''',
        ),
        SizedBox(height: 12),
        _CodeSection(
          label: 'GOOD — wrap with DefaultTabController',
          labelColor: Colors.green,
          code: '''// ✅ DefaultTabController connects everything
DefaultTabController(
  length: 3,              // must match tab count
  child: Scaffold(
    appBar: AppBar(
      title: const Text('My App'),
      bottom: const TabBar(
        tabs: [
          Tab(icon: Icon(Icons.home), text: 'Home'),
          Tab(icon: Icon(Icons.search), text: 'Search'),
          Tab(icon: Icon(Icons.person), text: 'Profile'),
        ],
      ),
    ),
    body: const TabBarView(
      children: [
        HomeView(),    // shown for tab 0
        SearchView(),  // shown for tab 1
        ProfileView(), // shown for tab 2
      ],
    ),
  ),
)''',
        ),
        SizedBox(height: 12),
        _CodeSection(
          label: 'Programmatic tab switching',
          labelColor: Colors.blue,
          code: '''// Jump to a specific tab from anywhere in the tree:
DefaultTabController.of(context).animateTo(2);

// Or create your own controller for full control:
final _ctrl = TabController(length: 3, vsync: this);
_ctrl.addListener(() {
  print('Tab changed to: \${_ctrl.index}');
});''',
        ),
      ],
    );
  }
}

// ── Tab 3: Demo ───────────────────────────────────────────────────────────────

class _DemoTab extends StatelessWidget {
  const _DemoTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.swipe, size: 48, color: Colors.indigo),
          const SizedBox(height: 16),
          const Text(
            'You are already in the demo!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'This entire screen IS the tab demo.\nTap the tabs above or swipe left/right.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 24),
          Card(
            color: Colors.indigo.shade50,
            margin: const EdgeInsets.symmetric(horizontal: 32),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Current tab index:',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${DefaultTabController.of(context).index}',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () =>
                        DefaultTabController.of(context).animateTo(0),
                    child: const Text('Jump to tab 0 (Concept)'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared helpers ────────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String body;

  const _InfoCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(body, style: const TextStyle(fontSize: 13)),
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
      decoration: BoxDecoration(
          color: Colors.grey.shade900, borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
      ]),
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
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.lightbulb, color: Colors.purple),
          const SizedBox(width: 12),
          Expanded(
              child:
                  Text(tip, style: const TextStyle(fontSize: 14, height: 1.5))),
        ]),
      ),
    );
  }
}
