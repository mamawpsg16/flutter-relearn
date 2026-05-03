import 'package:flutter/material.dart';

class CodeGenerationScreen extends StatelessWidget {
  const CodeGenerationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Serializing JSON via Code Generation'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'json_serializable generates fromJson/toJson code for you at build time. '
            'You annotate your class, run build_runner once, and the boilerplate '
            'is written automatically — and stays in sync whenever your model changes.',
          ),
          const SizedBox(height: 16),

          // ── Sub-section 1: Setting up json_serializable ───────────────
          _SectionHeader(
            icon: Icons.settings,
            color: Colors.indigo,
            title: 'Setting up json_serializable in a project',
          ),
          const SizedBox(height: 8),
          const Text(
            'Add three packages to pubspec.yaml: '
            'json_annotation (runtime annotations), '
            'json_serializable and build_runner (dev-only — only used during development).',
          ),
          const SizedBox(height: 12),
          const _CodeSection(
            label: 'pubspec.yaml — add these entries',
            labelColor: Colors.indigo,
            code: '''
dependencies:
  json_annotation: ^4.9.0   # @JsonSerializable annotation

dev_dependencies:
  build_runner: ^2.4.0       # runs the code generator
  json_serializable: ^6.8.0  # the generator itself''',
          ),
          const SizedBox(height: 8),
          const _CodeSection(
            label: 'Install the packages',
            labelColor: Colors.grey,
            code: 'flutter pub get',
          ),
          const SizedBox(height: 20),

          // ── Sub-section 2: Creating model classes ─────────────────────
          _SectionHeader(
            icon: Icons.class_,
            color: Colors.teal,
            title: 'Creating model classes the json_serializable way',
          ),
          const SizedBox(height: 8),
          const Text(
            'Add the @JsonSerializable() annotation and a part directive. '
            'Write fromJson and toJson as one-liners — the implementation '
            'is generated into the .g.dart file.',
          ),
          const SizedBox(height: 12),
          const _CodeSection(
            label: 'user.dart — the class you write',
            labelColor: Colors.teal,
            code: '''
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart'; // ← points to the generated file

@JsonSerializable()
class User {
  final int id;
  final String name;
  final String email;

  const User({required this.id, required this.name, required this.email});

  // These two lines are all the serialization code you write
  factory User.fromJson(Map<String, dynamic> json) => _\$UserFromJson(json);
  Map<String, dynamic> toJson() => _\$UserToJson(this);
}''',
          ),
          const SizedBox(height: 12),
          const _CodeSection(
            label: 'user.g.dart — what gets generated (do not edit manually)',
            labelColor: Colors.grey,
            code: '''
// GENERATED CODE - DO NOT MODIFY BY HAND

User _\$UserFromJson(Map<String, dynamic> json) => User(
  id:    (json['id']    as num).toInt(),
  name:  json['name']  as String,
  email: json['email'] as String,
);

Map<String, dynamic> _\$UserToJson(User instance) => <String, dynamic>{
  'id':    instance.id,
  'name':  instance.name,
  'email': instance.email,
};''',
          ),
          const SizedBox(height: 20),

          // ── Sub-section 3: Running the code generation utility ─────────
          _SectionHeader(
            icon: Icons.terminal,
            color: Colors.orange,
            title: 'Running the code generation utility',
          ),
          const SizedBox(height: 8),
          const Text(
            'Run build_runner from the terminal. '
            'Use build for a one-time generation, or watch to automatically '
            'regenerate every time you save a model file.',
          ),
          const SizedBox(height: 12),
          const _CodeSection(
            label: 'One-time build',
            labelColor: Colors.orange,
            code: 'dart run build_runner build',
          ),
          const SizedBox(height: 8),
          const _CodeSection(
            label: 'Watch mode — auto-regenerates on save',
            labelColor: Colors.orange,
            code: 'dart run build_runner watch',
          ),
          const SizedBox(height: 8),
          const _CodeSection(
            label: 'If generated files conflict, delete old ones first',
            labelColor: Colors.red,
            code: 'dart run build_runner build --delete-conflicting-outputs',
          ),
          const SizedBox(height: 8),
          Card(
            color: Colors.orange.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('After running build_runner you will see:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  SizedBox(height: 6),
                  Text('✓  lib/models/user.g.dart',
                      style: TextStyle(fontFamily: 'monospace', fontSize: 12)),
                  SizedBox(height: 4),
                  Text(
                    'Commit .g.dart files to source control — '
                    'your teammates do not need to run build_runner to build the app.',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── Sub-section 4: Consuming json_serializable models ──────────
          _SectionHeader(
            icon: Icons.play_circle,
            color: Colors.green,
            title: 'Consuming json_serializable models',
          ),
          const SizedBox(height: 8),
          const Text(
            'Once generated, using the model is identical to the manual approach — '
            'call fromJson() to decode and toJson() to encode. '
            'The rest of your app does not need to know how serialization works.',
          ),
          const SizedBox(height: 12),
          const _CodeSection(
            label: 'Decoding an HTTP response into a User',
            labelColor: Colors.green,
            code: '''
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<User> fetchUser(int id) async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/users/\$id'),
  );

  if (response.statusCode == 200) {
    // fromJson works exactly like the manual version
    return User.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }
  throw Exception('Failed to load user');
}''',
          ),
          const SizedBox(height: 12),
          const _CodeSection(
            label: 'Encoding a User to send in a POST body',
            labelColor: Colors.green,
            code: '''
final user = User(id: 0, name: 'Alice', email: 'alice@example.com');

final response = await http.post(
  Uri.parse('https://api.example.com/users'),
  headers: {'Content-Type': 'application/json; charset=UTF-8'},
  body: jsonEncode(user.toJson()), // same as manual
);''',
          ),
          const SizedBox(height: 16),

          const _TipCard(
            tip: 'Use @JsonKey(name: \'snake_case_key\') on a field to map a '
                'JSON key that differs from your Dart field name — '
                'e.g. @JsonKey(name: \'first_name\') final String firstName.',
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  const _SectionHeader(
      {required this.icon, required this.color, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, color: color, size: 20),
      const SizedBox(width: 8),
      Expanded(
        child: Text(title,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 15, color: color)),
      ),
    ]);
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
                  color: labelColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12)),
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
            Expanded(
                child: Text(tip, style: const TextStyle(fontSize: 13))),
          ],
        ),
      ),
    );
  }
}
