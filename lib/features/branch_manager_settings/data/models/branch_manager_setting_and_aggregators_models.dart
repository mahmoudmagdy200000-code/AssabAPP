import '../../domain/entities/branch_manager_setting_and_aggregators_entity.dart';

class BranchManagerBranchInfoModel extends BranchManagerBranchInfoEntity {
  const BranchManagerBranchInfoModel({
    required super.branchId,
    required super.branchName,
    required super.branchManagerName,
    required super.branchManagerImageUrl,
    required super.branchImageUrl,
    required super.branchOpening,
    required super.totalCashiers,
    required super.totalAggregators,
  });

  factory BranchManagerBranchInfoModel.fromJson(Map<String, dynamic> json) {
    return BranchManagerBranchInfoModel(
      branchId: json['branch_id'] as String? ?? '',
      branchName: json['branch_name'] as String? ?? '',
      branchManagerName: json['branch_manager_name'] as String? ?? '',
      branchManagerImageUrl: json['branch_manager_image_url'] as String? ?? '',
      branchOpening: json['branch_opening'] as String? ?? '',
      totalAggregators: json['total_aggregators'] as int? ?? 0,
      totalCashiers: json['total_cashiers'] as int? ?? 0,
      branchImageUrl: json['branch_image_url'] as String? ?? '',
    );
  }
}

class BranchManagerAggregatorModel extends BranchManagerAggregatorEntity {
  const BranchManagerAggregatorModel({
    required super.id,
    required super.name,
    required super.logoUrl,
    required super.enabled,
  });

  factory BranchManagerAggregatorModel.fromJson(Map<String, dynamic> json) {
    return BranchManagerAggregatorModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      logoUrl: json['logo_url'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? false,
    );
  }

  factory BranchManagerAggregatorModel.fromEntity(
    BranchManagerAggregatorEntity entity,
  ) {
    return BranchManagerAggregatorModel(
      id: entity.id,
      name: entity.name,
      logoUrl: entity.logoUrl,
      enabled: entity.enabled,
    );
  }
}

class BranchManagerNotificationModel extends BranchManagerNotificationEntity {
  const BranchManagerNotificationModel({
    required super.type,
    required super.enabled,
  });

  factory BranchManagerNotificationModel.fromJson(Map<String, dynamic> json) {
    return BranchManagerNotificationModel(
      type: BranchManagerNotificationType.fromString(json['type'] as String),
      enabled: json['enabled'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type.name, 'enabled': enabled};
  }

  factory BranchManagerNotificationModel.fromEntity(
    BranchManagerNotificationEntity entity,
  ) {
    return BranchManagerNotificationModel(
      type: entity.type,
      enabled: entity.enabled,
    );
  }
}

class BranchManagerSettingAndAggregatorsResponseModel {
  final BranchManagerBranchInfoModel branchInfo;
  final List<BranchManagerAggregatorModel> availableAggregators;
  final List<BranchManagerAggregatorModel> addedAggregators;
  final List<BranchManagerNotificationModel> notifications;

  const BranchManagerSettingAndAggregatorsResponseModel({
    required this.branchInfo,
    required this.availableAggregators,
    required this.addedAggregators,
    required this.notifications,
  });

  factory BranchManagerSettingAndAggregatorsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>? ?? const {};
    return BranchManagerSettingAndAggregatorsResponseModel(
      branchInfo: BranchManagerBranchInfoModel.fromJson(
        data['branch_info'] as Map<String, dynamic>? ?? const {},
      ),
      availableAggregators:
          (data['available_aggregators'] as List<dynamic>? ?? [])
              .map(
                (item) => BranchManagerAggregatorModel.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList(),
      addedAggregators: (data['added_aggregators'] as List<dynamic>? ?? [])
          .map(
            (item) => BranchManagerAggregatorModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      notifications: (data['notifications'] as List<dynamic>? ?? [])
          .map(
            (item) => BranchManagerNotificationModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  BranchManagerSettingAndAggregatorsEntity toEntity() {
    return BranchManagerSettingAndAggregatorsEntity(
      branchInfo: branchInfo,
      availableAggregators: availableAggregators,
      addedAggregators: addedAggregators,
      notifications: notifications,
    );
  }
}

class BranchManagerAggregatorRequestModel {
  final String aggregatorId;

  const BranchManagerAggregatorRequestModel({required this.aggregatorId});

  Map<String, dynamic> toJson() {
    return {'aggregator_id': aggregatorId};
  }
}

class BranchManagerAggregatorStatusRequestModel {
  final String aggregatorId;
  final bool enabled;

  const BranchManagerAggregatorStatusRequestModel({
    required this.aggregatorId,
    required this.enabled,
  });

  Map<String, dynamic> toJson() {
    return {'aggregator_id': aggregatorId, 'enabled': enabled};
  }
}

class BranchManagerNotificationRequestModel {
  final bool enabled;

  const BranchManagerNotificationRequestModel({required this.enabled});

  Map<String, dynamic> toJson() {
    return {'enabled': enabled};
  }
}
