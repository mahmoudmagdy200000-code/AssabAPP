import 'package:equatable/equatable.dart';

import '../../../../../core/errors/api_failure.dart';
import '../../../domain/entities/brand_owner_settings_entities.dart';
import '../../models/brand_owner_settings_save_status.dart';

sealed class BrandOwnerSettingApprovalState extends Equatable {
  const BrandOwnerSettingApprovalState();

  @override
  List<Object> get props => [];
}

final class BrandOwnerSettingApprovalInitial
    extends BrandOwnerSettingApprovalState {
  const BrandOwnerSettingApprovalInitial();
}

final class BrandOwnerSettingApprovalLoading
    extends BrandOwnerSettingApprovalState {
  const BrandOwnerSettingApprovalLoading();
}

final class BrandOwnerSettingApprovalLoaded
    extends BrandOwnerSettingApprovalState {
  final BrandOwnerSettingApprovalEntity data;
  final BrandOwnerSettingApprovalEntity initialData;
  final bool isDirty;
  final bool isValid;
  final BrandOwnerSettingsSaveStatus saveStatus;
  final ApiFailure? saveFailure;

  const BrandOwnerSettingApprovalLoaded({
    required this.data,
    required this.initialData,
    required this.isDirty,
    required this.isValid,
    this.saveStatus = BrandOwnerSettingsSaveStatus.idle,
    this.saveFailure,
  });

  bool get hasChanges => data != initialData;

  bool get canSubmit => hasChanges && isValid;

  BrandOwnerSettingApprovalLoaded copyWith({
    BrandOwnerSettingApprovalEntity? data,
    BrandOwnerSettingApprovalEntity? initialData,
    bool? isDirty,
    bool? isValid,
    BrandOwnerSettingsSaveStatus? saveStatus,
    ApiFailure? saveFailure,
  }) {
    return BrandOwnerSettingApprovalLoaded(
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

final class BrandOwnerSettingApprovalFailure
    extends BrandOwnerSettingApprovalState {
  final ApiFailure failure;

  const BrandOwnerSettingApprovalFailure(this.failure);

  @override
  List<Object> get props => [failure];
}