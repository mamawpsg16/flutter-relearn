import 'package:flutter/material.dart';

class WhichMethodScreen extends StatelessWidget {
  const WhichMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Which Method Is Right for Me?'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Flutter offers two ways to handle JSON: writing the conversion code yourself '
            '(manual), or letting a tool generate it for you (code generation). '
            'The right pick depends on project size and how often your models change.',
          ),
          const SizedBox(height: 16),

          // Comparison table
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey.shade100),
                  children: const [
                    _Cell('', bold: true),
                    _Cell('Manual', bold: true, color: Colors.orange),
                    _Cell('Code Gen', bold: true, color: Colors.purple),
                  ],
                ),
                const TableRow(children: [
                  _Cell('Setup'),
                  _Cell('None'),
                  _Cell('pubspec + build_runner'),
                ]),
                const TableRow(children: [
                  _Cell('Typo safety'),
                  _Cell('Runtime crash'),
                  _Cell('Compile-time error'),
                ]),
                const TableRow(children: [
                  _Cell('Boilerplate'),
                  _Cell('You write it'),
                  _Cell('Auto-generated'),
                ]),
                const TableRow(children: [
                  _Cell('Best for'),
                  _Cell('Small / prototypes'),
                  _Cell('Medium–large apps'),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Sub-section: Manual for smaller projects ──────────────────
          _SectionHeader(
            icon: Icons.handyman,
            color: Colors.orange,
            title: 'Use manual serialization for smaller projects',
          ),
          const SizedBox(height: 8),
          const Text(
            'If your app has only a few model classes that rarely change, '
            'manual serialization with dart:convert is the fastest approach — '
            'no tooling, no extra packages, no build step.',
          ),
          const SizedBox(height: 12),
          const _CodeSection(
            label: 'Manual — quick and zero setup',
            labelColor: Colors.orange,
            code: '''
import 'dart:convert';

// Decode once, use anywhere — fine for 1–3 simple models
final Map<String, dynamic> user = jsonDecode(responseBody);
print(user['name']); // works, but no type safety''',
          ),
          const SizedBox(height: 8),
          _ProConCard(
            color: Colors.orange,
            pros: const ['No setup', 'No build step', 'Easy to understand'],
            cons: const [
              'Typos cause runtime crashes',
              'Gets messy with many models',
              'No autocomplete on fields',
            ],
          ),
          const SizedBox(height: 20),

          // ── Sub-section: Code gen for larger projects ─────────────────
          _SectionHeader(
            icon: Icons.auto_awesome,
            color: Colors.purple,
            title: 'Use code generation for medium to large projects',
          ),
          const SizedBox(height: 8),
          const Text(
            'When your app has many models, nested objects, or a team of developers, '
            'json_serializable generates all the fromJson/toJson boilerplate for you. '
            'Rename a field and the generated code updates — no manual edits to forget.',
          ),
          const SizedBox(height: 12),
          const _CodeSection(
            label: 'Code gen — annotate once, generate forever',
            labelColor: Colors.purple,
            code: '''
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart'; // the generated file

@JsonSerializable()
class User {
  final String name;
  final String email;
  User({required this.name, required this.email});

  // These two lines are all you write — the rest is generated
  factory User.fromJson(Map<String, dynamic> json) => _\$UserFromJson(json);
  Map<String, dynamic> toJson() => _\$UserToJson(this);
}''',
          ),
          const SizedBox(height: 8),
          _ProConCard(
            color: Colors.purple,
            pros: const [
              'Type-safe — typos caught at compile time',
              'Scales to dozens of models',
              'Handles nested objects cleanly',
            ],
            cons: const [
              'Requires build_runner setup',
              'Must re-run generator after changes',
            ],
          ),
          const SizedBox(height: 16),

          const _TipCard(
            tip: 'Start with manual serialization to prototype fast. '
                'Migrate to json_serializable when models multiply — '
                'the fromJson/toJson interface stays the same, only the implementation changes.',
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

class _ProConCard extends StatelessWidget {
  final Color color;
  final List<String> pros;
  final List<String> cons;
  const _ProConCard(
      {required this.color, required this.pros, required this.cons});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pros',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green)),
                  const SizedBox(height: 4),
                  for (final p in pros)
                    Text('+ $p',
                        style: const TextStyle(fontSize: 12, color: Colors.green)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Cons',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red)),
                  const SizedBox(height: 4),
                  for (final c in cons)
                    Text('− $c',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
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
