import 'package:flutter/material.dart';

class ScrollingScreen extends StatelessWidget {
  const ScrollingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        cardTheme: CardThemeData(color: Colors.blue.shade50),
      ),
      home: Scrollbar(
        child: ListView.builder(
          itemCount: 100,
          itemBuilder: (context, index) => Card(
            child: SizedBox(
              height: 100,
              child: Center(child: Text('Item $index')),
            ),
          ),
        ),
      ),
    );
  }
}
