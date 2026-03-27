import 'package:flutter/material.dart';
import 'package:flutter_relearn/screens/platform_adaptations/platform_adaptations_screen.dart';
import 'package:flutter_relearn/screens/platform_adaptations/scrolling_physics_screen.dart';
import 'package:flutter_relearn/screens/platform_adaptations/haptic_feedback_screen.dart';
import 'package:flutter_relearn/screens/platform_adaptations/text_fields_platform_screen.dart';
import 'package:flutter_relearn/screens/platform_adaptations/nav_bars_platform_screen.dart';

class PlatformAdaptationsHome extends StatelessWidget {
  const PlatformAdaptationsHome({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = [
      _Topic(
        title: 'Widgets & Controls',
        description: 'Switch, Slider, Button — Material vs Cupertino',
        icon: Icons.widgets,
        color: Colors.green,
        screen: const PlatformAdaptationsScreen(),
      ),
      _Topic(
        title: 'Scrolling Physics',
        description: 'Bouncing vs Clamping, Scrollbar widget',
        icon: Icons.swap_vert,
        color: Colors.teal,
        screen: const ScrollingPhysicsScreen(),
      ),
      _Topic(
        title: 'Haptic Feedback',
        description: 'lightImpact, mediumImpact, heavyImpact, vibrate',
        icon: Icons.vibration,
        color: Colors.deepOrange,
        screen: const HapticFeedbackScreen(),
      ),
      _Topic(
        title: 'Text Fields',
        description: 'TextField vs CupertinoTextField, keyboard types',
        icon: Icons.text_fields,
        color: Colors.purple,
        screen: const TextFieldsPlatformScreen(),
      ),
      _Topic(
        title: 'Navigation Bars',
        description: 'AppBar, CupertinoNavigationBar, BottomNav, TabBar',
        icon: Icons.navigation,
        color: Colors.blue,
        screen: const NavBarsPlatformScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Automatic Platform Adaptations'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.separated(
        physics: const BouncingScrollPhysics(),
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
