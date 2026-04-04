import 'package:flutter/material.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  int _selectedIndex = 0;

  static const _pages = ['Home', 'Profile', 'Settings', 'About'];
  static const _icons = [Icons.home, Icons.person, Icons.settings, Icons.info];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Drawer'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // The hamburger menu icon is added automatically when a Drawer is present
      ),
      // ── The Drawer ──────────────────────────────────────────────────
      drawer: Drawer(
        child: Column(
          children: [
            // Header
            UserAccountsDrawerHeader(
              accountName: const Text('Kevin Mensah'),
              accountEmail: const Text('kevin@flutter.dev'),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.purple, size: 36),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            // Nav items
            ...List.generate(_pages.length, (i) {
              return ListTile(
                leading: Icon(_icons[i],
                    color: _selectedIndex == i ? Colors.purple : null),
                title: Text(_pages[i]),
                selected: _selectedIndex == i,
                selectedTileColor: Colors.purple.shade50,
                onTap: () {
                  setState(() => _selectedIndex = i);
                  Navigator.pop(context); // close the drawer
                },
              );
            }),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Sign out',
                  style: TextStyle(color: Colors.red)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Concept ────────────────────────────────────────────────
          const Text(
            'A Drawer is a panel that slides in from the side — usually '
            'the left — for top-level navigation. Add it to Scaffold\'s '
            'drawer property and Flutter automatically adds the hamburger '
            'icon to the AppBar. Call Navigator.pop() to close it.',
            style: TextStyle(fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 16),
          Card(
            color: Colors.purple.shade50,
            child: ListTile(
              leading: const Icon(Icons.menu, color: Colors.purple),
              title: Text(
                'Currently showing: ${_pages[_selectedIndex]}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Tap the ☰ icon above to open the drawer'),
            ),
          ),
          const SizedBox(height: 24),

          const _CodeSection(
            label: 'BAD — manually building a side panel from scratch',
            labelColor: Colors.red,
            code: '''// ❌ Reinventing the wheel with a Stack + GestureDetector
Stack(
  children: [
    MainContent(),
    if (_isOpen)
      Positioned(left: 0, child: CustomSidePanel()), // no animation, no overlay
  ],
)''',
          ),
          const SizedBox(height: 12),

          const _CodeSection(
            label: 'GOOD — use the Drawer widget in Scaffold',
            labelColor: Colors.green,
            code: '''Scaffold(
  appBar: AppBar(title: const Text('My App')),
  // ✅ Scaffold adds the ☰ icon automatically
  drawer: Drawer(
    child: Column(
      children: [
        // Optional branded header
        UserAccountsDrawerHeader(
          accountName: const Text('Jane Doe'),
          accountEmail: const Text('jane@example.com'),
          currentAccountPicture: const CircleAvatar(child: Icon(Icons.person)),
        ),
        // Navigation items
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Home'),
          onTap: () {
            // do something
            Navigator.pop(context); // ✅ close drawer
          },
        ),
      ],
    ),
  ),
  body: const MainContent(),
)

// Open the drawer programmatically:
Scaffold.of(context).openDrawer();

// End drawer (slides from the right):
Scaffold(endDrawer: Drawer(...))''',
          ),
          const SizedBox(height: 24),

          const _TipCard(
            tip: 'Always call Navigator.pop(context) inside the drawer\'s '
                'onTap handlers to close it after navigating. '
                'Use Scaffold.of(context).openDrawer() to open '
                'it programmatically from a button anywhere in the body.',
          ),
        ],
      ),
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

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
                color: labelColor, fontWeight: FontWeight.bold, fontSize: 12)),
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
              child: Text(tip,
                  style: const TextStyle(fontSize: 14, height: 1.5))),
        ]),
      ),
    );
  }
}
