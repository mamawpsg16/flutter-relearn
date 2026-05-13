import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseScreen extends StatefulWidget {
  const SupabaseScreen({super.key});

  @override
  State<SupabaseScreen> createState() => _SupabaseScreenState();
}

class _SupabaseScreenState extends State<SupabaseScreen> {
  final _supabase = Supabase.instance.client;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  bool _isLoading = false;
  bool _isObscure = true;

  User? get _currentUser => _supabase.auth.currentUser;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      if (_isLogin) {
        await _supabase.auth.signInWithPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        await _supabase.auth.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }
      if (mounted) setState(() {});
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signOut() async {
    await _supabase.auth.signOut();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supabase'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Supabase is an open-source Firebase alternative built on PostgreSQL. '
              'It gives you auth, a real SQL database, and file storage — all with a Flutter SDK. '
              'If you know SQL, Supabase queries will feel instantly familiar.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 20),

            _CodeSection(
              label: 'SETUP — main.dart (run once at startup)',
              labelColor: Colors.blue,
              code: '''await Supabase.initialize(
  url: 'https://your-project.supabase.co',
  anonKey: 'your-anon-key',
);

// Global accessor — use anywhere in the app
final supabase = Supabase.instance.client;''',
            ),
            const SizedBox(height: 12),

            _CodeSection(
              label: 'BAD — ignoring AuthException, app crashes on wrong password',
              labelColor: Colors.red,
              code: '''// No error handling — throws unhandled exception
await supabase.auth.signInWithPassword(
  email: email,
  password: password,
);''',
            ),
            const SizedBox(height: 12),

            _CodeSection(
              label: 'GOOD — catch AuthException for user-friendly errors',
              labelColor: Colors.green,
              code: '''try {
  await supabase.auth.signInWithPassword(
    email: email,
    password: password,
  );
} on AuthException catch (e) {
  // e.message is readable: "Invalid login credentials"
  showSnackBar(e.message);
} finally {
  if (mounted) setState(() => _isLoading = false);
}''',
            ),
            const SizedBox(height: 24),

            const Text(
              'Live Demo — Auth',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            if (_currentUser != null) _buildLoggedIn() else _buildAuthForm(),

            const SizedBox(height: 24),

            const Text(
              'Database CRUD — SQL → Supabase',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Create a table in the Supabase dashboard, then query it like SQL:',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 12),

            _CodeSection(
              label: 'SELECT * FROM notes WHERE user_id = ?',
              labelColor: Colors.blue,
              code: '''final data = await supabase
  .from('notes')
  .select()
  .eq('user_id', supabase.auth.currentUser!.id);''',
            ),
            const SizedBox(height: 12),

            _CodeSection(
              label: 'INSERT INTO notes (title, body, user_id) VALUES (...)',
              labelColor: Colors.blue,
              code: '''await supabase.from('notes').insert({
  'title': 'Shopping list',
  'body': 'Milk, eggs, bread',
  'user_id': supabase.auth.currentUser!.id,
});''',
            ),
            const SizedBox(height: 12),

            _CodeSection(
              label: 'UPDATE notes SET title = ? WHERE id = ?',
              labelColor: Colors.blue,
              code: '''await supabase
  .from('notes')
  .update({'title': 'Updated title'})
  .eq('id', noteId);''',
            ),
            const SizedBox(height: 12),

            _CodeSection(
              label: 'DELETE FROM notes WHERE id = ?',
              labelColor: Colors.blue,
              code: '''await supabase
  .from('notes')
  .delete()
  .eq('id', noteId);''',
            ),
            const SizedBox(height: 24),

            const Text(
              'Supabase vs Firebase',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildDecisionTable(),
            const SizedBox(height: 24),

            const _TipCard(
              tip:
                  'Always enable Row Level Security (RLS) on your tables. '
                  'Without RLS, anyone with your anon key can read or write all data. '
                  'With RLS, you write SQL policies like: '
                  '"allow select where auth.uid() = user_id" — '
                  'users can only see their own rows.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthForm() {
    return Form(
      key: _formKey,
      child: Theme(
        data: Theme.of(context).copyWith(
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        child: Column(
          children: [
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Sign In')),
                ButtonSegment(value: false, label: Text('Sign Up')),
              ],
              selected: {_isLogin},
              onSelectionChanged: (v) =>
                  setState(() => _isLogin = v.first),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Enter your email';
                if (!v.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passwordController,
              obscureText: _isObscure,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () =>
                      setState(() => _isObscure = !_isObscure),
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Enter your password';
                if (v.length < 6) return 'Min 6 characters';
                return null;
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_isLogin ? 'Sign In' : 'Sign Up'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoggedIn() {
    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Signed in',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Email: ${_currentUser!.email}'),
            Text(
              'UID: ${_currentUser!.id}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _signOut,
              icon: const Icon(Icons.logout),
              label: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDecisionTable() {
    const headerStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 13);
    const cellStyle = TextStyle(fontSize: 12);

    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade100),
          children: const [
            Padding(
              padding: EdgeInsets.all(8),
              child: Text('', style: headerStyle),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text('Supabase', style: headerStyle),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text('Firebase', style: headerStyle),
            ),
          ],
        ),
        _tableRow('Database', 'PostgreSQL (SQL)', 'Firestore (NoSQL)', cellStyle),
        _tableRow('Query style', 'SQL-like chaining', 'Document/collection', cellStyle),
        _tableRow('Real-time', 'Yes (channels)', 'Yes (snapshots)', cellStyle),
        _tableRow('Auth', 'Yes', 'Yes', cellStyle),
        _tableRow('Open source', 'Yes ✓', 'No', cellStyle),
        _tableRow('Best for', 'SQL lovers, relational data', 'Quick NoSQL prototypes', cellStyle),
      ],
    );
  }

  TableRow _tableRow(
    String label,
    String supabase,
    String firebase,
    TextStyle style,
  ) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            label,
            style: style.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(supabase, style: style),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(firebase, style: style),
        ),
      ],
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
      padding: const EdgeInsets.all(12),
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
              fontSize: 12,
              height: 1.5,
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
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lightbulb, color: Colors.purple),
            const SizedBox(width: 8),
            Expanded(child: Text(tip, style: const TextStyle(height: 1.5))),
          ],
        ),
      ),
    );
  }
}
