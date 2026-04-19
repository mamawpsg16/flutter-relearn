import 'package:flutter/material.dart';
import 'package:flutter_relearn/screens/beyond_ui/state_management_screen.dart';
import 'package:flutter_relearn/screens/beyond_ui/state_management_approaches_screen.dart';

class BeyondUiHome extends StatelessWidget {
  const BeyondUiHome({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = [
      _Topic(
        title: 'State Management',
        description:
            'ChangeNotifier, ChangeNotifierProvider, Consumer, Provider.of',
        icon: Icons.share_outlined,
        color: Colors.deepPurple,
        screen: const StateManagementScreen(),
      ),
      _Topic(
        title: 'Approaches to State Management',
        description:
            'setState, ValueNotifier, InheritedWidget, community packages',
        icon: Icons.account_tree_outlined,
        color: Colors.teal,
        screen: const StateManagementApproachesScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beyond the UI'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: topics.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: topic.color,
          child: Icon(topic.icon, color: Colors.white),
        ),
        title: Text(topic.title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
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
