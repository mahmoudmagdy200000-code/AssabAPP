import '../../../../core/utils/future_api_result.dart';
import '../entities/brand_owner_settings_entities.dart';

abstract class BrandOwnerSettingsRepository {
  FutureApiResult<BrandOwnerSettingApprovalEntity> getApprovalSettings();

  FutureApiResult<BrandOwnerReportSettingsEntity> getReportSettings();

  FutureApiResult<BrandOwnerSecuritySettingsEntity> getSecuritySettings();

  FutureApiResult<BrandOwnerRetentionSettingsEntity> getRetentionSettings();

  FutureApiResult<BrandOwnerNotificationsSettingsEntity>
  getNotificationsSettings();

  FutureApiResult<BrandOwnerSettingApprovalEntity> updateApprovalSettings(
    BrandOwnerSettingApprovalEntity entity,
  );

  FutureApiResult<BrandOwnerReportSettingsEntity> updateReportSettings(
    BrandOwnerReportSettingsEntity entity,
  );

  FutureApiResult<BrandOwnerSecuritySettingsEntity> updateSecuritySettings(
    BrandOwnerSecuritySettingsEntity entity,
  );

  FutureApiResult<BrandOwnerRetentionSettingsEntity> updateRetentionSettings(
    BrandOwnerRetentionSettingsEntity entity,
  );

  FutureApiResult<BrandOwnerNotificationsSettingsEntity>
  updateNotificationsSettings(BrandOwnerNotificationsSettingsEntity entity);
}
