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
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final manager = data['branch_manager'];
    return CashierBranchInfoResponse(
      id: (data['id'] ?? '').toString(),
      name: (data['name'] as String?) ?? '-',
      image: data['image'] as String?,
      location: data['location'] as String?,
      lat: (data['lat'] as num?)?.toDouble(),
      lng: (data['lng'] as num?)?.toDouble(),
      openingHours: data['opening_hours'] as String?,
      closingHours: data['closing_hours'] as String?,
      googleMapsUrl: data['google_maps_url'] as String?,
      branchManager: manager is Map<String, dynamic>
          ? CashierBranchInfoBranchManager.fromJson(manager)
          : null,
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
        id: (json['id'] ?? '').toString(),
        name: (json['name'] as String?) ?? '-',
        image: json['image'] as String?,
      );
}
