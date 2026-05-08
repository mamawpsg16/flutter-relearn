import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ── Model ────────────────────────────────────────────────────────────────────

class CartModel extends ChangeNotifier {
  // Map<item, qty> — tracks quantity per item
  // Example: {"Shoes": 2, "Hat": 1} instead of ["Shoes", "Shoes", "Hat"]
  final Map<String, int> _items = {};

  // Unmodifiable — outside can read but not mutate directly
  Map<String, int> get items => Map.unmodifiable(_items);

  // Derived — total qty across all items: {Shoes:2, Hat:1} → 3
  int get totalItems => _items.values.fold(0, (sum, qty) => sum + qty);

  // Add or increment — if "Shoes" exists add 1, else start at 1
  // Before: {"Hat": 1}
  // add("Shoes") →  {"Hat": 1, "Shoes": 1}
  // add("Shoes") →  {"Hat": 1, "Shoes": 2}
  void add(String item) {
    _items[item] = (_items[item] ?? 0) + 1;
    notifyListeners(); // tell all Consumer/context.watch to rebuild
  }

  // Decrement — if qty hits 0, remove item entirely
  // Before: {"Shoes": 2}
  // decrement("Shoes") → {"Shoes": 1}
  // decrement("Shoes") → {}  (removed)
  void decrement(String item) {
    if (!_items.containsKey(item)) return;
    if (_items[item]! <= 1) {
      _items.remove(item);
    } else {
      _items[item] = _items[item]! - 1;
    }
    notifyListeners();
  }

  // Remove whole item regardless of qty
  // Before: {"Shoes": 5, "Hat": 1}
  // remove("Shoes") → {"Hat": 1}
  void remove(String item) {
    _items.remove(item);
    notifyListeners();
  }

  // Wipe everything
  // Before: {"Shoes": 2, "Hat": 1}
  // clear() → {}
  void clear() {
    _items.clear();
    notifyListeners();
  }
}

// ── Screen ───────────────────────────────────────────────────────────────────

class ProviderScreen extends StatelessWidget {
  const ProviderScreen({super.key});

  // item → price map
  static const _products = {
    'Shoes': 59.99,
    'Shirt': 24.99,
    'Hat': 14.99,
    'Bag': 39.99,
    'Watch': 89.99,
  };

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartModel(), // creates CartModel, disposes when screen pops
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Provider — Shopping Cart'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            // Consumer with child:
            // - child (Icon) built ONCE, never rebuilt even when cart changes
            // - builder runs every time CartModel calls notifyListeners()
            // - child! passed into builder so it can be reused
            Consumer<CartModel>(
              child: const Icon(Icons.shopping_cart, color: Colors.white), // built once
              builder: (context, cart, child) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    child!, // reuse pre-built icon — no rebuild
                    if (cart.totalItems > 0)
                      Positioned(
                        top: 8,
                        right: 0,
                        child: CircleAvatar(
                          radius: 8,
                          backgroundColor: Colors.red,
                          // only this Text rebuilds when totalItems changes
                          child: Text(
                            '${cart.totalItems}',
                            style: const TextStyle(
                                fontSize: 10, color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(12),
              child: _CodeSection(
                label: 'Key patterns used in this screen',
                labelColor: Colors.deepPurple,
                code: '''
// Map<String,int> = item→qty, better than List<String>
// {"Shoes": 2, "Hat": 1}  not  ["Shoes","Shoes","Hat"]

// Consumer child = built once, passed into builder
Consumer<CartModel>(
  child: Icon(Icons.cart),     // never rebuilds
  builder: (ctx, cart, child) => Stack(
    children: [child!, Text(cart.totalItems)],
  ),
)

// context.read = action, no rebuild (use in callbacks)
// context.watch = subscribe, whole widget rebuilds
onPressed: () => context.read<CartModel>().add(item)''',
              ),
            ),

            // Product list — iterate Map entries (name, price)
            Expanded(
              child: ListView(
                children: _products.entries.map((entry) {
                  final name = entry.key;
                  final price = entry.value;
                  return Consumer<CartModel>(
                    builder: (context, cart, child) {
                      final qty = cart.items[name] ?? 0;
                      return ListTile(
                        leading: const Icon(Icons.inventory_2_outlined),
                        title: Text(name),
                        subtitle: Text('\$${price.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.green)),
                        trailing: qty == 0
                            ? ElevatedButton(
                                onPressed: () =>
                                    context.read<CartModel>().add(name),
                                child: const Text('Add'),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline),
                                    onPressed: () =>
                                        context.read<CartModel>().decrement(name),
                                  ),
                                  Text('$qty',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () =>
                                        context.read<CartModel>().add(name),
                                  ),
                                ],
                              ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),

            // Cart summary — Consumer wraps only this section
            // Scaffold/AppBar/ListView above do NOT rebuild when cart changes
            Consumer<CartModel>(
              builder: (context, cart, child) => Container(
                width: double.infinity,
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cart (${cart.totalItems} items)',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    if (cart.items.isEmpty)
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
                      ...cart.items.entries.map((entry) {
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
                                onTap: () => context.read<CartModel>().remove(entry.key),
                                child: const Icon(Icons.delete_outline,
                                    size: 16, color: Colors.red),
                              ),
                            ],
                          ),
                        );
                      }),
                      const Divider(),
                      // Total = sum of (price × qty) for each item
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            '\$${cart.items.entries.fold(0.0, (sum, e) => sum + (_products[e.key] ?? 0) * e.value).toStringAsFixed(2)}',
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
                          onPressed: () => context.read<CartModel>().clear(),
                          child: const Text('Clear Cart'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
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
