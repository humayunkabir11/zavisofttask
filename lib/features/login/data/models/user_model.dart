import '../../domain/entities/user_entity.dart';

/// Data model for https://fakestoreapi.com/users/{id}
class UserModel {
  final int id;
  final String email;
  final String username;
  final String firstName;
  final String lastName;
  final String phone;

  const UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as Map<String, dynamic>? ?? {};
    return UserModel(
      id: json['id'] as int? ?? 0,
      email: json['email'] as String? ?? '',
      username: json['username'] as String? ?? '',
      firstName: name['firstname'] as String? ?? '',
      lastName: name['lastname'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
    );
  }

  UserEntity toEntity() => UserEntity(
        id: id,
        email: email,
        username: username,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );
}
