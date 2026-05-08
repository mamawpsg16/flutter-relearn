import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── Providers ─────────────────────────────────────────────────────────────────

// Map<item, qty> state — same logic as Provider but with Notifier
// Example state: {"Shoes": 2, "Hat": 1}
final cartProvider =
    NotifierProvider<CartNotifier, Map<String, int>>(CartNotifier.new);

class CartNotifier extends Notifier<Map<String, int>> {
  @override
  Map<String, int> build() => {}; // initial state = empty map

  // Add or increment qty
  // Before: {"Hat": 1}
  // add("Shoes") → {"Hat": 1, "Shoes": 1}
  // add("Shoes") → {"Hat": 1, "Shoes": 2}
  void add(String item) {
    state = {
      ...state,                        // copy existing entries
      item: (state[item] ?? 0) + 1,   // add/increment item
    };
  }

  // Decrement — remove if hits 0
  // Before: {"Shoes": 2}
  // decrement("Shoes") → {"Shoes": 1}
  // decrement("Shoes") → {}
  void decrement(String item) {
    if (!state.containsKey(item)) return;
    if (state[item]! <= 1) {
      final newState = Map<String, int>.from(state);
      newState.remove(item);
      state = newState;
    } else {
      state = {...state, item: state[item]! - 1};
    }
  }

  // Remove whole item regardless of qty
  void remove(String item) {
    final newState = Map<String, int>.from(state);
    newState.remove(item);
    state = newState;
  }

  // Wipe all
  void clear() => state = {};
}

// Derived provider — auto-recomputes when cartProvider changes
// Before: {"Shoes": 2, "Hat": 1} → total = 3
// Riverpod recalculates this whenever cart state changes
final cartTotalProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).values.fold(0, (sum, qty) => sum + qty);
});

// ── Screen ────────────────────────────────────────────────────────────────────

class RiverpodScreen extends StatelessWidget {
  const RiverpodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ProviderScope — scopes providers to this subtree
    // In real app, ProviderScope wraps entire app in main.dart
    return const ProviderScope(child: _RiverpodBody());
  }
}

class _RiverpodBody extends ConsumerWidget {
  static const _products = {
    'Shoes': 59.99,
    'Shirt': 24.99,
    'Hat': 14.99,
    'Bag': 39.99,
    'Watch': 89.99,
  };

  const _RiverpodBody();

  @override
  // WidgetRef ref — like context but for Riverpod
  // ref.watch = subscribe (rebuild on change)
  // ref.read  = one-time read, no rebuild (use in callbacks)
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod — Shopping Cart'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Consumer in Riverpod — same concept as Provider's Consumer
          // child = built once, passed into builder for reuse
          Consumer(
            child: const Icon(Icons.shopping_cart, color: Colors.white), // built once
            builder: (context, ref, child) {
              // ref.watch inside Consumer — only this builder reruns
              final total = ref.watch(cartTotalProvider);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    child!, // reuse pre-built icon
                    if (total > 0)
                      Positioned(
                        top: 8,
                        right: 0,
                        child: CircleAvatar(
                          radius: 8,
                          backgroundColor: Colors.red,
                          child: Text(
                            '$total',
                            style: const TextStyle(
                                fontSize: 10, color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(12),
            child: _CodeSection(
              label: 'Riverpod vs Provider key differences',
              labelColor: Colors.teal,
              code: '''
// State = Map<String,int> not List<String>
// {"Shoes": 2, "Hat": 1} — qty per item

// Notifier.state = immutable, always assign new map
state = {...state, item: qty + 1}  // spread + override

// Derived provider — auto-recomputes
final totalProvider = Provider((ref) =>
  ref.watch(cartProvider).values.fold(0, (s, q) => s + q)
);

// ref.read = action (like context.read)
// ref.watch = subscribe (like context.watch)
ref.read(cartProvider.notifier).add(item)
ref.watch(cartTotalProvider)''',
            ),
          ),

          // Product list — iterate Map entries (name, price)
          Expanded(
            child: ListView(
              children: _products.entries.map((entry) {
                final name = entry.key;
                final price = entry.value;
                return Consumer(
                  builder: (context, ref, child) {
                    final qty = ref.watch(cartProvider)[name] ?? 0;
                    return ListTile(
                      leading: const Icon(Icons.inventory_2_outlined),
                      title: Text(name),
                      subtitle: Text('\$${price.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.green)),
                      trailing: qty == 0
                          ? ElevatedButton(
                              onPressed: () =>
                                  ref.read(cartProvider.notifier).add(name),
                              child: const Text('Add'),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () => ref
                                      .read(cartProvider.notifier)
                                      .decrement(name),
                                ),
                                Text('$qty',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () =>
                                      ref.read(cartProvider.notifier).add(name),
                                ),
                              ],
                            ),
                    );
                  },
                );
              }).toList(),
            ),
          ),

          // Cart summary — Consumer wraps only this, not whole screen
          Consumer(
            builder: (context, ref, child) {
              final cart = ref.watch(cartProvider); // Map<String,int>
              final total = ref.watch(cartTotalProvider);
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cart ($total items)',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    if (cart.isEmpty)
                      const Text('Empty — add some items',
                          style: TextStyle(color: Colors.grey))
                    else ...[
                      const Row(
                        children: [
                          Expanded(child: Text('Item',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                          Text('Qty',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          SizedBox(width: 8),
                          SizedBox(width: 60, child: Text('Price',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                              textAlign: TextAlign.right)),
                          SizedBox(width: 24),
                        ],
                      ),
                      const Divider(),
                      ...cart.entries.map((entry) {
                        final price = _products[entry.key] ?? 0;
                        final subtotal = price * entry.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Expanded(child: Text(entry.key)),
                              Text('×${entry.value}',
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 60,
                                child: Text(
                                  '\$${subtotal.toStringAsFixed(2)}',
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(color: Colors.green),
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () => ref
                                    .read(cartProvider.notifier)
                                    .remove(entry.key),
                                child: const Icon(Icons.delete_outline,
                                    size: 16, color: Colors.red),
                              ),
                            ],
                          ),
                        );
                      }),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            '\$${cart.entries.fold(0.0, (sum, e) => sum + (_products[e.key] ?? 0) * e.value).toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () =>
                              ref.read(cartProvider.notifier).clear(),
                          child: const Text('Clear Cart'),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

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
          Text(label,
              style: TextStyle(
                  color: labelColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12)),
          const SizedBox(height: 8),
          Text(code,
              style: const TextStyle(
                  color: Colors.white, fontFamily: 'monospace', fontSize: 11)),
        ],
      ),
    );
  }
}
