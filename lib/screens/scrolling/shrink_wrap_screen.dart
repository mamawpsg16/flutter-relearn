import 'package:flutter/material.dart';

class ShrinkWrapScreen extends StatelessWidget {
  const ShrinkWrapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShrinkWrap Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const ShrinkWrapPage(),
    );
  }
}

class ShrinkWrapPage extends StatelessWidget {
  const ShrinkWrapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ShrinkWrap Demo'),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Good Use ✅'),
              Tab(text: 'Bad Use ❌'),
            ],
          ),
        ),
        body: const TabBarView(children: [_GoodShrinkWrap(), _BadShrinkWrap()]),
      ),
    );
  }
}

// ✅ GOOD: shrinkWrap on a small list inside a Column
class _GoodShrinkWrap extends StatelessWidget {
  const _GoodShrinkWrap();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Some content above the list
          Container(
            color: Colors.teal.shade50,
            padding: const EdgeInsets.all(16),
            child: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.teal),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'shrinkWrap: true is fine here — small list (5 items), inside a Column with other widgets.',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // ✅ Good use: small, fixed list inside a Column
          ListView(
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(), // disable inner scroll
            children: const [
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Notifications'),
              ),
              ListTile(leading: Icon(Icons.lock), title: Text('Privacy')),
              ListTile(leading: Icon(Icons.palette), title: Text('Appearance')),
              ListTile(leading: Icon(Icons.language), title: Text('Language')),
              ListTile(leading: Icon(Icons.help), title: Text('Help')),
            ],
          ),

          const Divider(),

          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'More Content Below',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Because the list is small and shrinkWrap sizes it to its content, '
                'everything flows naturally in the Column.',
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ❌ BAD: shrinkWrap on a large list — use SliverList instead
class _BadShrinkWrap extends StatelessWidget {
  const _BadShrinkWrap();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.red.shade50,
          padding: const EdgeInsets.all(16),
          child: const Row(
            children: [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'shrinkWrap: true on 500 items — renders ALL at once, no lazy loading. '
                  'Use CustomScrollView + SliverList instead!',
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        ),

        // ❌ Bad use: large list with shrinkWrap
        Expanded(
          child: SingleChildScrollView(
            child: ListView.builder(
              shrinkWrap: true, // ← forces all 500 items to render immediately
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 500,
              itemBuilder: (context, index) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.red.shade100,
                  child: Text('${index + 1}'),
                ),
                title: Text('Item ${index + 1}'),
                subtitle: const Text(
                  'All 500 items rendered at startup — bad!',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
