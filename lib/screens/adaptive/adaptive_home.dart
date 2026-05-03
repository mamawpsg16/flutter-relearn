import 'package:flutter/material.dart';
import 'package:flutter_relearn/screens/design_theming/design_theming_home.dart';
import 'package:flutter_relearn/screens/interactivity/interactivity_home.dart';
import 'package:flutter_relearn/screens/adaptive/media_query_screen.dart';
import 'package:flutter_relearn/screens/adaptive/layout_builder_screen.dart';
import 'package:flutter_relearn/screens/adaptive/safe_area_screen.dart';
import 'package:flutter_relearn/screens/adaptive/flexible_expanded_screen.dart';
import 'package:flutter_relearn/screens/adaptive/adaptive_scaffold_screen.dart';
import 'package:flutter_relearn/screens/adaptive/nested_theme_screen.dart';
import 'package:flutter_relearn/screens/adaptive/best_practices_screen.dart';
import 'package:flutter_relearn/screens/platform_adaptations/platform_adaptations_home.dart';
import 'package:flutter_relearn/screens/accessibility/accessibility_home.dart';
import 'package:flutter_relearn/screens/accessibility/accessibility_docs_home.dart';
import 'package:flutter_relearn/screens/assets_images/assets_images_home.dart';
import 'package:flutter_relearn/screens/navigation/navigation_home.dart';
import 'package:flutter_relearn/screens/animations/animations_home.dart';
import 'package:flutter_relearn/screens/i18n/i18n_home.dart';
import 'package:flutter_relearn/screens/beyond_ui/beyond_ui_home.dart';
import 'package:flutter_relearn/screens/networking/networking_home.dart';
import 'package:flutter_relearn/screens/serialization/json_serialization_home.dart';

class AdaptiveHome extends StatelessWidget {
  const AdaptiveHome({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = [
      _Topic(
        title: 'MediaQuery',
        description: 'Screen size, orientation, text scale',
        icon: Icons.phone_android,
        color: Colors.indigo,
        screen: const MediaQueryScreen(),
      ),
      _Topic(
        title: 'LayoutBuilder',
        description: 'Build based on parent constraints',
        icon: Icons.view_quilt,
        color: Colors.teal,
        screen: const LayoutBuilderScreen(),
      ),
      _Topic(
        title: 'SafeArea',
        description: 'Avoid system UI intrusions',
        icon: Icons.safety_check,
        color: Colors.orange,
        screen: const SafeAreaScreen(),
      ),
      _Topic(
        title: 'Flexible & Expanded',
        description: 'Flex-based sizing',
        icon: Icons.swap_horiz,
        color: Colors.purple,
        screen: const FlexibleExpandedScreen(),
      ),
      _Topic(
        title: 'Adaptive Scaffold',
        description: 'Multi-pane layout for large screens',
        icon: Icons.view_sidebar,
        color: Colors.blue,
        screen: const AdaptiveScaffoldScreen(),
      ),
      _Topic(
        title: 'Platform Adaptations',
        description: 'Controls, scrolling, haptics, text fields, nav bars',
        icon: Icons.devices,
        color: Colors.green,
        screen: const PlatformAdaptationsHome(),
      ),
      _Topic(
        title: 'Nested Theme',
        description: 'How context finds the nearest Theme',
        icon: Icons.palette,
        color: Colors.deepPurple,
        screen: const NestedThemeScreen(),
      ),
      _Topic(
        title: 'Best Practices',
        description: 'Adaptive design guidelines from Flutter docs',
        icon: Icons.checklist,
        color: Colors.green,
        screen: const BestPracticesScreen(),
      ),
      _Topic(
        title: 'User Input & Accessibility',
        description: 'Semantics, focus, gestures',
        icon: Icons.accessibility_new,
        color: Colors.indigo,
        screen: const AccessibilityHome(),
      ),
      _Topic(
        title: 'Accessibility',
        description: 'Introduction, UI design, assistive tech, testing, web',
        icon: Icons.hearing,
        color: Colors.deepPurple,
        screen: const AccessibilityDocsHome(),
      ),
      _Topic(
        title: 'Design & Theming',
        description: 'Themes, Material 3, fonts, typography, shaders',
        icon: Icons.palette_outlined,
        color: Colors.pink,
        screen: const DesignThemingHome(),
      ),
      _Topic(
        title: 'Adding Interactivity',
        description: 'Stateful widgets, state management, interactive components',
        icon: Icons.touch_app,
        color: Colors.deepOrange,
        screen: const InteractivityHome(),
      ),
      _Topic(
        title: 'Assets & Images',
        description: 'Declare, load, and display images and text assets',
        icon: Icons.photo_library,
        color: Colors.teal,
        screen: const AssetsImagesHome(),
      ),
      _Topic(
        title: 'Navigation & Routing',
        description: 'Tabs, push/pop, send & return data, drawer, sheets',
        icon: Icons.route,
        color: Colors.indigo,
        screen: const NavigationHome(),
      ),
      _Topic(
        title: 'Animations & Transitions',
        description: 'AnimatedContainer, Opacity, Switcher, Hero, page routes',
        icon: Icons.animation,
        color: Colors.deepOrange,
        screen: const AnimationsHome(),
      ),
      _Topic(
        title: 'Internationalizing Flutter Apps',
        description: 'i18n, ARB files, AppLocalizations, RTL, plurals',
        icon: Icons.language,
        color: Colors.teal,
        screen: const I18nHome(),
      ),
      _Topic(
        title: 'Beyond the UI',
        description: 'State management with ChangeNotifier & Provider',
        icon: Icons.share_outlined,
        color: Colors.deepPurple,
        screen: const BeyondUiHome(),
      ),
      _Topic(
        title: 'Networking & HTTP',
        description: 'Fetch, POST, PUT, PATCH, DELETE, WebSockets',
        icon: Icons.wifi,
        color: Colors.indigo,
        screen: const NetworkingHome(),
      ),
      _Topic(
        title: 'JSON Serialization',
        description: 'Manual dart:convert, json_serializable, nested classes & more',
        icon: Icons.data_object,
        color: Colors.deepPurple,
        screen: const JsonSerializationHome(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adaptive & Responsive Design'),
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
