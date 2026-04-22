import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthenticatedRequestsScreen extends StatefulWidget {
  const AuthenticatedRequestsScreen({super.key});

  @override
  State<AuthenticatedRequestsScreen> createState() =>
      _AuthenticatedRequestsScreenState();
}

class _AuthenticatedRequestsScreenState
    extends State<AuthenticatedRequestsScreen> {
  final _tokenController = TextEditingController(text: 'my-secret-token');
  String _result = '';
  bool _loading = false;
  bool _isError = false;

  // Authenticated GET — adds Authorization header to every request
  Future<void> _fetchWithAuth() async {
    setState(() {
      _loading = true;
      _result = '';
      _isError = false;
    });

    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
        // The headers map is where you put auth credentials
        headers: {
          'Authorization': 'Bearer ${_tokenController.text}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        setState(() {
          _result = 'Status: ${response.statusCode} OK\n\n'
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
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authenticated Requests'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Most APIs require authentication. You pass credentials in the '
            'request headers — typically an Authorization header with a token.',
          ),
          const SizedBox(height: 16),

          const _CodeSection(
            label: 'Add Authorization header to http.get()',
            labelColor: Colors.teal,
            code: '''
final response = await http.get(
  Uri.parse('https://api.example.com/data'),
  headers: {
    // Bearer token — most common auth method
    'Authorization': 'Bearer \$myToken',
    'Content-Type': 'application/json',
  },
);''',
          ),
          const SizedBox(height: 12),

          const _CodeSection(
            label: 'Other common auth header formats',
            labelColor: Colors.blue,
            code: '''
// Bearer token (OAuth2, JWT)
'Authorization': 'Bearer eyJhbGciOi...'

// Basic auth (username:password encoded in base64)
'Authorization': 'Basic \${base64Encode(utf8.encode("user:pass"))}'

// API key in header
'X-API-Key': 'your-api-key-here'

// API key as query param (less secure)
Uri.parse('https://api.example.com/data?api_key=xxx')''',
          ),
          const SizedBox(height: 12),

          const _CodeSection(
            label: 'Reusable authenticated client pattern',
            labelColor: Colors.green,
            code: '''
// Create a helper that injects auth headers automatically
Future<http.Response> authGet(String url) {
  return http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer \$token',
      'Content-Type': 'application/json',
    },
  );
}

// Usage
final response = await authGet('/api/profile');''',
          ),
          const SizedBox(height: 16),

          // Live demo
          const Text('Live demo — type a token and make an authenticated request:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Token input
                  TextField(
                    controller: _tokenController,
                    decoration: const InputDecoration(
                      labelText: 'Authorization token',
                      prefixText: 'Bearer ',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.key),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _loading ? null : _fetchWithAuth,
                    icon: _loading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.lock_open),
                    label: Text(_loading ? 'Fetching...' : 'Send Authenticated Request'),
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
                      child: Text(_result,
                          style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                              color: _isError
                                  ? Colors.red.shade800
                                  : Colors.green.shade800)),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          const _TipCard(
            tip: 'Never hardcode tokens in source code. Store them in secure '
                'storage (flutter_secure_storage) and read them at runtime.',
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
