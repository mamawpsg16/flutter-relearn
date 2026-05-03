import 'dart:convert';
import 'package:flutter/material.dart';

// Manual nested models for the live demo
class _Address {
  final String street;
  final String city;
  final String country;

  const _Address(
      {required this.street, required this.city, required this.country});

  factory _Address.fromJson(Map<String, dynamic> json) => _Address(
        street: json['street'] as String,
        city: json['city'] as String,
        country: json['country'] as String,
      );

  Map<String, dynamic> toJson() =>
      {'street': street, 'city': city, 'country': country};
}

class _Person {
  final String name;
  final int age;
  final _Address address;

  const _Person(
      {required this.name, required this.age, required this.address});

  factory _Person.fromJson(Map<String, dynamic> json) => _Person(
        name: json['name'] as String,
        age: json['age'] as int,
        address:
            _Address.fromJson(json['address'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() =>
      {'name': name, 'age': age, 'address': address.toJson()};
}

const _sampleJson = '''
{
  "name": "Alice",
  "age": 30,
  "address": {
    "street": "123 Main St",
    "city": "New York",
    "country": "USA"
  }
}
''';

class NestedClassesScreen extends StatefulWidget {
  const NestedClassesScreen({super.key});

  @override
  State<NestedClassesScreen> createState() => _NestedClassesScreenState();
}

class _NestedClassesScreenState extends State<NestedClassesScreen> {
  _Person? _result;

  void _parse() {
    final map = jsonDecode(_sampleJson) as Map<String, dynamic>;
    setState(() => _result = _Person.fromJson(map));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generating Code for Nested Classes'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'When a JSON object contains another object, you need nested model classes. '
            'Each nested class has its own fromJson/toJson, '
            'and the parent calls them explicitly.',
          ),
          const SizedBox(height: 16),

          const _CodeSection(
            label: 'BAD — flattening nested objects manually',
            labelColor: Colors.red,
            code: '''
// Reaching into nested maps inline → messy and crash-prone
final city = (json['address'] as Map)['city'] as String;
// What if address is null? RuntimeError.''',
          ),
          const SizedBox(height: 12),

          const _CodeSection(
            label: 'GOOD — separate model classes for each object',
            labelColor: Colors.green,
            code: '''
class Address {
  final String street;
  final String city;
  final String country;

  Address({required this.street, required this.city, required this.country});

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    street:  json['street']  as String,
    city:    json['city']    as String,
    country: json['country'] as String,
  );

  Map<String, dynamic> toJson() =>
    {'street': street, 'city': city, 'country': country};
}

class Person {
  final String name;
  final int age;
  final Address address; // typed — not a raw Map

  Person({required this.name, required this.age, required this.address});

  factory Person.fromJson(Map<String, dynamic> json) => Person(
    name:    json['name'] as String,
    age:     json['age']  as int,
    address: Address.fromJson(json['address'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() =>
    {'name': name, 'age': age, 'address': address.toJson()};
}''',
          ),
          const SizedBox(height: 16),

          const _CodeSection(
            label: 'json_serializable — use explicitToJson: true for nesting',
            labelColor: Colors.purple,
            code: '''
@JsonSerializable()
class Address {
  final String street, city, country;
  Address({required this.street, required this.city, required this.country});

  factory Address.fromJson(Map<String, dynamic> json) =>
      _\$AddressFromJson(json);
  Map<String, dynamic> toJson() => _\$AddressToJson(this);
}

// explicitToJson: true tells the generator to call address.toJson()
// instead of leaving it as a raw object
@JsonSerializable(explicitToJson: true)
class Person {
  final String name;
  final int age;
  final Address address;

  Person({required this.name, required this.age, required this.address});

  factory Person.fromJson(Map<String, dynamic> json) =>
      _\$PersonFromJson(json);
  Map<String, dynamic> toJson() => _\$PersonToJson(this);
}''',
          ),
          const SizedBox(height: 16),

          // Live demo
          const Text('Live demo — parse nested JSON:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _sampleJson.trim(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'monospace',
                          fontSize: 11),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _parse,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Parse nested JSON'),
                  ),
                  if (_result != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        border: Border.all(color: Colors.green.shade200),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Person',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade800)),
                          const SizedBox(height: 4),
                          _MonoLine('name: ${_result!.name}'),
                          _MonoLine('age:  ${_result!.age}'),
                          const SizedBox(height: 4),
                          Text('  address:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade700,
                                  fontSize: 12)),
                          _MonoLine('    street:  ${_result!.address.street}'),
                          _MonoLine('    city:    ${_result!.address.city}'),
                          _MonoLine('    country: ${_result!.address.country}'),
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
            tip: 'Always add explicitToJson: true when using json_serializable '
                'with nested objects. Without it, toJson() will serialize the '
                'nested class as a Dart object instead of a JSON-compatible Map.',
          ),
        ],
      ),
    );
  }
}

class _MonoLine extends StatelessWidget {
  final String text;
  const _MonoLine(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
            color: Colors.green.shade800));
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
                  color: labelColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12)),
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
            Expanded(
                child: Text(tip, style: const TextStyle(fontSize: 13))),
          ],
        ),
      ),
    );
  }
}
