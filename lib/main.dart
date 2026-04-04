import 'package:flutter/material.dart';
import 'package:flutter_relearn/screens/adaptive/adaptive_home.dart';
import 'package:flutter_relearn/screens/navigation/hands_on_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(                          // ← const removed
      debugShowCheckedModeBanner: false,
      home: const AdaptiveHome(),         // ← const moved here
      routes: {
        '/first':  (ctx) => const HandsOnScreen(),
        '/second': (ctx) => const SecondScreen(),
      },
    ),
  );
}
