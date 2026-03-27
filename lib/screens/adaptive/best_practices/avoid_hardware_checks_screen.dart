import 'package:flutter/material.dart';

class AvoidHardwareChecksScreen extends StatelessWidget {
  const AvoidHardwareChecksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avoid Hardware Type Checks'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _CodeSection(
            label: 'BAD — platform does not equal capabilities',
            labelColor: Colors.red,
            code: '''
if (Platform.isAndroid || Platform.isIOS)
  return MobileLayout();
else
  return DesktopLayout();''',
          ),
          SizedBox(height: 12),
          _CodeSection(
            label: 'GOOD — actual width drives the layout',
            labelColor: Colors.green,
            code: '''
final w = MediaQuery.of(context).size.width;
if (w >= 900) return DesktopLayout();
if (w >= 600) return TabletLayout();
return MobileLayout();''',
          ),
          SizedBox(height: 16),
          _TipCard(
            tip: 'A Chromebook runs Android but has a mouse and large screen. '
                'A foldable phone can be either. Check capabilities '
                '(screen size, pointer device) — not hardware type.',
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
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lightbulb, color: Colors.red, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(tip)),
          ],
        ),
      ),
    );
  }
}
