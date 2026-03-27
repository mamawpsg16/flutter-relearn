import 'package:flutter/material.dart';
import '../../ models/product.dart';

class ShoppingListItem extends StatelessWidget {
  final Product product;
  final bool inCart;
  final void Function(Product product, bool inCart) onCartChanged;
  ShoppingListItem({
    required this.product,
    required this.inCart,
    required this.onCartChanged,
  }) : super(key: ObjectKey(product));

  @override
  Widget build(BuildContext context) {
    return Container(
      color: inCart ? Colors.green[100] : Colors.white,
      child: ListTile(
        onTap: () => onCartChanged(product, !inCart),
        leading: CircleAvatar(
          backgroundColor: inCart ? Colors.black54 : null,
          child: Text(product.name[0]),
        ),
        title: Text(
          product.name,
          style: TextStyle(
            fontSize: 16.0,
            decoration: inCart ? TextDecoration.lineThrough : null,
          ),
        ),
      ),
    );
  }
}

class ShoppingList extends StatefulWidget {
  final List<Product> products;
  const ShoppingList({super.key, required this.products});

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class ShoppingRunApp extends StatelessWidget {
  const ShoppingRunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: ShoppingList(
        products: [
          Product(name: 'Apples'),
          Product(name: 'Bananas'),
          Product(name: 'Milk'),
          Product(name: 'Bread'),
        ],
      ),
    );
  }
}

class _ShoppingListState extends State<ShoppingList> {
  final _shoppingCart = <Product>[];

  void _handleCartChanged(Product product, bool inCart) {
    setState(() {
      if (inCart) {
        _shoppingCart.add(product);
      } else {
        _shoppingCart.remove(product);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shopping List')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: widget.products.map((Product product) {
          return ShoppingListItem(
            product: product,
            inCart: _shoppingCart.contains(product),
            onCartChanged: _handleCartChanged,
          );
        }).toList(),
      ),
    );
  }
}
