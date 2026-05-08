import 'package:flutter/material.dart';
import '../../ models/user.dart';
import '../../ models/address.dart';
import '../../ models/profile.dart';
import '../../ models/post.dart';
import 'dart:convert';

// Single user — full nested API response matching User model
const singleUserJson = '''
{
  "name": "John Doe",
  "email": "john@example.com",
  "address": {
    "street": "123 Main St",
    "city": "Springfield"
  },
  "profile": {
    "bio": "Flutter developer from Springfield",
    "avatar": "https://example.com/avatar.png"
  },
  "posts": [
    {"id": 1, "title": "First post"},
    {"id": 2, "title": "Second post"},
    {"id": 3, "title": "Third post"}
  ]
}
''';

final singleUserData = jsonDecode(singleUserJson) as Map<String, dynamic>;
User user = User.fromJson(singleUserData);
// Multiple users — array of nested objects
const usersJson = '''
[
  {
    "name": "John Doe",
    "email": "john@example.com",
    "address": {"street": "123 Main St", "city": "Springfield"},
    "profile": {"bio": "Flutter dev", "avatar": "https://example.com/john.png"},
    "posts": [{"id": 1, "title": "Johns first post"}]
  },
  {
    "name": "Alice Smith",
    "email": "alice@example.com",
    "address": {"street": "456 Oak Ave", "city": "Shelbyville"},
    "profile": {"bio": "Dart enthusiast", "avatar": "https://example.com/alice.png"},
    "posts": [{"id": 2, "title": "Alice on nested JSON"}]
  }
]
''';
final multipleUserData = jsonDecode(usersJson) as List<dynamic>;
List<User> users = multipleUserData.map((json) => User.fromJson(json)).toList();

class NestedObjectsScreen extends StatelessWidget {
  const NestedObjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inside build() method temporarily
    return Scaffold(
      appBar: AppBar(
        title: const Text('Handling Nested Objects'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Real API responses often have nested objects and lists. '
            'Serialize them by creating model classes for each level.',
          ),
          const SizedBox(height: 16),

          const _CodeSection(
            label: 'Example API response (nested objects + lists)',
            labelColor: Colors.blue,
            code: '''{
  "id": 1,
  "name": "John",
  "profile": {
    "bio": "Flutter dev",
    "avatar": "https://..."
  },
  "posts": [
    {"id": 1, "title": "First post"},
    {"id": 2, "title": "Second post"}
  ]
}''',
          ),
          const SizedBox(height: 12),

          const _CodeSection(
            label: 'Create model classes for each level',
            labelColor: Colors.green,
            code: '''
class Profile {
  final String bio;
  final String avatar;

  const Profile({required this.bio, required this.avatar});

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    bio: json['bio'] as String,
    avatar: json['avatar'] as String,
  );

  Map<String, dynamic> toJson() => {'bio': bio, 'avatar': avatar};
}

class Post {
  final int id;
  final String title;

  const Post({required this.id, required this.title});

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json['id'] as int,
    title: json['title'] as String,
  );

  Map<String, dynamic> toJson() => {'id': id, 'title': title};
}

class User {
  final int id;
  final String name;
  final Profile profile;        // Nested object
  final List<Post> posts;       // List of objects

  const User({
    required this.id,
    required this.name,
    required this.profile,
    required this.posts,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as int,
    name: json['name'] as String,
    profile: Profile.fromJson(json['profile'] as Map<String, dynamic>),
    posts: (json['posts'] as List<dynamic>)
      .map((item) => Post.fromJson(item as Map<String, dynamic>))
      .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'profile': profile.toJson(),
    'posts': posts.map((p) => p.toJson()).toList(),
  };
}''',
          ),
          const SizedBox(height: 12),

          const _CodeSection(
            label: 'With json_serializable (@JsonSerializable)',
            labelColor: Colors.orange,
            code: '''
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String name;
  final Profile profile;        // Automatically nested
  final List<Post> posts;       // Automatically mapped

  User({
    required this.id,
    required this.name,
    required this.profile,
    required this.posts,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      profile: Profile.fromJson(json['profile']),
      posts: List<Post>.from(
        (json['posts'] as List<dynamic>)
          .map((p) => Post.fromJson(p))
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'profile': profile.toJson(),
    'posts': posts.map((p) => p.toJson()).toList(),
  };
}

// Same for Profile and Post classes
@JsonSerializable()
class Profile { /* ... */ }

@JsonSerializable()
class Post { /* ... */ }''',
          ),
          const SizedBox(height: 16),

          // Common mistake
          Card(
            color: Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '❌ Forgetting to map list items',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'posts: json[\'posts\']  // Wrong — still a List<dynamic>',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 11),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'posts: (json[\'posts\'] as List).map((p) => Post.fromJson(p)).toList()  // Right',
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

          // Single nested object demo
          Card(
            color: Colors.indigo.shade50,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Single user — nested address + profile + posts',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    // TODO: parse singleUserJson, display user name, address, profile bio, post titles
                    child: Text(
                      'ID: ${user.id}, Name: ${user.name}, Email: ${user.email}\n'
                      'Address: ${user.address?.street}, ${user.address?.city}\n'
                      'Profile: ${user.profile.bio}, Avatar: ${user.profile.avatar}\n'
                      'Posts:\n'
                      '${user.posts.map((p) => '- ${p.title}').join('\n')}',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Multiple objects demo
          Card(
            color: Colors.purple.shade50,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Multiple users — array of nested objects',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    // TODO: parse usersJson array, map to List<User>, display each user name
                    child: Text(
                      users
                          .map(
                            (user) =>
                                'ID: ${user.id}\n'
                                'Name: ${user.name}\n'
                                'Email: ${user.email}\n'
                                'Address: ${user.address?.street}, ${user.address?.city}\n'
                                'Profile: ${user.profile.bio}, Avatar: ${user.profile.avatar}\n'
                                'Posts:\n'
                                '${user.posts.map((p) => '- ${p.title}').join('\n')}\n'
                                '===============================',
                          )
                          .join('\n'),
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          const _TipCard(
            tip:
                'Nested serialization works the same as flat: each '
                'class has fromJson/toJson. Build from inside out—parse '
                'Profile first, then use it in User.fromJson().',
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
