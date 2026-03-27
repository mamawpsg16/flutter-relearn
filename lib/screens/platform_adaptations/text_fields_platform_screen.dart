// Text Fields — Material TextField vs CupertinoTextField + keyboard types

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextFieldsPlatformScreen extends StatefulWidget {
  const TextFieldsPlatformScreen({super.key});

  @override
  State<TextFieldsPlatformScreen> createState() =>
      _TextFieldsPlatformScreenState();
}

class _TextFieldsPlatformScreenState extends State<TextFieldsPlatformScreen> {
  final _materialCtrl = TextEditingController();
  final _cupertinoCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _numberCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _searchCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _materialCtrl.dispose();
    _cupertinoCtrl.dispose();
    _emailCtrl.dispose();
    _numberCtrl.dispose();
    _passwordCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Fields'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Explanation ───────────────────────────────────────────────
            Card(
              color: Colors.purple.shade50,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Text input widgets differ by platform. '
                      'Flutter gives you Material and Cupertino variants, '
                      'plus keyboard types for different input contexts.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• TextField → Material style (underline or outlined)\n'
                      '• CupertinoTextField → iOS style (rounded rect border)\n'
                      '• keyboardType controls which keyboard opens',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Material TextField ────────────────────────────────────────
            const _SectionTitle('Material — TextField'),
            const _Tip(
              'Default underline style. Use InputDecoration to customize.',
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _materialCtrl,
              decoration: const InputDecoration(
                labelText: 'Material TextField',
                hintText: 'Type something...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.edit),
              ),
            ),

            const SizedBox(height: 24),

            // ── CupertinoTextField ────────────────────────────────────────
            const _SectionTitle('Cupertino — CupertinoTextField'),
            const _Tip('iOS-style rounded border. Uses CupertinoColors.'),
            const SizedBox(height: 8),
            CupertinoTextField(
              controller: _cupertinoCtrl,
              placeholder: 'CupertinoTextField',
              prefix: const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.edit, color: CupertinoColors.systemGrey),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: CupertinoColors.systemGrey4),
                borderRadius: BorderRadius.circular(8),
              ),
            ),

            const SizedBox(height: 24),

            // ── Keyboard types ────────────────────────────────────────────
            const _SectionTitle('Keyboard types'),
            const _Tip(
              'keyboardType tells the OS which keyboard to show. '
              'Tap each field to see the different keyboards.',
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email (emailAddress)',
                hintText: 'user@example.com',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _numberCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Number (number)',
                hintText: '12345',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.numbers),
              ),
            ),

            const SizedBox(height: 12),

            // ── Password field ────────────────────────────────────────────
            const _SectionTitle('Password / obscureText'),
            const _Tip(
              'Set obscureText: true to hide input. '
              'Toggle visibility with a suffix icon.',
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordCtrl,
              obscureText: _obscure,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter password',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Text input actions ────────────────────────────────────────
            const _SectionTitle('TextInputAction'),
            const _Tip(
              'textInputAction controls the action button on the keyboard '
              '(Done, Next, Search, Send, etc.).',
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _searchCtrl,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Searching: $value')));
              },
              decoration: const InputDecoration(
                labelText: 'Search (action = search)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),

            const SizedBox(height: 24),

            // ── Key takeaways ─────────────────────────────────────────────
            Card(
              color: Colors.purple.shade50,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Key takeaways',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• TextField (Material) and CupertinoTextField differ visually but behave the same.\n'
                      '• Use keyboardType to open the right keyboard for the input context.\n'
                      '• obscureText: true hides password input.\n'
                      '• TextInputAction changes the keyboard\'s action button.\n'
                      '• TextEditingController lets you read/clear/set field value.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  );
}

class _Tip extends StatelessWidget {
  final String text;
  const _Tip(this.text);
  @override
  Widget build(BuildContext context) =>
      Text(text, style: const TextStyle(color: Colors.black54, fontSize: 12));
}
