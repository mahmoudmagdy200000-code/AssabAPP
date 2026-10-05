import 'package:assab/core/errors/repository_mixin.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:injectable/injectable.dart';

import '../../../brand_owner_tools/data/datasources/brand_owner_fixed_assets_requests_remote_data_source.dart';
import '../../domain/entities/brand_owner_settings_entities.dart';
import '../../domain/repositories/brand_owner_settings_repository.dart';

@LazySingleton(as: BrandOwnerSettingsRepository)
class BrandOwnerSettingsRepositoryImpl
    with RepositoryMixin
    implements BrandOwnerSettingsRepository {
  final BrandOwnerFixedAssetsRequestsRemoteDataSource _dataSource;

  BrandOwnerSettingsRepositoryImpl(this._dataSource);

  @override
  FutureApiResult<BrandOwnerSettingApprovalEntity> getApprovalSettings() {
    return execute(() async => await _dataSource.getApprovalSettings());
  }

  @override
  FutureApiResult<BrandOwnerReportSettingsEntity> getReportSettings() {
    return execute(() async => await _dataSource.getReportSettings());
  }

  @override
  FutureApiResult<BrandOwnerSecuritySettingsEntity> getSecuritySettings() {
    return execute(() async => await _dataSource.getSecuritySettings());
  }

  @override
  FutureApiResult<BrandOwnerRetentionSettingsEntity> getRetentionSettings() {
    return execute(() async => await _dataSource.getRetentionSettings());
  }

  @override
  FutureApiResult<BrandOwnerNotificationsSettingsEntity>
  getNotificationsSettings() {
    return execute(() async => await _dataSource.getNotificationsSettings());
  }

  @override
  FutureApiResult<BrandOwnerSettingApprovalEntity> updateApprovalSettings(
    BrandOwnerSettingApprovalEntity entity,
  ) {
    return execute(() async {
      await _dataSource.updateApprovalSettings({
        'response_time_hours': entity.responseTimeHours,
        'initial_audit_minimum_assets': entity.initialAuditMinimumAssets,
        'initial_audit_excellent_ratio': entity.initialAuditExcellentRatio,
        'personal_approval_for_all_new_branches':
            entity.personalApprovalForAllNewBranches,
        'auto_approve_transfers_within': entity.autoApproveTransfersWithin,
        'auto_approve_modifications_within':
            entity.autoApproveModificationsWithin,
        'auto_approve_disposals_within': entity.autoApproveDisposalsWithin,
        'critical_assets_always_require_approval':
            entity.criticalAssetsAlwaysRequireApproval,
      });
      return await _dataSource.getApprovalSettings();
    });
  }

  @override
  FutureApiResult<BrandOwnerReportSettingsEntity> updateReportSettings(
    BrandOwnerReportSettingsEntity entity,
  ) {
    return execute(() async {
      await _dataSource.updateReportSettings({
        'monthly_reports':
            entity.monthlyReports.map((e) => e.value).toList(),
        'quarterly_reports':
            entity.quarterlyReports.map((e) => e.value).toList(),
        'annual_reports':
            entity.annualReports.map((e) => e.value).toList(),
      });
      return await _dataSource.getReportSettings();
    });
  }

  @override
  FutureApiResult<BrandOwnerSecuritySettingsEntity> updateSecuritySettings(
    BrandOwnerSecuritySettingsEntity entity,
  ) {
    return execute(() async {
      await _dataSource.updateSecuritySettings({
        'data_encryption': entity.dataEncryption,
        'daily_backup_enabled': entity.dailyBackupEnabled,
        'daily_backup_interval_hours': entity.dailyBackupIntervalHours,
        'monthly_security_audit': entity.monthlySecurityAudit,
      });
      return await _dataSource.getSecuritySettings();
    });
  }

  @override
  FutureApiResult<BrandOwnerRetentionSettingsEntity> updateRetentionSettings(
    BrandOwnerRetentionSettingsEntity entity,
  ) {
    return execute(() async {
      await _dataSource.updateRetentionSettings({
        'photo_retention_years': entity.photoRetentionYears,
        'handover_reports_retention_years': entity.handoverReportsRetentionYears,
      });
      return await _dataSource.getRetentionSettings();
    });
  }

  @override
  FutureApiResult<BrandOwnerNotificationsSettingsEntity>
  updateNotificationsSettings(BrandOwnerNotificationsSettingsEntity entity) {
    return execute(() async {
      await _dataSource.updateNotificationsSettings({
        'notifications': entity.notifications
            .map(
              (n) => {'type': n.type.value, 'enabled': n.enabled},
            )
            .toList(),
      });
      return await _dataSource.getNotificationsSettings();
    });
  }
}
