import 'package:flutter/material.dart';

class AssistiveTechnologiesScreen extends StatefulWidget {
  const AssistiveTechnologiesScreen({super.key});

  @override
  State<AssistiveTechnologiesScreen> createState() =>
      _AssistiveTechnologiesScreenState();
}

class _AssistiveTechnologiesScreenState
    extends State<AssistiveTechnologiesScreen> {
  bool _showDebugger = false;
  bool _useMergeSemantics = true;
  bool _excludeDecoration = true;

  @override
  Widget build(BuildContext context) {
    Widget body = _buildBody();
    if (_showDebugger) {
      body = SemanticsDebugger(child: body);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assistive Technologies'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: body,
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TalkBack (Android) and VoiceOver (iOS) read the semantic tree to users '
            'who cannot see the screen. Flutter translates its semantic tree into '
            'native platform accessibility APIs. Two key tools: MergeSemantics groups '
            'related nodes into one focus stop, and ExcludeSemantics hides decorative '
            'elements from the tree entirely.',
            style: TextStyle(fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 20),

          _CodeSection(
            label: 'BAD — every child is a separate focus stop',
            labelColor: Colors.red,
            code: '''Row(children: [
  Icon(Icons.star),     // "star, image"
  Text("Rating:"),      // "Rating:"
  Text("4.8"),          // "4.8"
  Text("(2 k reviews)"),// "2 k reviews"
])
// User must swipe 4 times to get past this one row''',
          ),
          const SizedBox(height: 12),
          _CodeSection(
            label: 'GOOD — MergeSemantics = one focus stop for the whole row',
            labelColor: Colors.green,
            code: '''MergeSemantics(
  child: Row(children: [
    Icon(Icons.star),
    Text("Rating:"),
    Text("4.8"),
    Text("(2 k reviews)"),
  ]),
)
// Screen reader: "star image, Rating: 4.8, 2 k reviews" — one swipe''',
          ),
          const SizedBox(height: 24),

          const Text('Live Demo — MergeSemantics & ExcludeSemantics',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('MergeSemantics'),
                    subtitle: Text(_useMergeSemantics
                        ? 'Rating row = 1 focus stop'
                        : 'Rating row = 4 focus stops'),
                    value: _useMergeSemantics,
                    onChanged: (v) =>
                        setState(() => _useMergeSemantics = v),
                  ),
                  SwitchListTile(
                    title: const Text('ExcludeSemantics on divider'),
                    subtitle: Text(_excludeDecoration
                        ? 'Divider is hidden from screen readers'
                        : 'Divider shows up as "horizontal line"'),
                    value: _excludeDecoration,
                    onChanged: (v) =>
                        setState(() => _excludeDecoration = v),
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  _buildRatingRow(),
                  const SizedBox(height: 8),
                  _excludeDecoration
                      ? ExcludeSemantics(child: const Divider())
                      : const Divider(),
                  const SizedBox(height: 8),
                  const Text(
                    'Enable the Semantics Debugger below to see the tree',
                    style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          Card(
            color: Colors.indigo.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SwitchListTile(
                title: const Text('SemanticsDebugger overlay',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text(
                    'Overlays the semantic tree on the whole screen'),
                value: _showDebugger,
                onChanged: (v) => setState(() => _showDebugger = v),
              ),
            ),
          ),
          const SizedBox(height: 24),

          const Text('Platform Quick Reference',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: const [
                _PlatformRow(
                  icon: Icons.android,
                  color: Color(0xFF3DDC84),
                  platform: 'TalkBack (Android)',
                  how: 'Settings → Accessibility → TalkBack',
                ),
                Divider(height: 1),
                _PlatformRow(
                  icon: Icons.phone_iphone,
                  color: Color(0xFF555555),
                  platform: 'VoiceOver (iOS)',
                  how: 'Settings → Accessibility → VoiceOver',
                ),
                Divider(height: 1),
                _PlatformRow(
                  icon: Icons.desktop_windows,
                  color: Color(0xFF0078D4),
                  platform: 'Narrator (Windows)',
                  how: 'Win + Ctrl + Enter',
                ),
                Divider(height: 1),
                _PlatformRow(
                  icon: Icons.web,
                  color: Color(0xFF4285F4),
                  platform: 'ChromeVox',
                  how: 'Built-in on ChromeOS / Chrome extension',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _TipCard(
            tip: 'Use MergeSemantics to group related pieces (icon + label + value) '
                'into a single focus stop. Use ExcludeSemantics on purely decorative '
                'elements like dividers, background illustrations, or repeated icons '
                'that add no meaning.',
          ),
        ],
      ),
    );
  }

  Widget _buildRatingRow() {
    final row = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.star, color: Colors.amber, size: 20),
        SizedBox(width: 4),
        Text('Rating:', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(width: 4),
        Text('4.8', style: TextStyle(color: Colors.green)),
        SizedBox(width: 4),
        Text('(2 k reviews)',
            style: TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
    return _useMergeSemantics ? MergeSemantics(child: row) : row;
  }
}

class _PlatformRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String platform;
  final String how;

  const _PlatformRow({
    required this.icon,
    required this.color,
    required this.platform,
    required this.how,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color,
        radius: 18,
        child: Icon(icon, color: Colors.white, size: 18),
      ),
      title: Text(platform,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      subtitle: Text(how, style: const TextStyle(fontSize: 12)),
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
