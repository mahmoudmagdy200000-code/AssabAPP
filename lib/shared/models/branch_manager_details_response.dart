class BranchManagerDetailsResponse {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? image;

  BranchManagerDetailsResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.image,
  });

  factory BranchManagerDetailsResponse.fromJson(Map<String, dynamic> json) {
    return BranchManagerDetailsResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      image: json['image'] as String?,
    );
  }
}
