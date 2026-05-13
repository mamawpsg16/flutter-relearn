import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// RESULT PATTERN
//
// Problem: Dart exceptions are unhandled by default. Methods can throw
// without declaring it, and callers aren't forced to catch them.
// This leads to crashes and uncaught errors in large apps.
//
// Solution: Return a Result object instead of throwing.
// The caller MUST handle both success and failure — the type system enforces it.
// ═══════════════════════════════════════════════════════════════════════════════

// Result is a sealed class — it can only be Success or Failure
sealed class Result<T> {
  const Result();
}

// Success wraps the value
class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}

// Failure wraps the error
class Failure<T> extends Result<T> {
  final Exception error;
  const Failure(this.error);
}

// ─── Simulated service using Result ──────────────────────────────────────────

class _UserService {
  // Returns Result instead of throwing — caller decides what to do with errors
  Future<Result<String>> fetchUsername(String userId) async {
    await Future.delayed(const Duration(seconds: 1));

    if (userId.isEmpty) {
      return Failure(Exception('User ID cannot be empty'));
    }
    if (userId == '404') {
      return Failure(Exception('User not found'));
    }
    return Success('Kevin_$userId'); // success
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SCREEN
// ═══════════════════════════════════════════════════════════════════════════════

class ResultPatternScreen extends StatefulWidget {
  const ResultPatternScreen({super.key});

  @override
  State<ResultPatternScreen> createState() => _ResultPatternScreenState();
}

class _ResultPatternScreenState extends State<ResultPatternScreen> {
  final _service = _UserService();
  final _controller = TextEditingController(text: '42');

  bool _isLoading = false;
  String? _successValue;
  String? _errorMessage;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchUser() async {
    setState(() {
      _isLoading = true;
      _successValue = null;
      _errorMessage = null;
    });

    // Call the service — returns a Result, never throws
    final result = await _service.fetchUsername(_controller.text.trim());

    // Switch on the result type — compiler forces you to handle both cases
    switch (result) {
      case Success<String>(:final value):
        setState(() => _successValue = value);
      case Failure<String>(:final error):
        setState(() => _errorMessage = error.toString());
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result Pattern'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dart exceptions are unhandled by default — methods can throw '
              'without declaring it, and callers aren\'t forced to catch them. '
              'The Result pattern makes errors explicit: the caller must handle '
              'both success and failure.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 20),

            _CodeSection(
              label: 'BAD — exceptions can propagate silently to the user',
              labelColor: Colors.red,
              code: '''// Service throws — but nothing forces the caller to catch it
Future<String> fetchUsername(String id) async {
  final response = await http.get('/api/users/\$id');
  if (response.statusCode == 404) throw Exception('Not found');
  return response.body;
}

// Caller might forget try/catch → unhandled exception → crash
final name = await fetchUsername(id); // 💥 if 404, app crashes''',
            ),
            const SizedBox(height: 12),

            _CodeSection(
              label: 'GOOD — Result forces the caller to handle both cases',
              labelColor: Colors.green,
              code: '''// sealed class — only Success or Failure are possible
sealed class Result<T> {}
class Success<T> extends Result<T> { final T value; ... }
class Failure<T> extends Result<T> { final Exception error; ... }

// Service returns Result — never throws
Future<Result<String>> fetchUsername(String id) async {
  try {
    final response = await http.get('/api/users/\$id');
    return Success(response.body);
  } on Exception catch (e) {
    return Failure(e);
  }
}

// Caller MUST handle both — switch is exhaustive
final result = await fetchUsername(id);
switch (result) {
  case Success(:final value): showUser(value);
  case Failure(:final error): showError(error.toString());
}''',
            ),
            const SizedBox(height: 12),

            _CodeSection(
              label: 'Using Result across layers — repository wraps service errors',
              labelColor: Colors.blue,
              code: '''class UserRepository {
  final UserService _service;

  Future<Result<User>> getUser(String id) async {
    // Catches any exception from the service and wraps it in Failure
    try {
      final raw = await _service.fetchRawUser(id);
      return Success(User.fromJson(raw));
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}

// ViewModel uses the result cleanly
Future<void> _loadUser(String id) async {
  final result = await _repository.getUser(id);
  switch (result) {
    case Success(:final value): _user = value; notifyListeners();
    case Failure(:final error): _error = error.toString(); notifyListeners();
  }
}''',
            ),
            const SizedBox(height: 24),

            const Text(
              'Live Demo',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Try: any text = success  •  empty = validation error  •  "404" = not found',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'User ID',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _isLoading ? null : _fetchUser,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Fetch'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Result display
            if (_successValue != null)
              _ResultDisplay(
                isSuccess: true,
                label: 'Success<String>',
                message: 'value: "$_successValue"',
              ),
            if (_errorMessage != null)
              _ResultDisplay(
                isSuccess: false,
                label: 'Failure<String>',
                message: 'error: $_errorMessage',
              ),

            const SizedBox(height: 24),

            const _TipCard(
              tip:
                  'sealed classes make Result exhaustive — the Dart compiler '
                  'warns you if you don\'t handle both Success and Failure in a '
                  'switch statement. This makes it impossible to silently ignore errors.',
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultDisplay extends StatelessWidget {
  final bool isSuccess;
  final String label;
  final String message;

  const _ResultDisplay({
    required this.isSuccess,
    required this.label,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSuccess ? Colors.green : Colors.red;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        border: Border.all(color: color.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isSuccess ? Icons.check_circle : Icons.error,
                color: color,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(message,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 13)),
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
