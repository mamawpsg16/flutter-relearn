import 'package:flutter/material.dart';
import 'architecture_concepts_screen.dart';
import 'architecture_guide_screen.dart';
import 'architecture_case_study_screen.dart';
import 'architecture_recommendations_screen.dart';
import 'design_patterns/design_patterns_home.dart';

class AppArchitectureHome extends StatelessWidget {
  const AppArchitectureHome({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = [
      _Topic(
        title: 'Architecture Concepts',
        description:
            'Separation of concerns, layered architecture, SSOT, UDF, UI = f(state)',
        icon: Icons.layers_outlined,
        color: Colors.deepPurple,
        screen: const ArchitectureConceptsScreen(),
      ),
      _Topic(
        title: 'Architecture Guide',
        description: 'MVVM in depth — Views, ViewModels, Repositories, Services, Use-cases',
        icon: Icons.account_tree_outlined,
        color: Colors.indigo,
        screen: const ArchitectureGuideScreen(),
      ),
      _Topic(
        title: 'Architecture Case Study',
        description: 'Command pattern, ChangeNotifier, DI, package structure',
        icon: Icons.cases_outlined,
        color: Colors.teal,
        screen: const ArchitectureCaseStudyScreen(),
      ),
      _Topic(
        title: 'Recommendations',
        description: 'Priority-ranked best practices — strongly recommend, recommend, conditional',
        icon: Icons.checklist_outlined,
        color: Colors.green.shade700,
        screen: const ArchitectureRecommendationsScreen(),
      ),
      _Topic(
        title: 'Design Patterns',
        description: 'Optimistic state, Result objects, Offline-first support',
        icon: Icons.pattern_outlined,
        color: Colors.deepOrange,
        screen: const DesignPatternsHome(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('App Architecture'),
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
