class FixedAssetsZonesResponse {
  final List<FixedAssetsZoneData> zones;

  FixedAssetsZonesResponse({required this.zones});

  factory FixedAssetsZonesResponse.fromJson(Map<String, dynamic> json) {
    var zonesJson = json['data']['data'] as List<dynamic>;
    List<FixedAssetsZoneData> zonesList = zonesJson
        .map(
          (zoneJson) =>
              FixedAssetsZoneData.fromJson(zoneJson as Map<String, dynamic>),
        )
        .toList();

    return FixedAssetsZonesResponse(zones: zonesList);
  }
}

class FixedAssetsZoneData {
  final String id;
  final String name;

  FixedAssetsZoneData({required this.id, required this.name});

  factory FixedAssetsZoneData.fromJson(Map<String, dynamic> json) {
    return FixedAssetsZoneData(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}
