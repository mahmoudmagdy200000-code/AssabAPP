import 'package:equatable/equatable.dart';

import '../../../../../core/errors/api_failure.dart';
import '../../../domain/entities/brand_owner_settings_entities.dart';
import '../../models/brand_owner_settings_save_status.dart';

sealed class BrandOwnerSecuritySettingState extends Equatable {
  const BrandOwnerSecuritySettingState();

  @override
  List<Object> get props => [];
}

final class BrandOwnerSecuritySettingInitial
    extends BrandOwnerSecuritySettingState {
  const BrandOwnerSecuritySettingInitial();
}

final class BrandOwnerSecuritySettingLoading
    extends BrandOwnerSecuritySettingState {
  const BrandOwnerSecuritySettingLoading();
}

final class BrandOwnerSecuritySettingLoaded
    extends BrandOwnerSecuritySettingState {
  final BrandOwnerSecuritySettingsEntity data;
  final BrandOwnerSecuritySettingsEntity initialData;
  final bool isDirty;
  final bool isValid;
  final BrandOwnerSettingsSaveStatus saveStatus;
  final ApiFailure? saveFailure;

  const BrandOwnerSecuritySettingLoaded({
    required this.data,
    required this.initialData,
    required this.isDirty,
    required this.isValid,
    this.saveStatus = BrandOwnerSettingsSaveStatus.idle,
    this.saveFailure,
  });

  bool get hasChanges => data != initialData;

  bool get canSubmit => hasChanges && isValid;

  BrandOwnerSecuritySettingLoaded copyWith({
    BrandOwnerSecuritySettingsEntity? data,
    BrandOwnerSecuritySettingsEntity? initialData,
    bool? isDirty,
    bool? isValid,
    BrandOwnerSettingsSaveStatus? saveStatus,
    ApiFailure? saveFailure,
  }) {
    return BrandOwnerSecuritySettingLoaded(
      data: data ?? this.data,
      initialData: initialData ?? this.initialData,
      isDirty: isDirty ?? this.isDirty,
      isValid: isValid ?? this.isValid,
      saveStatus: saveStatus ?? this.saveStatus,
      saveFailure: saveFailure,
    );
  }

  @override
  List<Object> get props => [
    data,
    initialData,
    isDirty,
    isValid,
    saveStatus,
    saveFailure ?? const Object(),
  ];
}

final class BrandOwnerSecuritySettingFailure
    extends BrandOwnerSecuritySettingState {
  final ApiFailure failure;

  const BrandOwnerSecuritySettingFailure(this.failure);

  @override
  List<Object> get props => [failure];
}