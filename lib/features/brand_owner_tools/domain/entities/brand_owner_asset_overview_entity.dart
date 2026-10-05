class BrandOwnerAssetOverviewEntity {
  final List<BrandOwnerAssetOverviewBranchEntity> branches;
  final BrandOwnerAssetOverviewNetworkStatisticsEntity networkStatistics;
  final BrandOwnerAssetOverviewPerformanceSummaryEntity performanceSummary;

  const BrandOwnerAssetOverviewEntity({
    required this.branches,
    required this.networkStatistics,
    required this.performanceSummary,
  });
}

class BrandOwnerAssetOverviewBranchEntity {
  final String id;
  final String branchName;
  final String managerName;
  final String? managerImageUrl;
  final int assetsCount;
  final int excellentCount;
  final int attentionCount;
  final int problemCount;
  final List<BrandOwnerAssetOverviewAssetEntity> assets;

  const BrandOwnerAssetOverviewBranchEntity({
    required this.id,
    required this.branchName,
    required this.managerName,
    required this.managerImageUrl,
    required this.assetsCount,
    required this.excellentCount,
    required this.attentionCount,
    required this.problemCount,
    required this.assets,
  });
}

class BrandOwnerAssetOverviewAssetEntity {
  final String id;
  final String name;
  final String code;
  final String zoneName;
  final String custodianName;
  final String custodyDuration;
  final String lastAuditDate;
  final String photoDate;
  final int transfersCount;
  final String imageUrl;

  const BrandOwnerAssetOverviewAssetEntity({
    required this.id,
    required this.name,
    required this.code,
    required this.zoneName,
    required this.custodianName,
    required this.custodyDuration,
    required this.lastAuditDate,
    required this.photoDate,
    required this.transfersCount,
    required this.imageUrl,
  });
}

class BrandOwnerAssetOverviewNetworkStatisticsEntity {
  final int totalAssets;
  final String excellentStatus;
  final String photoAccuracy;
  final String averageAssetAge;

  const BrandOwnerAssetOverviewNetworkStatisticsEntity({
    required this.totalAssets,
    required this.excellentStatus,
    required this.photoAccuracy,
    required this.averageAssetAge,
  });
}

class BrandOwnerAssetOverviewPerformanceSummaryEntity {
  final int assetsInExcellentCondition;
  final String excellentPercent;
  final String photoCompliance;
  final String averageResolutionTime;
  final int lastAuditScore;

  const BrandOwnerAssetOverviewPerformanceSummaryEntity({
    required this.assetsInExcellentCondition,
    required this.excellentPercent,
    required this.photoCompliance,
    required this.averageResolutionTime,
    required this.lastAuditScore,
  });
}

class BrandOwnerAssetOverviewExportRequestEntity {
  final String branchId;
  final String format;

  const BrandOwnerAssetOverviewExportRequestEntity({
    required this.branchId,
    required this.format,
  });
}

class BrandOwnerAssetOverviewExportResponseEntity {
  final String branchId;
  final String branchName;
  final String format;
  final String message;

  const BrandOwnerAssetOverviewExportResponseEntity({
    required this.branchId,
    required this.branchName,
    required this.format,
    required this.message,
  });
}