/// Domain entity for a user profile
class UserEntity {
  final int id;
  final String email;
  final String username;
  final String firstName;
  final String lastName;
  final String phone;

  const UserEntity({
    required this.id,
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.phone,
  });

  String get fullName => '$firstName $lastName';
}
