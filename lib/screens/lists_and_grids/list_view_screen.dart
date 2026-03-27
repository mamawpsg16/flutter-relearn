import 'dart:ui';
import 'package:flutter/material.dart';

class CartList extends StatelessWidget {
  final List<Map<String, String>> items;

  const CartList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          leading: const Icon(Icons.shopping_cart),
          title: Text(item['name']!),
          subtitle: Text(item['description']!),
          onTap: () => print('Tapped on ${item['name']}'),
        );
      },
    );
  }
}

class VerticalListViewRun extends StatelessWidget {
  const VerticalListViewRun({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ListView Example',
      home: Scaffold(
        appBar: AppBar(title: const Text('ListView Example')),
        body: const CartList(
          items: [
            {'name': 'Apples', 'description': 'Fresh red apples'},
            {'name': 'Bananas', 'description': 'Ripe yellow bananas'},
            {'name': 'Oranges', 'description': 'Juicy oranges'},
            {'name': 'Milk', 'description': '1% milk'},
            {'name': 'Bread', 'description': 'Whole wheat bread'},
          ],
        ),
      ),
    );
  }
}

class HorizontalListViewRun extends StatelessWidget {
  const HorizontalListViewRun({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Horizontal list';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(title: const Text(title)),
        body: Center(
          child: Container(
            alignment: Alignment.center,
            height: 300,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final color in Colors.primaries)
                  Container(width: 160, color: color),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GridViewRun extends StatefulWidget {
  final List<Map<String, String>> items;
  const GridViewRun({super.key, required this.items});
  @override
  State<GridViewRun> createState() => _GridViewRunState();
}

class _GridViewRunState extends State<GridViewRun> {
  @override
  Widget build(BuildContext context) {
    const title = 'Grid view';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(title: const Text(title)),
        body: GridView.count(
          crossAxisCount: 2,
          children: widget.items.map((item) {
            return Container(
              alignment: Alignment.center,
              color: Colors.blue[100],
              child: Text(item['name']!),
            );
          }).toList(),
        ),
      ),
    );
  }
}
