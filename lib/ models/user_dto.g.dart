// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDTO _$UserDTOFromJson(Map<String, dynamic> json) => UserDTO(
  name: json['name'] as String,
  email: json['email'] as String,
  profile: Profile.fromJson(json['profile'] as Map<String, dynamic>),
  posts: (json['posts'] as List<dynamic>)
      .map((e) => Post.fromJson(e as Map<String, dynamic>))
      .toList(),
  address: json['address'] == null
      ? null
      : Address.fromJson(json['address'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserDTOToJson(UserDTO instance) => <String, dynamic>{
  'name': instance.name,
  'email': instance.email,
  'address': instance.address?.toJson(),
  'profile': instance.profile.toJson(),
  'posts': instance.posts.map((e) => e.toJson()).toList(),
};
