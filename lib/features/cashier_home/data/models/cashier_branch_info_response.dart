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
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    final manager = data['branch_manager'];
    final managerId = manager is Map<String, dynamic>
        ? manager['id']?.toString().trim()
        : null;
    final managerName = manager is Map<String, dynamic>
        ? manager['name']
        : null;
    return CashierBranchInfoResponse(
      id: (data['id'] ?? '').toString(),
      name: data['name'] is String ? data['name'] as String : '-',
      image: data['image'] is String ? data['image'] as String : null,
      location: data['location'] is String ? data['location'] as String : null,
      lat: data['lat'] is num ? (data['lat'] as num).toDouble() : null,
      lng: data['lng'] is num ? (data['lng'] as num).toDouble() : null,
      openingHours: data['opening_hours'] is String
          ? data['opening_hours'] as String
          : null,
      closingHours: data['closing_hours'] is String
          ? data['closing_hours'] as String
          : null,
      googleMapsUrl: data['google_maps_url'] is String
          ? data['google_maps_url'] as String
          : null,
      branchManager:
          manager is Map<String, dynamic> &&
              managerId != null &&
              managerId.isNotEmpty &&
              managerName is String &&
              managerName.trim().isNotEmpty
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
        name: json['name'] is String ? json['name'] as String : '-',
        image: json['image'] is String ? json['image'] as String : null,
      );
}
