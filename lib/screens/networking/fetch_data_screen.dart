import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Model class — converts raw JSON into a typed Dart object
class Album {
  final int userId;
  final int id;
  final String title;

  const Album({required this.userId, required this.id, required this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      // 'userId'     → key to look up in the map
      // int          → expected type of that value
      // parsedUserId → new local variable Dart creates and binds the value to
      {
        'userId': int parsedUserId,
        'id': int parsedId,
        'title': String parsedTitle,
      } =>
        Album(userId: parsedUserId, id: parsedId, title: parsedTitle),
      // _ is the default — runs if a key is missing or has the wrong type
      _ => throw const FormatException(
        'Failed to load album — unexpected JSON shape.',
      ),
    };
  }
}

// Fetch function lives outside the widget — keeps it testable
// Takes an id so the caller controls which album to load
Future<Album> fetchAlbum(int id) async {
  // Artificial delay so the loading spinner is visible in the demo
  // await Future.delayed(const Duration(seconds: 2));

  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/$id'),
  );

  // Always check the status code before parsing
  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load album (${response.statusCode})');
  }
}

class FetchDataScreen extends StatefulWidget {
  const FetchDataScreen({super.key});

  @override
  State<FetchDataScreen> createState() => _FetchDataScreenState();
}

class _FetchDataScreenState extends State<FetchDataScreen> {
  Future<Album>? _futureAlbum; // nullable — null means nothing fetched yet
  int? _albumId; // null until user triggers a fetch
  bool _loading = false;
  String _inputError = '';
  late final TextEditingController _idController;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
  }

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  void _fetch(int id) {
    final future = fetchAlbum(id).whenComplete(() {
      if (mounted) setState(() => _loading = false);
    });
    // single setState — _futureAlbum stays null until loading is done
    setState(() {
      _albumId = id;
      _loading = true;
      _futureAlbum = null;
    });
    // assign future after setState so FutureBuilder never sees it while loading
    _futureAlbum = future;
  }

  void _fetchFromInput() {
    final text = _idController.text.trim();
    if (text.isEmpty) {
      setState(() => _inputError = 'Please enter an album ID');
      return;
    }
    final id = int.tryParse(text);
    if (id == null || id < 1) {
      setState(() => _inputError = 'Enter a valid number (1 or more)');
      return;
    }
    setState(() => _inputError = '');
    _fetch(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fetch Data from the Internet'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Use the http package to fetch data from the internet. '
            'Convert the raw http.Response into a typed Dart object '
            'using a model class with a fromJson factory constructor.',
          ),
          const SizedBox(height: 16),

          // Step 1 — add the package
          const _CodeSection(
            label: 'Step 1 — add http to pubspec.yaml',
            labelColor: Colors.blue,
            code: '''
dependencies:
  http: ^1.6.0''',
          ),
          const SizedBox(height: 12),

          // Step 2 — create the model
          const _CodeSection(
            label: 'Step 2 — create a model class',
            labelColor: Colors.blue,
            code: '''
class Album {
  final int userId;
  final int id;
  final String title;

  const Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  // Old way — crashes with a generic error if a key is missing or wrong type
  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
    );
  }

  // Dart 3 way — pattern matches the map shape in one step.
  // Checks keys exist + correct type + binds variable, all at once.
  // _ catches anything unexpected with a clear error message.
  factory Album.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'userId': int userId, 'id': int id, 'title': String title} => Album(
        userId: userId,
        id: id,
        title: title,
      ),
      _ => throw const FormatException('Unexpected JSON shape'),
    };
  }
}''',
          ),
          const SizedBox(height: 12),

          // Step 3 — the fetch function
          const _CodeSection(
            label: 'Step 3 — fetch function returns a Future',
            labelColor: Colors.blue,
            code: '''
Future<Album> fetchAlbum() async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
  );

  if (response.statusCode == 200) {
    // 200 OK — decode JSON and return typed object
    return Album.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  } else {
    // Anything else — throw so FutureBuilder shows error
    throw Exception('Failed to load album');
  }
}''',
          ),
          const SizedBox(height: 12),

          // Step 4 — FutureBuilder
          const _CodeSection(
            label: 'Step 4 — display with FutureBuilder',
            labelColor: Colors.blue,
            code: '''
// Call fetch once in initState — NOT inside build()
// Calling it in build() would re-fetch on every rebuild
@override
void initState() {
  super.initState();
  _futureAlbum = fetchAlbum();
}

// FutureBuilder handles 3 states: loading, data, error
FutureBuilder<Album>(
  future: _futureAlbum,
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return Text(snapshot.data!.title);  // success
    } else if (snapshot.hasError) {
      return Text('\${snapshot.error}');   // error
    }
    return const CircularProgressIndicator(); // loading
  },
)''',
          ),
          const SizedBox(height: 16),

          // Live demo
          const Text(
            'Live demo — fetching from jsonplaceholder.typicode.com:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.cloud_download, color: Colors.indigo),
                      const SizedBox(width: 8),
                      Text(
                        _albumId == null
                            ? 'GET /albums/{id}'
                            : 'GET /albums/$_albumId',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _idController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Album ID',
                            hintText: 'e.g. 1 – 100',
                            border: const OutlineInputBorder(),
                            isDense: true,
                            errorText: _inputError.isEmpty ? null : _inputError,
                          ),
                          onSubmitted: (_) => _fetchFromInput(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: ElevatedButton(
                          onPressed: _loading ? null : _fetchFromInput,
                          child: const Text('Fetch'),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  if (_futureAlbum == null)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          'Enter an album ID above and press Fetch',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else if (_loading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else
                    FutureBuilder<Album>(
                      future: _futureAlbum,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final album = snapshot.data!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _JsonRow('userId', '${album.userId}'),
                              _JsonRow('id', '${album.id}'),
                              _JsonRow('title', album.title),
                            ],
                          );
                        }
                        return Row(
                          children: [
                            const Icon(Icons.error, color: Colors.red),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${snapshot.error}',
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  const SizedBox(height: 12),
                  if (_albumId != null)
                    OutlinedButton.icon(
                      onPressed: _loading ? null : () => _fetch(_albumId!),
                      icon: const Icon(Icons.refresh),
                      label: Text('Refetch /albums/$_albumId'),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          const _TipCard(
            tip:
                'Always call your fetch function in initState(), not inside '
                'build(). build() can run many times — you don\'t want a new '
                'network request on every rebuild.',
          ),
        ],
      ),
    );
  }
}

class _JsonRow extends StatelessWidget {
  final String label;
  final String value;
  const _JsonRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '"$label": ',
            style: const TextStyle(
              fontFamily: 'monospace',
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              '"$value"',
              style: const TextStyle(
                fontFamily: 'monospace',
                color: Colors.green,
              ),
            ),
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
  const _CodeSection({
    required this.label,
    required this.labelColor,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: labelColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            code,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'monospace',
              fontSize: 11,
            ),
          ),
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
