import 'package:flutter/material.dart';
import 'which_method_screen.dart';
import 'gson_equivalent_screen.dart';
import 'manual_serialization_screen.dart';
import 'code_generation_screen.dart';
import 'nested_classes_screen.dart';
import 'further_references_screen.dart';

class JsonSerializationHome extends StatelessWidget {
  const JsonSerializationHome({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = [
      _Topic(
        title: 'Which Method Is Right for Me?',
        description:
            'Manual vs code generation — comparison, pros/cons, and decision guide',
        icon: Icons.help_outline,
        color: Colors.indigo,
        screen: const WhichMethodScreen(),
      ),
      _Topic(
        title: 'GSON / Jackson / Moshi Equivalent?',
        description:
            'What Flutter uses instead of Java reflection-based JSON libraries',
        icon: Icons.compare_arrows,
        color: Colors.teal,
        screen: const GsonEquivalentScreen(),
      ),
      _Topic(
        title: 'Serializing JSON Manually',
        description:
            'dart:convert — inline decoding and model class approach with live demo',
        icon: Icons.code,
        color: Colors.orange,
        screen: const ManualSerializationScreen(),
      ),
      _Topic(
        title: 'Serializing JSON via Code Generation',
        description:
            'Setup, @JsonSerializable, build_runner, and consuming generated models',
        icon: Icons.auto_awesome,
        color: Colors.purple,
        screen: const CodeGenerationScreen(),
      ),
      _Topic(
        title: 'Generating Code for Nested Classes',
        description:
            'Nested objects with fromJson/toJson and explicitToJson: true',
        icon: Icons.account_tree,
        color: Colors.green,
        screen: const NestedClassesScreen(),
      ),
      _Topic(
        title: 'Further References',
        description:
            'dart:convert, json_serializable, freezed, built_value, and official docs',
        icon: Icons.link,
        color: Colors.blueGrey,
        screen: const FurtherReferencesScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('JSON Serialization'),
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
