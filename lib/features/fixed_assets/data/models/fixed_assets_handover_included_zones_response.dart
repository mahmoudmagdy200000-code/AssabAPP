class FixedAssetsHandoverIncludedZonesResponse {
  final int totalIncludedItems;
  final double totalValueOfIncludedZones;
  final List<FixedAssetsHandoverIncludedZone> includedZones;

  FixedAssetsHandoverIncludedZonesResponse({
    required this.totalIncludedItems,
    required this.totalValueOfIncludedZones,
    required this.includedZones,
  });

  factory FixedAssetsHandoverIncludedZonesResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>;
    var zonesList = data['includedZones'] as List;

    List<FixedAssetsHandoverIncludedZone> includedZonesList = zonesList
        .map((zoneJson) => FixedAssetsHandoverIncludedZone.fromJson(zoneJson))
        .toList();

    return FixedAssetsHandoverIncludedZonesResponse(
      totalIncludedItems: data['totalIncludedItems'] as int,
      totalValueOfIncludedZones: (data['totalValueOfIncludedZones'] as num)
          .toDouble(), // Ensure it's a double
      includedZones: includedZonesList,
    );
  }
}

class FixedAssetsHandoverIncludedZone {
  final String zoneID;
  final String zoneName;
  final List<FixedAssetsHandoverIncludedZoneAsset> assetsInZone;

  FixedAssetsHandoverIncludedZone({
    required this.zoneID,
    required this.zoneName,
    required this.assetsInZone,
  });

  factory FixedAssetsHandoverIncludedZone.fromJson(Map<String, dynamic> json) {
    var assetsList = json['assetsInZone'] as List;
    List<FixedAssetsHandoverIncludedZoneAsset> assetsInZoneList = assetsList
        .map(
          (assetJson) =>
              FixedAssetsHandoverIncludedZoneAsset.fromJson(assetJson),
        )
        .toList();

    return FixedAssetsHandoverIncludedZone(
      zoneID: json['zoneID'] as String,
      zoneName: json['zoneName'] as String,
      assetsInZone: assetsInZoneList,
    );
  }
}

class FixedAssetsHandoverIncludedZoneAsset {
  final String assetId;
  final String assetName;
  final String assetImageURL;
  final int totalQuantityInZone;
  final int totalExcellentConditionQuantityInZone;
  final int totalNeedAttentionConditionQuantityInZone;
  final int totalProblemConditionQuantityInZone;

  FixedAssetsHandoverIncludedZoneAsset({
    required this.assetId,
    required this.assetName,
    required this.assetImageURL,
    required this.totalQuantityInZone,
    required this.totalExcellentConditionQuantityInZone,
    required this.totalNeedAttentionConditionQuantityInZone,
    required this.totalProblemConditionQuantityInZone,
  });

  factory FixedAssetsHandoverIncludedZoneAsset.fromJson(
    Map<String, dynamic> json,
  ) {
    return FixedAssetsHandoverIncludedZoneAsset(
      assetId: json['assetId'] as String,
      assetName: json['assetName'] as String,
      assetImageURL: json['assetImageURL'] as String,
      totalQuantityInZone: json['totalQuantityInZone'] as int,
      totalExcellentConditionQuantityInZone:
          json['totalExcellentConditionQuantityInZone'] as int,
      totalNeedAttentionConditionQuantityInZone:
          json['totalNeedAttentionConditionQuantityInZone'] as int,
      totalProblemConditionQuantityInZone:
          json['totalProblemConditionQuantityInZone'] as int,
    );
  }
}
