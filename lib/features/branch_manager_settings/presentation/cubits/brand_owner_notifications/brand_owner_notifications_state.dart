import 'package:equatable/equatable.dart';

import '../../../../../core/errors/api_failure.dart';
import '../../../domain/entities/brand_owner_settings_entities.dart';
import '../../models/brand_owner_settings_save_status.dart';

sealed class BrandOwnerNotificationsState extends Equatable {
  const BrandOwnerNotificationsState();

  @override
  List<Object> get props => [];
}

final class BrandOwnerNotificationsInitial
    extends BrandOwnerNotificationsState {
  const BrandOwnerNotificationsInitial();
}

final class BrandOwnerNotificationsLoading
    extends BrandOwnerNotificationsState {
  const BrandOwnerNotificationsLoading();
}

final class BrandOwnerNotificationsLoaded
    extends BrandOwnerNotificationsState {
  final BrandOwnerNotificationsSettingsEntity data;
  final BrandOwnerNotificationsSettingsEntity initialData;
  final bool isDirty;
  final BrandOwnerSettingsSaveStatus saveStatus;
  final ApiFailure? saveFailure;

  const BrandOwnerNotificationsLoaded({
    required this.data,
    required this.initialData,
    required this.isDirty,
    this.saveStatus = BrandOwnerSettingsSaveStatus.idle,
    this.saveFailure,
  });

  bool get hasChanges => data != initialData;

  bool get isValid => data.notifications.isNotEmpty;

  bool get canSubmit => hasChanges && isValid;

  BrandOwnerNotificationsLoaded copyWith({
    BrandOwnerNotificationsSettingsEntity? data,
    BrandOwnerNotificationsSettingsEntity? initialData,
    bool? isDirty,
    BrandOwnerSettingsSaveStatus? saveStatus,
    ApiFailure? saveFailure,
  }) {
    return BrandOwnerNotificationsLoaded(
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

final class BrandOwnerNotificationsFailure
    extends BrandOwnerNotificationsState {
  final ApiFailure failure;

  const BrandOwnerNotificationsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}