import 'package:flutter/material.dart';

class HandsOnScreen extends StatelessWidget {
  const HandsOnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hands-On Screen')),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/second');
                // Navigator.of(context).push(
                //   MaterialPageRoute<void>(
                //     builder: (context) => const SecondScreen(),
                //   ),
                // );
              },
              child: const Text('Open second screen'),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── This screen was opened by the Router (named route) ────
            const Text('Opened via named route: /second',
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),

            // ── Local Navigator.push — no named route needed ──────────
            ElevatedButton.icon(
              icon: const Icon(Icons.open_in_new),
              label: const Text('Open a modal (local Navigator.push)'),
              onPressed: () {
                // This push is LOCAL — it does NOT go through named routes.
                // The Router/GoRouter doesn't know about it.
                // Perfect for modals, wizards, and overlays.
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    fullscreenDialog: true,   // gives it a ✕ instead of ←
                    builder: (context) => const _ModalScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            // ── Go back through the Router ────────────────────────────
            OutlinedButton.icon(
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go back (Navigator.pop)'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Modal screen — pushed with Navigator.push, NOT a named route ──────────────
class _ModalScreen extends StatelessWidget {
  const _ModalScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modal (local push)'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This screen was opened with Navigator.push() directly —\n'
              'NOT through a named route.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 24),
            // Visual: show the two systems side by side
            _SystemCard(
              color: Colors.blue,
              icon: Icons.route,
              label: 'Router / Named Routes',
              handles: 'Main screens with URLs\n/first → /second',
              active: false,
            ),
            const SizedBox(height: 8),
            _SystemCard(
              color: Colors.deepPurple,
              icon: Icons.layers,
              label: 'Navigator.push()',
              handles: 'This modal — local,\nno URL, no named route',
              active: true,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white),
                onPressed: () => Navigator.pop(context),
                child: const Text('Close modal'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SystemCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  final String handles;
  final bool active;

  const _SystemCard({
    required this.color,
    required this.icon,
    required this.label,
    required this.handles,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: active ? color : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: active ? color : Colors.grey.shade300, width: 2),
      ),
      child: Row(children: [
        Icon(icon, color: active ? Colors.white : Colors.grey),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style: TextStyle(
                  color: active ? Colors.white : Colors.grey,
                  fontWeight: FontWeight.bold)),
          Text(handles,
              style: TextStyle(
                  color: active ? Colors.white70 : Colors.grey,
                  fontSize: 12)),
        ]),
        if (active) ...[
          const Spacer(),
          const Icon(Icons.check_circle, color: Colors.white),
        ],
      ]),
    );
  }
}
