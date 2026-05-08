import 'package:flutter/material.dart';
import 'dart:convert';

const jsonData = '''
{
  "id": 123,
  "name": "Alice",
  "email": "iKb3T@example.com"
}''';

final decodedJson = jsonDecode(jsonData) as Map<String, dynamic>;

class WhichMethodScreen extends StatelessWidget {
  const WhichMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Which JSON Serialization Method is Right for Me?'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Two main approaches: manually write toJson()/fromJson() methods, '
            'or use code generation with json_serializable. Choose based on '
            'project size, team size, and how often your models change.',
          ),
          const SizedBox(height: 16),

          // Decision table
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(1.2),
                1: FlexColumnWidth(1.5),
                2: FlexColumnWidth(1.5),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey.shade100),
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Criteria',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Manual (dart:convert)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Code Generation',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Project size',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Small / 1–2 models'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Medium to large'),
                    ),
                  ],
                ),
                const TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Boilerplate',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('You write every line'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Auto-generated, minimal effort'),
                    ),
                  ],
                ),
                const TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Maintenance',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Error-prone, hard to debug'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Reliable, consistent'),
                    ),
                  ],
                ),
                const TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Build time',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('None (runtime only)'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Adds build step (build_runner)'),
                    ),
                  ],
                ),
                const TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Flexibility',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Full control over serialization'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Limited; annotations control behavior'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: Colors.orange.shade50,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Try it: Parse the JSON above',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 4, 4, 4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${decodedJson["name"]}\'s JSON Data',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 255, 253, 253),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Recommendation card
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '💡 Quick Recommendation',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• 1–2 models, learning Flutter → Manual\n'
                    '• Production app, 5+ models, team → json_serializable\n'
                    '• Rapid prototyping → Manual first, migrate later\n'
                    '• Complex nested structures → Code gen (less error-prone)',
                    style: TextStyle(fontSize: 13, height: 1.6),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Real-world examples
          const _CodeSection(
            label: 'Example: User profile model (3 fields)',
            labelColor: Colors.orange,
            code: '''
// Manual: 15 lines, you write every line
class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as int,
    name: json['name'] as String,
    email: json['email'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
  };
}

// Code generation: 5 lines + auto-generated code
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';  // ← build_runner creates this

@JsonSerializable()
class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  // These are generated automatically ↓
  factory User.fromJson(Map<String, dynamic> json) {
    // build_runner generates the implementation
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    // build_runner generates the implementation
    return {'id': id, 'name': name, 'email': email};
  }
}

// Command: flutter pub run build_runner build''',
          ),
          const SizedBox(height: 16),

          const _TipCard(
            tip:
                'Start manual for small projects to understand how '
                'serialization works, then switch to code generation '
                'when you hit 5+ models or nested structures.',
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
