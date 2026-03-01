import 'package:flutter/material.dart';
import 'validators.dart';

/// The Contact Us screen.
/// Single Responsibility: This widget ONLY handles form layout and submission.
/// Dependency Injection: Validators are imported as functions, not hardcoded inline.
class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  // Form key to track validation state
  final _formKey = GlobalKey<FormState>();

  // Controllers to read field values
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  // When true, validators run and errors show. When false, errors are hidden.
  bool _showErrors = false;

  // Stores all sent messages
  final List<Map<String, String>> _messages = [];

  // Key to control the scaffold (open/close drawer)
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _submitForm() {
    // Turn on error display
    setState(() {
      _showErrors = true;
    });

    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Thanks, ${_nameController.text}! Message sent.'),
          backgroundColor: Colors.green,
        ),
      );

      // Save the message before clearing
      _messages.add({
        'name': _nameController.text,
        'email': _emailController.text,
        'message': _messageController.text,
      });

      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
      setState(() {
        _showErrors = false;
      });
    }
  }

  // Called when user types in any field — hide errors so they get a clean slate
  void _onFieldChanged(String _) {
    if (_showErrors) {
      setState(() {
        _showErrors = false;
      });
      // Reset the form's validation state to clear error messages
      _formKey.currentState?.reset();
    }
  }

  @override
  void dispose() {
    // Always dispose controllers to free memory
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Contact Us'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (_messages.isNotEmpty)
            IconButton(
              onPressed: () {
                _scaffoldKey.currentState?.openEndDrawer();
              },
              icon: Badge(
                label: Text('${_messages.length}'),
                child: const Icon(Icons.inbox),
              ),
              tooltip: 'Show messages',
            ),
        ],
      ),
      // Drawer that slides in from the right
      endDrawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: Text(
                      'Sent Messages',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text('${_messages.length}',
                      style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
            Expanded(
              child: _messages.isEmpty
                  ? const Center(child: Text('No messages yet'))
                  : ListView.builder(
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final msg = _messages[_messages.length - 1 - index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(msg['name']!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                const SizedBox(height: 4),
                                Text(msg['email']!,
                                    style: TextStyle(color: Colors.grey[600])),
                                const SizedBox(height: 8),
                                Text(msg['message']!),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Name field — validator is injected from validators.dart
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter your name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                onChanged: _onFieldChanged,
                validator: (value) => _showErrors ? validateName(value) : null,
              ),
              const SizedBox(height: 16),

              // Email field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: _onFieldChanged,
                validator: (value) => _showErrors ? validateEmail(value) : null,
              ),
              const SizedBox(height: 16),

              // Message field
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  hintText: 'What would you like to say?',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.message),
                ),
                maxLines: 4,
                onChanged: _onFieldChanged,
                validator: (value) => _showErrors ? validateMessage(value) : null,
              ),
              const SizedBox(height: 24),

              // Submit button
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Send Message',
                  style: TextStyle(fontSize: 16),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
