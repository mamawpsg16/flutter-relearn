import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Model for the post we'll create
class Post {
  final int? id;
  final String title;
  final String body;
  final int userId;

  const Post({
    this.id,
    required this.title,
    required this.body,
    required this.userId,
  });

  // toJson — converts Post to Map for the request body
  Map<String, dynamic> toJson() => {
        'title': title,
        'body': body,
        'userId': userId,
      };

  // fromJson — parses the server response
  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json['id'] as int?,
        title: json['title'] as String,
        body: json['body'] as String,
        userId: json['userId'] as int,
      );
}

// POST request — sends JSON body to the server
Future<Post> createPost(Post post) async {
  final response = await http.post(
    Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    // Tell server we're sending JSON
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    // Encode the Post object to a JSON string
    body: jsonEncode(post.toJson()),
  );

  if (response.statusCode == 201) {
    // 201 Created — parse the response body into a Post
    return Post.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to create post (${response.statusCode})');
  }
}

class SendDataScreen extends StatefulWidget {
  const SendDataScreen({super.key});

  @override
  State<SendDataScreen> createState() => _SendDataScreenState();
}

class _SendDataScreenState extends State<SendDataScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  Future<Post>? _futurePost;

  void _submitPost() {
    if (_titleController.text.isEmpty || _bodyController.text.isEmpty) return;

    setState(() {
      _futurePost = createPost(Post(
        title: _titleController.text,
        body: _bodyController.text,
        userId: 1,
      ));
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Data to the Internet'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Use http.post() to send data to a server. '
            'Encode your Dart object to JSON with jsonEncode() '
            'and set the Content-Type header so the server knows the format.',
          ),
          const SizedBox(height: 16),

          const _CodeSection(
            label: 'http.post() — send JSON to the server',
            labelColor: Colors.orange,
            code: '''
Future<Post> createPost(Post post) async {
  final response = await http.post(
    Uri.parse('https://api.example.com/posts'),
    headers: {
      // Tell server the body is JSON
      'Content-Type': 'application/json; charset=UTF-8',
    },
    // jsonEncode converts Map to JSON string
    body: jsonEncode({
      'title': post.title,
      'body': post.body,
      'userId': post.userId,
    }),
  );

  if (response.statusCode == 201) {
    // 201 Created — server made the resource
    return Post.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create post');
  }
}''',
          ),
          const SizedBox(height: 12),

          const _CodeSection(
            label: 'toJson() — converts your model to a Map',
            labelColor: Colors.blue,
            code: '''
class Post {
  final String title;
  final String body;
  final int userId;

  // toJson — used when sending to server
  Map<String, dynamic> toJson() => {
    'title': title,
    'body': body,
    'userId': userId,
  };

  // fromJson — used when receiving from server
  factory Post.fromJson(Map<String, dynamic> json) => Post(
    title: json['title'] as String,
    body: json['body'] as String,
    userId: json['userId'] as int,
  );
}''',
          ),
          const SizedBox(height: 16),

          // Live demo
          const Text('Live demo — fill in the form and POST to the server:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _bodyController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Body',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _submitPost,
                    icon: const Icon(Icons.send),
                    label: const Text('POST to server'),
                  ),
                  const SizedBox(height: 12),
                  if (_futurePost != null)
                    FutureBuilder<Post>(
                      future: _futurePost,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final post = snapshot.data!;
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('✓ Created successfully!',
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Text('id: ${post.id}',
                                    style: const TextStyle(
                                        fontFamily: 'monospace', fontSize: 12)),
                                Text('title: "${post.title}"',
                                    style: const TextStyle(
                                        fontFamily: 'monospace', fontSize: 12)),
                                Text('userId: ${post.userId}',
                                    style: const TextStyle(
                                        fontFamily: 'monospace', fontSize: 12)),
                              ],
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}',
                              style: const TextStyle(color: Colors.red));
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          const _TipCard(
            tip: 'Always set Content-Type: application/json when sending JSON. '
                'Without it, the server may not parse the body correctly. '
                'A 201 status means the resource was created successfully.',
          ),
        ],
      ),
    );
  }
}

class _CodeSection extends StatelessWidget {
  final String label;
  final Color labelColor;
  final String code;
  const _CodeSection(
      {required this.label, required this.labelColor, required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.grey.shade900, borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  color: labelColor, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 8),
          Text(code,
              style: const TextStyle(
                  color: Colors.white, fontFamily: 'monospace', fontSize: 11)),
        ],
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final String tip;
  const _TipCard({required this.tip});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple.shade50,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lightbulb, color: Colors.purple, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(tip, style: const TextStyle(fontSize: 13))),
          ],
        ),
      ),
    );
  }
}
