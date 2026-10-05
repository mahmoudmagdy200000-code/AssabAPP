import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../domain/entities/brand_owner_settings_entities.dart';
import '../../../domain/usecases/brand_owner_settings_usecases.dart';
import '../../models/brand_owner_settings_save_status.dart';
import 'brand_owner_retention_settings_state.dart';

@injectable
class BrandOwnerRetentionSettingsCubit
    extends SafeCubit<BrandOwnerRetentionSettingsState> {
  final GetBrandOwnerRetentionSettingsUseCase _getRetentionSettingsUseCase;
  final UpdateBrandOwnerRetentionSettingsUseCase _updateRetentionSettingsUseCase;
  BrandOwnerRetentionSettingsCubit(
    this._getRetentionSettingsUseCase,
    this._updateRetentionSettingsUseCase,
  ) : super(const BrandOwnerRetentionSettingsInitial());

  Future<void> loadData() async {
    emit(const BrandOwnerRetentionSettingsLoading());

    final result = await _getRetentionSettingsUseCase();
    handle(
      result,
      success: (data) => emit(
        BrandOwnerRetentionSettingsLoaded(
          data: data,
          initialData: data,
          isDirty: false,
          isValid: _isValid(data),
          saveStatus: BrandOwnerSettingsSaveStatus.idle,
        ),
      ),
      failure: (failure) => emit(BrandOwnerRetentionSettingsFailure(failure)),
    );
  }

  void updatePhotoRetentionYears(int value) {
    _update((data) => data.copyWith(photoRetentionYears: value));
  }

  void updateHandoverReportsRetentionYears(int value) {
    _update(
      (data) => data.copyWith(handoverReportsRetentionYears: value),
    );
  }

  void resetToDefaults() {
    final currentState = state;
    if (currentState is! BrandOwnerRetentionSettingsLoaded) return;

    emit(
      BrandOwnerRetentionSettingsLoaded(
        data: currentState.initialData,
        initialData: currentState.initialData,
        isDirty: false,
        isValid: _isValid(currentState.initialData),
        saveStatus: BrandOwnerSettingsSaveStatus.idle,
      ),
    );
  }

  void markAsSaved() {
    final currentState = state;
    if (currentState is! BrandOwnerRetentionSettingsLoaded) return;

    emit(
      BrandOwnerRetentionSettingsLoaded(
        data: currentState.data,
        initialData: currentState.data,
        isDirty: false,
        isValid: _isValid(currentState.data),
        saveStatus: BrandOwnerSettingsSaveStatus.idle,
      ),
    );
  }

  Future<void> save() async {
    final currentState = state;
    if (currentState is! BrandOwnerRetentionSettingsLoaded) return;

    emit(
      currentState.copyWith(
        saveStatus: BrandOwnerSettingsSaveStatus.saving,
        saveFailure: null,
      ),
    );

    final result = await _updateRetentionSettingsUseCase(currentState.data);
    handle(
      result,
      success: (data) => emit(
        currentState.copyWith(
          data: data,
          initialData: data,
          isDirty: false,
          isValid: _isValid(data),
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
    BrandOwnerRetentionSettingsEntity Function(
      BrandOwnerRetentionSettingsEntity data,
    ) updater,
  ) {
    final currentState = state;
    if (currentState is! BrandOwnerRetentionSettingsLoaded) return;

    final updatedData = updater(currentState.data);
    if (updatedData == currentState.data) return;

    emit(
      BrandOwnerRetentionSettingsLoaded(
        data: updatedData,
        initialData: currentState.initialData,
        isDirty: updatedData != currentState.initialData,
        isValid: _isValid(updatedData),
        saveStatus: BrandOwnerSettingsSaveStatus.idle,
      ),
    );
  }

  bool _isValid(BrandOwnerRetentionSettingsEntity data) {
    return data.photoRetentionYears > 0 &&
        data.handoverReportsRetentionYears > 0;
  }

}