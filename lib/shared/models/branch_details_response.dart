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
      id: json['id'],
      name: json['name'],
      image: json['image'],
      location: json['location'].toString(),
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      openingHours: DateTime.tryParse(json['opening_hours']),
      closingHours: DateTime.tryParse(json['closing_hours']),
    );
  }
}
