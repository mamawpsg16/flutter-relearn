import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart'; // Generated code will go here

@JsonSerializable()
class Address {
  String street;
  String city;

  Address(this.street, this.city);

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);

  @override
  String toString() => 'Address(street: $street, city: $city)';
}
