class AvailableCashierEntity {
  final String id;
  final String name;
  final String? image;
  final bool isAvailable;

  AvailableCashierEntity({
    required this.id,
    required this.name,
    this.image,
    required this.isAvailable,
  });
}
