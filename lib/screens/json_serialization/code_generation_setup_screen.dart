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

class CodeGenerationSetupScreen extends StatelessWidget {
  const CodeGenerationSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Code Generation with json_serializable'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Use json_serializable to auto-generate toJson()/fromJson() code. '
            'Less boilerplate, fewer bugs, scales well. Requires build_runner.',
          ),
          const SizedBox(height: 16),

          const _CodeSection(
            label: 'Step 1: Add dependencies to pubspec.yaml',
            labelColor: Colors.blue,
            code: '''
dependencies:
  json_annotation: ^4.8.0

dev_dependencies:
  build_runner: ^2.4.0
  json_serializable: ^6.7.0''',
          ),
          const SizedBox(height: 12),

          const _CodeSection(
            label: 'Step 2: Annotate model with @JsonSerializable()',
            labelColor: Colors.green,
            code: '''
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';  // Tells Dart generator where to put code

@JsonSerializable()
class User {
  final int id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  // Generated code — build_runner creates the implementation
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email};
  }
}''',
          ),
          const SizedBox(height: 12),

          const _CodeSection(
            label: 'Step 3: Run build_runner to generate code',
            labelColor: Colors.orange,
            code: '''
flutter pub run build_runner build

# Output: user.g.dart is created automatically
# It contains generated helper functions (UserFromJson, UserToJson)

# For watch mode (rebuild on file changes):
flutter pub run build_runner watch''',
          ),
          const SizedBox(height: 12),

          const _CodeSection(
            label: 'Step 4: Use like manual serialization',
            labelColor: Colors.purple,
            code: '''
import 'dart:convert';

final json = jsonDecode(responseBody) as Map<String, dynamic>;
final user = User.fromJson(json);  // Generated code handles parsing

final jsonString = jsonEncode(user.toJson());  // Generated code''',
          ),
          const SizedBox(height: 16),

          // Key differences
          const Text(
            'What build_runner generates for you:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),

          Card(
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '✓ Type casting (as int, as String)',
                    style: TextStyle(color: Colors.green),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '✓ Null-safety checks',
                    style: TextStyle(color: Colors.green),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '✓ fromJson factory implementation',
                    style: TextStyle(color: Colors.green),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '✓ toJson method body',
                    style: TextStyle(color: Colors.green),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '✓ Support for @JsonKey annotations',
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Common annotations
          const _CodeSection(
            label: 'Common @JsonKey annotations',
            labelColor: Colors.teal,
            code: '''
@JsonSerializable()
class User {
  final int id;

  // Rename JSON key
  @JsonKey(name: 'full_name')
  final String name;

  // Default if missing in JSON
  @JsonKey(defaultValue: 'unknown@example.com')
  final String email;

  // Ignore this field in serialization
  @JsonKey(ignore: true)
  final String? tempData;

  User({required this.id, required this.name, required this.email});

  // Generated code — build_runner creates the implementation
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email};
  }
}''',
          ),
          const SizedBox(height: 16),

          Card(
            color: Colors.amber.shade50,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Try it: Use json_serializable setup',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '$user\n$userJsonString',
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
                'Use json_serializable in production. It\'s the Flutter '
                'standard, tested extensively, and catches errors at build time '
                'instead of runtime.',
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
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lightbulb, color: Colors.green, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(tip, style: const TextStyle(fontSize: 13))),
          ],
        ),
      ),
    );
  }
}
