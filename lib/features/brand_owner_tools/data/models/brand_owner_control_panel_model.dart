import '../../domain/entities/brand_owner_control_panel_entity.dart';

class BrandOwnerControlPanelModel extends BrandOwnerControlPanelEntity {
  const BrandOwnerControlPanelModel({
    required super.strategicOverview,
    required super.branchPerformance,
    required super.executiveSummary,
  });

  factory BrandOwnerControlPanelModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return BrandOwnerControlPanelModel(
      strategicOverview:
          ControlPanelStrategicOverviewModel.fromJson(
            data['strategic_overview'] as Map<String, dynamic>? ?? {},
          ),
      branchPerformance:
          ControlPanelBranchPerformanceModel.fromJson(
            data['branch_performance'] as Map<String, dynamic>? ?? {},
          ),
      executiveSummary:
          ControlPanelExecutiveSummaryModel.fromJson(
            data['executive_summary'] as Map<String, dynamic>? ?? {},
          ),
    );
  }

  Map<String, dynamic> toJson() => {
    'strategic_overview':
        (strategicOverview as ControlPanelStrategicOverviewModel).toJson(),
    'branch_performance':
        (branchPerformance as ControlPanelBranchPerformanceModel).toJson(),
    'executive_summary':
        (executiveSummary as ControlPanelExecutiveSummaryModel).toJson(),
  };
}

class ControlPanelStrategicOverviewModel
    extends ControlPanelStrategicOverviewEntity {
  const ControlPanelStrategicOverviewModel({
    required super.totalChainAssets,
    required super.excellentStatus,
    required super.branchesCount,
    required super.totalInvestment,
    required super.criticalValueImpact,
  });

  factory ControlPanelStrategicOverviewModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ControlPanelStrategicOverviewModel(
      totalChainAssets: (json['total_chain_assets'] as num?)?.toInt() ?? 0,
      excellentStatus: json['excellent_status'] as String? ?? '',
      branchesCount: (json['branches_count'] as num?)?.toInt() ?? 0,
      totalInvestment: json['total_investment'] as String? ?? '',
      criticalValueImpact: json['critical_value_impact'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'total_chain_assets': totalChainAssets,
    'excellent_status': excellentStatus,
    'branches_count': branchesCount,
    'total_investment': totalInvestment,
    'critical_value_impact': criticalValueImpact,
  };
}

class ControlPanelBranchPerformanceModel
    extends ControlPanelBranchPerformanceEntity {
  const ControlPanelBranchPerformanceModel({
    required super.items,
  });

  factory ControlPanelBranchPerformanceModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ControlPanelBranchPerformanceModel(
      items: (json['items'] as List<dynamic>? ?? [])
          .map(
            (e) =>
                ControlPanelBranchPerformanceItemModel.fromJson(
                  e as Map<String, dynamic>,
                ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'items': items
        .map((e) => (e as ControlPanelBranchPerformanceItemModel).toJson())
        .toList(),
  };
}

class ControlPanelBranchPerformanceItemModel
    extends ControlPanelBranchPerformanceItemEntity {
  const ControlPanelBranchPerformanceItemModel({
    required super.name,
    required super.percentage,
    required super.status,
  });

  factory ControlPanelBranchPerformanceItemModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ControlPanelBranchPerformanceItemModel(
      name: json['name'] as String? ?? '',
      percentage: json['percentage'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'percentage': percentage,
    'status': status,
  };
}

class ControlPanelExecutiveSummaryModel
    extends ControlPanelExecutiveSummaryEntity {
  const ControlPanelExecutiveSummaryModel({
    required super.photoAccuracy,
    required super.auditCompletion,
  });

  factory ControlPanelExecutiveSummaryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ControlPanelExecutiveSummaryModel(
      photoAccuracy: json['photo_accuracy'] as String? ?? '',
      auditCompletion: json['audit_completion'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'photo_accuracy': photoAccuracy,
    'audit_completion': auditCompletion,
  };
}
