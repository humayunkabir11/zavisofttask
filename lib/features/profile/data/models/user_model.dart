import '../../domain/entities/user_entity.dart';

class UserModel {
  final int id;
  final String email;
  final String username;
  final String firstName;
  final String lastName;
  final String phone;
  final String city;
  final String street;
  final String zipcode;

  const UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.city,
    required this.street,
    required this.zipcode,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as Map<String, dynamic>? ?? {};
    final address = json['address'] as Map<String, dynamic>? ?? {};
    return UserModel(
      id: json['id'] as int? ?? 0,
      email: json['email'] as String? ?? '',
      username: json['username'] as String? ?? '',
      firstName: name['firstname'] as String? ?? '',
      lastName: name['lastname'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      city: address['city'] as String? ?? '',
      street: address['street'] as String? ?? '',
      zipcode: address['zipcode'] as String? ?? '',
    );
  }

  ProfileUserEntity toEntity() => ProfileUserEntity(
        id: id,
        email: email,
        username: username,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        city: city,
        street: street,
        zipcode: zipcode,
      );
}
