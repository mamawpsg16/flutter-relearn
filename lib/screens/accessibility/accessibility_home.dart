import 'package:flutter/material.dart';
import 'package:flutter_relearn/screens/accessibility/semantics_screen.dart';
import 'package:flutter_relearn/screens/accessibility/focus_keyboard_screen.dart';
import 'package:flutter_relearn/screens/accessibility/gesture_detector_screen.dart';

class AccessibilityHome extends StatelessWidget {
  const AccessibilityHome({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = [
      _Topic(
        title: 'Semantics',
        description: 'Labels, hints, ExcludeSemantics, MergeSemantics, Tooltip',
        icon: Icons.accessibility_new,
        color: Colors.indigo,
        screen: const SemanticsScreen(),
      ),
      _Topic(
        title: 'Focus & Keyboard Navigation',
        description: 'FocusNode, FocusScope, autofocus, key events',
        icon: Icons.keyboard,
        color: Colors.cyan,
        screen: const FocusKeyboardScreen(),
      ),
      _Topic(
        title: 'GestureDetector',
        description: 'Tap, double tap, long press, pan, scale, InkWell',
        icon: Icons.touch_app,
        color: Colors.pink,
        screen: const GestureDetectorScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Input & Accessibility'),
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
