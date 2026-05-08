import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Data model — mirrors API response fields exactly
class Photo {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  const Photo({
    required this.albumId,
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });

  // Manual fromJson — no code gen needed for simple model
  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      albumId: json['albumId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }
}

// MUST be top-level function (not inside class/closure)
// Reason: compute() sends this to a separate isolate (thread)
// Isolates can't share memory — closures capture surrounding state, can't be sent
// Top-level functions have no captured state — safe to send
List<Photo> parsePhotos(String responseBody) {
  // jsonDecode returns dynamic — cast to List<Object?> first
  // then .cast<Map>() narrows each item type — lazy, no loop yet
  final parsed = (jsonDecode(responseBody) as List<Object?>)
      .cast<Map<String, Object?>>();
  // .map() loops here — converts each Map → Photo object
  return parsed.map<Photo>(Photo.fromJson).toList();
}

// Takes http.Client (not http.get) — reuses connection, easier to test
// Returns Future<List<Photo>> — async, resolves when parsing done
Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response = await client.get(
    Uri.parse('https://jsonplaceholder.typicode.com/photos'),
  );
  // compute(fn, arg) — spawns background isolate, runs parsePhotos(response.body) there
  // UI thread stays free while 5000 photos parse in background
  return compute(parsePhotos, response.body);
}

class BackgroundParsingScreen extends StatefulWidget {
  const BackgroundParsingScreen({super.key});

  @override
  State<BackgroundParsingScreen> createState() =>
      _BackgroundParsingScreenState();
}

class _BackgroundParsingScreenState extends State<BackgroundParsingScreen> {
  // late = initialized in initState, not null when build runs
  late Future<List<Photo>> futurePhotos;

  @override
  void initState() {
    super.initState();
    // fetch on screen load — compute() handles background parsing inside
    futurePhotos = fetchPhotos(http.Client());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parse JSON in the Background'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: _CodeSection(
              label: 'Pattern: FutureBuilder + compute()',
              labelColor: Colors.blue,
              code: '''
// initState — fetch once on load
futurePhotos = fetchPhotos(http.Client());

// build — FutureBuilder reacts to future state
FutureBuilder<List<Photo>>(
  future: futurePhotos,
  builder: (context, snapshot) {
    if (snapshot.hasError)  return ErrorWidget();
    if (snapshot.hasData)   return PhotoGrid(snapshot.data!);
    return CircularProgressIndicator();  // loading
  },
)''',
            ),
          ),

          // FutureBuilder — exact pattern from Flutter docs
          Expanded(
            child: FutureBuilder<List<Photo>>(
              future: futurePhotos,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 48,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${snapshot.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasData) {
                  final photos = snapshot.data!;
                  return GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.8,
                        ),
                    itemCount: photos.length,
                    itemBuilder: (context, index) {
                      final photo = photos[index];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              'https://picsum.photos/seed/${photo.id}/300/250',
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return Container(
                                  color: Colors.grey.shade300,
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircularProgressIndicator(
                                          strokeWidth: 2,
                                          value:
                                              progress.expectedTotalBytes !=
                                                  null
                                              ? progress.cumulativeBytesLoaded /
                                                    progress.expectedTotalBytes!
                                              : null,
                                        ),
                                        const SizedBox(height: 6),
                                        const Text(
                                          'Loading...',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stack) =>
                                  Container(
                                    color: Colors.grey.shade300,
                                    child: Center(child: Text('#${photo.id}')),
                                  ),
                            ),
                            // Title overlay at bottom
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withValues(alpha: 0.7),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                                child: Text(
                                  photo.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
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
