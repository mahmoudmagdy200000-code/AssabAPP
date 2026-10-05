import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../domain/entities/brand_owner_settings_entities.dart';
import '../../../domain/usecases/brand_owner_settings_usecases.dart';
import '../../models/brand_owner_settings_save_status.dart';
import 'brand_owner_setting_approval_state.dart';

@injectable
class BrandOwnerSettingApprovalCubit
    extends SafeCubit<BrandOwnerSettingApprovalState> {
  final GetBrandOwnerSettingApprovalUseCase _getSettingApprovalUseCase;
  final UpdateBrandOwnerSettingApprovalUseCase _updateSettingApprovalUseCase;
  BrandOwnerSettingApprovalCubit(
    this._getSettingApprovalUseCase,
    this._updateSettingApprovalUseCase,
  ) : super(const BrandOwnerSettingApprovalInitial());

  Future<void> loadData() async {
    emit(const BrandOwnerSettingApprovalLoading());

    final result = await _getSettingApprovalUseCase();
    handle(
      result,
      success: (data) => emit(
        BrandOwnerSettingApprovalLoaded(
          data: data,
          initialData: data,
          isDirty: false,
          isValid: _isValid(data),
          saveStatus: BrandOwnerSettingsSaveStatus.idle,
        ),
      ),
      failure: (failure) => emit(BrandOwnerSettingApprovalFailure(failure)),
    );
  }

  void updateResponseTimeHours(int value) {
    _update((data) => data.copyWith(responseTimeHours: value));
  }

  void updateInitialAuditMinimumAssets(String value) {
    _update(
      (data) => data.copyWith(initialAuditMinimumAssets: _parseInt(value)),
    );
  }

  void updateInitialAuditExcellentRatio(String value) {
    _update(
      (data) => data.copyWith(initialAuditExcellentRatio: _parseInt(value)),
    );
  }

  void updatePersonalApprovalForAllNewBranches(bool value) {
    _update((data) => data.copyWith(personalApprovalForAllNewBranches: value));
  }

  void updateAutoApproveTransfersWithin(String value) {
    _update(
      (data) => data.copyWith(autoApproveTransfersWithin: _parseInt(value)),
    );
  }

  void updateAutoApproveModificationsWithin(String value) {
    _update(
      (data) => data.copyWith(autoApproveModificationsWithin: _parseInt(value)),
    );
  }

  void updateAutoApproveDisposalsWithin(String value) {
    _update(
      (data) => data.copyWith(autoApproveDisposalsWithin: _parseInt(value)),
    );
  }

  void updateCriticalAssetsAlwaysRequireApproval(bool value) {
    _update(
      (data) => data.copyWith(criticalAssetsAlwaysRequireApproval: value),
    );
  }

  void resetToDefaults() {
    final currentState = state;
    if (currentState is! BrandOwnerSettingApprovalLoaded) return;

    emit(
      BrandOwnerSettingApprovalLoaded(
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
    if (currentState is! BrandOwnerSettingApprovalLoaded) return;

    emit(
      BrandOwnerSettingApprovalLoaded(
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
    if (currentState is! BrandOwnerSettingApprovalLoaded) return;

    emit(
      currentState.copyWith(
        saveStatus: BrandOwnerSettingsSaveStatus.saving,
        saveFailure: null,
      ),
    );

    final result = await _updateSettingApprovalUseCase(currentState.data);
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
    BrandOwnerSettingApprovalEntity Function(
      BrandOwnerSettingApprovalEntity data,
    )
    updater,
  ) {
    final currentState = state;
    if (currentState is! BrandOwnerSettingApprovalLoaded) return;

    final updatedData = updater(currentState.data);
    if (updatedData == currentState.data) return;

    emit(
      BrandOwnerSettingApprovalLoaded(
        data: updatedData,
        initialData: currentState.initialData,
        isDirty: updatedData != currentState.initialData,
        isValid: _isValid(updatedData),
        saveStatus: BrandOwnerSettingsSaveStatus.idle,
      ),
    );
  }

  bool _isValid(BrandOwnerSettingApprovalEntity data) {
    return data.responseTimeHours > 0 &&
        data.initialAuditMinimumAssets >= 0 &&
        data.initialAuditExcellentRatio >= 0 &&
        data.initialAuditExcellentRatio <= 100 &&
        data.autoApproveTransfersWithin >= 0 &&
        data.autoApproveModificationsWithin >= 0 &&
        data.autoApproveDisposalsWithin >= 0;
  }

  int _parseInt(String value) {
    return int.tryParse(value.replaceAll(',', '').trim()) ?? 0;
  }
}
