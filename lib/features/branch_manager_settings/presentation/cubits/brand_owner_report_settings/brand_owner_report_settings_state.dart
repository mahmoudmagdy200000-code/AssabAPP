import 'package:equatable/equatable.dart';

import '../../../../../core/errors/api_failure.dart';
import '../../../domain/entities/brand_owner_settings_entities.dart';
import '../../models/brand_owner_settings_save_status.dart';

sealed class BrandOwnerReportSettingsState extends Equatable {
  const BrandOwnerReportSettingsState();

  @override
  List<Object> get props => [];
}

final class BrandOwnerReportSettingsInitial
    extends BrandOwnerReportSettingsState {
  const BrandOwnerReportSettingsInitial();
}

final class BrandOwnerReportSettingsLoading
    extends BrandOwnerReportSettingsState {
  const BrandOwnerReportSettingsLoading();
}

final class BrandOwnerReportSettingsLoaded
    extends BrandOwnerReportSettingsState {
  final BrandOwnerReportSettingsEntity data;
  final BrandOwnerReportSettingsEntity initialData;
  final bool isDirty;
  final BrandOwnerSettingsSaveStatus saveStatus;
  final ApiFailure? saveFailure;

  const BrandOwnerReportSettingsLoaded({
    required this.data,
    required this.initialData,
    required this.isDirty,
    this.saveStatus = BrandOwnerSettingsSaveStatus.idle,
    this.saveFailure,
  });

  bool get hasChanges => data != initialData;

  bool get isValid =>
      data.monthlyReports.isNotEmpty &&
      data.quarterlyReports.isNotEmpty &&
      data.annualReports.isNotEmpty;

  bool get canSubmit => hasChanges && isValid;

  BrandOwnerReportSettingsLoaded copyWith({
    BrandOwnerReportSettingsEntity? data,
    BrandOwnerReportSettingsEntity? initialData,
    bool? isDirty,
    BrandOwnerSettingsSaveStatus? saveStatus,
    ApiFailure? saveFailure,
  }) {
    return BrandOwnerReportSettingsLoaded(
      data: data ?? this.data,
      initialData: initialData ?? this.initialData,
      isDirty: isDirty ?? this.isDirty,
      saveStatus: saveStatus ?? this.saveStatus,
      saveFailure: saveFailure,
    );
  }

  @override
  List<Object> get props => [
    data,
    initialData,
    isDirty,
    saveStatus,
    saveFailure ?? const Object(),
  ];
}

final class BrandOwnerReportSettingsFailure
    extends BrandOwnerReportSettingsState {
  final ApiFailure failure;

  const BrandOwnerReportSettingsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}