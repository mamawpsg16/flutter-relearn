import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeleteDataScreen extends StatefulWidget {
  const DeleteDataScreen({super.key});

  @override
  State<DeleteDataScreen> createState() => _DeleteDataScreenState();
}

class _DeleteDataScreenState extends State<DeleteDataScreen> {
  int _postId = 1;
  String _result = '';
  bool _loading = false;
  bool _isError = false;
  bool _deleted = false;

  Future<void> _doDelete() async {
    setState(() {
      _loading = true;
      _result = '';
      _isError = false;
      _deleted = false;
    });

    try {
      final response = await http.delete(
        Uri.parse('https://jsonplaceholder.typicode.com/posts/$_postId'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      // 200 OK — some APIs return the deleted object
      // 204 No Content — most APIs return nothing on delete
      if (response.statusCode == 200 || response.statusCode == 204) {
        setState(() {
          _deleted = true;
          _result = 'Status: ${response.statusCode} '
              '${response.statusCode == 204 ? "No Content" : "OK"}\n\n'
              'Post $_postId was deleted.\n'
              'Response body: ${response.body.isEmpty ? "(empty — 204 pattern)" : response.body}';
          _isError = false;
        });
      } else {
        setState(() {
          _result = 'Error: ${response.statusCode}';
          _isError = true;
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Network error: $e';
        _isError = true;
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Data on the Internet'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Use http.delete() to remove a resource from the server. '
            'A successful delete typically returns 200 OK (with deleted object) '
            'or 204 No Content (empty body — nothing to return).',
          ),
          const SizedBox(height: 16),

          const _CodeSection(
            label: 'http.delete() — remove a resource',
            labelColor: Colors.red,
            code: '''
Future<void> deletePost(int id) async {
  final response = await http.delete(
    Uri.parse('https://api.example.com/posts/\$id'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
  );

  // 200 OK — server returned the deleted object
  // 204 No Content — delete succeeded, no body returned
  if (response.statusCode == 200 || response.statusCode == 204) {
    print('Deleted successfully');
  } else {
    throw Exception('Delete failed: \${response.statusCode}');
  }
}''',
          ),
          const SizedBox(height: 12),

          // Status code reference
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey.shade100),
                  children: const [
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Text('Status',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Text('Meaning',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
                const TableRow(children: [
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('200 OK',
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold))),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Deleted — server echoes the removed object')),
                ]),
                const TableRow(children: [
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('204 No Content',
                          style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold))),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                          'Deleted — no body (most RESTful APIs use this)')),
                ]),
                const TableRow(children: [
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('404 Not Found',
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold))),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Resource does not exist (already deleted?)')),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 12),

          const _CodeSection(
            label: 'UI pattern — remove item from list after delete',
            labelColor: Colors.blue,
            code: '''
// After a successful delete, update local state to match
Future<void> _deleteItem(int id) async {
  final response = await http.delete(
    Uri.parse('https://api.example.com/items/\$id'),
  );

  if (response.statusCode == 200 || response.statusCode == 204) {
    setState(() {
      // Remove from the local list so UI updates immediately
      _items.removeWhere((item) => item.id == id);
    });
  }
}''',
          ),
          const SizedBox(height: 16),

          // Live demo
          const Text('Live demo — delete a post by ID:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Text('Post ID: '),
                      const SizedBox(width: 12),
                      // ID picker
                      for (final id in [1, 2, 3, 5, 10])
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: ChoiceChip(
                            label: Text('$id'),
                            selected: _postId == id,
                            onSelected: _loading || _deleted
                                ? null
                                : (_) => setState(() {
                                      _postId = id;
                                      _result = '';
                                      _deleted = false;
                                    }),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _loading || _deleted ? null : _doDelete,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: _deleted ? Colors.grey : Colors.red),
                    icon: _loading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child:
                                CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Icon(
                            _deleted ? Icons.check : Icons.delete,
                            color: Colors.white,
                          ),
                    label: Text(
                      _loading
                          ? 'Deleting...'
                          : _deleted
                              ? 'Deleted'
                              : 'DELETE /posts/$_postId',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  if (_result.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _isError
                            ? Colors.red.shade50
                            : Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _isError
                              ? Colors.red.shade200
                              : Colors.green.shade200,
                        ),
                      ),
                      child: Text(
                        _result,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: _isError
                              ? Colors.red.shade800
                              : Colors.green.shade800,
                        ),
                      ),
                    ),
                    if (_deleted) ...[
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => setState(() {
                          _deleted = false;
                          _result = '';
                        }),
                        child: const Text('Reset demo'),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          const _TipCard(
            tip: 'After a successful delete, remove the item from your local '
                'list immediately (optimistic UI) rather than re-fetching the '
                'entire list — it feels instant and saves a network round-trip.',
          ),
        ],
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
          color: Colors.grey.shade900, borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  color: labelColor, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 8),
          Text(code,
              style: const TextStyle(
                  color: Colors.white, fontFamily: 'monospace', fontSize: 11)),
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
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lightbulb, color: Colors.purple, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(tip, style: const TextStyle(fontSize: 13))),
          ],
        ),
      ),
    );
  }
}
