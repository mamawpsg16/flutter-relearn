import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// OPTIMISTIC STATE
//
// Normal flow:  tap button → wait for network → update UI
// Optimistic:   tap button → update UI immediately → network runs in background
//               if network fails → revert UI back
//
// Real examples: Like button, Subscribe button, Follow button, delete item
// ═══════════════════════════════════════════════════════════════════════════════

class OptimisticStateScreen extends StatefulWidget {
  const OptimisticStateScreen({super.key});

  @override
  State<OptimisticStateScreen> createState() => _OptimisticStateScreenState();
}

class _OptimisticStateScreenState extends State<OptimisticStateScreen> {
  // ── Demo 1: Subscribe button ───────────────────────────────────────────────
  bool _isSubscribed = false;
  bool _subscribeLoading = false;

  // ── Demo 2: Like button (with simulated failure) ───────────────────────────
  int _likeCount = 142;
  bool _isLiked = false;
  bool _shouldFail = false; // toggle to simulate network failure

  // ── Demo 3: Delete item ────────────────────────────────────────────────────
  final List<String> _items = ['Flutter basics', 'MVVM pattern', 'Supabase setup'];
  bool _deleteShouldFail = false;

  // ── Subscribe: optimistic update ──────────────────────────────────────────
  Future<void> _toggleSubscribe() async {
    final previous = _isSubscribed;

    // Step 1: update UI immediately (optimistic)
    setState(() {
      _isSubscribed = !_isSubscribed;
      _subscribeLoading = true;
    });

    try {
      // Step 2: run the real network call in background
      await Future.delayed(const Duration(seconds: 2));
      // success — keep the optimistic state
    } catch (_) {
      // Step 3: revert if it fails
      setState(() => _isSubscribed = previous);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to subscribe — reverted')),
        );
      }
    } finally {
      if (mounted) setState(() => _subscribeLoading = false);
    }
  }

  // ── Like: with optional simulated failure ─────────────────────────────────
  Future<void> _toggleLike() async {
    final previousLiked = _isLiked;
    final previousCount = _likeCount;

    // Optimistic update
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });

    try {
      await Future.delayed(const Duration(milliseconds: 1500));
      if (_shouldFail) throw Exception('Network error');
    } catch (_) {
      // Revert both the liked state and the count
      setState(() {
        _isLiked = previousLiked;
        _likeCount = previousCount;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Like failed — reverted'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ── Delete: optimistic removal ────────────────────────────────────────────
  Future<void> _deleteItem(String item) async {
    // Optimistic: remove from list immediately
    setState(() => _items.remove(item));

    try {
      await Future.delayed(const Duration(seconds: 1));
      if (_deleteShouldFail) throw Exception('Delete failed');
    } catch (_) {
      // Revert: put the item back
      setState(() => _items.add(item));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not delete "$item" — restored'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Optimistic State'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Optimistic state updates the UI immediately before the network '
              'call finishes. If the call succeeds, nothing changes. '
              'If it fails, the UI reverts. Users perceive the app as faster.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 20),

            _CodeSection(
              label: 'BAD — waits for network before updating UI (feels slow)',
              labelColor: Colors.red,
              code: '''Future<void> toggleSubscribe() async {
  setState(() => _isLoading = true);
  await api.subscribe(); // user waits here... 👎
  setState(() {
    _isSubscribed = true;
    _isLoading = false;
  });
}''',
            ),
            const SizedBox(height: 12),
            _CodeSection(
              label: 'GOOD — update UI first, revert on failure',
              labelColor: Colors.green,
              code: '''Future<void> toggleSubscribe() async {
  final previous = _isSubscribed;

  // 1. Update UI immediately — feels instant 👍
  setState(() => _isSubscribed = !_isSubscribed);

  try {
    await api.subscribe(); // runs in background
    // success — keep the optimistic state
  } catch (_) {
    // 2. Revert if network fails
    setState(() => _isSubscribed = previous);
    showSnackBar('Failed — reverted');
  }
}''',
            ),
            const SizedBox(height: 24),

            const Text(
              'Live Demos',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // ── Demo 1: Subscribe ────────────────────────────────────────
            _DemoCard(
              title: 'Subscribe button',
              subtitle: 'UI updates instantly, network runs for 2s in background',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: ElevatedButton.icon(
                      onPressed: _subscribeLoading ? null : _toggleSubscribe,
                      icon: _subscribeLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(_isSubscribed
                              ? Icons.notifications_active
                              : Icons.notifications_none),
                      label: Text(_isSubscribed ? 'Subscribed' : 'Subscribe'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isSubscribed ? Colors.green : null,
                        foregroundColor:
                            _isSubscribed ? Colors.white : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ── Demo 2: Like with failure toggle ─────────────────────────
            _DemoCard(
              title: 'Like button (with failure simulation)',
              subtitle: 'Toggle "Simulate failure" to see the revert in action',
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: _toggleLike,
                        icon: Icon(
                          _isLiked ? Icons.favorite : Icons.favorite_border,
                          color: _isLiked ? Colors.red : Colors.grey,
                          size: 32,
                        ),
                      ),
                      Text(
                        '$_likeCount',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Simulate failure',
                          style: TextStyle(fontSize: 13)),
                      Switch(
                        value: _shouldFail,
                        onChanged: (v) => setState(() => _shouldFail = v),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ── Demo 3: Delete item ──────────────────────────────────────
            _DemoCard(
              title: 'Delete item (optimistic removal)',
              subtitle: 'Item disappears instantly — restored if network fails',
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Simulate failure',
                          style: TextStyle(fontSize: 13)),
                      Switch(
                        value: _deleteShouldFail,
                        onChanged: (v) =>
                            setState(() => _deleteShouldFail = v),
                      ),
                    ],
                  ),
                  ..._items.map((item) => ListTile(
                        dense: true,
                        title: Text(item),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.red),
                          onPressed: () => _deleteItem(item),
                        ),
                      )),
                  if (_items.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('All items deleted',
                          style: TextStyle(color: Colors.grey)),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const _TipCard(
              tip:
                  'Always save the previous state before applying an optimistic update. '
                  'This is the "snapshot" you revert to if the network call fails. '
                  'Also disable the button while the call is in progress to prevent '
                  'double-taps that would create inconsistent state.',
            ),
          ],
        ),
      ),
    );
  }
}

class _DemoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _DemoCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _CodeSection extends StatelessWidget {
  final String label;
  final Color labelColor;
  final String code;
  const _CodeSection(
      {required this.label, required this.labelColor, required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(12),
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
                  color: Colors.white,
                  fontFamily: 'monospace',
                  fontSize: 12,
                  height: 1.5)),
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
                child: Text(tip, style: const TextStyle(height: 1.5))),
          ],
        ),
      ),
    );
  }
}
