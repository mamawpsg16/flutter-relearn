import 'package:flutter/material.dart';
import 'android/android_home.dart';

class PlatformIntegrationHome extends StatelessWidget {
  const PlatformIntegrationHome({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = [
      _Topic(
        title: 'Android',
        description: 'Splash screen, app icons, permissions, Kotlin integration',
        icon: Icons.android,
        color: Colors.green.shade700,
        screen: const AndroidHome(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Platform Integration'),
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
