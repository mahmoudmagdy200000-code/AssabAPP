import 'fixed_assets_handover_included_zones_response.dart';

class FixedAssetsJoinHandoverSessionDetailsResponse {
  final String sessionId;
  final String sessionCode;
  final String sessionImageUrl;
  final String handoverByName;
  final String handoverByImageUrl;
  final String branchName;
  final DateTime sessionDate;
  final int totalZones;
  final int totalAssets;
  final double totalValue;
  final String note;
  final List<FixedAssetsHandoverIncludedZone> includedZones;

  const FixedAssetsJoinHandoverSessionDetailsResponse({
    required this.sessionId,
    required this.sessionCode,
    required this.sessionImageUrl,
    required this.handoverByName,
    required this.handoverByImageUrl,
    required this.branchName,
    required this.sessionDate,
    required this.totalZones,
    required this.totalAssets,
    required this.totalValue,
    required this.note,
    required this.includedZones,
  });

  factory FixedAssetsJoinHandoverSessionDetailsResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    final zonesList = data['includedZones'] as List;
    final includedZonesList = zonesList
        .map((zoneJson) => FixedAssetsHandoverIncludedZone.fromJson(zoneJson))
        .toList();

    return FixedAssetsJoinHandoverSessionDetailsResponse(
      sessionId: data['sessionId'] as String,
      sessionCode: data['sessionCode'] as String,
      sessionImageUrl: data['sessionImageUrl'] as String,
      handoverByName: data['handoverByName'] as String,
      handoverByImageUrl: data['handoverByImageUrl'] as String,
      branchName: data['branchName'] as String,
      sessionDate: DateTime.parse(data['sessionDate'] as String),
      totalZones: data['totalZones'] as int,
      totalAssets: data['totalAssets'] as int,
      totalValue: (data['totalValue'] as num).toDouble(),
      note: data['note'] as String,
      includedZones: includedZonesList,
    );
  }
}
