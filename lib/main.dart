import 'package:flutter/material.dart';
import 'package:flutter_relearn/screens/layout_screen_example.dart';
import 'package:flutter_relearn/screens/list_view_screen.dart';
import 'package:flutter_relearn/screens/shopping_screen.dart';
import './ models/product.dart';
import 'package:flutter_relearn/screens/registration_screen.dart';

void main() {
  return runApp(
    GridViewRun(
      items: [
        {'name': 'Apples', 'description': 'Fresh red apples'},
        {'name': 'Bananas', 'description': 'Ripe yellow bananas'},
        {'name': 'Oranges', 'description': 'Juicy oranges'},
        {'name': 'Milk', 'description': '1% milk'},
        {'name': 'Bread', 'description': 'Whole wheat bread'},
        {'name': 'Apples', 'description': 'Fresh red apples'},
        {'name': 'Bananas', 'description': 'Ripe yellow bananas'},
        {'name': 'Oranges', 'description': 'Juicy oranges'},
        {'name': 'Milk', 'description': '1% milk'},
        {'name': 'Bread', 'description': 'Whole wheat bread'},
      ],
    ),
  );
}
