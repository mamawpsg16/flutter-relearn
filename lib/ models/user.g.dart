// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
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

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'name': instance.name,
  'email': instance.email,
  'profile': instance.profile.toJson(),
  'posts': instance.posts.map((e) => e.toJson()).toList(),
  'address': instance.address?.toJson(),
};
