// Adaptive Design Best Practices — Flutter official recommendations

import 'package:flutter/material.dart';
import 'package:flutter_relearn/screens/adaptive/best_practices/break_down_widgets_screen.dart';
import 'package:flutter_relearn/screens/adaptive/best_practices/solve_touch_first_screen.dart';
import 'package:flutter_relearn/screens/adaptive/best_practices/use_width_not_orientation_screen.dart';
import 'package:flutter_relearn/screens/adaptive/best_practices/constrain_max_width_screen.dart';
import 'package:flutter_relearn/screens/adaptive/best_practices/avoid_hardware_checks_screen.dart';
import 'package:flutter_relearn/screens/adaptive/best_practices/restore_list_state_screen.dart';
import 'package:flutter_relearn/screens/adaptive/best_practices/save_app_state_screen.dart';

class BestPracticesScreen extends StatelessWidget {
  const BestPracticesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = [
      _Topic(
        title: 'Break Down Your Widgets',
        description: 'Small, focused widgets rebuild faster and can be const',
        icon: Icons.groups,
        color: Colors.indigo,
        screen: const BreakDownWidgetsScreen(),
      ),
      _Topic(
        title: 'Solve Touch First',
        description: 'Minimum 48×48 px tap targets — fingers before mouse',
        icon: Icons.touch_app,
        color: Colors.orange,
        screen: const SolveTouchFirstScreen(),
      ),
      _Topic(
        title: 'Use Width, Not Orientation',
        description: 'Branch on available width, not Orientation enum',
        icon: Icons.screen_rotation,
        color: Colors.teal,
        screen: const UseWidthNotOrientationScreen(),
      ),
      _Topic(
        title: "Don't Gobble Horizontal Space",
        description: 'Constrain max width so content stays readable',
        icon: Icons.settings_ethernet,
        color: Colors.purple,
        screen: const ConstrainMaxWidthScreen(),
      ),
      _Topic(
        title: 'Avoid Hardware Type Checks',
        description: 'Check capabilities (screen size) not Platform.isX',
        icon: Icons.devices_other,
        color: Colors.red,
        screen: const AvoidHardwareChecksScreen(),
      ),
      _Topic(
        title: 'Restore List State',
        description: 'PageStorageKey preserves scroll position on rebuild',
        icon: Icons.restore,
        color: Colors.brown,
        screen: const RestoreListStateScreen(),
      ),
      _Topic(
        title: 'Save App State',
        description: "Don't lose form data on rotation or resize",
        icon: Icons.save,
        color: Colors.green,
        screen: const SaveAppStateScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Best Practices'),
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
        title: Text(
          topic.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(topic.description),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => topic.screen),
          );
        },
      ),
    );
  }
}
