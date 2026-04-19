import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ---------------------------------------------------------------------------
// Model — used throughout this screen's live demo
// ---------------------------------------------------------------------------
class CartModel extends ChangeNotifier {
  final List<String> _items = [];

  List<String> get items => List.unmodifiable(_items);
  int get totalItems => _items.length;

  void add(String item) {
    _items.add(item);
    notifyListeners();
  }

  void remove(String item) {
    _items.remove(item);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------
class StateManagementScreen extends StatelessWidget {
  const StateManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('State Management'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: const _Body(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _SectionHeader('Our Example'),
        _OurExampleSection(),
        SizedBox(height: 24),
        _SectionHeader('Lifting State Up'),
        _LiftingStateSection(),
        SizedBox(height: 24),
        _SectionHeader('Accessing the State'),
        _AccessingStateSection(),
        SizedBox(height: 24),
        _SectionHeader('ChangeNotifier'),
        _ChangeNotifierSection(),
        SizedBox(height: 24),
        _SectionHeader('ChangeNotifierProvider'),
        _ChangeNotifierProviderSection(),
        SizedBox(height: 24),
        _SectionHeader('Consumer'),
        _ConsumerSection(),
        SizedBox(height: 24),
        _SectionHeader('Provider.of'),
        _ProviderOfSection(),
        SizedBox(height: 24),
        _SectionHeader('Putting it all together'),
        _PuttingItAllTogetherSection(),
        SizedBox(height: 32),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Section header
// ---------------------------------------------------------------------------
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 1. Our Example
// ---------------------------------------------------------------------------
class _OurExampleSection extends StatelessWidget {
  const _OurExampleSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'The Flutter docs use a simple shopping-cart app as the running '
          'example for state management. A catalog screen lets users pick items; '
          'a cart screen shows what\'s been added. The challenge: both screens '
          'need to share the same cart state.',
        ),
        const SizedBox(height: 12),
        _CodeSection(
          label: 'EXAMPLE',
          labelColor: Colors.blue,
          code: '''// Two screens, one shared cart
class CatalogScreen extends Widget { ... }
class CartScreen extends Widget   { ... }

// CartModel must be accessible from both''',
        ),
        const SizedBox(height: 12),
        _TipCard(
          tip: 'State that is needed by multiple screens should live above '
              'all of them in the widget tree — not inside either screen.',
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 2. Lifting State Up
// ---------------------------------------------------------------------------
class _LiftingStateSection extends StatelessWidget {
  const _LiftingStateSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'When two widgets need the same piece of state, move that state to '
          'their closest common ancestor. This is called "lifting state up." '
          'The ancestor owns the data and passes it down via constructors or '
          'a state-management solution.',
        ),
        const SizedBox(height: 12),
        _CodeSection(
          label: 'BAD — state siloed inside widget',
          labelColor: Colors.red,
          code: '''class CatalogScreen extends StatefulWidget {
  // ❌ cart lives inside catalog — CartScreen can't see it
  final List<String> _cart = [];
}''',
        ),
        const SizedBox(height: 8),
        _CodeSection(
          label: 'GOOD — state lifted to common ancestor',
          labelColor: Colors.green,
          code: '''class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(   // ✅ above both screens
      create: (_) => CartModel(),
      child: MaterialApp(...),
    );
  }
}''',
        ),
        const SizedBox(height: 12),
        _TipCard(
          tip: 'Lift state up only as far as needed. Lifting too high creates '
              'unnecessary rebuilds. Provider scopes help keep it surgical.',
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 3. Accessing the State
// ---------------------------------------------------------------------------
class _AccessingStateSection extends StatelessWidget {
  const _AccessingStateSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Once the state is above the widgets that need it, you have two '
          'main ways to read it: Consumer (rebuilds on change) and Provider.of '
          'with listen: false (read once, no rebuild). Choose the right tool '
          'to avoid unnecessary widget rebuilds.',
        ),
        const SizedBox(height: 12),
        _CodeSection(
          label: 'TWO ACCESS PATTERNS',
          labelColor: Colors.blue,
          code: '''// 1. Consumer — rebuilds when model changes
Consumer<CartModel>(
  builder: (ctx, cart, child) => Text('\${cart.totalItems} items'),
)

// 2. Provider.of — one-time read, no rebuild
final cart = Provider.of<CartModel>(context, listen: false);
cart.add('Apple');''',
        ),
        const SizedBox(height: 12),
        _TipCard(
          tip: 'Use Consumer to display reactive data. Use Provider.of with '
              'listen: false inside callbacks and initState where you only '
              'need to call a method, not watch for changes.',
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 4. ChangeNotifier
// ---------------------------------------------------------------------------
class _ChangeNotifierSection extends StatelessWidget {
  const _ChangeNotifierSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ChangeNotifier is a class from the Flutter SDK that provides change '
          'notification to its listeners. It\'s the "model" in the Provider '
          'pattern. Call notifyListeners() whenever the state changes to trigger '
          'a rebuild in all listening widgets.',
        ),
        const SizedBox(height: 12),
        _CodeSection(
          label: 'ChangeNotifier MODEL',
          labelColor: Colors.green,
          code: '''class CartModel extends ChangeNotifier {
  final List<String> _items = [];

  List<String> get items => List.unmodifiable(_items);
  int get totalItems => _items.length;

  void add(String item) {
    _items.add(item);
    notifyListeners(); // ← tells listeners to rebuild
  }

  void remove(String item) {
    _items.remove(item);
    notifyListeners();
  }
}''',
        ),
        const SizedBox(height: 12),
        _TipCard(
          tip: 'Keep business logic inside ChangeNotifier — not in widgets. '
              'Expose state via getters and mutate only through methods that '
              'call notifyListeners().',
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 5. ChangeNotifierProvider
// ---------------------------------------------------------------------------
class _ChangeNotifierProviderSection extends StatelessWidget {
  const _ChangeNotifierProviderSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ChangeNotifierProvider is the widget that makes a ChangeNotifier '
          'available to all descendants. Place it above the widgets that need '
          'it. It creates the model, provides it down the tree, and disposes '
          'it automatically when the provider is removed.',
        ),
        const SizedBox(height: 12),
        _CodeSection(
          label: 'USAGE',
          labelColor: Colors.green,
          code: '''void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: const MyApp(),
    ),
  );
}

// For multiple models use MultiProvider:
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => CartModel()),
    ChangeNotifierProvider(create: (_) => UserModel()),
  ],
  child: const MyApp(),
)''',
        ),
        const SizedBox(height: 12),
        _TipCard(
          tip: 'Prefer ChangeNotifierProvider.value only when the model is '
              'already created elsewhere (e.g., passed into a route). The '
              'standard create: form manages the model\'s lifecycle for you.',
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 6. Consumer
// ---------------------------------------------------------------------------
class _ConsumerSection extends StatelessWidget {
  const _ConsumerSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Consumer<T> subscribes to a ChangeNotifier and rebuilds its builder '
          'whenever notifyListeners() is called. Wrap only the smallest widget '
          'that needs the data to minimise rebuild cost.',
        ),
        const SizedBox(height: 12),
        _CodeSection(
          label: 'BAD — rebuilds too much',
          labelColor: Colors.red,
          code: '''// ❌ The entire page rebuilds on every cart change
Consumer<CartModel>(
  builder: (ctx, cart, child) => Scaffold(
    appBar: AppBar(title: Text('Shop')),
    body: HugeCatalogWidget(), // doesn't use cart!
    floatingActionButton: Text('\${cart.totalItems}'),
  ),
)''',
        ),
        const SizedBox(height: 8),
        _CodeSection(
          label: 'GOOD — minimal rebuild with child param',
          labelColor: Colors.green,
          code: '''// ✅ Only the badge text rebuilds; HugeCatalogWidget is stable
Consumer<CartModel>(
  builder: (ctx, cart, child) => Stack(
    children: [
      child!,                          // passed in, never rebuilt
      CartBadge(count: cart.totalItems),
    ],
  ),
  child: const HugeCatalogWidget(),   // built once
)''',
        ),
        const SizedBox(height: 12),
        // Live demo
        const _ConsumerDemo(),
        const SizedBox(height: 12),
        _TipCard(
          tip: 'Use the child parameter of Consumer for subtrees that do NOT '
              'depend on the model — they are built once and reused, saving '
              'unnecessary rebuilds.',
        ),
      ],
    );
  }
}

class _ConsumerDemo extends StatelessWidget {
  const _ConsumerDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.deepPurple.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Live Demo — Consumer',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade700)),
          const SizedBox(height: 8),
          Consumer<CartModel>(
            builder: (ctx, cart, child) => Text(
              'Cart has ${cart.totalItems} item(s)',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
              Provider.of<CartModel>(context, listen: false).add('Apple');
            },
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('Add "Apple" via Provider.of'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 7. Provider.of
// ---------------------------------------------------------------------------
class _ProviderOfSection extends StatelessWidget {
  const _ProviderOfSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Provider.of<T>(context) is the low-level API. With listen: true '
          '(default) it subscribes and rebuilds; with listen: false it reads '
          'the model once without subscribing. Use listen: false in callbacks '
          'or places where you only need to call a method.',
        ),
        const SizedBox(height: 12),
        _CodeSection(
          label: 'listen: true vs listen: false',
          labelColor: Colors.blue,
          code: '''// Subscribes — widget rebuilds on change
final cart = Provider.of<CartModel>(context);
Text('\${cart.totalItems} items');

// Read-only — no rebuild subscription
// Safe inside onPressed, initState, etc.
onPressed: () {
  final cart = Provider.of<CartModel>(context, listen: false);
  cart.add('Book');
}''',
        ),
        const SizedBox(height: 12),
        _TipCard(
          tip: 'If you only call a method and don\'t display data, always pass '
              'listen: false. Forgetting it causes the button\'s parent widget '
              'to rebuild on every model change — a subtle performance bug.',
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 8. Putting it all together — full interactive demo
// ---------------------------------------------------------------------------
class _PuttingItAllTogetherSection extends StatelessWidget {
  const _PuttingItAllTogetherSection();

  static const _catalog = ['Apple', 'Banana', 'Mango', 'Orange', 'Grapes'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Here is the complete pattern in action. A catalog list and a cart '
          'summary share a single CartModel provided by ChangeNotifierProvider. '
          'The catalog uses Provider.of (listen: false) to mutate; the cart '
          'badge and list use Consumer to reactively display.',
        ),
        const SizedBox(height: 12),
        _CodeSection(
          label: 'ARCHITECTURE',
          labelColor: Colors.green,
          code: '''ChangeNotifierProvider(      // ← provides CartModel
  create: (_) => CartModel(),
  child: Column(
    children: [
      // Reads reactively
      Consumer<CartModel>(
        builder: (_, cart, __) => CartBadge(cart.totalItems),
      ),
      // Writes without subscribing
      ElevatedButton(
        onPressed: () =>
          Provider.of<CartModel>(ctx, listen: false).add(item),
        child: Text('Add'),
      ),
    ],
  ),
)''',
        ),
        const SizedBox(height: 16),
        // Live interactive demo
        Container(
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.deepPurple.shade200),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cart summary (Consumer — reactive)
              Consumer<CartModel>(
                builder: (ctx, cart, _) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.shopping_cart,
                            color: Colors.deepPurple),
                        const SizedBox(width: 8),
                        Text(
                          'Cart (${cart.totalItems})',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const Spacer(),
                        if (cart.totalItems > 0)
                          TextButton(
                            onPressed: () =>
                                Provider.of<CartModel>(ctx, listen: false)
                                    .clear(),
                            child: const Text('Clear',
                                style: TextStyle(color: Colors.red)),
                          ),
                      ],
                    ),
                    if (cart.items.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Text('Empty — add some items below',
                            style: TextStyle(color: Colors.grey)),
                      )
                    else
                      Wrap(
                        spacing: 6,
                        children: cart.items
                            .map((item) => Chip(
                                  label: Text(item),
                                  onDeleted: () =>
                                      Provider.of<CartModel>(ctx, listen: false)
                                          .remove(item),
                                  deleteIconColor: Colors.red,
                                ))
                            .toList(),
                      ),
                  ],
                ),
              ),
              const Divider(height: 24),
              // Catalog (Provider.of listen:false for writes)
              Text('Catalog',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple.shade700)),
              const SizedBox(height: 8),
              ..._catalog.map(
                (item) => _CatalogTile(item: item),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _TipCard(
          tip: 'ChangeNotifier + ChangeNotifierProvider + Consumer + Provider.of '
              'is the "simple app state management" approach from the Flutter docs. '
              'It covers most use-cases without extra complexity.',
        ),
      ],
    );
  }
}

class _CatalogTile extends StatelessWidget {
  final String item;
  const _CatalogTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartModel>(
      builder: (ctx, cart, _) {
        final inCart = cart.items.contains(item);
        return ListTile(
          dense: true,
          leading: Icon(
            inCart ? Icons.check_circle : Icons.circle_outlined,
            color: inCart ? Colors.green : Colors.grey,
          ),
          title: Text(item),
          trailing: inCart
              ? TextButton(
                  onPressed: () =>
                      Provider.of<CartModel>(ctx, listen: false).remove(item),
                  child: const Text('Remove',
                      style: TextStyle(color: Colors.red)),
                )
              : ElevatedButton(
                  onPressed: () =>
                      Provider.of<CartModel>(ctx, listen: false).add(item),
                  child: const Text('Add'),
                ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Shared private widgets
// ---------------------------------------------------------------------------
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  color: labelColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12)),
          const SizedBox(height: 8),
          Text(
            code,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'monospace',
              fontSize: 12,
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
              child: Text(tip,
                  style: const TextStyle(color: Colors.black87)),
            ),
          ],
        ),
      ),
    );
  }
}
