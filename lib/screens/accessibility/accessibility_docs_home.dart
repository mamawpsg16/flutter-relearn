import 'package:flutter/material.dart';
import 'package:flutter_relearn/screens/accessibility/introduction_screen.dart';
import 'package:flutter_relearn/screens/accessibility/ui_design_styling_screen.dart';
import 'package:flutter_relearn/screens/accessibility/assistive_technologies_screen.dart';
import 'package:flutter_relearn/screens/accessibility/accessibility_testing_screen.dart';
import 'package:flutter_relearn/screens/accessibility/web_accessibility_screen.dart';

class AccessibilityDocsHome extends StatelessWidget {
  const AccessibilityDocsHome({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = [
      _Topic(
        title: 'Introduction',
        description: 'What is the semantic tree, screen reader simulation',
        icon: Icons.accessibility_new,
        color: Colors.indigo,
        screen: const AccessibilityIntroductionScreen(),
      ),
      _Topic(
        title: 'UI Design & Styling',
        description: 'Touch targets, text scaling, color contrast (WCAG AA)',
        icon: Icons.palette_outlined,
        color: Colors.teal,
        screen: const UiDesignStylingScreen(),
      ),
      _Topic(
        title: 'Assistive Technologies',
        description: 'TalkBack, VoiceOver, MergeSemantics, SemanticsDebugger',
        icon: Icons.hearing,
        color: Colors.deepPurple,
        screen: const AssistiveTechnologiesScreen(),
      ),
      _Topic(
        title: 'Accessibility Testing',
        description: 'meetsGuideline(), DevTools inspector, checklist',
        icon: Icons.fact_check_outlined,
        color: Colors.orange,
        screen: const AccessibilityTestingScreen(),
      ),
      _Topic(
        title: 'Web Accessibility',
        description: 'Keyboard focus order, skip links, semantic HTML on web',
        icon: Icons.web,
        color: Colors.blue,
        screen: const WebAccessibilityScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accessibility'),
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
