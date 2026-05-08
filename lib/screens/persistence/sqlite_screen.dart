import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

// ── Pet model ─────────────────────────────────────────────────────────────────

class Pet {
  final int? id;       // nullable — null before inserted (DB assigns id)
  final String name;
  final String type;   // Dog, Cat, Bird, etc.
  final double age;
  // isSynced — offline-first flag
  // 0 = saved locally only, not yet sent to server
  // 1 = synced to server
  final int isSynced;

  const Pet({
    this.id,
    required this.name,
    required this.type,
    required this.age,
    this.isSynced = 0, // default: not synced
  });

  // Convert Pet → Map for SQLite insert/update
  // SQLite doesn't know Dart objects — needs Map<String, Object?>
  Map<String, Object?> toMap() => {
    'id': id,
    'name': name,
    'type': type,
    'age': age,
    'is_synced': isSynced,
  };

  // Convert Map (SQLite row) → Pet object
  factory Pet.fromMap(Map<String, Object?> map) => Pet(
    id: map['id'] as int?,
    name: map['name'] as String,
    type: map['type'] as String,
    age: (map['age'] as num).toDouble(),
    isSynced: map['is_synced'] as int,
  );

  // copyWith — create updated Pet without mutating original
  // Used in update operations
  Pet copyWith({String? name, String? type, double? age, int? isSynced}) => Pet(
    id: id,
    name: name ?? this.name,
    type: type ?? this.type,
    age: age ?? this.age,
    isSynced: isSynced ?? this.isSynced,
  );
}

// ── Database helper ───────────────────────────────────────────────────────────

class PetDatabase {
  static Database? _db;

  // Singleton — only one DB connection for whole app
  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  // Step 3: Open database
  static Future<Database> _initDb() async {
    // getDatabasesPath() — finds correct platform DB folder
    // join() — safely joins path segments (handles / separators)
    final path = p.join(await getDatabasesPath(), 'pets.db');

    return openDatabase(
      path,
      version: 2,
      // onCreate — runs ONCE when DB first created
      // If DB already exists (app restart), this is SKIPPED
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE pets (
            id        INTEGER PRIMARY KEY AUTOINCREMENT,
            name      TEXT    NOT NULL,
            type      TEXT    NOT NULL,
            age       REAL    NOT NULL,
            is_synced INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
      // onUpgrade — runs when version bumped (existing installs)
      // Recreates table so age column changes INTEGER → REAL
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('DROP TABLE IF EXISTS pets');
        await db.execute('''
          CREATE TABLE pets (
            id        INTEGER PRIMARY KEY AUTOINCREMENT,
            name      TEXT    NOT NULL,
            type      TEXT    NOT NULL,
            age       REAL    NOT NULL,
            is_synced INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
    );
  }

  // Step 5: INSERT — returns new row id
  static Future<int> insert(Pet pet) async {
    final db = await database;
    // conflictAlgorithm.replace — if id exists, replace row
    return db.insert('pets', pet.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Step 6: SELECT all — returns List<Map>, convert to List<Pet>
  static Future<List<Pet>> getAll() async {
    final db = await database;
    final maps = await db.query('pets', orderBy: 'id DESC');
    return maps.map(Pet.fromMap).toList();
  }

  // Get only unsynced pets — for sync to server
  static Future<List<Pet>> getUnsynced() async {
    final db = await database;
    final maps = await db.query('pets',
        where: 'is_synced = ?', whereArgs: [0]);
    return maps.map(Pet.fromMap).toList();
  }

  // Step 7: UPDATE — returns number of rows affected
  static Future<int> update(Pet pet) async {
    final db = await database;
    return db.update(
      'pets',
      pet.toMap(),
      where: 'id = ?',      // only update this row
      whereArgs: [pet.id],  // ? = pet.id (prevents SQL injection)
    );
  }

  // Mark as synced after successful server upload
  static Future<void> markSynced(int id) async {
    final db = await database;
    await db.update(
      'pets',
      {'is_synced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Step 8: DELETE
  static Future<int> delete(int id) async {
    final db = await database;
    return db.delete('pets', where: 'id = ?', whereArgs: [id]);
  }
}

// ── Screen ────────────────────────────────────────────────────────────────────

class SqliteScreen extends StatefulWidget {
  const SqliteScreen({super.key});

  @override
  State<SqliteScreen> createState() => _SqliteScreenState();
}

class _SqliteScreenState extends State<SqliteScreen> {
  List<Pet> _pets = [];
  bool _initialLoading = true;

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _scrollController = ScrollController();
  String _selectedType = 'Dog';
  static const _types = ['Dog', 'Cat', 'Bird', 'Fish', 'Rabbit'];

  @override
  void initState() {
    super.initState();
    _loadPets(initial: true);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadPets({bool initial = false}) async {
    if (initial) setState(() => _initialLoading = true);
    final pets = await PetDatabase.getAll();
    setState(() {
      _pets = pets;
      if (initial) _initialLoading = false;
    });
  }

  Future<void> _addPet() async {
    if (_nameController.text.isEmpty || _ageController.text.isEmpty) return;
    final pet = Pet(
      name: _nameController.text,
      type: _selectedType,
      age: double.tryParse(_ageController.text) ?? 0,
      isSynced: 0, // saved locally, not synced yet
    );
    await PetDatabase.insert(pet);
    _nameController.clear();
    _ageController.clear();
    await _loadPets();
  }

  Future<void> _deletePet(int id) async {
    await PetDatabase.delete(id);
    await _loadPets();
  }

  Future<void> _editPet(Pet pet) async {
    final nameCtrl = TextEditingController(text: pet.name);
    final ageCtrl = TextEditingController(text: pet.age.toString());
    String selectedType = pet.type;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Edit Pet'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: selectedType,
                isExpanded: true,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: _types
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => setDialogState(() => selectedType = v!),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ageCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      final updated = pet.copyWith(
        name: nameCtrl.text.trim().isEmpty ? pet.name : nameCtrl.text.trim(),
        type: selectedType,
        age: double.tryParse(ageCtrl.text) ?? pet.age,
        isSynced: 0,
      );
      await PetDatabase.update(updated);
      await _loadPets();
    }

    nameCtrl.dispose();
    ageCtrl.dispose();
  }

  // Simulate sync — in real app: POST to API, then markSynced
  Future<void> _simulateSync() async {
    final unsynced = await PetDatabase.getUnsynced();
    for (final pet in unsynced) {
      // Real app: await api.uploadPet(pet);
      await Future.delayed(const Duration(milliseconds: 300)); // simulate network
      await PetDatabase.markSynced(pet.id!);
    }
    await _loadPets();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Synced ${unsynced.length} pets to server')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final unsyncedCount = _pets.where((p) => p.isSynced == 0).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SQLite — Pets Database'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Sync button — shows badge if unsynced items exist
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.cloud_upload_outlined),
                onPressed: unsyncedCount > 0 ? _simulateSync : null,
                tooltip: 'Sync to server',
              ),
              if (unsyncedCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text('$unsyncedCount',
                        style: const TextStyle(
                            fontSize: 10, color: Colors.white)),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: _initialLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              controller: _scrollController,
              child: Column(
              children: [
                // How it works
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      const _CodeSection(
                        label: 'SQLite flow — open → create table → CRUD',
                        labelColor: Colors.blue,
                        code: '''
// 1. Open DB (once, singleton)
final db = await openDatabase(
  join(await getDatabasesPath(), 'pets.db'),
  version: 1,
  onCreate: (db, v) => db.execute('CREATE TABLE pets (...)'),
);

// 2. INSERT — toMap() converts Pet → Map for SQLite
await db.insert('pets', pet.toMap());

// 3. SELECT — returns List<Map>, convert to models
final rows = await db.query('pets');
return rows.map(Pet.fromMap).toList();

// 4. UPDATE — where clause targets specific row
await db.update('pets', pet.toMap(),
  where: 'id = ?', whereArgs: [pet.id]);

// 5. DELETE
await db.delete('pets', where: 'id = ?', whereArgs: [id]);''',
                      ),
                      const SizedBox(height: 8),
                      const _CodeSection(
                        label: 'Offline-first + sync pattern',
                        labelColor: Colors.orange,
                        code: '''
// Save locally first — isSynced = 0
await PetDatabase.insert(Pet(..., isSynced: 0));

// When online — upload unsynced, mark done
final unsynced = await PetDatabase.getUnsynced();
for (final pet in unsynced) {
  await api.uploadPet(pet);       // POST to server
  await PetDatabase.markSynced(pet.id!); // is_synced = 1
}

// Result: works offline, syncs when online''',
                      ),
                    ],
                  ),
                ),

                // Add pet form
                Container(
                  color: Colors.grey.shade50,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Name',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z\s]')),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            flex: 2,
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              initialValue: _selectedType,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              items: _types
                                  .map((t) => DropdownMenuItem(
                                      value: t, child: Text(t)))
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => _selectedType = v!),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: _ageController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Age',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              inputFormatters: [_DecimalFormatter()],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _addPet,
                          child: const Text('Add Pet'),
                        ),
                      ),
                    ],
                  ),
                ),

                // Pets list
                _pets.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(child: Text('No pets yet — add one above')),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _pets.length,
                        itemBuilder: (context, index) {
                          final pet = _pets[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: pet.isSynced == 1
                                  ? Colors.green.shade100
                                  : Colors.orange.shade100,
                              child: Text(
                                pet.type == 'Dog'
                                    ? '🐕'
                                    : pet.type == 'Cat'
                                        ? '🐈'
                                        : pet.type == 'Bird'
                                            ? '🐦'
                                            : pet.type == 'Fish'
                                                ? '🐟'
                                                : '🐇',
                              ),
                            ),
                            title: Text(pet.name),
                            subtitle: Text(
                                '${pet.type} • ${pet.age % 1 == 0 ? pet.age.toInt() : pet.age}y old • '
                                '${pet.isSynced == 1 ? '✓ synced' : '⏳ local only'}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (pet.isSynced == 0)
                                  const Icon(Icons.cloud_off,
                                      size: 16, color: Colors.orange),
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined,
                                      color: Colors.blue),
                                  onPressed: () => _editPet(pet),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline,
                                      color: Colors.red),
                                  onPressed: () => _deletePet(pet.id!),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

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
          Text(label,
              style: TextStyle(
                  color: labelColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12)),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(code,
                style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'monospace',
                    fontSize: 11)),
          ),
        ],
      ),
    );
  }
}

class _DecimalFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;
    if (!RegExp(r'^\d*\.?\d*$').hasMatch(newValue.text)) return oldValue;
    return newValue;
  }
}
