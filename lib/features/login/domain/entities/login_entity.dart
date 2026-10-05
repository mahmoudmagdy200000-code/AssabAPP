class LoginEntity {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? image;
  final String createdAt;
  final String token;

  const LoginEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.image,
    required this.createdAt,
    required this.token,
  });
}
