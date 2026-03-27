// Navigation Bars — Material AppBar/BottomNavigationBar vs Cupertino equivalents

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavBarsPlatformScreen extends StatefulWidget {
  const NavBarsPlatformScreen({super.key});

  @override
  State<NavBarsPlatformScreen> createState() => _NavBarsPlatformScreenState();
}

class _NavBarsPlatformScreenState extends State<NavBarsPlatformScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Bars'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Explanation ───────────────────────────────────────────────
            Card(
              color: Colors.blue.shade50,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Top and bottom navigation bars look different per platform.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• AppBar (Material) → colored, flat, with actions\n'
                      '• CupertinoNavigationBar → white/translucent, centered title\n'
                      '• BottomNavigationBar (Material) → icons + labels, colored indicator\n'
                      '• CupertinoTabBar → iOS tab bar, translucent background',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── AppBar preview ────────────────────────────────────────────
            const _SectionTitle('Material AppBar'),
            const _Tip(
              'AppBar sits in Scaffold.appBar. It supports leading, title, actions, bottom (TabBar).',
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AppBar(
                automaticallyImplyLeading: false,
                title: const Text('Material AppBar'),
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                actions: [
                  IconButton(icon: const Icon(Icons.search), onPressed: () {}),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── CupertinoNavigationBar preview ────────────────────────────
            const _SectionTitle('CupertinoNavigationBar'),
            const _Tip(
              'iOS-style bar: centered title, back button on the left, trailing on the right.',
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CupertinoNavigationBar(
                middle: const Text('Cupertino Nav Bar'),
                trailing: GestureDetector(
                  onTap: () {
                    print("Hello from CupertinoNavigationBar!");
                  },
                  child: const Icon(CupertinoIcons.add),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── BottomNavigationBar ───────────────────────────────────────
            const _SectionTitle('Material BottomNavigationBar'),
            const _Tip(
              'Shows 2–5 destinations at the bottom. '
              'type: fixed keeps all items visible; shifting animates them.',
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: (i) => setState(() => _selectedIndex = i),
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: 'Search',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── CupertinoTabBar ───────────────────────────────────────────
            const _SectionTitle('CupertinoTabBar'),
            const _Tip(
              'iOS tab bar — translucent background, tinted active icon. '
              'Normally used inside CupertinoTabScaffold.',
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CupertinoTabBar(
                currentIndex: _selectedIndex,
                onTap: (i) => setState(() => _selectedIndex = i),
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.search),
                    label: 'Search',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.person),
                    label: 'Profile',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── NavigationBar (Material 3) ────────────────────────────────
            const _SectionTitle('NavigationBar (Material 3)'),
            const _Tip(
              'The newer Material 3 bottom nav — uses NavigationDestination, '
              'pill-shaped indicator, no labels until selected.',
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: NavigationBar(
                selectedIndex: _selectedIndex,
                onDestinationSelected: (i) =>
                    setState(() => _selectedIndex = i),
                destinations: const [
                  NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
                  NavigationDestination(
                    icon: Icon(Icons.search),
                    label: 'Search',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Key takeaways ─────────────────────────────────────────────
            Card(
              color: Colors.blue.shade50,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Key takeaways',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• Use AppBar for Material, CupertinoNavigationBar for iOS.\n'
                      '• BottomNavigationBar is Material 2; NavigationBar is Material 3.\n'
                      '• CupertinoTabBar pairs with CupertinoTabScaffold for full iOS nav.\n'
                      '• For cross-platform apps, pick one style or branch on platform.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  );
}

class _Tip extends StatelessWidget {
  final String text;
  const _Tip(this.text);
  @override
  Widget build(BuildContext context) =>
      Text(text, style: const TextStyle(color: Colors.black54, fontSize: 12));
}
