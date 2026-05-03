import 'dart:convert';
import 'package:flutter/material.dart';

// Demo model — no packages needed, just dart:convert
class _User {
  final int id;
  final String name;
  final String email;

  const _User({required this.id, required this.name, required this.email});

  factory _User.fromJson(Map<String, dynamic> json) => _User(
        id: json['id'] as int,
        name: json['name'] as String,
        email: json['email'] as String,
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'email': email};
}

const _sampleJson = '''
{
  "id": 1,
  "name": "Alice",
  "email": "alice@example.com"
}
''';

class ManualSerializationScreen extends StatefulWidget {
  const ManualSerializationScreen({super.key});

  @override
  State<ManualSerializationScreen> createState() =>
      _ManualSerializationScreenState();
}

class _ManualSerializationScreenState
    extends State<ManualSerializationScreen> {
  _User? _parsed;
  String? _encoded;
  bool _showDecode = true;

  void _runDecode() {
    final map = jsonDecode(_sampleJson) as Map<String, dynamic>;
    setState(() {
      _parsed = _User.fromJson(map);
      _encoded = null;
    });
  }

  void _runEncode() {
    const user = _User(id: 42, name: 'Bob', email: 'bob@example.com');
    setState(() {
      _encoded = const JsonEncoder.withIndent('  ').convert(user.toJson());
      _parsed = null;
    });
  }

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
            'dart:convert is Flutter\'s built-in JSON library — no packages needed. '
            'jsonDecode() turns a JSON string into a Dart Map, '
            'and jsonEncode() turns a Map back into a JSON string.',
          ),
          const SizedBox(height: 16),

          // ── Sub-section: Serializing JSON inline ─────────────────────
          _SectionHeader(
            icon: Icons.bolt,
            color: Colors.orange,
            title: 'Serializing JSON inline',
          ),
          const SizedBox(height: 8),
          const Text(
            'Inline serialization reads values directly from the decoded Map '
            'without creating a dedicated class. Fast to write, but brittle — '
            'a typo in a key name crashes at runtime, not compile time.',
          ),
          const SizedBox(height: 12),
          const _CodeSection(
            label: 'BAD — inline access scattered through the UI',
            labelColor: Colors.red,
            code: '''
// Repeated jsonDecode calls spread across widgets
final data = jsonDecode(response.body);
Text(data['naem']);   // typo → null at runtime, no warning
Text(data['emial']); // typo → null at runtime, no warning''',
          ),
          const SizedBox(height: 12),
          const _CodeSection(
            label: 'OK — inline decode at a single point',
            labelColor: Colors.orange,
            code: '''
import 'dart:convert';

final Map<String, dynamic> user = jsonDecode(responseBody);
final String name  = user['name']  as String;
final String email = user['email'] as String;
// Better than scattered access, but still no type checking on keys''',
          ),
          const SizedBox(height: 20),

          // ── Sub-section: Serializing JSON inside model classes ────────
          _SectionHeader(
            icon: Icons.class_,
            color: Colors.teal,
            title: 'Serializing JSON inside model classes',
          ),
          const SizedBox(height: 8),
          const Text(
            'The recommended pattern: create a model class with a fromJson() factory '
            'and a toJson() method. All JSON logic lives in one place, '
            'and the rest of your app works with typed Dart objects.',
          ),
          const SizedBox(height: 12),
          const _CodeSection(
            label: 'GOOD — model class with fromJson / toJson',
            labelColor: Colors.green,
            code: '''
import 'dart:convert';

class User {
  final int id;
  final String name;
  final String email;

  const User({required this.id, required this.name, required this.email});

  // Decode: JSON string → User object
  factory User.fromJson(Map<String, dynamic> json) => User(
    id:    json['id']    as int,
    name:  json['name']  as String,
    email: json['email'] as String,
  );

  // Encode: User object → Map (jsonEncode will turn it to string)
  Map<String, dynamic> toJson() => {
    'id':    id,
    'name':  name,
    'email': email,
  };
}

// Usage
final user = User.fromJson(jsonDecode(responseBody));
final json = jsonEncode(user.toJson()); // back to string''',
          ),
          const SizedBox(height: 16),

          // Live demo
          const Text('Live demo — try decode and encode:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Toggle
                  SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment(
                          value: true,
                          label: Text('Decode'),
                          icon: Icon(Icons.download)),
                      ButtonSegment(
                          value: false,
                          label: Text('Encode'),
                          icon: Icon(Icons.upload)),
                    ],
                    selected: {_showDecode},
                    onSelectionChanged: (v) =>
                        setState(() => _showDecode = v.first),
                  ),
                  const SizedBox(height: 12),

                  if (_showDecode) ...[
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _sampleJson.trim(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'monospace',
                            fontSize: 11),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: _runDecode,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Run User.fromJson()'),
                    ),
                    if (_parsed != null) ...[
                      const SizedBox(height: 10),
                      _ResultBox(lines: [
                        'id:    ${_parsed!.id}',
                        'name:  ${_parsed!.name}',
                        'email: ${_parsed!.email}',
                      ]),
                    ],
                  ] else ...[
                    const Text(
                      'Input: User(id: 42, name: "Bob", email: "bob@example.com")',
                      style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: _runEncode,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Run user.toJson()'),
                    ),
                    if (_encoded != null) ...[
                      const SizedBox(height: 10),
                      _ResultBox(lines: _encoded!.split('\n')),
                    ],
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          const _TipCard(
            tip: 'Always put fromJson/toJson inside the model class, not inline in widgets. '
                'When the API changes a field name, you fix it in one place.',
          ),
        ],
      ),
    );
  }
}

class _ResultBox extends StatelessWidget {
  final List<String> lines;
  const _ResultBox({required this.lines});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        border: Border.all(color: Colors.green.shade200),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final l in lines)
            Text(l,
                style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: Colors.green.shade800)),
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
