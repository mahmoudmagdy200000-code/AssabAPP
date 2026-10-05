import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../domain/entities/brand_owner_settings_entities.dart';
import '../../../domain/enums/brand_owner_report_setting_monthly_report_enum.dart';
import '../../../domain/usecases/brand_owner_settings_usecases.dart';
import '../../models/brand_owner_settings_save_status.dart';
import 'brand_owner_report_settings_state.dart';

@injectable
class BrandOwnerReportSettingsCubit
    extends SafeCubit<BrandOwnerReportSettingsState> {
  final GetBrandOwnerReportSettingsUseCase _getReportSettingsUseCase;
  final UpdateBrandOwnerReportSettingsUseCase _updateReportSettingsUseCase;
  BrandOwnerReportSettingsCubit(
    this._getReportSettingsUseCase,
    this._updateReportSettingsUseCase,
  ) : super(const BrandOwnerReportSettingsInitial());

  Future<void> loadData() async {
    emit(const BrandOwnerReportSettingsLoading());

    final result = await _getReportSettingsUseCase();
    handle(
      result,
      success: (data) => emit(
        BrandOwnerReportSettingsLoaded(
          data: data,
          initialData: data,
          isDirty: false,
          saveStatus: BrandOwnerSettingsSaveStatus.idle,
        ),
      ),
      failure: (failure) => emit(BrandOwnerReportSettingsFailure(failure)),
    );
  }

  void toggleMonthlyReport(BrandOwnerReportSettingMonthlyReportEnum value) {
    _update((data) => data.copyWith(monthlyReports: _toggle(data.monthlyReports, value)));
  }

  void toggleQuarterlyReport(BrandOwnerReportSettingMonthlyReportEnum value) {
    _update((data) => data.copyWith(quarterlyReports: _toggle(data.quarterlyReports, value)));
  }

  void toggleAnnualReport(BrandOwnerReportSettingMonthlyReportEnum value) {
    _update((data) => data.copyWith(annualReports: _toggle(data.annualReports, value)));
  }

  void resetToDefaults() {
    final currentState = state;
    if (currentState is! BrandOwnerReportSettingsLoaded) return;

    emit(
      BrandOwnerReportSettingsLoaded(
        data: currentState.initialData,
        initialData: currentState.initialData,
        isDirty: false,
        saveStatus: BrandOwnerSettingsSaveStatus.idle,
      ),
    );
  }

  void markAsSaved() {
    final currentState = state;
    if (currentState is! BrandOwnerReportSettingsLoaded) return;

    emit(
      BrandOwnerReportSettingsLoaded(
        data: currentState.data,
        initialData: currentState.data,
        isDirty: false,
        saveStatus: BrandOwnerSettingsSaveStatus.idle,
      ),
    );
  }

  Future<void> save() async {
    final currentState = state;
    if (currentState is! BrandOwnerReportSettingsLoaded) return;

    emit(
      currentState.copyWith(
        saveStatus: BrandOwnerSettingsSaveStatus.saving,
        saveFailure: null,
      ),
    );

    final result = await _updateReportSettingsUseCase(currentState.data);
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
    BrandOwnerReportSettingsEntity Function(
      BrandOwnerReportSettingsEntity data,
    ) updater,
  ) {
    final currentState = state;
    if (currentState is! BrandOwnerReportSettingsLoaded) return;

    final updatedData = updater(currentState.data);
    if (updatedData == currentState.data) return;

    emit(
      BrandOwnerReportSettingsLoaded(
        data: updatedData,
        initialData: currentState.initialData,
        isDirty: updatedData != currentState.initialData,
        saveStatus: BrandOwnerSettingsSaveStatus.idle,
      ),
    );
  }

  List<BrandOwnerReportSettingMonthlyReportEnum> _toggle(
    List<BrandOwnerReportSettingMonthlyReportEnum> current,
    BrandOwnerReportSettingMonthlyReportEnum value,
  ) {
    final selected = [...current];
    if (selected.contains(value)) {
      selected.remove(value);
    } else {
      selected.add(value);
    }

    return BrandOwnerReportSettingMonthlyReportEnum.values
        .where(selected.contains)
        .toList();
  }
}