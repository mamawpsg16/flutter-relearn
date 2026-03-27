import 'package:flutter/material.dart';

class SliversScreen extends StatelessWidget {
  const SliversScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slivers Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SliversPage(),
    );
  }
}

class SliversPage extends StatelessWidget {
  const SliversPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 1. SliverAppBar — collapses as you scroll down
          SliverAppBar(
            expandedHeight: 200,
            pinned: true, // stays visible (collapsed) when scrolled past
            floating: false,
            backgroundColor: Colors.deepPurple,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Slivers Demo',
                style: TextStyle(color: Colors.white),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.deepPurple, Colors.purpleAccent],
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.layers, size: 80, color: Colors.white54),
                ),
              ),
            ),
          ),

          // 2. SliverToBoxAdapter — wraps a regular widget inside CustomScrollView
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Featured Grid',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // 3. SliverGrid — grid section
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final colors = [
                  Colors.red,
                  Colors.orange,
                  Colors.green,
                  Colors.blue,
                  Colors.purple,
                  Colors.teal,
                ];
                return Card(
                  color: colors[index % colors.length].shade100,
                  child: Center(
                    child: Text(
                      'Grid $index',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
              childCount: 6,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.5,
            ),
          ),

          // 4. Another SliverToBoxAdapter for a section header
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                'All Items (lazy list)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // 5. SliverList — lazy, only renders visible items (performant on large lists)
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.deepPurple.shade100,
                  child: Text('${index + 1}'),
                ),
                title: Text('Item ${index + 1}'),
                subtitle: Text('Sliver list item — lazy loaded'),
                trailing: const Icon(Icons.chevron_right),
              ),
              childCount: 50,
            ),
          ),

          // 6. SliverFillRemaining — fills leftover space (useful for empty states)
          // Commented out here since we have content, but shown for reference:
          // SliverFillRemaining(child: Center(child: Text('No more items'))),
        ],
      ),
    );
  }
}
