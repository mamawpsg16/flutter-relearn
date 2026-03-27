import 'package:flutter/material.dart';

class OtherInteractiveScreen extends StatefulWidget {
  const OtherInteractiveScreen({super.key});

  @override
  State<OtherInteractiveScreen> createState() => _OtherInteractiveScreenState();
}

class _OtherInteractiveScreenState extends State<OtherInteractiveScreen> {
  // Standard widget state
  bool _checkboxVal = false;
  bool _switchVal = false;
  double _sliderVal = 0.5;
  int _radioVal = 1;

  // Material component state
  bool _isFavorited = false;
  int _selectedIndex = 0;
  final _textController = TextEditingController();
  String _submittedText = '';

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Other Interactive Widgets'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Flutter ships dozens of ready-made interactive widgets. '
            'Standard widgets handle common input patterns; '
            'Material Components add opinionated design on top.',
          ),
          const SizedBox(height: 20),

          // ── Standard Widgets ──────────────────────────────────────────
          _SectionHeader('Standard Widgets', Icons.widgets, Colors.teal),
          const SizedBox(height: 12),

          // Form widget — TextField
          const Text('TextField', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const _CodeSection(
            label: 'TextField with onSubmitted',
            labelColor: Colors.teal,
            code: '''
TextField(
  controller: _textController,
  decoration: InputDecoration(labelText: 'Type something'),
  onSubmitted: (val) => setState(() => _submittedText = val),
)''',
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _textController,
            decoration: const InputDecoration(
              labelText: 'Type something',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (val) => setState(() => _submittedText = val),
          ),
          if (_submittedText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text('Submitted: "$_submittedText"',
                  style: const TextStyle(color: Colors.teal)),
            ),
          const SizedBox(height: 16),

          // Checkbox
          const Text('Checkbox', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const _CodeSection(
            label: 'Checkbox',
            labelColor: Colors.teal,
            code: '''
Checkbox(
  value: _checkboxVal,
  onChanged: (val) => setState(() => _checkboxVal = val!),
)''',
          ),
          const SizedBox(height: 8),
          Card(
            child: CheckboxListTile(
              title: const Text('I agree to the terms'),
              value: _checkboxVal,
              onChanged: (val) => setState(() => _checkboxVal = val!),
            ),
          ),
          const SizedBox(height: 16),

          // Switch
          const Text('Switch', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const _CodeSection(
            label: 'Switch',
            labelColor: Colors.teal,
            code: '''
Switch(
  value: _switchVal,
  onChanged: (val) => setState(() => _switchVal = val),
)''',
          ),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              title: const Text('Enable notifications'),
              value: _switchVal,
              onChanged: (val) => setState(() => _switchVal = val),
            ),
          ),
          const SizedBox(height: 16),

          // Slider
          const Text('Slider', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const _CodeSection(
            label: 'Slider',
            labelColor: Colors.teal,
            code: '''
Slider(
  value: _sliderVal,
  onChanged: (val) => setState(() => _sliderVal = val),
)''',
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 8),
                    child: Text(
                        'Volume: ${(_sliderVal * 100).toInt()}%'),
                  ),
                  Slider(
                    value: _sliderVal,
                    onChanged: (val) => setState(() => _sliderVal = val),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Radio
          const Text('Radio', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const _CodeSection(
            label: 'Radio buttons — use RadioGroup (Flutter 3.32+)',
            labelColor: Colors.teal,
            code: '''
RadioGroup<int>(
  groupValue: _radioVal,
  onChanged: (val) => setState(() => _radioVal = val!),
  child: Column(
    children: [1, 2, 3].map((v) =>
      RadioListTile<int>(title: Text('Option \$v'), value: v),
    ).toList(),
  ),
)''',
          ),
          const SizedBox(height: 8),
          Card(
            child: RadioGroup<int>(
              groupValue: _radioVal,
              onChanged: (val) => setState(() => _radioVal = val!),
              child: Column(
                children: [1, 2, 3]
                    .map((v) => RadioListTile<int>(
                          title: Text('Option $v'),
                          value: v,
                        ))
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ── Material Components ───────────────────────────────────────
          _SectionHeader('Material Components', Icons.layers, Colors.purple),
          const SizedBox(height: 12),

          // IconButton
          const Text('IconButton', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const _CodeSection(
            label: 'IconButton — tap to toggle favorite',
            labelColor: Colors.purple,
            code: '''
IconButton(
  icon: Icon(
    _isFavorited ? Icons.favorite : Icons.favorite_border,
    color: Colors.red,
  ),
  onPressed: () => setState(() => _isFavorited = !_isFavorited),
)''',
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              title: const Text('Tap to favorite'),
              trailing: IconButton(
                icon: Icon(
                  _isFavorited ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: () =>
                    setState(() => _isFavorited = !_isFavorited),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // SegmentedButton
          const Text('SegmentedButton',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const _CodeSection(
            label: 'SegmentedButton (M3)',
            labelColor: Colors.purple,
            code: '''
SegmentedButton<int>(
  segments: const [
    ButtonSegment(value: 0, label: Text('Day')),
    ButtonSegment(value: 1, label: Text('Week')),
    ButtonSegment(value: 2, label: Text('Month')),
  ],
  selected: {_selectedIndex},
  onSelectionChanged: (s) => setState(() => _selectedIndex = s.first),
)''',
          ),
          const SizedBox(height: 8),
          Center(
            child: SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('Day')),
                ButtonSegment(value: 1, label: Text('Week')),
                ButtonSegment(value: 2, label: Text('Month')),
              ],
              selected: {_selectedIndex},
              onSelectionChanged: (s) =>
                  setState(() => _selectedIndex = s.first),
            ),
          ),
          const SizedBox(height: 16),

          // Buttons showcase
          const Text('Button variants',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(onPressed: () {}, child: const Text('Elevated')),
              FilledButton(onPressed: () {}, child: const Text('Filled')),
              FilledButton.tonal(onPressed: () {}, child: const Text('Tonal')),
              OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
              TextButton(onPressed: () {}, child: const Text('Text')),
              IconButton.filled(
                onPressed: () {},
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 24),

          const _TipCard(
            tip: 'Prefer Material components over custom GestureDetector '
                'when possible — they handle accessibility, focus, '
                'ripple effects, and theming automatically.',
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  const _SectionHeader(this.title, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: color,
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 10),
        Text(title,
            style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}

class _CodeSection extends StatelessWidget {
  final String label;
  final Color labelColor;
  final String code;
  const _CodeSection(
      {required this.label, required this.labelColor, required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.grey.shade900, borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  color: labelColor, fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          Text(code,
              style: const TextStyle(
                  color: Colors.white, fontFamily: 'monospace', fontSize: 12)),
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
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lightbulb, color: Colors.purple, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(tip)),
          ],
        ),
      ),
    );
  }
}
