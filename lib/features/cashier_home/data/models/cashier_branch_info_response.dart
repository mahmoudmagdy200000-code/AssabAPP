class CashierBranchInfoResponse {
  final String id;
  final String name;
  final String image;
  final String location;
  final double lat;
  final double lng;
  final String openingHours;
  final String closingHours;
  final String googleMapsUrl;
  final CashierBranchInfoBranchManager branchManager;

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
    final data = json['data'];
    return CashierBranchInfoResponse(
      id: data['id'],
      name: data['name'],
      image: data['image'],
      location: data['location'],
      lat: data['lat'],
      lng: data['lng'],
      openingHours: data['opening_hours'],
      closingHours: data['closing_hours'],
      googleMapsUrl: data['google_maps_url'],
      branchManager: CashierBranchInfoBranchManager.fromJson(
        data['branch_manager'],
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
        id: json['id'],
        name: json['name'],
        image: json['image'],
      );
}
