import '../../domain/entities/brand_owner_settings_entities.dart';
import '../../domain/enums/brand_owner_report_setting_monthly_report_enum.dart';

class BrandOwnerSettingApprovalModel extends BrandOwnerSettingApprovalEntity {
  const BrandOwnerSettingApprovalModel({
    required super.responseTimeHours,
    required super.initialAuditMinimumAssets,
    required super.initialAuditExcellentRatio,
    required super.personalApprovalForAllNewBranches,
    required super.autoApproveTransfersWithin,
    required super.autoApproveModificationsWithin,
    required super.autoApproveDisposalsWithin,
    required super.criticalAssetsAlwaysRequireApproval,
  });

  factory BrandOwnerSettingApprovalModel.fromJson(Map<String, dynamic> json) {
    return BrandOwnerSettingApprovalModel(
      responseTimeHours: json['response_time_hours'] as int? ?? 24,
      initialAuditMinimumAssets:
          json['initial_audit_minimum_assets'] as int? ?? 0,
      initialAuditExcellentRatio:
          json['initial_audit_excellent_ratio'] as int? ?? 85,
      personalApprovalForAllNewBranches:
          json['personal_approval_for_all_new_branches'] as bool? ?? false,
      autoApproveTransfersWithin:
          json['auto_approve_transfers_within'] as int? ?? 20000,
      autoApproveModificationsWithin:
          json['auto_approve_modifications_within'] as int? ?? 15000,
      autoApproveDisposalsWithin:
          json['auto_approve_disposals_within'] as int? ?? 10000,
      criticalAssetsAlwaysRequireApproval:
          json['critical_assets_always_require_approval'] as bool? ?? false,
    );
  }
}

class BrandOwnerReportSettingsModel extends BrandOwnerReportSettingsEntity {
  const BrandOwnerReportSettingsModel({
    required super.monthlyReports,
    required super.quarterlyReports,
    required super.annualReports,
  });

  factory BrandOwnerReportSettingsModel.fromJson(Map<String, dynamic> json) {
    List<BrandOwnerReportSettingMonthlyReportEnum> parseList(String key) {
      return (json[key] as List<dynamic>? ?? const [])
          .map(
            (item) => BrandOwnerReportSettingMonthlyReportEnum.fromValue(
              item as String,
            ),
          )
          .toList();
    }

    return BrandOwnerReportSettingsModel(
      monthlyReports: parseList('monthly_reports'),
      quarterlyReports: parseList('quarterly_reports'),
      annualReports: parseList('annual_reports'),
    );
  }
}

class BrandOwnerSecuritySettingsModel extends BrandOwnerSecuritySettingsEntity {
  const BrandOwnerSecuritySettingsModel({
    required super.dataEncryption,
    required super.dailyBackupEnabled,
    required super.dailyBackupIntervalHours,
    required super.monthlySecurityAudit,
  });

  factory BrandOwnerSecuritySettingsModel.fromJson(Map<String, dynamic> json) {
    return BrandOwnerSecuritySettingsModel(
      dataEncryption: json['data_encryption'] as bool? ?? true,
      dailyBackupEnabled: json['daily_backup_enabled'] as bool? ?? true,
      dailyBackupIntervalHours:
          json['daily_backup_interval_hours'] as int? ?? 24,
      monthlySecurityAudit: json['monthly_security_audit'] as bool? ?? false,
    );
  }
}

class BrandOwnerRetentionSettingsModel
    extends BrandOwnerRetentionSettingsEntity {
  const BrandOwnerRetentionSettingsModel({
    required super.photoRetentionYears,
    required super.handoverReportsRetentionYears,
  });

  factory BrandOwnerRetentionSettingsModel.fromJson(Map<String, dynamic> json) {
    return BrandOwnerRetentionSettingsModel(
      photoRetentionYears: json['photo_retention_years'] as int? ?? 3,
      handoverReportsRetentionYears:
          json['handover_reports_retention_years'] as int? ?? 5,
    );
  }
}

class BrandOwnerNotificationModel extends BrandOwnerNotificationEntity {
  const BrandOwnerNotificationModel({
    required super.type,
    required super.enabled,
  });

  factory BrandOwnerNotificationModel.fromJson(Map<String, dynamic> json) {
    return BrandOwnerNotificationModel(
      type: BrandOwnerNotificationSettingType.fromValue(
        json['type'] as String? ?? 'audit',
      ),
      enabled: json['enabled'] as bool? ?? false,
    );
  }
}

class BrandOwnerNotificationsSettingsModel
    extends BrandOwnerNotificationsSettingsEntity {
  const BrandOwnerNotificationsSettingsModel({required super.notifications});

  factory BrandOwnerNotificationsSettingsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return BrandOwnerNotificationsSettingsModel(
      notifications:
          (json['notifications'] as List<dynamic>? ?? const [])
              .map(
                (item) => BrandOwnerNotificationModel.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList(),
    );
  }
}