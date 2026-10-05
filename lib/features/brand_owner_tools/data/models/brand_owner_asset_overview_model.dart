import '../../domain/entities/brand_owner_asset_overview_entity.dart';

class BrandOwnerAssetOverviewResponseModel
    extends BrandOwnerAssetOverviewEntity {
  const BrandOwnerAssetOverviewResponseModel({
    required super.branches,
    required super.networkStatistics,
    required super.performanceSummary,
  });

  factory BrandOwnerAssetOverviewResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return BrandOwnerAssetOverviewResponseModel(
      branches: (data['branches'] as List<dynamic>? ?? [])
          .map(
            (e) =>
                BrandOwnerAssetOverviewBranchModel.fromJson(
                  e as Map<String, dynamic>,
                ),
          )
          .toList(),
      networkStatistics:
          BrandOwnerAssetOverviewNetworkStatisticsModel.fromJson(
            data['network_statistics'] as Map<String, dynamic>? ?? {},
          ),
      performanceSummary:
          BrandOwnerAssetOverviewPerformanceSummaryModel.fromJson(
            data['performance_summary'] as Map<String, dynamic>? ?? {},
          ),
    );
  }

  Map<String, dynamic> toJson() => {
    'branches': branches
        .map((e) => (e as BrandOwnerAssetOverviewBranchModel).toJson())
        .toList(),
    'network_statistics':
        (networkStatistics as BrandOwnerAssetOverviewNetworkStatisticsModel)
            .toJson(),
    'performance_summary':
        (performanceSummary as BrandOwnerAssetOverviewPerformanceSummaryModel)
            .toJson(),
  };
}

class BrandOwnerAssetOverviewBranchModel
    extends BrandOwnerAssetOverviewBranchEntity {
  const BrandOwnerAssetOverviewBranchModel({
    required super.id,
    required super.branchName,
    required super.managerName,
    required super.managerImageUrl,
    required super.assetsCount,
    required super.excellentCount,
    required super.attentionCount,
    required super.problemCount,
    required super.assets,
  });

  factory BrandOwnerAssetOverviewBranchModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return BrandOwnerAssetOverviewBranchModel(
      id: data['id'] as String? ?? '',
      branchName: data['branch_name'] as String? ?? '',
      managerName: data['manager_name'] as String? ?? '',
      managerImageUrl: data['manager_image_url'] as String?,
      assetsCount: (data['assets_count'] as num?)?.toInt() ?? 0,
      excellentCount: (data['excellent_count'] as num?)?.toInt() ?? 0,
      attentionCount: (data['attention_count'] as num?)?.toInt() ?? 0,
      problemCount: (data['problem_count'] as num?)?.toInt() ?? 0,
      assets: (data['assets'] as List<dynamic>? ?? [])
          .map(
            (e) =>
                BrandOwnerAssetOverviewAssetModel.fromJson(
                  e as Map<String, dynamic>,
                ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'branch_name': branchName,
    'manager_name': managerName,
    'manager_image_url': managerImageUrl,
    'assets_count': assetsCount,
    'excellent_count': excellentCount,
    'attention_count': attentionCount,
    'problem_count': problemCount,
    'assets': assets
        .map((e) => (e as BrandOwnerAssetOverviewAssetModel).toJson())
        .toList(),
  };
}

class BrandOwnerAssetOverviewAssetModel
    extends BrandOwnerAssetOverviewAssetEntity {
  const BrandOwnerAssetOverviewAssetModel({
    required super.id,
    required super.name,
    required super.code,
    required super.zoneName,
    required super.custodianName,
    required super.custodyDuration,
    required super.lastAuditDate,
    required super.photoDate,
    required super.transfersCount,
    required super.imageUrl,
  });

  factory BrandOwnerAssetOverviewAssetModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return BrandOwnerAssetOverviewAssetModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      zoneName: json['zone_name'] as String? ?? '',
      custodianName: json['custodian_name'] as String? ?? '',
      custodyDuration: json['custody_duration'] as String? ?? '',
      lastAuditDate: json['last_audit_date'] as String? ?? '',
      photoDate: json['photo_date'] as String? ?? '',
      transfersCount: (json['transfers_count'] as num?)?.toInt() ?? 0,
      imageUrl: json['image_url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'code': code,
    'zone_name': zoneName,
    'custodian_name': custodianName,
    'custody_duration': custodyDuration,
    'last_audit_date': lastAuditDate,
    'photo_date': photoDate,
    'transfers_count': transfersCount,
    'image_url': imageUrl,
  };
}

class BrandOwnerAssetOverviewNetworkStatisticsModel
    extends BrandOwnerAssetOverviewNetworkStatisticsEntity {
  const BrandOwnerAssetOverviewNetworkStatisticsModel({
    required super.totalAssets,
    required super.excellentStatus,
    required super.photoAccuracy,
    required super.averageAssetAge,
  });

  factory BrandOwnerAssetOverviewNetworkStatisticsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return BrandOwnerAssetOverviewNetworkStatisticsModel(
      totalAssets: (json['total_assets'] as num?)?.toInt() ?? 0,
      excellentStatus: json['excellent_status'] as String? ?? '',
      photoAccuracy: json['photo_accuracy'] as String? ?? '',
      averageAssetAge: json['average_asset_age'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'total_assets': totalAssets,
    'excellent_status': excellentStatus,
    'photo_accuracy': photoAccuracy,
    'average_asset_age': averageAssetAge,
  };
}

class BrandOwnerAssetOverviewPerformanceSummaryModel
    extends BrandOwnerAssetOverviewPerformanceSummaryEntity {
  const BrandOwnerAssetOverviewPerformanceSummaryModel({
    required super.assetsInExcellentCondition,
    required super.excellentPercent,
    required super.photoCompliance,
    required super.averageResolutionTime,
    required super.lastAuditScore,
  });

  factory BrandOwnerAssetOverviewPerformanceSummaryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return BrandOwnerAssetOverviewPerformanceSummaryModel(
      assetsInExcellentCondition:
          (data['assets_in_excellent_condition'] as num?)?.toInt() ?? 0,
      excellentPercent: data['excellent_percent'] as String? ?? '',
      photoCompliance: data['photo_compliance'] as String? ?? '',
      averageResolutionTime: data['average_resolution_time'] as String? ?? '',
      lastAuditScore: (data['last_audit_score'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'assets_in_excellent_condition': assetsInExcellentCondition,
    'excellent_percent': excellentPercent,
    'photo_compliance': photoCompliance,
    'average_resolution_time': averageResolutionTime,
    'last_audit_score': lastAuditScore,
  };
}

class BrandOwnerAssetOverviewExportRequestModel
    extends BrandOwnerAssetOverviewExportRequestEntity {
  const BrandOwnerAssetOverviewExportRequestModel({
    required super.branchId,
    required super.format,
  });

  factory BrandOwnerAssetOverviewExportRequestModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return BrandOwnerAssetOverviewExportRequestModel(
      branchId: json['branch_id'] as String? ?? '',
      format: json['format'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'branch_id': branchId,
    'format': format,
  };
}

class BrandOwnerAssetOverviewExportResponseModel
    extends BrandOwnerAssetOverviewExportResponseEntity {
  const BrandOwnerAssetOverviewExportResponseModel({
    required super.branchId,
    required super.branchName,
    required super.format,
    required super.message,
  });

  factory BrandOwnerAssetOverviewExportResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return BrandOwnerAssetOverviewExportResponseModel(
      branchId: data['branch_id'] as String? ?? '',
      branchName: data['branch_name'] as String? ?? '',
      format: data['format'] as String? ?? '',
      message: data['message'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'branch_id': branchId,
    'branch_name': branchName,
    'format': format,
    'message': message,
  };
}