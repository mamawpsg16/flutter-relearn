import 'package:flutter/material.dart';

class PageRouteTransitionsScreen extends StatelessWidget {
  const PageRouteTransitionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final demos = [
      _Demo(
        label: 'Fade Transition',
        color: Colors.indigo,
        buildRoute: () => _FadeRoute(child: const _DemoPage('Fade', Colors.indigo)),
      ),
      _Demo(
        label: 'Slide from Right',
        color: Colors.teal,
        buildRoute: () => _SlideRoute(
          child: const _DemoPage('Slide from Right', Colors.teal),
          begin: const Offset(1, 0),
        ),
      ),
      _Demo(
        label: 'Slide from Bottom',
        color: Colors.orange,
        buildRoute: () => _SlideRoute(
          child: const _DemoPage('Slide from Bottom', Colors.orange),
          begin: const Offset(0, 1),
        ),
      ),
      _Demo(
        label: 'Scale (zoom in)',
        color: Colors.purple,
        buildRoute: () => _ScaleRoute(child: const _DemoPage('Scale', Colors.purple)),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Route Transitions'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Custom PageRoutes let you define how screens enter and exit. '
              'Use PageRouteBuilder with a transitionsBuilder callback '
              'to compose any combination of Fade, Slide, and Scale.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 20),

            _CodeSection(
              label: 'BAD — default push has no custom transition',
              labelColor: Colors.red,
              code: '''Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => NextScreen()),
  // Platform default — slide on iOS, fade on Android
)''',
            ),
            const SizedBox(height: 12),

            _CodeSection(
              label: 'GOOD — custom PageRouteBuilder',
              labelColor: Colors.green,
              code: '''Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (_, __, ___) => NextScreen(),
    transitionsBuilder: (_, animation, __, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    transitionDuration: Duration(milliseconds: 400),
  ),
)''',
            ),
            const SizedBox(height: 24),

            const Text(
              'Live Demo — tap to navigate with each transition',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            ...demos.map(
              (demo) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: demo.color,
                      child: const Icon(Icons.play_arrow, color: Colors.white),
                    ),
                    title: Text(demo.label,
                        style:
                            const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () =>
                        Navigator.push(context, demo.buildRoute()),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Curve cheat sheet
            const Text('Curve cheat-sheet:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _CurveDemo(),
            const SizedBox(height: 20),

            _TipCard(
              tip:
                  'Compose transitions by nesting them: wrap FadeTransition '
                  'inside SlideTransition for a combined effect. '
                  'Keep durations between 200–500 ms for a snappy feel.',
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Custom route builders ────────────────────────────────────────────────────

class _FadeRoute extends PageRouteBuilder {
  _FadeRoute({required Widget child})
      : super(
          pageBuilder: (_, __, ___) => child,
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        );
}

class _SlideRoute extends PageRouteBuilder {
  _SlideRoute({required Widget child, required Offset begin})
      : super(
          pageBuilder: (_, __, ___) => child,
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (_, animation, __, child) => SlideTransition(
            position: Tween<Offset>(begin: begin, end: Offset.zero)
                .animate(CurvedAnimation(
                    parent: animation, curve: Curves.easeInOut)),
            child: child,
          ),
        );
}

class _ScaleRoute extends PageRouteBuilder {
  _ScaleRoute({required Widget child})
      : super(
          pageBuilder: (_, __, ___) => child,
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (_, animation, __, child) => ScaleTransition(
            scale: CurvedAnimation(
                parent: animation, curve: Curves.easeOutBack),
            child: child,
          ),
        );
}

// ─── Demo destination page ────────────────────────────────────────────────────

class _DemoPage extends StatelessWidget {
  final String label;
  final Color color;
  const _DemoPage(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(label),
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: color, size: 80),
            const SizedBox(height: 16),
            Text(
              '$label transition!',
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Curve visualizer ─────────────────────────────────────────────────────────

class _CurveDemo extends StatefulWidget {
  @override
  State<_CurveDemo> createState() => _CurveDemoState();
}

class _CurveDemoState extends State<_CurveDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  Curve _selected = Curves.easeInOut;
  final _curves = {
    'easeInOut': Curves.easeInOut,
    'easeOutBack': Curves.easeOutBack,
    'bounceOut': Curves.bounceOut,
    'elasticOut': Curves.elasticOut,
    'linear': Curves.linear,
  };

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _play() {
    _ctrl.reset();
    _ctrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    final anim =
        CurvedAnimation(parent: _ctrl, curve: _selected);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _curves.entries.map((e) {
                final selected = e.value == _selected;
                return FilterChip(
                  label: Text(e.key),
                  selected: selected,
                  onSelected: (_) =>
                      setState(() => _selected = e.value),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            AnimatedBuilder(
              animation: anim,
              builder: (_, __) => Stack(
                children: [
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Positioned(
                    left:
                        anim.value * (MediaQuery.of(context).size.width - 100),
                    top: 10,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: ElevatedButton.icon(
                onPressed: _play,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Play'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Shared private widgets ───────────────────────────────────────────────────

class _Demo {
  final String label;
  final Color color;
  final Route Function() buildRoute;
  const _Demo({required this.label, required this.color, required this.buildRoute});
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
          Text(
            label,
            style: TextStyle(
              color: labelColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            code,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'monospace',
              fontSize: 12,
              height: 1.5,
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
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lightbulb, color: Colors.purple),
            const SizedBox(width: 8),
            Expanded(
              child: Text(tip, style: const TextStyle(height: 1.5)),
            ),
          ],
        ),
      ),
    );
  }
}
