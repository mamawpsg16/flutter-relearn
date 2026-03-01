import 'package:flutter/material.dart';
import 'contact/contact_screen.dart';

/// App configuration widget.
/// Single Responsibility: ONLY handles theme and routing — no business logic here.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ContactScreen(),
    );
  }
}
