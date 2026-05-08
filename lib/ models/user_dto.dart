import 'package:json_annotation/json_annotation.dart';
import 'address.dart';
import 'profile.dart';
import 'post.dart';

part 'user_dto.g.dart';

// DTO — mirrors API exactly, no UI logic
@JsonSerializable(explicitToJson: true)
class UserDTO {
  final String name;
  final String email;
  final Address? address;
  final Profile profile;
  final List<Post> posts;

  UserDTO({
    required this.name,
    required this.email,
    required this.profile,
    required this.posts,
    this.address,
  });

  factory UserDTO.fromJson(Map<String, dynamic> json) => _$UserDTOFromJson(json);
  Map<String, dynamic> toJson() => _$UserDTOToJson(this);
}
