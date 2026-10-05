import 'package:injectable/injectable.dart';

import '../../../../core/utils/future_api_result.dart';
import '../entities/brand_owner_settings_entities.dart';
import '../repositories/brand_owner_settings_repository.dart';

@LazySingleton()
class GetBrandOwnerSettingApprovalUseCase {
  final BrandOwnerSettingsRepository _repository;

  GetBrandOwnerSettingApprovalUseCase(this._repository);

  FutureApiResult<BrandOwnerSettingApprovalEntity> call() {
    return _repository.getApprovalSettings();
  }
}

@LazySingleton()
class GetBrandOwnerReportSettingsUseCase {
  final BrandOwnerSettingsRepository _repository;

  GetBrandOwnerReportSettingsUseCase(this._repository);

  FutureApiResult<BrandOwnerReportSettingsEntity> call() {
    return _repository.getReportSettings();
  }
}

@LazySingleton()
class GetBrandOwnerSecuritySettingsUseCase {
  final BrandOwnerSettingsRepository _repository;

  GetBrandOwnerSecuritySettingsUseCase(this._repository);

  FutureApiResult<BrandOwnerSecuritySettingsEntity> call() {
    return _repository.getSecuritySettings();
  }
}

@LazySingleton()
class GetBrandOwnerRetentionSettingsUseCase {
  final BrandOwnerSettingsRepository _repository;

  GetBrandOwnerRetentionSettingsUseCase(this._repository);

  FutureApiResult<BrandOwnerRetentionSettingsEntity> call() {
    return _repository.getRetentionSettings();
  }
}

@LazySingleton()
class GetBrandOwnerNotificationsSettingsUseCase {
  final BrandOwnerSettingsRepository _repository;

  GetBrandOwnerNotificationsSettingsUseCase(this._repository);

  FutureApiResult<BrandOwnerNotificationsSettingsEntity> call() {
    return _repository.getNotificationsSettings();
  }
}

@LazySingleton()
class UpdateBrandOwnerSettingApprovalUseCase {
  final BrandOwnerSettingsRepository _repository;

  UpdateBrandOwnerSettingApprovalUseCase(this._repository);

  FutureApiResult<BrandOwnerSettingApprovalEntity> call(
    BrandOwnerSettingApprovalEntity entity,
  ) {
    return _repository.updateApprovalSettings(entity);
  }
}

@LazySingleton()
class UpdateBrandOwnerReportSettingsUseCase {
  final BrandOwnerSettingsRepository _repository;

  UpdateBrandOwnerReportSettingsUseCase(this._repository);

  FutureApiResult<BrandOwnerReportSettingsEntity> call(
    BrandOwnerReportSettingsEntity entity,
  ) {
    return _repository.updateReportSettings(entity);
  }
}

@LazySingleton()
class UpdateBrandOwnerSecuritySettingsUseCase {
  final BrandOwnerSettingsRepository _repository;

  UpdateBrandOwnerSecuritySettingsUseCase(this._repository);

  FutureApiResult<BrandOwnerSecuritySettingsEntity> call(
    BrandOwnerSecuritySettingsEntity entity,
  ) {
    return _repository.updateSecuritySettings(entity);
  }
}

@LazySingleton()
class UpdateBrandOwnerRetentionSettingsUseCase {
  final BrandOwnerSettingsRepository _repository;

  UpdateBrandOwnerRetentionSettingsUseCase(this._repository);

  FutureApiResult<BrandOwnerRetentionSettingsEntity> call(
    BrandOwnerRetentionSettingsEntity entity,
  ) {
    return _repository.updateRetentionSettings(entity);
  }
}

@LazySingleton()
class UpdateBrandOwnerNotificationsSettingsUseCase {
  final BrandOwnerSettingsRepository _repository;

  UpdateBrandOwnerNotificationsSettingsUseCase(this._repository);

  FutureApiResult<BrandOwnerNotificationsSettingsEntity> call(
    BrandOwnerNotificationsSettingsEntity entity,
  ) {
    return _repository.updateNotificationsSettings(entity);
  }
}