// Use SafeArea to prevent content from being hidden by system UI (notches, status bar, home indicator)

import 'package:flutter/material.dart';

class SafeAreaScreen extends StatefulWidget {
  const SafeAreaScreen({super.key});

  @override
  State<SafeAreaScreen> createState() => _SafeAreaScreenState();
}

class _SafeAreaScreenState extends State<SafeAreaScreen> {
  // Toggle between side-by-side and top/bottom split
  bool _sideBySide = true;

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SafeArea'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          TextButton.icon(
            onPressed: () => setState(() => _sideBySide = !_sideBySide),
            icon: Icon(
              _sideBySide ? Icons.view_agenda : Icons.view_week,
              color: Colors.white,
            ),
            label: Text(
              _sideBySide ? 'Split top/bottom' : 'Split left/right',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      // We use a custom body so that the UNSAFE half can intentionally
      // ignore safe-area insets and go edge-to-edge.
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Inset values ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(12),
            child: Card(
              color: Colors.orange.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'MediaQuery.of(context).padding\n'
                  '  top:    ${padding.top.toStringAsFixed(1)} dp  ← status bar / notch\n'
                  '  bottom: ${padding.bottom.toStringAsFixed(1)} dp  ← home indicator\n'
                  '  left:   ${padding.left.toStringAsFixed(1)} dp\n'
                  '  right:  ${padding.right.toStringAsFixed(1)} dp',
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                ),
              ),
            ),
          ),

          // ── Split demo ───────────────────────────────────────────────
          Expanded(child: _sideBySide ? _buildSideBySide() : _buildTopBottom()),
        ],
      ),
    );
  }

  // ── Side-by-side layout ───────────────────────────────────────────────────

  Widget _buildSideBySide() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // LEFT — without SafeArea
        Expanded(child: _UnsafePanel()),
        // RIGHT — with SafeArea
        Expanded(child: _SafePanel()),
      ],
    );
  }

  // ── Top-bottom layout ─────────────────────────────────────────────────────

  Widget _buildTopBottom() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: _UnsafePanel()),
        Expanded(child: _SafePanel()),
      ],
    );
  }
}

// ── Unsafe panel (no SafeArea) ────────────────────────────────────────────────

class _UnsafePanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red.shade400,
      // No SafeArea — content may slip under the status bar / notch
      child: const Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WITHOUT SafeArea',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'This panel has NO SafeArea wrapper.\n\n'
              'On devices with a notch or a thick status bar the text at '
              'the very top could be hidden behind system UI.\n\n'
              'The red background deliberately extends to the edge of the '
              'available space to show the problem.',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Safe panel (with SafeArea) ────────────────────────────────────────────────

class _SafePanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green.shade400,
      // SafeArea automatically insets content away from system UI
      child: SafeArea(
        // Only apply left/right/bottom here because the AppBar already
        // handles the top edge. Set top: true to see the extra inset.
        top: false,
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'WITH SafeArea',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'This panel IS wrapped in SafeArea.\n\n'
                'Flutter automatically adds padding equal to the system '
                'intrusions (notch, status bar, home indicator) so your '
                'content is always fully visible.\n\n'
                'You can pass top/bottom/left/right flags to SafeArea to '
                'control which edges are protected.',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
