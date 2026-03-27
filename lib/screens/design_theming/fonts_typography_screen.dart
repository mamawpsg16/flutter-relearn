import 'package:flutter/material.dart';

class FontsTypographyScreen extends StatefulWidget {
  const FontsTypographyScreen({super.key});

  @override
  State<FontsTypographyScreen> createState() => _FontsTypographyScreenState();
}

class _FontsTypographyScreenState extends State<FontsTypographyScreen> {
  bool _useCustomTypography = false;

  // A custom typography scale to compare with the default
  static final _customTypography = Typography.material2021().copyWith(
    black: Typography.material2021().black.copyWith(
      displayLarge: const TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.w300,
        letterSpacing: -0.25,
      ),
      headlineMedium: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: const TextStyle(fontSize: 18, height: 1.6),
      labelSmall: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fonts & Typography'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'TextTheme defines a scale of 15 named text styles. '
            'Every Material widget uses these roles internally. '
            'You customise the whole app\'s typography in one place via ThemeData.',
          ),
          const SizedBox(height: 16),

          const _CodeSection(
            label: 'Apply a custom TextTheme in ThemeData',
            labelColor: Colors.green,
            code: '''
ThemeData(
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w300),
    headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
    bodyLarge: TextStyle(fontSize: 18, height: 1.6),
  ),
)''',
          ),
          const SizedBox(height: 16),

          const _CodeSection(
            label: 'Read a text role anywhere in the tree',
            labelColor: Colors.blue,
            code: '''
Text(
  'Hello',
  style: Theme.of(context).textTheme.headlineMedium,
)''',
          ),
          const SizedBox(height: 16),

          // Toggle custom typography
          Row(
            children: [
              const Text(
                'Custom typography:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 12),
              Switch(
                value: _useCustomTypography,
                onChanged: (v) => setState(() => _useCustomTypography = v),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Render all 15 TextTheme roles
          Theme(
            data: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
              typography: _useCustomTypography
                  ? _customTypography
                  : Typography.material2021(),
              useMaterial3: true,
            ),
            child: Builder(
              builder: (ctx) {
                final t = Theme.of(ctx).textTheme;
                final rolesList = [
                  ('displayLarge', t.displayLarge),
                  ('displayMedium', t.displayMedium),
                  ('displaySmall', t.displaySmall),
                  ('headlineLarge', t.headlineLarge),
                  ('headlineMedium', t.headlineMedium),
                  ('headlineSmall', t.headlineSmall),
                  ('titleLarge', t.titleLarge),
                  ('titleMedium', t.titleMedium),
                  ('titleSmall', t.titleSmall),
                  ('bodyLarge', t.bodyLarge),
                  ('bodyMedium', t.bodyMedium),
                  ('bodySmall', t.bodySmall),
                  ('labelLarge', t.labelLarge),
                  ('labelMedium', t.labelMedium),
                  ('labelSmall', t.labelSmall),
                ];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: rolesList.map((r) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          SizedBox(
                            width: 150,
                            child: Text(
                              r.$1,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text('The quick brown fox', style: r.$2),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          const _TipCard(
            tip:
                'Use TextTheme roles by name (headlineMedium, bodyLarge) '
                'rather than hardcoded sizes. This makes your app respect the '
                'user\'s system font scale and is easy to restyle globally.',
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
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            code,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'monospace',
              fontSize: 13,
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
            Expanded(child: Text(tip)),
          ],
        ),
      ),
    );
  }
}
