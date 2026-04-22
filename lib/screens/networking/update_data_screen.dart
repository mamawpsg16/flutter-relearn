import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateDataScreen extends StatefulWidget {
  const UpdateDataScreen({super.key});

  @override
  State<UpdateDataScreen> createState() => _UpdateDataScreenState();
}

class _UpdateDataScreenState extends State<UpdateDataScreen> {
  final _titleController = TextEditingController(text: 'Updated title');
  final _bodyController = TextEditingController(text: 'Updated body content');
  String _result = '';
  bool _loading = false;
  bool _isError = false;
  String _lastMethod = '';

  // PUT — replaces the entire resource
  Future<void> _doPut() async {
    _sendRequest('PUT', http.put(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      // PUT sends the full object — all fields required
      body: jsonEncode({
        'id': 1,
        'title': _titleController.text,
        'body': _bodyController.text,
        'userId': 1,
      }),
    ));
  }

  // PATCH — updates only specific fields
  Future<void> _doPatch() async {
    _sendRequest('PATCH', http.patch(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      // PATCH sends only the fields you want to change
      body: jsonEncode({
        'title': _titleController.text,
      }),
    ));
  }

  Future<void> _sendRequest(String method, Future<http.Response> request) async {
    setState(() {
      _loading = true;
      _lastMethod = method;
      _result = '';
      _isError = false;
    });

    try {
      final response = await request;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        setState(() {
          _result = 'Status: 200 OK\n\n'
              'id: ${data['id']}\n'
              'title: "${data['title']}"';
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
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Data over the Internet'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Use http.put() to replace an entire resource, or http.patch() '
            'to update only specific fields. Both return the updated object.',
          ),
          const SizedBox(height: 16),

          // PUT vs PATCH comparison
          const _CodeSection(
            label: 'PUT — replace the entire resource',
            labelColor: Colors.purple,
            code: '''
// PUT requires ALL fields — replaces the whole object
final response = await http.put(
  Uri.parse('https://api.example.com/posts/1'),
  headers: {'Content-Type': 'application/json; charset=UTF-8'},
  body: jsonEncode({
    'id': 1,
    'title': 'New title',
    'body': 'New body',   // ← must include all fields
    'userId': 1,          // ← even unchanged ones
  }),
);

// 200 OK — resource was replaced''',
          ),
          const SizedBox(height: 12),

          const _CodeSection(
            label: 'PATCH — update only specific fields',
            labelColor: Colors.orange,
            code: '''
// PATCH — send only the fields you want to change
final response = await http.patch(
  Uri.parse('https://api.example.com/posts/1'),
  headers: {'Content-Type': 'application/json; charset=UTF-8'},
  body: jsonEncode({
    'title': 'Updated title only', // ← only changed field
    // body and userId stay unchanged on the server
  }),
);

// 200 OK — resource was partially updated''',
          ),
          const SizedBox(height: 12),

          // Comparison table
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
                    Padding(padding: EdgeInsets.all(10), child: Text('Method', style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(padding: EdgeInsets.all(10), child: Text('Use when', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
                const TableRow(children: [
                  Padding(padding: EdgeInsets.all(10), child: Text('PUT', style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold))),
                  Padding(padding: EdgeInsets.all(10), child: Text('Replacing an entire object (edit profile form)')),
                ]),
                const TableRow(children: [
                  Padding(padding: EdgeInsets.all(10), child: Text('PATCH', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold))),
                  Padding(padding: EdgeInsets.all(10), child: Text('Updating one or two fields (toggle dark mode)')),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Live demo
          const Text('Live demo — try both PUT and PATCH:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _bodyController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Body (only used by PUT)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _loading ? null : _doPut,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple),
                          child: const Text('PUT', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _loading ? null : _doPatch,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange),
                          child: const Text('PATCH', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                  if (_loading)
                    const Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  if (_result.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _isError ? Colors.red.shade50 : Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _isError ? Colors.red.shade200 : Colors.green.shade200,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$_lastMethod response:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _lastMethod == 'PUT'
                                      ? Colors.purple
                                      : Colors.orange)),
                          const SizedBox(height: 6),
                          Text(_result,
                              style: const TextStyle(
                                  fontFamily: 'monospace', fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          const _TipCard(
            tip: 'Prefer PATCH over PUT when you only need to change a few '
                'fields. PUT is safer when you want a full replace and need '
                'to guarantee no stale data remains.',
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
