import 'package:flutter/material.dart';

class I18nSetupScreen extends StatelessWidget {
  const I18nSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Introduction & Setup'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Internationalizing (i18n) your Flutter app means extracting all '
              'user-visible text into translation files so the app can display '
              'the right language based on the device locale. Flutter uses '
              '.arb files (Application Resource Bundle) and generates a typed '
              'AppLocalizations class from them.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 20),

            _CodeSection(
              label: 'BAD — hardcoded strings, impossible to translate',
              labelColor: Colors.red,
              code: '''Text('Add to Cart')          // English only, forever
Text('Welcome to our store') // Can\'t be translated''',
            ),
            const SizedBox(height: 12),
            _CodeSection(
              label: 'GOOD — text comes from AppLocalizations',
              labelColor: Colors.green,
              code: '''// Once set up, use the generated class anywhere:
final l = AppLocalizations.of(context)!;

Text(l.addToCart)       // "Add to Cart" / "Ajouter au panier" / "カートに追加"
Text(l.welcomeMessage)  // switches with device locale automatically''',
            ),
            const SizedBox(height: 24),

            const Text('Step-by-Step Setup',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // Step 1
            _StepCard(
              step: '1',
              title: 'Add dependencies to pubspec.yaml',
              child: _CodeSection(
                label: 'pubspec.yaml',
                labelColor: Colors.blue,
                code: '''dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:   # ← add this
    sdk: flutter
  intl: any                # ← add this

flutter:
  generate: true           # ← add this''',
              ),
            ),
            const SizedBox(height: 12),

            // Step 2
            _StepCard(
              step: '2',
              title: 'Create l10n.yaml at the project root',
              child: _CodeSection(
                label: 'l10n.yaml',
                labelColor: Colors.blue,
                code: '''arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart''',
              ),
            ),
            const SizedBox(height: 12),

            // Step 3
            _StepCard(
              step: '3',
              title: 'Create .arb translation files',
              child: Column(
                children: [
                  _CodeSection(
                    label: 'lib/l10n/app_en.arb  (template)',
                    labelColor: Colors.blue,
                    code: '''{
  "@@locale": "en",

  "addToCart": "Add to Cart",
  "@addToCart": { "description": "Button label" },

  "greeting": "Hello, {name}!",
  "@greeting": {
    "placeholders": {
      "name": { "type": "String" }
    }
  },

  "itemCount": "{count,plural,=0{No items}=1{1 item}other{{count} items}}",
  "@itemCount": {
    "placeholders": {
      "count": { "type": "int" }
    }
  }
}''',
                  ),
                  const SizedBox(height: 8),
                  _CodeSection(
                    label: 'lib/l10n/app_fr.arb  (French)',
                    labelColor: Colors.blue,
                    code: '''{
  "@@locale": "fr",
  "addToCart": "Ajouter au panier",
  "greeting": "Bonjour, {name} !",
  "itemCount": "{count,plural,=0{Aucun article}=1{1 article}other{{count} articles}}"
}''',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Step 4
            _StepCard(
              step: '4',
              title: 'Wire into MaterialApp',
              child: _CodeSection(
                label: 'main.dart',
                labelColor: Colors.blue,
                code: '''import 'package:flutter_gen/gen_l10n/app_localizations.dart';

MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: const MyHomePage(),
)''',
              ),
            ),
            const SizedBox(height: 12),

            // Step 5
            _StepCard(
              step: '5',
              title: 'Run code generation, then use it',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CodeSection(
                    label: 'Terminal',
                    labelColor: Colors.blue,
                    code: 'flutter pub get   # triggers code generation',
                  ),
                  const SizedBox(height: 8),
                  _CodeSection(
                    label: 'Any widget',
                    labelColor: Colors.green,
                    code: '''final l = AppLocalizations.of(context)!;

Text(l.addToCart)          // simple string
Text(l.greeting("Alice"))  // with parameter → "Hello, Alice!"
Text(l.itemCount(3))       // plural       → "3 items"''',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text('File Structure After Setup',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '''my_app/
├── l10n.yaml
├── lib/
│   ├── l10n/
│   │   ├── app_en.arb   ← English (template)
│   │   ├── app_fr.arb   ← French
│   │   ├── app_ar.arb   ← Arabic
│   │   └── app_ja.arb   ← Japanese
│   └── main.dart
└── pubspec.yaml''',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'monospace',
                  fontSize: 12,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 24),

            _TipCard(
              tip: 'The template ARB file (app_en.arb) is the source of truth — '
                  'it must contain every key plus @metadata. Other language files '
                  'only need the translated strings. Flutter warns you when a '
                  'translation is missing.',
            ),
          ],
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final String step;
  final String title;
  final Widget child;

  const _StepCard({
    required this.step,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 13,
                  backgroundColor: Colors.indigo,
                  child: Text(step,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
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
      padding: const EdgeInsets.all(12),
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
                  color: Colors.white,
                  fontFamily: 'monospace',
                  fontSize: 12,
                  height: 1.5)),
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
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lightbulb, color: Colors.purple),
            const SizedBox(width: 8),
            Expanded(child: Text(tip, style: const TextStyle(height: 1.5))),
          ],
        ),
      ),
    );
  }
}
