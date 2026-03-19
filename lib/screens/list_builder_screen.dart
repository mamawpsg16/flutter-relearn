import 'package:flutter/material.dart';

class RunListBuildScreenApp extends StatelessWidget {
  const RunListBuildScreenApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'List builder';
    final items = List<ListItem>.generate(
      1000,
      (i) => i % 6 == 0
          ? HeadingItem('Heading $i')
          : MessageItem('Sender $i', 'Message body $i'),
    );
    return MaterialApp(
      title: title,
      home: ListBuilderScreen(items: items, title: title),
    );
  }
}

abstract class ListItem {
  Widget buildTitle(BuildContext context);
  Widget buildSubtitle(BuildContext context);
}

class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);

  @override
  Widget buildSubtitle(BuildContext context) => const SizedBox.shrink();

  @override
  Widget buildTitle(BuildContext context) =>
      Text(heading, style: Theme.of(context).textTheme.headlineMedium);
}

class MessageItem implements ListItem {
  final String sender;
  final String body;

  MessageItem(this.sender, this.body);

  @override
  Widget buildSubtitle(BuildContext context) => Text(body);

  @override
  Widget buildTitle(BuildContext context) =>
      Text(sender, style: Theme.of(context).textTheme.titleMedium);
}

class ListBuilderScreen extends StatelessWidget {
  final List<ListItem> items;
  final String title;
  const ListBuilderScreen({
    super.key,
    required this.items,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            title: item.buildTitle(context),
            subtitle: item.buildSubtitle(context),
          );
        },
      ),
    );
  }
}
