import 'package:flutter/material.dart';
import 'tabs_screen.dart';
import 'navigate_screen.dart';
import 'send_data_screen.dart';
import 'return_data_screen.dart';
import 'drawer_screen.dart';
import 'cupertino_sheet_screen.dart';
import 'hands_on_screen.dart';

class NavigationHome extends StatelessWidget {
  const NavigationHome({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = [
      _Topic(
        title: 'Hands On Tabs',
        description: 'My Work',
        icon: Icons.tab,
        color: Colors.indigo,
        screen: const HandsOnScreen(),
      ),
      _Topic(
        title: 'Add Tabs',
        description: 'TabBar + TabBarView for horizontal tab navigation',
        icon: Icons.tab,
        color: Colors.indigo,
        screen: const TabsScreen(),
      ),
      _Topic(
        title: 'Navigate to a Screen & Back',
        description: 'Push a new route and pop back with Navigator',
        icon: Icons.arrow_forward,
        color: Colors.teal,
        screen: const NavigateScreen(),
      ),
      _Topic(
        title: 'Send Data to a Screen',
        description: 'Pass arguments to the next screen via constructor',
        icon: Icons.send,
        color: Colors.orange,
        screen: const SendDataScreen(),
      ),
      _Topic(
        title: 'Return Data from a Screen',
        description: 'Get a result back when a screen is popped',
        icon: Icons.reply,
        color: Colors.green,
        screen: const ReturnDataScreen(),
      ),
      _Topic(
        title: 'Add a Drawer',
        description: 'Side navigation panel with Drawer widget',
        icon: Icons.menu,
        color: Colors.purple,
        screen: const DrawerScreen(),
      ),
      _Topic(
        title: 'Cupertino Sheet',
        description: 'iOS-style modal bottom sheet',
        icon: Icons.keyboard_arrow_up,
        color: Colors.blue,
        screen: const CupertinoSheetScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation & Routing'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: topics.length,
        separatorBuilder: (_, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _TopicCard(topic: topics[index]),
      ),
    );
  }
}

class _Topic {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Widget screen;
  const _Topic({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.screen,
  });
}

class _TopicCard extends StatelessWidget {
  final _Topic topic;
  const _TopicCard({required this.topic});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: topic.color,
          child: Icon(topic.icon, color: Colors.white),
        ),
        title: Text(
          topic.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(topic.description),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => topic.screen),
        ),
      ),
    );
  }
}
