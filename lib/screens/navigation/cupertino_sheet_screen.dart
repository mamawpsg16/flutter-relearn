import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoSheetScreen extends StatefulWidget {
  const CupertinoSheetScreen({super.key});

  @override
  State<CupertinoSheetScreen> createState() => _CupertinoSheetScreenState();
}

class _CupertinoSheetScreenState extends State<CupertinoSheetScreen> {
  String _lastAction = 'None yet';
  _SheetType _selectedType = _SheetType.modal;

  void _showSheet() {
    switch (_selectedType) {
      case _SheetType.modal:
        _showCupertinoModal();
      case _SheetType.actionSheet:
        _showCupertinoActionSheet();
      case _SheetType.materialBottom:
        _showMaterialBottom();
    }
  }

  void _showCupertinoModal() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: const Text('Cupertino Modal Sheet'),
        message: const Text(
            'This is showCupertinoModalPopup — the standard iOS-style sheet.'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              setState(() => _lastAction = 'Tapped Option A');
              Navigator.pop(ctx);
            },
            child: const Text('Option A'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              setState(() => _lastAction = 'Tapped Option B');
              Navigator.pop(ctx);
            },
            child: const Text('Option B'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              setState(() => _lastAction = 'Tapped Delete ❌');
              Navigator.pop(ctx);
            },
            child: const Text('Delete'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            setState(() => _lastAction = 'Cancelled');
            Navigator.pop(ctx);
          },
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  void _showCupertinoActionSheet() {
    showCupertinoDialog<void>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Cupertino Alert Dialog'),
        content: const Text('This is showCupertinoDialog — an iOS-style alert.'),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              setState(() => _lastAction = 'Tapped Cancel');
              Navigator.pop(ctx);
            },
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              setState(() => _lastAction = 'Confirmed!');
              Navigator.pop(ctx);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showMaterialBottom() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Material Bottom Sheet',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              'showModalBottomSheet — the Material Design equivalent.\n'
              'Use this when building a non-iOS app.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() => _lastAction = 'Material sheet confirmed');
                Navigator.pop(ctx);
              },
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cupertino Sheet'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Concept ────────────────────────────────────────────────
          const Text(
            'A Cupertino sheet is an iOS-style modal that slides up from '
            'the bottom. Use showCupertinoModalPopup() with a '
            'CupertinoActionSheet for option lists, or showCupertinoDialog() '
            'for alerts. For Material apps use showModalBottomSheet().',
            style: TextStyle(fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 24),

          const _CodeSection(
            label: 'BAD — building a custom bottom panel with Stack',
            labelColor: Colors.red,
            code: '''// ❌ Manual animation + overlay = lots of code
showGeneralDialog(
  context: context,
  pageBuilder: (_, __, ___) => MyCustomPanel(), // no standard iOS feel
);''',
          ),
          const SizedBox(height: 12),

          const _CodeSection(
            label: 'GOOD — showCupertinoModalPopup + CupertinoActionSheet',
            labelColor: Colors.green,
            code: '''import 'package:flutter/cupertino.dart';

// iOS-style action sheet:
showCupertinoModalPopup<void>(
  context: context,
  builder: (ctx) => CupertinoActionSheet(
    title: const Text('Choose an option'),
    actions: [
      CupertinoActionSheetAction(
        onPressed: () => Navigator.pop(ctx, 'A'),
        child: const Text('Option A'),
      ),
      CupertinoActionSheetAction(
        isDestructiveAction: true,  // renders in red
        onPressed: () => Navigator.pop(ctx, 'delete'),
        child: const Text('Delete'),
      ),
    ],
    cancelButton: CupertinoActionSheetAction(
      onPressed: () => Navigator.pop(ctx),
      child: const Text('Cancel'),
    ),
  ),
);

// iOS-style alert dialog:
showCupertinoDialog(
  context: context,
  builder: (ctx) => CupertinoAlertDialog(
    title: const Text('Are you sure?'),
    actions: [
      CupertinoDialogAction(child: const Text('Cancel'),
          onPressed: () => Navigator.pop(ctx)),
      CupertinoDialogAction(isDestructiveAction: true,
          child: const Text('Delete'),
          onPressed: () => Navigator.pop(ctx)),
    ],
  ),
);''',
          ),
          const SizedBox(height: 24),

          // ── Live demo ─────────────────────────────────────────────
          const Text('Live Demo',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: _SheetType.values.map((t) {
              return ChoiceChip(
                label: Text(t.label),
                selected: _selectedType == t,
                selectedColor: Colors.blue.shade100,
                onSelected: (_) => setState(() => _selectedType = t),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                Row(children: [
                  const Icon(Icons.touch_app, color: Colors.blue),
                  const SizedBox(width: 8),
                  const Text('Last action:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Text(_lastAction,
                      style: const TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold)),
                ]),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.keyboard_arrow_up),
                    label: Text('Show ${_selectedType.label}'),
                    onPressed: _showSheet,
                  ),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 24),

          const _TipCard(
            tip: 'Use Cupertino widgets (showCupertinoModalPopup, '
                'CupertinoActionSheet) when you want an iOS look on all '
                'platforms. Use showModalBottomSheet() for a Material look. '
                'Both accept a builder — return the sheet widget from it.',
          ),
        ],
      ),
    );
  }
}

enum _SheetType {
  modal('Cupertino Action Sheet'),
  actionSheet('Cupertino Alert Dialog'),
  materialBottom('Material Bottom Sheet');

  final String label;
  const _SheetType(this.label);
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
              child: Text(tip,
                  style: const TextStyle(fontSize: 14, height: 1.5))),
        ]),
      ),
    );
  }
}
