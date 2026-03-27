// Scrolling Physics — BouncingScrollPhysics vs ClampingScrollPhysics + Scrollbar

import 'package:flutter/material.dart';

class ScrollingPhysicsScreen extends StatelessWidget {
  const ScrollingPhysicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scrolling Physics'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Explanation ───────────────────────────────────────────────
            Card(
              color: Colors.teal.shade50,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ScrollPhysics controls how a scroll view behaves at its edges and how it animates.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• BouncingScrollPhysics → iOS-style elastic overscroll\n'
                      '• ClampingScrollPhysics → Android-style hard stop (glow)\n'
                      '• NeverScrollableScrollPhysics → disables scrolling entirely\n'
                      '• AlwaysScrollableScrollPhysics → forces scroll even if content fits',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── BouncingScrollPhysics ─────────────────────────────────────
            const _SectionTitle('BouncingScrollPhysics (iOS-style)'),
            const _Tip('Drag past the end — the list bounces back elastically.'),
            const SizedBox(height: 8),
            SizedBox(
              height: 180,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: 6,
                itemBuilder: (_, i) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Text('${i + 1}',
                        style: const TextStyle(color: Colors.white)),
                  ),
                  title: Text('Bouncing item ${i + 1}'),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── ClampingScrollPhysics ─────────────────────────────────────
            const _SectionTitle('ClampingScrollPhysics (Android-style)'),
            const _Tip(
                'Drag past the end — it clamps hard. On Android you see a glow effect.'),
            const SizedBox(height: 8),
            SizedBox(
              height: 180,
              child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                itemCount: 6,
                itemBuilder: (_, i) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.indigo,
                    child: Text('${i + 1}',
                        style: const TextStyle(color: Colors.white)),
                  ),
                  title: Text('Clamping item ${i + 1}'),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Scrollbar widget ──────────────────────────────────────────
            const _SectionTitle('Scrollbar widget'),
            const _Tip(
                'Wrap any scrollable in Scrollbar to show a persistent or on-demand scrollbar. '
                'On desktop it is always visible; on mobile it appears while scrolling.'),
            const SizedBox(height: 8),
            SizedBox(
              height: 180,
              child: Scrollbar(
                thumbVisibility: true, // always show thumb
                child: ListView.builder(
                  itemCount: 20,
                  itemBuilder: (_, i) => ListTile(
                    dense: true,
                    title: Text('Scrollbar item ${i + 1}'),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── NeverScrollableScrollPhysics ──────────────────────────────
            const _SectionTitle('NeverScrollableScrollPhysics'),
            const _Tip(
                'The list below cannot be scrolled — useful when an outer scroll '
                'view drives scrolling and you want to disable inner scroll.'),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 10,
                itemBuilder: (_, i) => ListTile(
                  dense: true,
                  title: Text('Frozen item ${i + 1}'),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Key takeaways ─────────────────────────────────────────────
            Card(
              color: Colors.teal.shade50,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Key takeaways',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text(
                      '• Pass physics: to any scrollable (ListView, GridView, SingleChildScrollView).\n'
                      '• Flutter picks BouncingScrollPhysics on iOS and ClampingScrollPhysics on Android by default.\n'
                      '• Use Scrollbar() to add a visible scrollbar on any platform.\n'
                      '• thumbVisibility: true keeps the thumb always visible.',
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
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
}

class _Tip extends StatelessWidget {
  final String text;
  const _Tip(this.text);
  @override
  Widget build(BuildContext context) =>
      Text(text, style: const TextStyle(color: Colors.black54, fontSize: 12));
}
