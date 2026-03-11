class UserEntity {
  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String image;
  final String token;

  const UserEntity({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.image,
    required this.token,
  });

  String get fullName => '$firstName $lastName';
}
