import 'package:flutter/material.dart';
import '../../ models/user.dart';
import 'dart:convert';

final sampleJson = '''
{
  "name": "John Doe",
  "email": "john.doe@example.com",
  "profile": {
    "bio": "Flutter developer",
    "avatar": "https://example.com/john.png"
  },
  "posts": [
    {"id": 1, "title": "First post"},
    {"id": 2, "title": "Second post"}
  ]
}
''';

final userData = jsonDecode(sampleJson) as Map<String, dynamic>;
final user = User.fromJson(userData); // User object created from JSON
final userJsonString = jsonEncode(user.toJson());

class ManualSerializationScreen extends StatelessWidget {
  const ManualSerializationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Serializing JSON Manually'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Manually serialize JSON by writing toJson() and fromJson() '
            'methods using dart:convert. Complete control, but more boilerplate.',
          ),
          const SizedBox(height: 16),

          const _CodeSection(
            label: 'Step 1: Create model class with fields',
            labelColor: Colors.blue,
            code: '''
class User {
  final int id;
  final String name;
  final String email;

  const User({
    required this.id,
    required this.name,
    required this.email,
  });
}''',
          ),
          const SizedBox(height: 12),

          const _CodeSection(
            label: 'Step 2: Add fromJson factory (parse JSON → Dart object)',
            labelColor: Colors.green,
            code: '''
factory User.fromJson(Map<String, dynamic> json) => User(
  id: json['id'] as int,
  name: json['name'] as String,
  email: json['email'] as String,
);''',
          ),
          const SizedBox(height: 12),

          const _CodeSection(
            label: 'Step 3: Add toJson method (Dart object → JSON)',
            labelColor: Colors.orange,
            code: '''
Map<String, dynamic> toJson() => {
  'id': id,
  'name': name,
  'email': email,
};''',
          ),
          const SizedBox(height: 12),

          const _CodeSection(
            label: 'Step 4: Use with jsonDecode / jsonEncode',
            labelColor: Colors.purple,
            code: '''
import 'dart:convert';

// Parse JSON string → User object
final json = jsonDecode(responseBody) as Map<String, dynamic>;
final user = User.fromJson(json);

// Serialize User → JSON string
final jsonString = jsonEncode(user.toJson());''',
          ),
          const SizedBox(height: 16),

          // Common mistakes
          const Text(
            'Common Mistakes',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),

          Card(
            color: Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '❌ Forgetting type cast (as int, as String)',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'json[\'id\']  // Wrong — type is dynamic, crashes later',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 11),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'json[\'id\'] as int  // Right — explicit cast, safe',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          Card(
            color: Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '❌ Missing null-safety checks',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'json[\'email\']  // Crashes if key missing',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 11),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'json[\'email\'] ?? \'unknown\'  // Right — fallback value',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          Card(
            color: Colors.teal.shade50,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Try it: Parse JSON manually',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 15, 15, 15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Json to Dart object: $user\n Dart object to JSON: $userJsonString',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 255, 253, 253),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Real-world example
          const _CodeSection(
            label: 'Real-world: Fetch user from API',
            labelColor: Colors.teal,
            code: '''
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<User> fetchUser(int id) async {
  final response = await http.get(
    Uri.parse('https://api.example.com/users/\$id'),
  );

  if (response.statusCode == 200) {
    // Parse JSON and convert to User object
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return User.fromJson(json);
  } else {
    throw Exception('Failed to load user');
  }
}

// Usage
final user = await fetchUser(1);
print(user.name);  // "John Doe"''',
          ),
          const SizedBox(height: 16),

          const _TipCard(
            tip:
                'Always use "as Type" when pulling from JSON maps. '
                'JSON values are dynamic — explicit casts prevent runtime crashes '
                'and make the code self-documenting.',
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
  const _CodeSection({
    required this.label,
    required this.labelColor,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: labelColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            code,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'monospace',
              fontSize: 11,
            ),
          ),
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
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lightbulb, color: Colors.blue, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(tip, style: const TextStyle(fontSize: 13))),
          ],
        ),
      ),
    );
  }
}
