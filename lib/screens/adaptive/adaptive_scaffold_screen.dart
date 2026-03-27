// Adaptive scaffold: one layout for mobile (navigation), another for tablet/desktop (side-by-side)

import 'package:flutter/material.dart';

// Sample data
const _articles = [
  _Article(
    title: 'What is Flutter?',
    body:
        'Flutter is Google\'s UI toolkit for building natively compiled applications '
        'for mobile, web, and desktop from a single codebase. It uses the Dart '
        'programming language and provides its own rendering engine.',
  ),
  _Article(
    title: 'Widgets are everything',
    body:
        'In Flutter, almost everything is a widget — layouts, padding, alignment, '
        'gestures, themes. Widgets compose into a tree that Flutter traverses to '
        'build the UI.',
  ),
  _Article(
    title: 'Hot reload saves time',
    body:
        'Flutter\'s hot reload injects updated source files into the running Dart '
        'VM. The framework automatically rebuilds the widget tree, letting you see '
        'changes in under a second without losing app state.',
  ),
  _Article(
    title: 'State management',
    body:
        'Flutter has many state management approaches: setState, InheritedWidget, '
        'Provider, Riverpod, Bloc, and more. Choose based on complexity — '
        'setState is fine for local state, pick a package for shared state.',
  ),
  _Article(
    title: 'Adaptive & Responsive',
    body:
        'A responsive app adjusts its layout to screen size. An adaptive app also '
        'changes its behaviour per platform (touch vs mouse, iOS vs Android). '
        'Flutter supports both with LayoutBuilder, MediaQuery, and platform checks.',
  ),
];

class _Article {
  final String title;
  final String body;
  const _Article({required this.title, required this.body});
}

// ── Main screen ───────────────────────────────────────────────────────────────

class AdaptiveScaffoldScreen extends StatefulWidget {
  const AdaptiveScaffoldScreen({super.key});

  @override
  State<AdaptiveScaffoldScreen> createState() => _AdaptiveScaffoldScreenState();
}

class _AdaptiveScaffoldScreenState extends State<AdaptiveScaffoldScreen> {
  int? _selectedIndex; // null = nothing selected yet

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adaptive Scaffold'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: LayoutBuilder(
        // LayoutBuilder gives us the available width/height via `constraints`
        builder: (context, constraints) {
          // If the screen is 600dp or wider, treat it as tablet/desktop
          final isWide = constraints.maxWidth >= 600;

          if (isWide) {
            // TABLET/DESKTOP layout:
            // Show list on the LEFT and article content on the RIGHT at the same time
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left side — fixed 260dp wide list
                SizedBox(
                  width: 260,
                  child: _ArticleList(
                    selectedIndex: _selectedIndex,
                    // Tapping an article just updates _selectedIndex (no navigation)
                    onTap: (i) => setState(() => _selectedIndex = i),
                  ),
                ),
                const VerticalDivider(width: 1),
                // Right side — fills the rest of the screen
                Expanded(
                  child: _selectedIndex == null
                      ? const _Placeholder() // shown before any article is tapped
                      : _ArticleDetail(article: _articles[_selectedIndex!]),
                ),
              ],
            );
          } else {
            // MOBILE layout:
            // Show ONLY the list. Tapping an article pushes a new full screen.
            return _ArticleList(
              selectedIndex: null, // no highlight needed on mobile
              onTap: (i) {
                // Navigator.push opens a new screen on top (like going to a new page)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => _ArticleDetailScreen(article: _articles[i]),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

// ── Article list ──────────────────────────────────────────────────────────────

class _ArticleList extends StatelessWidget {
  final int? selectedIndex;
  final ValueChanged<int> onTap;

  const _ArticleList({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _articles.length,
      itemBuilder: (context, i) {
        final selected = selectedIndex == i;
        return ListTile(
          selected: selected,
          selectedTileColor: Colors.blue.shade50,
          leading: CircleAvatar(child: Text('${i + 1}')),
          title: Text(_articles[i].title),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => onTap(i),
        );
      },
    );
  }
}

// ── Article detail (inline, for tablet) ───────────────────────────────────────

class _ArticleDetail extends StatelessWidget {
  final _Article article;
  const _ArticleDetail({required this.article});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            article.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(article.body, style: const TextStyle(fontSize: 16, height: 1.6)),
        ],
      ),
    );
  }
}

// ── Placeholder shown on tablet when nothing is selected ──────────────────────

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.article_outlined, size: 64, color: Colors.black26),
          SizedBox(height: 12),
          Text('Select an article', style: TextStyle(color: Colors.black38)),
        ],
      ),
    );
  }
}

// ── Full-screen detail page pushed on mobile ──────────────────────────────────

class _ArticleDetailScreen extends StatelessWidget {
  final _Article article;
  const _ArticleDetailScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(article.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Text(
          article.body,
          style: const TextStyle(fontSize: 16, height: 1.6),
        ),
      ),
    );
  }
}
