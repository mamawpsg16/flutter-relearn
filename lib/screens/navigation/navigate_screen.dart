import 'package:flutter/material.dart';

class NavigateScreen extends StatelessWidget {
  const NavigateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigate to a Screen & Back'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Concept ──────────────────────────────────────────────────
          const Text(
            'Navigator manages a stack of routes. Navigator.push() adds a '
            'new screen on top; Navigator.pop() removes it and goes back. '
            'Every Scaffold\'s back button calls pop() automatically.',
            style: TextStyle(fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 24),

          // ── Stack diagram ─────────────────────────────────────────────
          _StackDiagram(),
          const SizedBox(height: 24),

          // ── BAD code ──────────────────────────────────────────────────
          const _CodeSection(
            label: 'BAD — navigating without MaterialPageRoute',
            labelColor: Colors.red,
            code: '''// ❌ You cannot just instantiate the screen widget directly
// and expect navigation to work
Navigator.push(context, DetailScreen()); // compile error

// ❌ Using a raw Route with no builder
Navigator.push(context, Route()); // abstract class, cannot instantiate''',
          ),
          const SizedBox(height: 12),

          // ── GOOD code ─────────────────────────────────────────────────
          const _CodeSection(
            label: 'GOOD — use MaterialPageRoute with a builder',
            labelColor: Colors.green,
            code: '''// ✅ Push a new screen
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const DetailScreen()),
);

// ✅ Pop back to the previous screen
Navigator.pop(context);

// ✅ Named routes (optional, useful for larger apps)
// Register in MaterialApp:
MaterialApp(routes: {'/detail': (ctx) => const DetailScreen()})

// Then push by name:
Navigator.pushNamed(context, '/detail');''',
          ),
          const SizedBox(height: 24),

          // ── Live demo ─────────────────────────────────────────────────
          const Text('Live Demo',
              style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('You are on Screen A',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Navigator stack: [Screen A]',
                      style: TextStyle(
                          fontFamily: 'monospace',
                          color: Colors.grey.shade600,
                          fontSize: 12)),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Push Screen B'),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const _ScreenB()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          const _TipCard(
            tip: 'MaterialPageRoute gives you the platform-appropriate '
                'transition animation — slide from right on Android, slide '
                'from bottom on iOS. Use CupertinoPageRoute for an explicit '
                'iOS-style transition on any platform.',
          ),
        ],
      ),
    );
  }
}

// ── Stack diagram ─────────────────────────────────────────────────────────────

class _StackDiagram extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(children: [
        const Text('Navigator Stack',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _StackBox('Home', Colors.grey, isActive: false)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Column(children: [
                Text('push()', style: TextStyle(fontSize: 10, color: Colors.green)),
                Icon(Icons.arrow_forward, size: 16, color: Colors.green),
                Icon(Icons.arrow_back, size: 16, color: Colors.red),
                Text('pop()', style: TextStyle(fontSize: 10, color: Colors.red)),
              ]),
            ),
            Expanded(child: _StackBox('Detail', Colors.teal, isActive: true)),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Stack after push: [Home, Detail] ← Detail is on top\n'
          'Stack after pop:  [Home]          ← back to Home',
          style: TextStyle(fontSize: 11, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
      ]),
    );
  }
}

class _StackBox extends StatelessWidget {
  final String label;
  final Color color;
  final bool isActive;
  const _StackBox(this.label, this.color, {required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isActive ? 1 : 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: isActive ? color : Colors.grey, width: isActive ? 2 : 1),
      ),
      child: Center(
        child: Text(label,
            style: TextStyle(
                color: Colors.white,
                fontWeight:
                    isActive ? FontWeight.bold : FontWeight.normal)),
      ),
    );
  }
}

// ── Screen B (pushed in the demo) ────────────────────────────────────────────

class _ScreenB extends StatelessWidget {
  const _ScreenB();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen B'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.layers, size: 64, color: Colors.teal),
            const SizedBox(height: 16),
            const Text('You are on Screen B',
                style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              'Navigator stack: [NavigateScreen, Screen B]',
              style: TextStyle(
                  fontFamily: 'monospace',
                  color: Colors.grey.shade600,
                  fontSize: 12),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.arrow_back),
              label: const Text('Pop back to Screen A'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal,
                  foregroundColor: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

class _CodeSection extends StatelessWidget {
  final String label;
  final Color labelColor;
  final String code;
  const _CodeSection(
      {required this.label, required this.labelColor, required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade900, borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: TextStyle(
                color: labelColor, fontWeight: FontWeight.bold, fontSize: 12)),
        const SizedBox(height: 8),
        Text(code,
            style: const TextStyle(
                color: Colors.white,
                fontFamily: 'monospace',
                fontSize: 12,
                height: 1.5)),
      ]),
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
        padding: const EdgeInsets.all(16),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.lightbulb, color: Colors.purple),
          const SizedBox(width: 12),
          Expanded(
              child:
                  Text(tip, style: const TextStyle(fontSize: 14, height: 1.5))),
        ]),
      ),
    );
  }
}
