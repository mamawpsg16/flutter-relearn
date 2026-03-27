import 'package:flutter/material.dart';
import 'package:flutter_relearn/screens/interactivity/stateful_stateless_screen.dart';
import 'package:flutter_relearn/screens/interactivity/creating_stateful_screen.dart';
import 'package:flutter_relearn/screens/interactivity/managing_state_screen.dart';
import 'package:flutter_relearn/screens/interactivity/other_interactive_screen.dart';

class InteractivityHome extends StatelessWidget {
  const InteractivityHome({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = [
      _Topic(
        title: 'Stateful & Stateless Widgets',
        description: 'When a widget needs state vs when it doesn\'t',
        icon: Icons.swap_vert,
        color: Colors.indigo,
        screen: const StatefulStatelessScreen(),
      ),
      _Topic(
        title: 'Creating a Stateful Widget',
        description: 'Steps 0–4: subclass, State, setState, and wiring',
        icon: Icons.build,
        color: Colors.teal,
        screen: const CreatingStatefulScreen(),
      ),
      _Topic(
        title: 'Managing State',
        description: 'Self, parent, and mix-and-match state ownership',
        icon: Icons.account_tree,
        color: Colors.orange,
        screen: const ManagingStateScreen(),
      ),
      _Topic(
        title: 'Other Interactive Widgets',
        description: 'Standard widgets and Material interactive components',
        icon: Icons.widgets,
        color: Colors.purple,
        screen: const OtherInteractiveScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adding Interactivity'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: topics.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final topic = topics[index];
          return _TopicCard(topic: topic);
        },
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
