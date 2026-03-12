import 'package:uuid/uuid.dart';

class User {
  final String id;
  final String name;
  final String email;

  User({required this.name, required this.email}) : id = const Uuid().v4();

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'email': email};
  }
}
