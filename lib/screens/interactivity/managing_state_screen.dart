import 'package:flutter/material.dart';

class ManagingStateScreen extends StatefulWidget {
  const ManagingStateScreen({super.key});

  @override
  State<ManagingStateScreen> createState() => _ManagingStateScreenState();
}

class _ManagingStateScreenState extends State<ManagingStateScreen> {
  int _selectedApproach = 0;

  static const _approaches = [
    'Widget manages its own state',
    'Parent manages the state',
    'Mix-and-match',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Managing State'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Who should manage a widget\'s state? It depends on whether '
            'the state is private to the widget, or needs to be shared '
            'with a parent or sibling.',
          ),
          const SizedBox(height: 16),

          // Approach selector
          const Text('Tap an approach to see it live:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...List.generate(_approaches.length, (i) {
            final selected = _selectedApproach == i;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () => setState(() => _selectedApproach = i),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: selected
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: selected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade300,
                      width: selected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: selected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade400,
                        child: Text('${i + 1}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(_approaches[i],
                            style: TextStyle(
                                fontWeight: selected
                                    ? FontWeight.bold
                                    : FontWeight.normal)),
                      ),
                      if (selected)
                        Icon(Icons.arrow_drop_down,
                            color: Theme.of(context).colorScheme.primary),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 8),

          // Content for selected approach
          if (_selectedApproach == 0) ...[
            const _CodeSection(
              label: 'Widget manages its own state',
              labelColor: Colors.teal,
              code: '''
// The widget owns the state — no parent involvement
class TapBox extends StatefulWidget {
  const TapBox({super.key});
  @override
  State<TapBox> createState() => _TapBoxState();
}

class _TapBoxState extends State<TapBox> {
  bool _active = false;  // private to this widget

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _active = !_active),
      child: Container(
        color: _active ? Colors.lightGreen : Colors.grey,
        child: Text(_active ? 'Active' : 'Inactive'),
      ),
    );
  }
}''',
            ),
            const SizedBox(height: 12),
            const Text('When to use: state is internal to the widget — '
                'no parent or sibling needs to know about it.\n'
                'Examples: animation state, form editing state.'),
            const SizedBox(height: 12),
            const Center(child: _SelfManagedTapBox()),
          ],

          if (_selectedApproach == 1) ...[
            const _CodeSection(
              label: 'Parent manages the state',
              labelColor: Colors.orange,
              code: '''
// Parent holds the state, passes it down via constructor
class ParentWidget extends StatefulWidget {
  @override
  State<ParentWidget> createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  bool _active = false;

  void _handleTap(bool newValue) {
    setState(() => _active = newValue);
  }

  @override
  Widget build(BuildContext context) {
    return TapBox(active: _active, onChanged: _handleTap);
  }
}

// Child is stateless — it just reports events upward
class TapBox extends StatelessWidget {
  final bool active;
  final ValueChanged<bool> onChanged;
  const TapBox({required this.active, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!active),
      child: Container(
        color: active ? Colors.lightGreen : Colors.grey,
        child: Text(active ? 'Active' : 'Inactive'),
      ),
    );
  }
}''',
            ),
            const SizedBox(height: 12),
            const Text('When to use: the parent needs to react to the child\'s '
                'state, or siblings need to share the same state.\n'
                'Examples: form submission, tab selection.'),
            const SizedBox(height: 12),
            const Center(child: _ParentManagedExample()),
          ],

          if (_selectedApproach == 2) ...[
            const _CodeSection(
              label: 'Mix-and-match approach',
              labelColor: Colors.purple,
              code: '''
// Some state is private to the widget,
// some state is managed by the parent.

class TapBox extends StatefulWidget {
  final bool active;          // managed by parent
  final ValueChanged<bool> onChanged;
  const TapBox({required this.active, required this.onChanged});

  @override
  State<TapBox> createState() => _TapBoxState();
}

class _TapBoxState extends State<TapBox> {
  bool _highlight = false; // private — parent doesn't need this

  void _handleTapDown(TapDownDetails _) {
    setState(() => _highlight = true);   // local state only
  }

  void _handleTapUp(TapUpDetails _) {
    setState(() => _highlight = false);
    widget.onChanged(!widget.active);    // report to parent
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      child: Container(
        decoration: BoxDecoration(
          color: widget.active ? Colors.lightGreen : Colors.grey,
          border: _highlight ? Border.all(color: Colors.teal, width: 3) : null,
        ),
        child: Text(widget.active ? 'Active' : 'Inactive'),
      ),
    );
  }
}''',
            ),
            const SizedBox(height: 12),
            const Text(
                'The highlight (press feedback) is private — the parent doesn\'t '
                'care about it. But the active/inactive toggle is shared with the parent.\n\n'
                'Tap and hold to see the highlight, release to toggle.'),
            const SizedBox(height: 12),
            const Center(child: _MixAndMatchExample()),
          ],

          const SizedBox(height: 16),
          const _TipCard(
            tip: 'Rule of thumb: keep state as low as possible in the tree. '
                'Lift it up only when a parent or sibling widget needs it.',
          ),
        ],
      ),
    );
  }
}

// ── Self-managed demo ─────────────────────────────────────────────────────
class _SelfManagedTapBox extends StatefulWidget {
  const _SelfManagedTapBox();

  @override
  State<_SelfManagedTapBox> createState() => _SelfManagedTapBoxState();
}

class _SelfManagedTapBoxState extends State<_SelfManagedTapBox> {
  bool _active = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _active = !_active),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 200,
        height: 80,
        decoration: BoxDecoration(
          color: _active ? Colors.lightGreen : Colors.grey.shade400,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            _active ? 'Active' : 'Inactive',
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// ── Parent-managed demo ───────────────────────────────────────────────────
class _ParentManagedExample extends StatefulWidget {
  const _ParentManagedExample();

  @override
  State<_ParentManagedExample> createState() => _ParentManagedExampleState();
}

class _ParentManagedExampleState extends State<_ParentManagedExample> {
  bool _active = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Parent state: _active = $_active',
            style: const TextStyle(fontFamily: 'monospace', fontSize: 13)),
        const SizedBox(height: 8),
        _ChildTapBox(
          active: _active,
          onChanged: (val) => setState(() => _active = val),
        ),
      ],
    );
  }
}

class _ChildTapBox extends StatelessWidget {
  final bool active;
  final ValueChanged<bool> onChanged;
  const _ChildTapBox({required this.active, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!active),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 200,
        height: 80,
        decoration: BoxDecoration(
          color: active ? Colors.lightGreen : Colors.grey.shade400,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            active ? 'Active' : 'Inactive',
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// ── Mix-and-match demo ────────────────────────────────────────────────────
class _MixAndMatchExample extends StatefulWidget {
  const _MixAndMatchExample();

  @override
  State<_MixAndMatchExample> createState() => _MixAndMatchExampleState();
}

class _MixAndMatchExampleState extends State<_MixAndMatchExample> {
  bool _active = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Parent state: _active = $_active',
            style: const TextStyle(fontFamily: 'monospace', fontSize: 13)),
        const SizedBox(height: 8),
        _MixTapBox(
          active: _active,
          onChanged: (val) => setState(() => _active = val),
        ),
      ],
    );
  }
}

class _MixTapBox extends StatefulWidget {
  final bool active;
  final ValueChanged<bool> onChanged;
  const _MixTapBox({required this.active, required this.onChanged});

  @override
  State<_MixTapBox> createState() => _MixTapBoxState();
}

class _MixTapBoxState extends State<_MixTapBox> {
  bool _highlight = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _highlight = true),
      onTapUp: (_) {
        setState(() => _highlight = false);
        widget.onChanged(!widget.active);
      },
      onTapCancel: () => setState(() => _highlight = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 200,
        height: 80,
        decoration: BoxDecoration(
          color: widget.active ? Colors.lightGreen : Colors.grey.shade400,
          borderRadius: BorderRadius.circular(12),
          border: _highlight ? Border.all(color: Colors.teal, width: 4) : null,
        ),
        child: Center(
          child: Text(
            widget.active ? 'Active' : 'Inactive',
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
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
