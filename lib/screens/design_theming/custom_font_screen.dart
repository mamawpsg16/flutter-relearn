import 'package:flutter/material.dart';

class CustomFontScreen extends StatefulWidget {
  const CustomFontScreen({super.key});

  @override
  State<CustomFontScreen> createState() => _CustomFontScreenState();
}

class _CustomFontScreenState extends State<CustomFontScreen> {
  bool _useCustomFont = false;

  @override
  Widget build(BuildContext context) {
    const sampleText =
        'The quick brown fox jumps over the lazy dog. 0123456789';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Use a Custom Font'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Flutter lets you bundle any .ttf or .otf font inside your app. '
            'You declare it in pubspec.yaml and then reference it by family name '
            'in a TextStyle or as the global font in ThemeData.',
          ),
          const SizedBox(height: 16),

          // Step 1
          const _CodeSection(
            label: 'Step 1 — declare the font in pubspec.yaml',
            labelColor: Colors.blue,
            code: '''
flutter:
  fonts:
    - family: RobotoMono
      fonts:
        - asset: assets/fonts/RobotoMono-Regular.ttf
        - asset: assets/fonts/RobotoMono-Bold.ttf
          weight: 700''',
          ),
          const SizedBox(height: 12),

          // Step 2
          const _CodeSection(
            label: 'Step 2a — use it in a single TextStyle',
            labelColor: Colors.green,
            code: '''
Text(
  'Hello',
  style: TextStyle(fontFamily: 'RobotoMono'),
)''',
          ),
          const SizedBox(height: 12),

          const _CodeSection(
            label: 'Step 2b — apply it globally via ThemeData',
            labelColor: Colors.green,
            code: '''
ThemeData(
  fontFamily: 'RobotoMono',
)''',
          ),
          const SizedBox(height: 16),

          // Toggle demo
          Row(
            children: [
              const Text('Apply custom font family:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 12),
              Switch(
                value: _useCustomFont,
                onChanged: (v) => setState(() => _useCustomFont = v),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Live text comparison
          _FontBox(
            label: 'Default system font',
            text: sampleText,
            style: const TextStyle(fontSize: 16),
            active: !_useCustomFont,
          ),
          const SizedBox(height: 12),
          _FontBox(
            label: 'monospace font family',
            text: sampleText,
            style: const TextStyle(fontSize: 16, fontFamily: 'monospace'),
            active: _useCustomFont,
          ),
          const SizedBox(height: 16),

          // Font weights
          const Text('Font weights (using system font):',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final w in [
            FontWeight.w100,
            FontWeight.w300,
            FontWeight.w400,
            FontWeight.w500,
            FontWeight.w700,
            FontWeight.w900,
          ])
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                'FontWeight.${w.toString().split('.').last} — The quick fox',
                style: TextStyle(fontSize: 15, fontWeight: w),
              ),
            ),
          const SizedBox(height: 16),

          const _TipCard(
            tip: 'Always place font files under assets/fonts/ and add that '
                'directory to pubspec.yaml. The family name is case-sensitive '
                'and must match exactly between pubspec and your TextStyle.',
          ),
        ],
      ),
    );
  }
}

class _FontBox extends StatelessWidget {
  final String label;
  final String text;
  final TextStyle style;
  final bool active;

  const _FontBox({
    required this.label,
    required this.text,
    required this.style,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor =
        active ? Theme.of(context).colorScheme.primary : Colors.grey.shade300;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: active ? 2 : 1),
        borderRadius: BorderRadius.circular(8),
        color: active
            ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  color: active
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(text, style: style),
        ],
      ),
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
                  color: labelColor, fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          Text(code,
              style: const TextStyle(
                  color: Colors.white, fontFamily: 'monospace', fontSize: 13)),
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
