import 'package:equatable/equatable.dart';

enum BranchManagerNotificationType {
  shiftVarianceAlerts('shiftVarianceAlerts'),
  dailyInventoryReminders('dailyInventoryReminders'),
  approvedAggregatorsOnly('approvedAggregatorsOnly'),
  assetTransferRequests('assetTransferRequests'),
  allowSplitShiftHandovers('allowSplitShiftHandovers');

  final String _value;

  const BranchManagerNotificationType(this._value);

  String get value => _value;

  static BranchManagerNotificationType fromString(String value) {
    return BranchManagerNotificationType.values.firstWhere(
      (type) => type.value.toLowerCase() == value.toLowerCase(),
      orElse: () => throw FormatException('Invalid notification type: $value'),
    );
  }
}

class BranchManagerBranchInfoEntity extends Equatable {
  final String branchId;
  final String branchName;
  final String branchManagerName;
  final String branchManagerImageUrl;
  final String branchImageUrl;
  final String branchOpening;
  final int totalCashiers;
  final int totalAggregators;

  const BranchManagerBranchInfoEntity({
    required this.branchId,
    required this.branchName,
    required this.branchManagerName,
    required this.branchManagerImageUrl,
    required this.branchImageUrl,
    required this.branchOpening,
    required this.totalCashiers,
    required this.totalAggregators,
  });

  @override
  List<Object> get props => [
    branchId,
    branchName,
    branchManagerName,
    branchManagerImageUrl,
    branchImageUrl,
    branchOpening,
    totalCashiers,
    totalAggregators,
  ];
}

class BranchManagerAggregatorEntity extends Equatable {
  final String id;
  final String name;
  final String logoUrl;
  final bool enabled;

  const BranchManagerAggregatorEntity({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.enabled,
  });

  BranchManagerAggregatorEntity copyWith({
    String? id,
    String? name,
    String? logoUrl,
    bool? enabled,
  }) {
    return BranchManagerAggregatorEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  List<Object> get props => [id, name, logoUrl, enabled];
}

class BranchManagerNotificationEntity extends Equatable {
  final BranchManagerNotificationType type;
  final bool enabled;

  const BranchManagerNotificationEntity({
    required this.type,
    required this.enabled,
  });

  BranchManagerNotificationEntity copyWith({bool? enabled}) {
    return BranchManagerNotificationEntity(
      type: type,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  List<Object> get props => [type, enabled];
}

class BranchManagerSettingAndAggregatorsEntity extends Equatable {
  final BranchManagerBranchInfoEntity branchInfo;
  final List<BranchManagerAggregatorEntity> availableAggregators;
  final List<BranchManagerAggregatorEntity> addedAggregators;
  final List<BranchManagerNotificationEntity> notifications;

  const BranchManagerSettingAndAggregatorsEntity({
    required this.branchInfo,
    required this.availableAggregators,
    required this.addedAggregators,
    required this.notifications,
  });

  BranchManagerSettingAndAggregatorsEntity copyWith({
    BranchManagerBranchInfoEntity? branchInfo,
    List<BranchManagerAggregatorEntity>? availableAggregators,
    List<BranchManagerAggregatorEntity>? addedAggregators,
    List<BranchManagerNotificationEntity>? notifications,
  }) {
    return BranchManagerSettingAndAggregatorsEntity(
      branchInfo: branchInfo ?? this.branchInfo,
      availableAggregators: availableAggregators ?? this.availableAggregators,
      addedAggregators: addedAggregators ?? this.addedAggregators,
      notifications: notifications ?? this.notifications,
    );
  }

  @override
  List<Object> get props => [
    branchInfo,
    availableAggregators,
    addedAggregators,
    notifications,
  ];
}
