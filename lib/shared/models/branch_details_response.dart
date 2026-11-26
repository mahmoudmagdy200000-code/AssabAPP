class BranchDetailsResponse {
  final String id;
  final String name;
  final String? image;
  final String location;
  final double lat;
  final double lng;
  final DateTime? openingHours;
  final DateTime? closingHours;

  BranchDetailsResponse({
    required this.id,
    required this.name,
    this.image,
    required this.location,
    required this.lat,
    required this.lng,
    required this.openingHours,
    required this.closingHours,
  });

  factory BranchDetailsResponse.fromJson(Map<String, dynamic> json) {
    return BranchDetailsResponse(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      image: json['image']?.toString(),
      location: (json['location'] ?? '').toString(),
      lat: ((json['lat'] as num?) ?? 0).toDouble(),
      lng: ((json['lng'] as num?) ?? 0).toDouble(),
      openingHours: json['opening_hours'] != null
          ? DateTime.tryParse(json['opening_hours'].toString())
          : null,
      closingHours: json['closing_hours'] != null
          ? DateTime.tryParse(json['closing_hours'].toString())
          : null,
    );
  }
}
