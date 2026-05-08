import 'package:flutter/material.dart';
import 'dart:convert';
import '../../ models/user_dto.dart';
import '../../ models/user_display.dart';

// Simulated API response
const _apiResponse = '''
{
  "name": "john doe",
  "email": "john@example.com",
  "address": {
    "street": "123 Main St",
    "city": "Springfield"
  },
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

class BestPracticesScreen extends StatelessWidget {
  const BestPracticesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Best Practices & Real-world Patterns'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Production-ready patterns for error handling, validation, '
            'and integrating serialization with real APIs.',
          ),
          const SizedBox(height: 16),

          const _Section(
            title: '1. Always validate before serializing',
            content: '''
Assume the API returned unexpected data. Use try-catch and validation:

factory User.fromJson(Map<String, dynamic> json) {
  try {
    final id = json['id'] as int?;
    final name = json['name'] as String?;

    if (id == null || name == null) {
      throw FormatException('Missing required fields');
    }

    return User(id: id, name: name);
  } catch (e) {
    throw FormatException('Invalid user JSON: \$e');
  }
}''',
          ),
          const SizedBox(height: 12),

          const _Section(
            title: '2. Use nullable fields for optional data',
            content: '''
Not every API field is guaranteed. Use ? for optional:

class User {
  final int id;
  final String name;
  final String? bio;  // May be null from API

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as int,
    name: json['name'] as String,
    bio: json['bio'] as String?,  // Safely null if missing
  );
}''',
          ),
          const SizedBox(height: 12),

          const _Section(
            title: '3. Handle API errors gracefully',
            content: '''
Don't assume statusCode 200 means valid JSON:

Future<User> fetchUser(int id) async {
  final response = await http.get(Uri.parse('https://api.example.com/users/\$id'));

  if (response.statusCode == 200) {
    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return User.fromJson(json);
    } catch (e) {
      throw Exception('Malformed user data: \$e');
    }
  } else if (response.statusCode == 404) {
    throw Exception('User not found');
  } else {
    throw Exception('Server error: \${response.statusCode}');
  }
}''',
          ),
          const SizedBox(height: 12),

          const _Section(
            title: '4. Cache parsed models to avoid re-parsing',
            content: '''
Once parsed, store the model—don't decode JSON repeatedly:

class UserRepository {
  final http.Client _client;
  User? _cachedUser;

  Future<User> getUser(int id) async {
    if (_cachedUser != null && _cachedUser!.id == id) {
      return _cachedUser!;  // Return cached
    }

    final user = await _fetchUser(id);
    _cachedUser = user;  // Cache for next call
    return user;
  }
}''',
          ),
          const SizedBox(height: 12),

          const _Section(
            title: '5. Use equatable for testing & state comparison',
            content: '''
With json_serializable, implement == for comparing parsed objects:

@JsonSerializable()
class User {
  final int id;
  final String name;

  User({required this.id, required this.name});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  factory User.fromJson(Map<String, dynamic> json) => /* ... */;
  Map<String, dynamic> toJson() => /* ... */;
}

// Now you can test: expect(user1, equals(user2))''',
          ),
          const SizedBox(height: 12),

          const _Section(
            title: '6. Separate data layer from UI layer',
            content: '''
Don't pass raw JSON models to UI. Create domain models:

// data_layer/models/user_dto.dart (from API)
@JsonSerializable()
class UserDTO {
  final int id;
  final String name;
  factory UserDTO.fromJson(...) => /* ... */;
}

// domain_layer/models/user.dart (for UI)
class User {
  final int id;
  final String displayName;  // Derived from API name

  User.fromDTO(UserDTO dto)
    : id = dto.id,
      displayName = dto.name.toUpperCase();
}''',
          ),
          const SizedBox(height: 16),

          // Decision table
          const Text(
            'Choose your approach:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(1.2),
                1: FlexColumnWidth(1.4),
                2: FlexColumnWidth(1.4),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey.shade100),
                  children: const [
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Text('Scenario',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Text('Manual',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Text('Code Gen',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
                const TableRow(children: [
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Learning Flutter')),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Start here')),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Later')),
                ]),
                const TableRow(children: [
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('1–3 models')),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Reasonable')),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Overkill')),
                ]),
                const TableRow(children: [
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('5+ models')),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Too slow')),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Recommended')),
                ]),
                const TableRow(children: [
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Complex validation')),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Full control')),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Limited')),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Card(
            color: Colors.lime.shade50,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Live Demo: DTO → Domain model pattern',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'API sends raw JSON → parse to UserDTO → transform to UserDisplay for UI',
                    style: TextStyle(fontSize: 11, color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  Builder(
                    builder: (context) {
                      // Step 1: Parse API JSON → DTO (data layer)
                      final dto = UserDTO.fromJson(
                        jsonDecode(_apiResponse) as Map<String, dynamic>,
                      );

                      // Step 2: Transform DTO → UI model (domain layer)
                      final user = UserDisplay.fromDTO(dto);

                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'DTO raw name: "${dto.name}"\n'
                          'Display name: "${user.displayName}"\n\n'
                          'Location: ${user.location}\n'
                          'Bio: ${user.bio}\n'
                          'Posts (${user.postCount}):\n'
                          '${user.postTitles.map((t) => '  - $t').join('\n')}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          const _TipCard(
            tip: 'Production rule: start with code generation, use manual '
                'only when you need custom validation logic that the generator '
                'can\'t handle.',
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String content;
  const _Section({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade900, borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 8),
          Text(content,
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
      color: Colors.teal.shade50,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lightbulb, color: Colors.teal, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(tip, style: const TextStyle(fontSize: 13))),
          ],
        ),
      ),
    );
  }
}
