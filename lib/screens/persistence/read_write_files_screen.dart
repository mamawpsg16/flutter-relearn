import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

// Read & Write Files
// path_provider → finds correct local path per platform
// dart:io File   → reads/writes actual file on disk
// Use for: logs, user-generated content, large data, JSON files

class ReadWriteFilesScreen extends StatefulWidget {
  const ReadWriteFilesScreen({super.key});

  @override
  State<ReadWriteFilesScreen> createState() => _ReadWriteFilesScreenState();
}

class _ReadWriteFilesScreenState extends State<ReadWriteFilesScreen> {
  final _controller = TextEditingController();
  String _fileContent = '';
  String _filePath = '';
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _init(); // get path + read existing content on open
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Step 1: Find correct local path
  // getApplicationDocumentsDirectory() — app's private documents folder
  // iOS: /Documents, Android: /data/data/<app>/files
  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    print('${dir.path} path');
    // dir.path = platform-specific documents folder path
    // File() = reference to file at that path (doesn't create yet)
    return File('${dir.path}/notes.txt');
  }

  Future<void> _init() async {
    setState(() => _loading = true);
    try {
      final file = await _getFile();
      setState(() => _filePath = file.path);
      // readAsString() — reads entire file as String
      // throws FileSystemException if file doesn't exist yet
      if (await file.exists()) {
        final content = await file.readAsString();
        setState(() {
          _fileContent = content;
          _controller.text = content;
        });
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  // Step 3: Write data to file
  // writeAsString() — creates file if not exist, overwrites if exists
  Future<void> _writeFile() async {
    try {
      final file = await _getFile();
      await file.writeAsString(_controller.text);
      setState(() => _fileContent = _controller.text);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Saved to file!')));
      }
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  // Step 4: Read data from file
  Future<void> _readFile() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        setState(() {
          _fileContent = content;
          _controller.text = content;
        });
      } else {
        setState(() => _fileContent = 'File does not exist yet. Write first.');
      }
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  // Append — add to end of file without overwriting
  Future<void> _appendFile() async {
    try {
      final file = await _getFile();
      await file.writeAsString('\n${_controller.text}', mode: FileMode.append);
      final content = await file.readAsString();
      setState(() => _fileContent = content);
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  // Delete file entirely
  Future<void> _deleteFile() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        await file.delete();
        setState(() {
          _fileContent = '';
          _controller.clear();
        });
      }
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Read & Write Files'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'path_provider finds the correct local path per platform. '
                  'dart:io File reads/writes actual files on disk.',
                ),
                const SizedBox(height: 16),

                const _CodeSection(
                  label: 'Step 1 & 2: Find path + get File reference',
                  labelColor: Colors.blue,
                  code: '''
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<File> get _localFile async {
  // getApplicationDocumentsDirectory — app private folder
  // iOS:     /Documents
  // Android: /data/data/<app>/files
  final dir = await getApplicationDocumentsDirectory();

  // File() = reference only, doesn't create file yet
  return File('\${dir.path}/notes.txt');
}''',
                ),
                const SizedBox(height: 12),

                const _CodeSection(
                  label: 'Step 3 & 4: Write + Read',
                  labelColor: Colors.green,
                  code: '''
// WRITE — creates file if not exist, overwrites if exists
Future<void> writeFile(String text) async {
  final file = await _localFile;
  await file.writeAsString(text);
}

// APPEND — add to end, keep existing content
await file.writeAsString(text, mode: FileMode.append);

// READ — returns entire file as String
Future<String> readFile() async {
  final file = await _localFile;
  if (await file.exists()) {
    return await file.readAsString();
  }
  return '';
}

// DELETE
await file.delete();''',
                ),
                const SizedBox(height: 16),

                // File path info
                if (_filePath.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'File path:\n$_filePath',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),

                // Demo card
                Card(
                  color: Colors.indigo.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Try it: Write & Read notes.txt',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Input
                        TextField(
                          controller: _controller,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Enter text to save',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Action buttons
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ElevatedButton.icon(
                              onPressed: _writeFile,
                              icon: const Icon(Icons.save, size: 16),
                              label: const Text('Write'),
                            ),
                            ElevatedButton.icon(
                              onPressed: _readFile,
                              icon: const Icon(Icons.file_open, size: 16),
                              label: const Text('Read'),
                            ),
                            OutlinedButton.icon(
                              onPressed: _appendFile,
                              icon: const Icon(Icons.add, size: 16),
                              label: const Text('Append'),
                            ),
                            OutlinedButton.icon(
                              onPressed: _deleteFile,
                              icon: const Icon(
                                Icons.delete_outline,
                                size: 16,
                                color: Colors.red,
                              ),
                              label: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // File content display
                        const Text(
                          'File content:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade900,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _fileContent.isEmpty
                                ? 'No content yet'
                                : _fileContent,
                            style: TextStyle(
                              color: _fileContent.isEmpty
                                  ? Colors.grey
                                  : Colors.white,
                              fontFamily: 'monospace',
                              fontSize: 12,
                            ),
                          ),
                        ),

                        if (_error != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            _error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                const _TipCard(
                  tip:
                      'Use getApplicationDocumentsDirectory for user data '
                      '(persists until app uninstall). '
                      'Use getTemporaryDirectory for cache files '
                      '(OS may delete anytime). '
                      'Never hardcode paths — always use path_provider.',
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
