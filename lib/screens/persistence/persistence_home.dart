import 'package:flutter/material.dart';
import 'shared_preferences_screen.dart';
import 'read_write_files_screen.dart';
import 'sqlite_screen.dart';
import 'firebase_auth_screen.dart';

class PersistenceHome extends StatelessWidget {
  const PersistenceHome({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = [
      _Topic(
        title: 'Store Key-Value Data on Disk',
        description: 'shared_preferences — save, read, remove, clear',
        icon: Icons.storage,
        color: Colors.indigo,
        screen: const SharedPreferencesScreen(),
      ),
      _Topic(
        title: 'Read & Write Files',
        description:
            'path_provider + dart:io — write, read, append, delete files',
        icon: Icons.file_copy_outlined,
        color: Colors.teal,
        screen: const ReadWriteFilesScreen(),
      ),
      _Topic(
        title: 'Persist Data with SQLite',
        description:
            'sqflite CRUD — insert, query, update, delete + offline sync',
        icon: Icons.table_chart_outlined,
        color: Colors.deepOrange,
        screen: const SqliteScreen(),
      ),
      _Topic(
        title: 'Firebase Authentication',
        description:
            'Firebase Authentication — sign up, sign in, sign out, auth state',
        icon: Icons.lock_outline,
        color: Colors.amber.shade700,
        screen: const FirebaseAuthScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Persistence'),
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
