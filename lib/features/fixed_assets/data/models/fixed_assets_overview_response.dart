import '../../domain/enums/fixed_assets_handover_enum.dart';
import '../../domain/enums/fixed_assets_handover_type_enum.dart';
import '../../domain/strategies/fixed_assets_handover_strategy.dart';
import '../../domain/strategies/fixed_assets_handover_type_strategy.dart';

class FixedAssetsOverviewResponse {
  final FixedAssetsOverviewHandover? handover;
  final List<FixedAssetsOverviewAssetRejectedItem> rejectedAssets;
  final int totalAssets;
  final int totalAssetsExcellent;
  final int totalAssetsMaintenance;
  final int totalAssetsProblem;

  FixedAssetsOverviewResponse({
    required this.handover,
    required this.rejectedAssets,
    required this.totalAssets,
    required this.totalAssetsExcellent,
    required this.totalAssetsMaintenance,
    required this.totalAssetsProblem,
  });

  factory FixedAssetsOverviewResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    return FixedAssetsOverviewResponse(
      handover: data['handover'] != null
          ? FixedAssetsOverviewHandover.fromJson(data['handover'])
          : null,
      rejectedAssets: (data['rejectedAssets'] as List<dynamic>? ?? [])
          .map((item) => FixedAssetsOverviewAssetRejectedItem.fromJson(item))
          .toList(),
      totalAssets: data['totalAssets'] ?? 0,
      totalAssetsExcellent: data['totalAssetsExcellent'] ?? 0,
      totalAssetsMaintenance: data['totalAssetsMaintenance'] ?? 0,
      totalAssetsProblem: data['totalAssetsProblem'] ?? 0,
    );
  }
}

class FixedAssetsOverviewHandover {
  final String id;
  final FixedAssetsHandoverStrategy status;
  final FixedAssetsHandoverTypeStrategy type;
  final String recipientName;

  FixedAssetsOverviewHandover({
    required this.id,
    required this.status,
    required this.type,
    required this.recipientName,
  });

  factory FixedAssetsOverviewHandover.fromJson(Map<String, dynamic> json) {
    return FixedAssetsOverviewHandover(
      id: json['id'],
      status: FixedAssetsHandoverStrategy.getStrategy(
        FixedAssetsHandoverEnum.fromString(json['status'] as String),
      ),
      type: FixedAssetsHandoverTypeStrategy.getStrategy(
        FixedAssetsHandoverTypeEnum.fromString(json['type'] as String),
      ),
      recipientName: json['recipientName'] ?? '',
    );
  }
}

class FixedAssetsOverviewAssetRejectedItem {
  final String id;
  final String name;
  final String code;
  final String zoneName;
  final String imageUrl;
  final String assetType;
  final String age;
  final String handoverDescription;

  FixedAssetsOverviewAssetRejectedItem({
    required this.id,
    required this.name,
    required this.code,
    required this.zoneName,
    required this.imageUrl,
    required this.assetType,
    required this.age,
    required this.handoverDescription,
  });

  factory FixedAssetsOverviewAssetRejectedItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return FixedAssetsOverviewAssetRejectedItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      zoneName: json['zoneName'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      assetType: json['assetType'] ?? '',
      age: json['age'] ?? '',
      handoverDescription: json['handoverDescription'] ?? '',
    );
  }
}
