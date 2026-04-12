import 'package:flutter/material.dart';
import 'package:flutter_relearn/screens/i18n/i18n_setup_screen.dart';
import 'package:flutter_relearn/screens/i18n/i18n_demo_screen.dart';

class I18nHome extends StatelessWidget {
  const I18nHome({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = [
      _Topic(
        title: 'Introduction & Setup',
        description: 'ARB files, l10n.yaml, AppLocalizations, pubspec setup',
        icon: Icons.settings_outlined,
        color: Colors.indigo,
        screen: const I18nSetupScreen(),
      ),
      _Topic(
        title: 'Live Language Switcher',
        description: 'EN / FR / AR (RTL) / JA — switch locale and see UI change',
        icon: Icons.language,
        color: Colors.teal,
        screen: const I18nDemoScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Internationalizing Flutter Apps'),
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
