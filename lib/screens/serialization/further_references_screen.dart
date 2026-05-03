import 'package:flutter/material.dart';

class FurtherReferencesScreen extends StatelessWidget {
  const FurtherReferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Further References'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Key packages and docs for JSON serialization in Flutter and Dart. '
            'These cover everything from basic decoding to full model generation '
            'and immutable data classes.',
          ),
          const SizedBox(height: 16),

          const _SectionLabel('Core — built into Dart'),
          const SizedBox(height: 8),
          const _RefCard(
            icon: Icons.code,
            color: Colors.indigo,
            title: 'dart:convert',
            subtitle: 'Built-in library',
            description:
                'jsonDecode() and jsonEncode() — the foundation of all JSON work in Dart. '
                'No package needed.',
            badge: 'Built-in',
            badgeColor: Colors.indigo,
          ),
          const SizedBox(height: 20),

          const _SectionLabel('Code generation'),
          const SizedBox(height: 8),
          _RefCard(
            icon: Icons.auto_awesome,
            color: Colors.teal,
            title: 'json_serializable',
            subtitle: 'pub.dev/packages/json_serializable',
            description:
                'The official Flutter/Dart code generation solution. '
                'Annotate with @JsonSerializable(), run build_runner, '
                'and fromJson/toJson are generated for you.',
            badge: 'Recommended',
            badgeColor: Colors.teal,
            extras: const [
              'Handles nullable fields',
              'Custom key names via @JsonKey',
              'Supports nested objects with explicitToJson',
            ],
          ),
          const SizedBox(height: 12),
          _RefCard(
            icon: Icons.construction,
            color: Colors.orange,
            title: 'build_runner',
            subtitle: 'pub.dev/packages/build_runner',
            description:
                'The code generation runner used by json_serializable, freezed, '
                'and other generators. Add as a dev dependency.',
            badge: 'Dev dependency',
            badgeColor: Colors.orange,
            extras: const [
              'dart run build_runner build',
              'dart run build_runner watch',
            ],
          ),
          const SizedBox(height: 20),

          const _SectionLabel('Advanced — immutable models'),
          const SizedBox(height: 8),
          _RefCard(
            icon: Icons.ac_unit,
            color: Colors.blue,
            title: 'freezed',
            subtitle: 'pub.dev/packages/freezed',
            description:
                'Builds on json_serializable to add immutable data classes, '
                'union types (sealed classes), copyWith(), and pattern matching. '
                'The go-to choice for complex state models.',
            badge: 'Popular',
            badgeColor: Colors.blue,
            extras: const [
              '@freezed annotation',
              'Generates copyWith, ==, hashCode',
              'Union / sealed class support',
            ],
          ),
          const SizedBox(height: 12),
          _RefCard(
            icon: Icons.build,
            color: Colors.blueGrey,
            title: 'built_value',
            subtitle: 'pub.dev/packages/built_value',
            description:
                'An alternative to freezed for immutable value types and '
                'serialization. More verbose but widely used in large codebases.',
            badge: 'Alternative',
            badgeColor: Colors.blueGrey,
          ),
          const SizedBox(height: 20),

          const _SectionLabel('Official documentation'),
          const SizedBox(height: 8),
          const _DocLink(
            icon: Icons.menu_book,
            color: Colors.green,
            title: 'JSON and serialization — flutter.dev',
            url: 'https://docs.flutter.dev/data-and-backend/serialization/json',
          ),
          const SizedBox(height: 8),
          const _DocLink(
            icon: Icons.menu_book,
            color: Colors.green,
            title: 'dart:convert library — api.dart.dev',
            url: 'https://api.dart.dev/stable/dart-convert/dart-convert-library.html',
          ),
          const SizedBox(height: 16),

          const _TipCard(
            tip: 'For most Flutter apps: use dart:convert for simple models, '
                'json_serializable for production models, '
                'and freezed when you also want immutability and union types.',
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Colors.black54));
  }
}

class _RefCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String description;
  final String badge;
  final Color badgeColor;
  final List<String> extras;

  const _RefCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.badge,
    required this.badgeColor,
    this.extras = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              CircleAvatar(
                  radius: 18,
                  backgroundColor: color,
                  child: Icon(icon, color: Colors.white, size: 18)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(subtitle,
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade600)),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: badgeColor.withValues(alpha: 0.4)),
                ),
                child: Text(badge,
                    style: TextStyle(
                        fontSize: 11,
                        color: badgeColor,
                        fontWeight: FontWeight.bold)),
              ),
            ]),
            const SizedBox(height: 8),
            Text(description, style: const TextStyle(fontSize: 13)),
            if (extras.isNotEmpty) ...[
              const SizedBox(height: 8),
              for (final e in extras)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text('• $e',
                      style: const TextStyle(
                          fontSize: 12, fontFamily: 'monospace')),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DocLink extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String url;
  const _DocLink(
      {required this.icon,
      required this.color,
      required this.title,
      required this.url});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontSize: 13)),
        subtitle: Text(url,
            style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
                fontFamily: 'monospace')),
        trailing: const Icon(Icons.open_in_new, size: 16),
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
