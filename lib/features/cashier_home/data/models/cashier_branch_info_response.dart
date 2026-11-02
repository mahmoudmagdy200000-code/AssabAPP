class CashierBranchInfoResponse {
  final String id;
  final String name;
  final String? image;
  final String? location;
  final double? lat;
  final double? lng;
  final String? openingHours;
  final String? closingHours;
  final String? googleMapsUrl;
  final CashierBranchInfoBranchManager? branchManager;

  CashierBranchInfoResponse({
    required this.id,
    required this.name,
    required this.image,
    required this.location,
    required this.lat,
    required this.lng,
    required this.openingHours,
    required this.closingHours,
    required this.googleMapsUrl,
    required this.branchManager,
  });

  factory CashierBranchInfoResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return CashierBranchInfoResponse(
      id: data['id'] as String,
      name: data['name'] as String,
      image: data['image'] as String?,
      location: data['location'] as String?,
      lat: (data['lat'] as num?)?.toDouble(),
      lng: (data['lng'] as num?)?.toDouble(),
      openingHours: data['opening_hours'] as String?,
      closingHours: data['closing_hours'] as String?,
      googleMapsUrl: data['google_maps_url'] as String?,
      branchManager: data['branch_manager'] == null
          ? null
          : CashierBranchInfoBranchManager.fromJson(
              data['branch_manager'] as Map<String, dynamic>,
            ),
    );
  }
}

class CashierBranchInfoBranchManager {
  final String id;
  final String name;
  final String? image;

  CashierBranchInfoBranchManager({
    required this.id,
    required this.name,
    required this.image,
  });

  factory CashierBranchInfoBranchManager.fromJson(Map<String, dynamic> json) =>
      CashierBranchInfoBranchManager(
        id: json['id'] as String,
        name: json['name'] as String,
        image: json['image'] as String?,
      );
}
