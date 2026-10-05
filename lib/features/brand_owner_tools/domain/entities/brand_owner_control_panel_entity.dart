class BrandOwnerControlPanelEntity {
  final ControlPanelStrategicOverviewEntity strategicOverview;
  final ControlPanelBranchPerformanceEntity branchPerformance;
  final ControlPanelExecutiveSummaryEntity executiveSummary;

  const BrandOwnerControlPanelEntity({
    required this.strategicOverview,
    required this.branchPerformance,
    required this.executiveSummary,
  });
}

class ControlPanelStrategicOverviewEntity {
  final int totalChainAssets;
  final String excellentStatus;
  final int branchesCount;
  final String totalInvestment;
  final String criticalValueImpact;

  const ControlPanelStrategicOverviewEntity({
    required this.totalChainAssets,
    required this.excellentStatus,
    required this.branchesCount,
    required this.totalInvestment,
    required this.criticalValueImpact,
  });
}

class ControlPanelBranchPerformanceEntity {
  final List<ControlPanelBranchPerformanceItemEntity> items;

  const ControlPanelBranchPerformanceEntity({required this.items});
}

class ControlPanelBranchPerformanceItemEntity {
  final String name;
  final String percentage;
  final String status;

  const ControlPanelBranchPerformanceItemEntity({
    required this.name,
    required this.percentage,
    required this.status,
  });
}

class ControlPanelExecutiveSummaryEntity {
  final String photoAccuracy;
  final String auditCompletion;

  const ControlPanelExecutiveSummaryEntity({
    required this.photoAccuracy,
    required this.auditCompletion,
  });
}
