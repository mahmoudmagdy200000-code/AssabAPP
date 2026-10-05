import 'package:equatable/equatable.dart';

import '../enums/brand_owner_report_setting_monthly_report_enum.dart';

enum BrandOwnerNotificationSettingType {
  audit('audit'),
  transfer('transfer'),
  statusModification('status_modification'),
  handover('handover'),
  majorDiscrepancies('major_discrepancies');

  final String value;

  const BrandOwnerNotificationSettingType(this.value);

  static BrandOwnerNotificationSettingType fromValue(String value) {
    return BrandOwnerNotificationSettingType.values.firstWhere(
      (item) => item.value == value,
      orElse: () => BrandOwnerNotificationSettingType.audit,
    );
  }
}

class BrandOwnerSettingApprovalEntity extends Equatable {
  final int responseTimeHours;
  final int initialAuditMinimumAssets;
  final int initialAuditExcellentRatio;
  final bool personalApprovalForAllNewBranches;
  final int autoApproveTransfersWithin;
  final int autoApproveModificationsWithin;
  final int autoApproveDisposalsWithin;
  final bool criticalAssetsAlwaysRequireApproval;

  const BrandOwnerSettingApprovalEntity({
    required this.responseTimeHours,
    required this.initialAuditMinimumAssets,
    required this.initialAuditExcellentRatio,
    required this.personalApprovalForAllNewBranches,
    required this.autoApproveTransfersWithin,
    required this.autoApproveModificationsWithin,
    required this.autoApproveDisposalsWithin,
    required this.criticalAssetsAlwaysRequireApproval,
  });

  BrandOwnerSettingApprovalEntity copyWith({
    int? responseTimeHours,
    int? initialAuditMinimumAssets,
    int? initialAuditExcellentRatio,
    bool? personalApprovalForAllNewBranches,
    int? autoApproveTransfersWithin,
    int? autoApproveModificationsWithin,
    int? autoApproveDisposalsWithin,
    bool? criticalAssetsAlwaysRequireApproval,
  }) {
    return BrandOwnerSettingApprovalEntity(
      responseTimeHours: responseTimeHours ?? this.responseTimeHours,
      initialAuditMinimumAssets:
          initialAuditMinimumAssets ?? this.initialAuditMinimumAssets,
      initialAuditExcellentRatio:
          initialAuditExcellentRatio ?? this.initialAuditExcellentRatio,
      personalApprovalForAllNewBranches:
          personalApprovalForAllNewBranches ??
          this.personalApprovalForAllNewBranches,
      autoApproveTransfersWithin:
          autoApproveTransfersWithin ?? this.autoApproveTransfersWithin,
      autoApproveModificationsWithin:
          autoApproveModificationsWithin ?? this.autoApproveModificationsWithin,
      autoApproveDisposalsWithin:
          autoApproveDisposalsWithin ?? this.autoApproveDisposalsWithin,
      criticalAssetsAlwaysRequireApproval:
          criticalAssetsAlwaysRequireApproval ??
          this.criticalAssetsAlwaysRequireApproval,
    );
  }

  @override
  List<Object> get props => [
    responseTimeHours,
    initialAuditMinimumAssets,
    initialAuditExcellentRatio,
    personalApprovalForAllNewBranches,
    autoApproveTransfersWithin,
    autoApproveModificationsWithin,
    autoApproveDisposalsWithin,
    criticalAssetsAlwaysRequireApproval,
  ];
}

class BrandOwnerReportSettingsEntity extends Equatable {
  final List<BrandOwnerReportSettingMonthlyReportEnum> monthlyReports;
  final List<BrandOwnerReportSettingMonthlyReportEnum> quarterlyReports;
  final List<BrandOwnerReportSettingMonthlyReportEnum> annualReports;

  const BrandOwnerReportSettingsEntity({
    required this.monthlyReports,
    required this.quarterlyReports,
    required this.annualReports,
  });

  BrandOwnerReportSettingsEntity copyWith({
    List<BrandOwnerReportSettingMonthlyReportEnum>? monthlyReports,
    List<BrandOwnerReportSettingMonthlyReportEnum>? quarterlyReports,
    List<BrandOwnerReportSettingMonthlyReportEnum>? annualReports,
  }) {
    return BrandOwnerReportSettingsEntity(
      monthlyReports: monthlyReports ?? this.monthlyReports,
      quarterlyReports: quarterlyReports ?? this.quarterlyReports,
      annualReports: annualReports ?? this.annualReports,
    );
  }

  @override
  List<Object> get props => [monthlyReports, quarterlyReports, annualReports];
}

class BrandOwnerSecuritySettingsEntity extends Equatable {
  final bool dataEncryption;
  final bool dailyBackupEnabled;
  final int dailyBackupIntervalHours;
  final bool monthlySecurityAudit;

  const BrandOwnerSecuritySettingsEntity({
    required this.dataEncryption,
    required this.dailyBackupEnabled,
    required this.dailyBackupIntervalHours,
    required this.monthlySecurityAudit,
  });

  BrandOwnerSecuritySettingsEntity copyWith({
    bool? dataEncryption,
    bool? dailyBackupEnabled,
    int? dailyBackupIntervalHours,
    bool? monthlySecurityAudit,
  }) {
    return BrandOwnerSecuritySettingsEntity(
      dataEncryption: dataEncryption ?? this.dataEncryption,
      dailyBackupEnabled: dailyBackupEnabled ?? this.dailyBackupEnabled,
      dailyBackupIntervalHours:
          dailyBackupIntervalHours ?? this.dailyBackupIntervalHours,
      monthlySecurityAudit: monthlySecurityAudit ?? this.monthlySecurityAudit,
    );
  }

  @override
  List<Object> get props => [
    dataEncryption,
    dailyBackupEnabled,
    dailyBackupIntervalHours,
    monthlySecurityAudit,
  ];
}

class BrandOwnerRetentionSettingsEntity extends Equatable {
  final int photoRetentionYears;
  final int handoverReportsRetentionYears;

  const BrandOwnerRetentionSettingsEntity({
    required this.photoRetentionYears,
    required this.handoverReportsRetentionYears,
  });

  BrandOwnerRetentionSettingsEntity copyWith({
    int? photoRetentionYears,
    int? handoverReportsRetentionYears,
  }) {
    return BrandOwnerRetentionSettingsEntity(
      photoRetentionYears: photoRetentionYears ?? this.photoRetentionYears,
      handoverReportsRetentionYears:
          handoverReportsRetentionYears ?? this.handoverReportsRetentionYears,
    );
  }

  @override
  List<Object> get props => [photoRetentionYears, handoverReportsRetentionYears];
}

class BrandOwnerNotificationEntity extends Equatable {
  final BrandOwnerNotificationSettingType type;
  final bool enabled;

  const BrandOwnerNotificationEntity({
    required this.type,
    required this.enabled,
  });

  BrandOwnerNotificationEntity copyWith({bool? enabled}) {
    return BrandOwnerNotificationEntity(
      type: type,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  List<Object> get props => [type, enabled];
}

class BrandOwnerNotificationsSettingsEntity extends Equatable {
  final List<BrandOwnerNotificationEntity> notifications;

  const BrandOwnerNotificationsSettingsEntity({required this.notifications});

  BrandOwnerNotificationsSettingsEntity copyWith({
    List<BrandOwnerNotificationEntity>? notifications,
  }) {
    return BrandOwnerNotificationsSettingsEntity(
      notifications: notifications ?? this.notifications,
    );
  }

  @override
  List<Object> get props => [notifications];
}