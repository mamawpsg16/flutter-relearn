import 'package:flutter/material.dart';
import 'animated_container_screen.dart';
import 'animated_opacity_screen.dart';
import 'animated_switcher_screen.dart';
import 'hero_screen.dart';
import 'page_route_transitions_screen.dart';
import 'tween_animation_builder_screen.dart';
import 'animation_controller_screen.dart';
import 'physics_simulation_screen.dart';
import 'staggered_menu_screen.dart';
class AnimationsHome extends StatelessWidget {
  const AnimationsHome({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = [
      _Topic(
        title: 'AnimatedContainer',
        description: 'Animate size, color, shape, padding — no controller',
        icon: Icons.crop_square,
        color: Colors.blue,
        screen: const AnimatedContainerScreen(),
      ),
      _Topic(
        title: 'AnimatedOpacity',
        description: 'Smoothly fade widgets in and out',
        icon: Icons.opacity,
        color: Colors.indigo,
        screen: const AnimatedOpacityScreen(),
      ),
      _Topic(
        title: 'AnimatedSwitcher',
        description: 'Transition between two different widgets',
        icon: Icons.swap_horiz,
        color: Colors.deepPurple,
        screen: const AnimatedSwitcherScreen(),
      ),
      _Topic(
        title: 'Hero',
        description: 'Fly a shared widget between screens',
        icon: Icons.flight_takeoff,
        color: Colors.teal,
        screen: const HeroScreen(),
      ),
      _Topic(
        title: 'Page Route Transitions',
        description: 'Custom fade, slide, and scale page transitions',
        icon: Icons.slideshow,
        color: Colors.orange,
        screen: const PageRouteTransitionsScreen(),
      ),
      _Topic(
        title: 'TweenAnimationBuilder',
        description: 'Implicit animation for ANY value — the bridge to explicit',
        icon: Icons.tune,
        color: Colors.pink,
        screen: const TweenAnimationBuilderScreen(),
      ),
      _Topic(
        title: 'AnimationController',
        description: 'Explicit control — loop, reverse, chain with Interval',
        icon: Icons.play_circle_outline,
        color: Colors.deepPurple,
        screen: const AnimationControllerScreen(),
      ),
      _Topic(
        title: 'Physics Simulation',
        description: 'Animate using spring physics',
        icon: Icons.sports_basketball,
        color: Colors.lightGreen,
        screen: const PhysicsSimulationScreen(),
      ),
      _Topic(
        title: 'Staggered Animations',
        description: 'Sequential entry using Intervals',
        icon: Icons.format_list_bulleted,
        color: Colors.cyan,
        screen: const StaggeredMenuScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Animations & Transitions'),
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
