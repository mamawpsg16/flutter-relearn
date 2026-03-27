import 'package:flutter/material.dart';
import 'package:flutter_relearn/screens/design_theming/share_styles_screen.dart';
import 'package:flutter_relearn/screens/design_theming/material_design_screen.dart';
import 'package:flutter_relearn/screens/design_theming/migrate_material3_screen.dart';
import 'package:flutter_relearn/screens/design_theming/fonts_typography_screen.dart';
import 'package:flutter_relearn/screens/design_theming/custom_font_screen.dart';
import 'package:flutter_relearn/screens/design_theming/export_fonts_screen.dart';
import 'package:flutter_relearn/screens/design_theming/google_fonts_screen.dart';
import 'package:flutter_relearn/screens/design_theming/fragment_shaders_screen.dart';

class DesignThemingHome extends StatelessWidget {
  const DesignThemingHome({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = [
      _Topic(
        title: 'Share Styles with Themes',
        description: 'ThemeData, Theme.of(context), and nested overrides',
        icon: Icons.palette,
        color: Colors.indigo,
        screen: const ShareStylesScreen(),
      ),
      _Topic(
        title: 'Material Design',
        description: 'ColorScheme, elevation, and Material widgets',
        icon: Icons.layers,
        color: Colors.blue,
        screen: const MaterialDesignScreen(),
      ),
      _Topic(
        title: 'Migrate to Material 3',
        description: 'useMaterial3 flag, new color roles, updated components',
        icon: Icons.upgrade,
        color: Colors.teal,
        screen: const MigrateMaterial3Screen(),
      ),
      _Topic(
        title: 'Fonts & Typography',
        description: 'TextTheme roles, TextStyle, and theme typography',
        icon: Icons.text_fields,
        color: Colors.orange,
        screen: const FontsTypographyScreen(),
      ),
      _Topic(
        title: 'Use a Custom Font',
        description: 'Bundle a font via pubspec.yaml and apply it',
        icon: Icons.font_download,
        color: Colors.purple,
        screen: const CustomFontScreen(),
      ),
      _Topic(
        title: 'Export Fonts from a Package',
        description: 'Load fonts declared inside a pub package',
        icon: Icons.inventory_2,
        color: Colors.brown,
        screen: const ExportFontsScreen(),
      ),
      _Topic(
        title: 'Google Fonts Package',
        description: 'Use google_fonts to apply web fonts at runtime',
        icon: Icons.public,
        color: Colors.red,
        screen: const GoogleFontsScreen(),
      ),
      _Topic(
        title: 'Custom Fragment Shaders',
        description: 'Write GLSL shaders and apply them as Flutter paint',
        icon: Icons.auto_awesome,
        color: Colors.deepPurple,
        screen: const FragmentShadersScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Design & Theming'),
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
