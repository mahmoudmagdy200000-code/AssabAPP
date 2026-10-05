import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../domain/entities/brand_owner_settings_entities.dart';
import '../../../domain/usecases/brand_owner_settings_usecases.dart';
import '../../models/brand_owner_settings_save_status.dart';
import 'brand_owner_notifications_state.dart';

@injectable
class BrandOwnerNotificationsCubit
    extends SafeCubit<BrandOwnerNotificationsState> {
  final GetBrandOwnerNotificationsSettingsUseCase _getNotificationsSettingsUseCase;
  final UpdateBrandOwnerNotificationsSettingsUseCase _updateNotificationsSettingsUseCase;
  BrandOwnerNotificationsCubit(
    this._getNotificationsSettingsUseCase,
    this._updateNotificationsSettingsUseCase,
  ) : super(const BrandOwnerNotificationsInitial());

  Future<void> loadData() async {
    emit(const BrandOwnerNotificationsLoading());

    final result = await _getNotificationsSettingsUseCase();
    handle(
      result,
      success: (data) => emit(
        BrandOwnerNotificationsLoaded(
          data: data,
          initialData: data,
          isDirty: false,
          saveStatus: BrandOwnerSettingsSaveStatus.idle,
        ),
      ),
      failure: (failure) => emit(BrandOwnerNotificationsFailure(failure)),
    );
  }

  void toggleNotification(
    BrandOwnerNotificationSettingType type,
    bool value,
  ) {
    _update(
      (data) => data.copyWith(
        notifications: [
          for (final item in data.notifications)
            if (item.type == type) item.copyWith(enabled: value) else item,
        ],
      ),
    );
  }

  void resetToDefaults() {
    final currentState = state;
    if (currentState is! BrandOwnerNotificationsLoaded) return;

    emit(
      BrandOwnerNotificationsLoaded(
        data: currentState.initialData,
        initialData: currentState.initialData,
        isDirty: false,
        saveStatus: BrandOwnerSettingsSaveStatus.idle,
      ),
    );
  }

  void markAsSaved() {
    final currentState = state;
    if (currentState is! BrandOwnerNotificationsLoaded) return;

    emit(
      BrandOwnerNotificationsLoaded(
        data: currentState.data,
        initialData: currentState.data,
        isDirty: false,
        saveStatus: BrandOwnerSettingsSaveStatus.idle,
      ),
    );
  }

  Future<void> save() async {
    final currentState = state;
    if (currentState is! BrandOwnerNotificationsLoaded) return;

    emit(
      currentState.copyWith(
        saveStatus: BrandOwnerSettingsSaveStatus.saving,
        saveFailure: null,
      ),
    );

    final result = await _updateNotificationsSettingsUseCase(currentState.data);
    handle(
      result,
      success: (data) => emit(
        currentState.copyWith(
          data: data,
          initialData: data,
          isDirty: false,
          saveStatus: BrandOwnerSettingsSaveStatus.success,
          saveFailure: null,
        ),
      ),
      failure: (failure) => emit(
        currentState.copyWith(
          saveStatus: BrandOwnerSettingsSaveStatus.failure,
          saveFailure: failure,
        ),
      ),
    );
  }

  void _update(
    BrandOwnerNotificationsSettingsEntity Function(
      BrandOwnerNotificationsSettingsEntity data,
    ) updater,
  ) {
    final currentState = state;
    if (currentState is! BrandOwnerNotificationsLoaded) return;

    final updatedData = updater(currentState.data);
    if (updatedData == currentState.data) return;

    emit(
      BrandOwnerNotificationsLoaded(
        data: updatedData,
        initialData: currentState.initialData,
        isDirty: updatedData != currentState.initialData,
        saveStatus: BrandOwnerSettingsSaveStatus.idle,
      ),
    );
  }
}