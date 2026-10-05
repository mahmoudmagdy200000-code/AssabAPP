import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../domain/entities/brand_owner_settings_entities.dart';
import '../../../domain/usecases/brand_owner_settings_usecases.dart';
import '../../models/brand_owner_settings_save_status.dart';
import 'brand_owner_security_setting_state.dart';

@injectable
class BrandOwnerSecuritySettingCubit
    extends SafeCubit<BrandOwnerSecuritySettingState> {
  final GetBrandOwnerSecuritySettingsUseCase _getSecuritySettingsUseCase;
  final UpdateBrandOwnerSecuritySettingsUseCase _updateSecuritySettingsUseCase;
  BrandOwnerSecuritySettingCubit(
    this._getSecuritySettingsUseCase,
    this._updateSecuritySettingsUseCase,
  ) : super(const BrandOwnerSecuritySettingInitial());

  Future<void> loadData() async {
    emit(const BrandOwnerSecuritySettingLoading());

    final result = await _getSecuritySettingsUseCase();
    handle(
      result,
      success: (data) => emit(
        BrandOwnerSecuritySettingLoaded(
          data: data,
          initialData: data,
          isDirty: false,
          isValid: _isValid(data),
          saveStatus: BrandOwnerSettingsSaveStatus.idle,
        ),
      ),
      failure: (failure) => emit(BrandOwnerSecuritySettingFailure(failure)),
    );
  }

  void updateDataEncryption(bool value) {
    _update((data) => data.copyWith(dataEncryption: value));
  }

  void updateDailyBackupEnabled(bool value) {
    _update((data) => data.copyWith(dailyBackupEnabled: value));
  }

  void updateDailyBackupIntervalHours(String value) {
    _update(
      (data) => data.copyWith(dailyBackupIntervalHours: _parseInt(value)),
    );
  }

  void updateMonthlySecurityAudit(bool value) {
    _update((data) => data.copyWith(monthlySecurityAudit: value));
  }

  void resetToDefaults() {
    final currentState = state;
    if (currentState is! BrandOwnerSecuritySettingLoaded) return;

    emit(
      BrandOwnerSecuritySettingLoaded(
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
    if (currentState is! BrandOwnerSecuritySettingLoaded) return;

    emit(
      BrandOwnerSecuritySettingLoaded(
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
    if (currentState is! BrandOwnerSecuritySettingLoaded) return;

    emit(
      currentState.copyWith(
        saveStatus: BrandOwnerSettingsSaveStatus.saving,
        saveFailure: null,
      ),
    );

    final result = await _updateSecuritySettingsUseCase(currentState.data);
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
    BrandOwnerSecuritySettingsEntity Function(
      BrandOwnerSecuritySettingsEntity data,
    ) updater,
  ) {
    final currentState = state;
    if (currentState is! BrandOwnerSecuritySettingLoaded) return;

    final updatedData = updater(currentState.data);
    if (updatedData == currentState.data) return;

    emit(
      BrandOwnerSecuritySettingLoaded(
        data: updatedData,
        initialData: currentState.initialData,
        isDirty: updatedData != currentState.initialData,
        isValid: _isValid(updatedData),
        saveStatus: BrandOwnerSettingsSaveStatus.idle,
      ),
    );
  }

  bool _isValid(BrandOwnerSecuritySettingsEntity data) {
    return data.dailyBackupIntervalHours > 0;
  }

  int _parseInt(String value) {
    return int.tryParse(value.replaceAll(',', '').trim()) ?? 0;
  }
}