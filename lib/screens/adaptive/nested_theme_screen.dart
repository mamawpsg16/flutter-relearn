// Nested Theme — simple demo showing Theme.of(context) in action

import 'package:flutter/material.dart';

class NestedThemeScreen extends StatelessWidget {
  const NestedThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nested Theme'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Box 1 — no Theme override, walks up and finds MaterialApp's Theme
            _ThemedBox(label: 'Box 1 — App default Theme'),

            const SizedBox(height: 16),

            // Box 2 — wrapped in a red Theme, so Theme.of(context) returns red
            Theme(
              data: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
              ),
              child: _ThemedBox(label: 'Box 2 — Red Theme override'),
            ),

            const SizedBox(height: 16),

            // Box 3 — wrapped in a green Theme
            Theme(
              data: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
              ),
              child: _ThemedBox(label: 'Box 3 — Green Theme override'),
            ),
          ],
        ),
      ),
    );
  }
}

// This widget does NOT know what color it will be.
// It just calls Theme.of(context).colorScheme.primary and uses whatever it gets.
class _ThemedBox extends StatelessWidget {
  final String label;
  const _ThemedBox({required this.label});

  @override
  Widget build(BuildContext context) {
    // Walks UP the tree and finds the nearest Theme ancestor
    final color = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            'Theme.of(context).colorScheme.primary = $color',
            style: TextStyle(fontSize: 11, color: color),
          ),
          const SizedBox(height: 8),
          // ElevatedButton also calls Theme.of(context) internally
          ElevatedButton(onPressed: () {}, child: const Text('Button')),
        ],
      ),
    );
  }
}
