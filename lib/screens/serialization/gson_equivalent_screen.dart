import 'package:flutter/material.dart';

class GsonEquivalentScreen extends StatelessWidget {
  const GsonEquivalentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GSON / Jackson / Moshi Equivalent?'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Java/Kotlin developers are used to reflection-based libraries like GSON, Jackson, '
            'and Moshi that automatically map JSON to objects at runtime. '
            'Dart does not support runtime reflection, so Flutter uses a different approach.',
          ),
          const SizedBox(height: 16),

          // Why no reflection
          Card(
            color: Colors.amber.shade50,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, color: Colors.amber, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Why no runtime reflection?',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text(
                          'Flutter uses tree-shaking to remove unused code and reduce app size. '
                          'Runtime reflection would require keeping all class metadata alive, '
                          'defeating tree-shaking. So Dart uses code generation instead.',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Comparison table
          const Text('Library comparison:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(3),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey.shade100),
                  children: const [
                    _Cell('Java/Kotlin', bold: true),
                    _Cell('Flutter/Dart', bold: true),
                    _Cell('Key difference', bold: true),
                  ],
                ),
                const TableRow(children: [
                  _Cell('GSON', color: Colors.indigo),
                  _Cell('json_serializable', color: Colors.teal),
                  _Cell('GSON uses reflection; json_serializable generates code at build time'),
                ]),
                const TableRow(children: [
                  _Cell('Jackson', color: Colors.indigo),
                  _Cell('json_serializable', color: Colors.teal),
                  _Cell('Jackson annotations → Dart @JsonSerializable annotation'),
                ]),
                const TableRow(children: [
                  _Cell('Moshi', color: Colors.indigo),
                  _Cell('json_serializable', color: Colors.teal),
                  _Cell('Moshi codegen ≈ json_serializable + build_runner'),
                ]),
                const TableRow(children: [
                  _Cell('Manual Map', color: Colors.indigo),
                  _Cell('dart:convert', color: Colors.teal),
                  _Cell('Both parse to a raw map — no annotation required'),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 16),

          const _CodeSection(
            label: 'Java — GSON (runtime reflection)',
            labelColor: Colors.indigo,
            code: '''
// Java / Kotlin — works at runtime via reflection
Gson gson = new Gson();
User user = gson.fromJson(jsonString, User.class);
// No setup beyond the dependency — magic at runtime''',
          ),
          const SizedBox(height: 12),

          const _CodeSection(
            label: 'Dart — json_serializable (build-time code gen)',
            labelColor: Colors.teal,
            code: '''
// Dart — annotation + generated code (no runtime magic)
@JsonSerializable()
class User {
  final String name;
  final int age;
  User({required this.name, required this.age});

  factory User.fromJson(Map<String, dynamic> json) => _\$UserFromJson(json);
  Map<String, dynamic> toJson() => _\$UserToJson(this);
}

// Usage — identical feel to GSON
final user = User.fromJson(jsonDecode(jsonString));''',
          ),
          const SizedBox(height: 16),

          const _CodeSection(
            label: 'Dart — dart:convert (no annotation, manual)',
            labelColor: Colors.orange,
            code: '''
// Closest to plain Java Map parsing — built-in, no packages
import 'dart:convert';

final Map<String, dynamic> map = jsonDecode(jsonString);
final name = map['name'] as String;
final age  = map['age']  as int;''',
          ),
          const SizedBox(height: 16),

          const _TipCard(
            tip: 'Think of dart:convert as Dart\'s built-in JSON parser (like Java\'s org.json), '
                'and json_serializable as the GSON/Moshi equivalent — '
                'just powered by build-time generation instead of runtime reflection.',
          ),
        ],
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  final String text;
  final bool bold;
  final Color? color;
  const _Cell(this.text, {this.bold = false, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(text,
          style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: color,
              fontSize: 12)),
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
