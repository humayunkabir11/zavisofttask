class ProfileUserEntity {
  final int id;
  final String email;
  final String username;
  final String firstName;
  final String lastName;
  final String phone;
  final String city;
  final String street;
  final String zipcode;

  const ProfileUserEntity({
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

  String get fullName => '$firstName $lastName';
}
