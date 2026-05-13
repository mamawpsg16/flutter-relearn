import 'package:flutter/material.dart';
import 'optimistic_state_screen.dart';
import 'result_pattern_screen.dart';
import 'offline_first_screen.dart';

class DesignPatternsHome extends StatelessWidget {
  const DesignPatternsHome({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = [
      _Topic(
        title: 'Optimistic State',
        description:
            'Update the UI instantly before the network call completes — revert on failure',
        icon: Icons.flash_on_outlined,
        color: Colors.amber.shade700,
        screen: const OptimisticStateScreen(),
      ),
      _Topic(
        title: 'Error Handling with Result',
        description:
            'Replace try/catch everywhere with a Result<T,E> object for clean error flow',
        icon: Icons.error_outline,
        color: Colors.red.shade600,
        screen: const ResultPatternScreen(),
      ),
      _Topic(
        title: 'Offline-First Support',
        description:
            'Serve cached data when offline, sync with remote when back online',
        icon: Icons.wifi_off_outlined,
        color: Colors.blueGrey,
        screen: const OfflineFirstScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Design Patterns'),
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
