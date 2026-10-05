class FixedAssetsActiveHandoverSessionDetailsResponse {
  final String sessionId;
  final String fromEmployeeName;
  final String toEmployeeName;
  final List<FixedAssetsActiveHandoverZone> zones;

  const FixedAssetsActiveHandoverSessionDetailsResponse({
    required this.sessionId,
    required this.fromEmployeeName,
    required this.toEmployeeName,
    required this.zones,
  });

  factory FixedAssetsActiveHandoverSessionDetailsResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final zonesList = data['zones'] as List;
    final zones = zonesList
        .map((zoneJson) => FixedAssetsActiveHandoverZone.fromJson(zoneJson))
        .toList();

    return FixedAssetsActiveHandoverSessionDetailsResponse(
      sessionId: data['sessionId'] as String,
      fromEmployeeName: data['fromEmployeeName'] as String,
      toEmployeeName: data['toEmployeeName'] as String,
      zones: zones,
    );
  }
}

class FixedAssetsActiveHandoverZone {
  final String zoneId;
  final String zoneName;
  final int assetsCount;
  final bool isZoneApproved;
  final List<FixedAssetsActiveHandoverAsset> assets;

  const FixedAssetsActiveHandoverZone({
    required this.zoneId,
    required this.zoneName,
    required this.assetsCount,
    required this.isZoneApproved,
    required this.assets,
  });

  FixedAssetsActiveHandoverZone copyWith({
    String? zoneId,
    String? zoneName,
    int? assetsCount,
    bool? isZoneApproved,
    List<FixedAssetsActiveHandoverAsset>? assets,
  }) {
    return FixedAssetsActiveHandoverZone(
      zoneId: zoneId ?? this.zoneId,
      zoneName: zoneName ?? this.zoneName,
      assetsCount: assetsCount ?? this.assetsCount,
      isZoneApproved: isZoneApproved ?? this.isZoneApproved,
      assets: assets ?? this.assets,
    );
  }

  factory FixedAssetsActiveHandoverZone.fromJson(Map<String, dynamic> json) {
    final assetsList = json['assets'] as List? ?? [];
    final assets = assetsList
        .map((assetJson) => FixedAssetsActiveHandoverAsset.fromJson(assetJson))
        .toList();

    return FixedAssetsActiveHandoverZone(
      zoneId: json['zoneId'] as String,
      zoneName: json['zoneName'] as String,
      assetsCount: json['assetsCount'] as int,
      isZoneApproved: json['isZoneApproved'] as bool? ?? false,
      assets: assets,
    );
  }
}

class FixedAssetsActiveHandoverAsset {
  final String assetId;
  final String assetName;
  final String assetCode;
  final String assetImageUrl;
  final int currentQty;

  const FixedAssetsActiveHandoverAsset({
    required this.assetId,
    required this.assetName,
    required this.assetCode,
    required this.assetImageUrl,
    required this.currentQty,
  });

  factory FixedAssetsActiveHandoverAsset.fromJson(Map<String, dynamic> json) {
    return FixedAssetsActiveHandoverAsset(
      assetId: json['assetId'] as String,
      assetName: json['assetName'] as String,
      assetCode: json['assetCode'] as String,
      assetImageUrl: json['assetImageUrl'] as String,
      currentQty: json['currentQty'] as int,
    );
  }
}
