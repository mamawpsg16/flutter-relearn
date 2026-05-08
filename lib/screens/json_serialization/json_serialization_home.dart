import 'package:flutter/material.dart';
import 'which_method_screen.dart';
import 'manual_serialization_screen.dart';
import 'code_generation_setup_screen.dart';
import 'nested_objects_screen.dart';
import 'best_practices_screen.dart';
import 'background_parsing_screen.dart';

class JsonSerializationHome extends StatelessWidget {
  const JsonSerializationHome({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = [
      _Topic(
        title: 'Which JSON Serialization Method is Right for Me?',
        description: 'Decide between manual dart:convert vs json_serializable',
        icon: Icons.help_outline,
        color: Colors.blue,
        screen: const WhichMethodScreen(),
      ),
      _Topic(
        title: 'Serializing JSON Manually',
        description: 'toJson() and fromJson() with dart:convert',
        icon: Icons.code,
        color: Colors.orange,
        screen: const ManualSerializationScreen(),
      ),
      _Topic(
        title: 'Code Generation with json_serializable',
        description: 'Setup, build_runner, and generating serialization code',
        icon: Icons.auto_fix_high,
        color: Colors.green,
        screen: const CodeGenerationSetupScreen(),
      ),
      _Topic(
        title: 'Handling Nested Objects',
        description: 'Complex models with nested classes and lists',
        icon: Icons.account_tree,
        color: Colors.purple,
        screen: const NestedObjectsScreen(),
      ),
      _Topic(
        title: 'Best Practices & Real-world Patterns',
        description: 'Error handling, validation, API integration patterns',
        icon: Icons.checklist,
        color: Colors.teal,
        screen: const BestPracticesScreen(),
      ),
      _Topic(
        title: 'Parse JSON in the Background',
        description: 'Use compute() to parse large responses without freezing UI',
        icon: Icons.sync,
        color: Colors.deepOrange,
        screen: const BackgroundParsingScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('JSON Serialization in Flutter'),
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
