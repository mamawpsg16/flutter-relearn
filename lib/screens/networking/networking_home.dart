import 'package:flutter/material.dart';
import 'package:flutter_relearn/screens/networking/fetch_data_screen.dart';
import 'package:flutter_relearn/screens/networking/authenticated_requests_screen.dart';
import 'package:flutter_relearn/screens/networking/send_data_screen.dart';
import 'package:flutter_relearn/screens/networking/update_data_screen.dart';
import 'package:flutter_relearn/screens/networking/delete_data_screen.dart';
import 'package:flutter_relearn/screens/networking/websockets_screen.dart';

class NetworkingHome extends StatelessWidget {
  const NetworkingHome({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = [
      _Topic(
        title: 'Fetch Data from the Internet',
        description: 'http.get(), Future, convert JSON to Dart object',
        icon: Icons.download,
        color: Colors.indigo,
        screen: const FetchDataScreen(),
      ),
      _Topic(
        title: 'Make Authenticated Requests',
        description: 'Add Authorization headers to HTTP requests',
        icon: Icons.lock,
        color: Colors.teal,
        screen: const AuthenticatedRequestsScreen(),
      ),
      _Topic(
        title: 'Send Data to the Internet',
        description: 'http.post() with JSON body',
        icon: Icons.upload,
        color: Colors.orange,
        screen: const SendDataScreen(),
      ),
      _Topic(
        title: 'Update Data over the Internet',
        description: 'http.put() and http.patch() for updates',
        icon: Icons.edit,
        color: Colors.purple,
        screen: const UpdateDataScreen(),
      ),
      _Topic(
        title: 'Delete Data on the Internet',
        description: 'http.delete() to remove resources',
        icon: Icons.delete,
        color: Colors.red,
        screen: const DeleteDataScreen(),
      ),
      _Topic(
        title: 'Communicate with WebSockets',
        description: 'Real-time two-way communication with WebSockets',
        icon: Icons.swap_horiz,
        color: Colors.green,
        screen: const WebSocketsScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Networking & HTTP'),
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
