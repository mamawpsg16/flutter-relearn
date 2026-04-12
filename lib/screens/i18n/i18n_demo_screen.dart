import 'package:flutter/material.dart';
import 'package:flutter_relearn/l10n/app_localizations.dart';

class I18nDemoScreen extends StatefulWidget {
  const I18nDemoScreen({super.key});

  @override
  State<I18nDemoScreen> createState() => _I18nDemoScreenState();
}

class _I18nDemoScreenState extends State<I18nDemoScreen> {
  int _cartCount = 0;

  // These are the locales we support — matches your .arb files
  static const _locales = [
    (code: 'en',  flag: '🇺🇸', name: 'English'),
    (code: 'fil', flag: '🇵🇭', name: 'Filipino'),
    (code: 'fr',  flag: '🇫🇷', name: 'Français'),
    (code: 'ar',  flag: '🇸🇦', name: 'العربية'),
    (code: 'ja',  flag: '🇯🇵', name: '日本語'),
  ];

  Locale _selectedLocale = const Locale('en');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Language Switcher'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This demo uses the real AppLocalizations — the same class Flutter '
              'uses in production. Localizations.override() wraps the preview card '
              'so only that section changes locale, not the whole app.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 20),

            _CodeSection(
              label: 'REAL usage — zero hardcoded translations in your widget',
              labelColor: Colors.green,
              code: '''final l = AppLocalizations.of(context)!;

Text(l.addToCart)         // "Add to Cart" / "Idagdag sa Cart" / ...
Text(l.welcomeMessage)    // switches automatically with device locale
Text(l.itemCount(3))      // "3 items" / "3 na aytem" / "3 articles"''',
            ),
            const SizedBox(height: 24),

            // ── Language Selector ───────────────────────────────────
            const Text('Select Language:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _locales.map((loc) {
                final selected = _selectedLocale.languageCode == loc.code;
                return ChoiceChip(
                  label: Text('${loc.flag}  ${loc.name}'),
                  selected: selected,
                  selectedColor: Colors.indigo.shade100,
                  onSelected: (_) => setState(() {
                    _selectedLocale = Locale(loc.code);
                    _cartCount = 0;
                  }),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // ── Live UI Preview ─────────────────────────────────────
            // Localizations.override wraps ONLY this section with a
            // different locale — the rest of the app is untouched.
            const Text('Live App Preview:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              'Using Localizations.override(locale: $_selectedLocale)',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 10),

            Localizations.override(
              context: context,
              locale: _selectedLocale,
              child: Builder(
                builder: (localizedCtx) {
                  // l is now scoped to _selectedLocale — the REAL deal
                  final l = AppLocalizations.of(localizedCtx)!;
                  final isRtl = _selectedLocale.languageCode == 'ar';

                  return Directionality(
                    textDirection:
                        isRtl ? TextDirection.rtl : TextDirection.ltr,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _buildPreviewCard(
                        key: ValueKey(_selectedLocale.languageCode),
                        l: l,
                        isRtl: isRtl,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // ── Plural demo ─────────────────────────────────────────
            const Text('Plural Forms:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _CodeSection(
              label: 'app_en.arb — ICU plural syntax',
              labelColor: Colors.blue,
              code: '''"itemCount": "{count,plural,=0{No items}=1{1 item}other{{count} items}}"

// app_fil.arb
"itemCount": "{count,plural,=0{Walang aytem}=1{1 aytem}other{{count} na aytem}}"

// Flutter picks the right plural rule per language automatically''',
            ),
            const SizedBox(height: 12),

            Localizations.override(
              context: context,
              locale: _selectedLocale,
              child: Builder(
                builder: (localizedCtx) {
                  final l = AppLocalizations.of(localizedCtx)!;
                  final isRtl = _selectedLocale.languageCode == 'ar';
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Text('Items in cart:  '),
                              Expanded(
                                child: Slider(
                                  value: _cartCount.toDouble(),
                                  min: 0,
                                  max: 10,
                                  divisions: 10,
                                  label: '$_cartCount',
                                  onChanged: (v) => setState(
                                      () => _cartCount = v.round()),
                                ),
                              ),
                              SizedBox(
                                width: 24,
                                child: Text('$_cartCount',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const Divider(),
                          Directionality(
                            textDirection: isRtl
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.shopping_cart,
                                    color: Colors.indigo),
                                const SizedBox(width: 8),
                                // ← real AppLocalizations plural call
                                Text(
                                  l.itemCount(_cartCount),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigo),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'AppLocalizations.of(ctx).itemCount($_cartCount)',
                            style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                                fontFamily: 'monospace'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            _TipCard(
              tip: 'In a real app you never touch the widget when adding a language. '
                  'You just add a new .arb file, run flutter gen-l10n, and '
                  'AppLocalizations handles the rest. The widget code stays identical.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewCard({
    required Key key,
    required AppLocalizations l,
    required bool isRtl,
  }) {
    return Card(
      key: key,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header — uses real l.welcomeMessage and l.greeting
            Text(
              l.welcomeMessage,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              l.greeting('Alice'),
              style: TextStyle(
                  color: Colors.grey.shade600, fontSize: 13),
            ),
            const Divider(height: 20),

            // Product row
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.headphones,
                      color: Colors.indigo, size: 32),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Wireless Headphones',
                          style:
                              TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        l.price('29.99'),
                        style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Buttons — uses real l.addToCart and l.checkout
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        setState(() => _cartCount++),
                    icon: const Icon(Icons.add_shopping_cart,
                        size: 18),
                    label: Text(l.addToCart),   // ← real translation
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Text(l.checkout),    // ← real translation
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                l.itemCount(_cartCount),        // ← real plural
                style: TextStyle(
                    color: Colors.grey.shade500, fontSize: 12),
              ),
            ),

            if (isRtl) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.orange),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.swap_horiz,
                        color: Colors.orange, size: 14),
                    SizedBox(width: 4),
                    Text('RTL layout active',
                        style: TextStyle(
                            color: Colors.orange, fontSize: 11)),
                  ],
                ),
              ),
            ],
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
            Expanded(
                child: Text(tip, style: const TextStyle(height: 1.5))),
          ],
        ),
      ),
    );
  }
}
