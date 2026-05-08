import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// SharedPreferences — store key-value pairs on device disk
// Data persists after app close/restart
// Supported types: int, double, bool, String, List<String>
// NOT for: large data, sensitive data, complex objects

class SharedPreferencesScreen extends StatefulWidget {
  const SharedPreferencesScreen({super.key});

  @override
  State<SharedPreferencesScreen> createState() =>
      _SharedPreferencesScreenState();
}

class _SharedPreferencesScreenState extends State<SharedPreferencesScreen> {
  // Keys — string identifiers for stored values
  // Use constants to avoid typos
  static const _keyCounter = 'counter';
  static const _keyUsername = 'username';
  static const _keyDarkMode = 'dark_mode';
  static const _keyProfile = 'profile'; // Map stored as JSON string

  // Local state — mirrors what's on disk
  int _counter = 0;
  String _username = '';
  bool _darkMode = false;
  bool _loading = true;
  Map<String, dynamic> _profile = <String, dynamic>{}; // decoded Map from disk

  final _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAll(); // read from disk on screen open
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  // READ — load all saved values from disk
  // SharedPreferences.getInstance() is async — must await
  Future<void> _loadAll() async {
    // getInstance() returns SharedPreferences instance
    // internally reads from disk — async because disk I/O
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      // getInt/getString/getBool — returns null if key never saved
      // ?? provides default if null
      _counter = prefs.getInt(_keyCounter) ?? 0;
      _username = prefs.getString(_keyUsername) ?? '';
      _darkMode = prefs.getBool(_keyDarkMode) ?? false;
      _usernameController.text = _username;
      // Map — stored as JSON string, decode on read
      final raw = prefs.getString(_keyProfile);
      _profile = raw != null
          ? jsonDecode(raw) as Map<String, dynamic>
          : {};
      _loading = false;
    });
  }

  // SAVE int
  Future<void> _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    final newVal = _counter + 1;
    // setInt(key, value) — writes to disk immediately
    await prefs.setInt(_keyCounter, newVal);
    setState(() => _counter = newVal);
  }

  Future<void> _decrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    if (_counter == 0) return; // prevent negative values
    final newVal = _counter - 1;
    // setInt(key, value) — writes to disk immediately
    await prefs.setInt(_keyCounter, newVal);
    setState(() => _counter = newVal);
  }

  // SAVE String
  Future<void> _saveUsername() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, _usernameController.text);
    setState(() => _username = _usernameController.text);
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Username saved!')));
    }
  }

  // SAVE bool
  Future<void> _toggleDarkMode(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDarkMode, val);
    setState(() => _darkMode = val);
  }

  // SAVE Map — encode to JSON string first, then save as String
  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profile = {
      'name': 'John Doe',
      'age': 28,
      'email': 'john@example.com',
      'skills': ['Flutter', 'Dart', 'Firebase'],
    };
    // Map → JSON string → save as String
    await prefs.setString(_keyProfile, jsonEncode(profile));
    setState(() => _profile = profile);
  }

  // REMOVE — delete single key
  Future<void> _removeCounter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyCounter); // removes only this key
    setState(() => _counter = 0);
  }

  // CLEAR — delete ALL keys
  Future<void> _clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // wipes everything in SharedPreferences
    setState(() {
      _counter = 0;
      _username = '';
      _darkMode = false;
      _profile = {};
      _usernameController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store Key-Value Data on Disk'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'shared_preferences stores simple key-value data on disk. '
                  'Data survives app restarts. Close and reopen app to verify.',
                ),
                const SizedBox(height: 16),

                const _CodeSection(
                  label: 'Step 1: Add dependency',
                  labelColor: Colors.blue,
                  code: '''
# pubspec.yaml
dependencies:
  shared_preferences: ^2.0.0

# Install
flutter pub add shared_preferences''',
                ),
                const SizedBox(height: 12),

                const _CodeSection(
                  label: 'Step 2: Save, Read, Remove',
                  labelColor: Colors.green,
                  code: '''
// Always await getInstance() first
final prefs = await SharedPreferences.getInstance();

// SAVE — setInt, setString, setBool, setDouble, setStringList
await prefs.setInt('counter', 42);
await prefs.setString('username', 'Alice');
await prefs.setBool('dark_mode', true);

// READ — returns null if key not found
final count = prefs.getInt('counter') ?? 0;
final name = prefs.getString('username') ?? '';
final dark = prefs.getBool('dark_mode') ?? false;

// REMOVE single key
await prefs.remove('counter');

// CLEAR all keys
await prefs.clear();''',
                ),
                const SizedBox(height: 16),

                // ── Demo: int ────────────────────────────────────────────
                _DemoCard(
                  title: 'int — Counter (persists after restart)',
                  color: Colors.blue.shade50,
                  child: Row(
                    children: [
                      Text(
                        'Counter: $_counter',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: _incrementCounter,
                        child: const Text('+'),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _decrementCounter,
                        child: const Text('-'),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: _removeCounter,
                        child: const Text('Remove'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // ── Demo: String ─────────────────────────────────────────
                _DemoCard(
                  title: 'String — Username (persists after restart)',
                  color: Colors.green.shade50,
                  child: Column(
                    children: [
                      TextField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (_username.isNotEmpty)
                            Text(
                              'Saved: $_username',
                              style: const TextStyle(color: Colors.green),
                            ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: _saveUsername,
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // ── Demo: bool ───────────────────────────────────────────
                // AnimatedContainer — smooth color transition on toggle
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: _darkMode
                        ? Colors.grey.shade900
                        : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'bool — Dark Mode (persists after restart)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: _darkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Dark Mode',
                            style: TextStyle(
                              color: _darkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          const Spacer(),
                          Switch(value: _darkMode, onChanged: _toggleDarkMode),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // ── Demo: Map ────────────────────────────────────────────
                _DemoCard(
                  title: 'Map — Profile (encoded as JSON string)',
                  color: Colors.teal.shade50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Map → jsonEncode → String → prefs.setString
                      // prefs.getString → jsonDecode → Map
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: _saveProfile,
                            child: const Text('Save Profile'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (_profile.isEmpty)
                        const Text('No profile saved yet',
                            style: TextStyle(color: Colors.grey))
                      else
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade900,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'name: ${_profile['name'] ?? ''}\n'
                            'age: ${_profile['age'] ?? ''}\n'
                            'email: ${_profile['email'] ?? ''}\n'
                            'skills: ${(_profile['skills'] is List ? (_profile['skills'] as List).join(', ') : '')}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'monospace',
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Supported types reference
                const _CodeSection(
                  label: 'Supported types',
                  labelColor: Colors.purple,
                  code: '''
prefs.setInt('key', 42)
prefs.setDouble('key', 3.14)
prefs.setBool('key', true)
prefs.setString('key', 'hello')
prefs.setStringList('key', ['a', 'b', 'c'])

// NOT supported — must encode to JSON string first
prefs.setString('user', jsonEncode(user.toJson()))
final user = User.fromJson(jsonDecode(prefs.getString('user')!))''',
                ),
                const SizedBox(height: 16),

                // Clear all button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _clearAll,
                    icon: const Icon(Icons.delete_sweep, color: Colors.red),
                    label: const Text(
                      'Clear All Saved Data',
                      style: TextStyle(color: Colors.red),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                const _TipCard(
                  tip:
                      'SharedPreferences is for small, simple data — '
                      'settings, flags, counters. For complex objects, '
                      'encode to JSON string first. For sensitive data '
                      '(tokens, passwords) use flutter_secure_storage instead.',
                ),
              ],
            ),
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

class _DemoCard extends StatelessWidget {
  final String title;
  final Color color;
  final Widget child;
  const _DemoCard({
    required this.title,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 10),
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
