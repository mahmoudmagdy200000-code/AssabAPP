import 'package:injectable/injectable.dart';

import '../../../../core/helpers/safe_cubit.dart';
import '../../domain/entities/branch_manager_setting_and_aggregators_entity.dart';
import '../../domain/usecases/branch_manager_setting_and_aggregators_usecases.dart';
import 'branch_manager_setting_and_aggregators_state.dart';

@injectable
class BranchManagerSettingAndAggregatorsCubit
    extends SafeCubit<BranchManagerSettingAndAggregatorsState> {
  final GetBranchManagerSettingAndAggregatorsUseCase _getScreenUseCase;
  final GetAvailableAggregatorsUseCase _getAvailableAggregatorsUseCase;
  final GetBranchAggregatorsUseCase _getBranchAggregatorsUseCase;
  final AddBranchManagerAggregatorUseCase _addAggregatorUseCase;
  final DeleteBranchManagerAggregatorUseCase _deleteAggregatorUseCase;
  final SetBranchManagerAggregatorStatusUseCase _setAggregatorStatusUseCase;
  final UpdateBranchManagerNotificationUseCase _updateNotificationUseCase;

  BranchManagerSettingAndAggregatorsCubit(
    this._getScreenUseCase,
    this._getAvailableAggregatorsUseCase,
    this._getBranchAggregatorsUseCase,
    this._addAggregatorUseCase,
    this._deleteAggregatorUseCase,
    this._setAggregatorStatusUseCase,
    this._updateNotificationUseCase,
  ) : super(const BranchManagerSettingAndAggregatorsInitial());

  Future<void> loadData() async {
    emit(const BranchManagerSettingAndAggregatorsLoading());

    final screenResult = await _getScreenUseCase();
    handle(
      screenResult,
      success: (data) => emit(BranchManagerSettingAndAggregatorsLoaded(data)),
      failure: (failure) =>
          emit(BranchManagerSettingAndAggregatorsFailure(failure)),
    );
  }

  Future<void> refreshAvailableAggregators() async {
    final result = await _getAvailableAggregatorsUseCase();
    final branchResult = await _getBranchAggregatorsUseCase();

    if (result.isCancelled || branchResult.isCancelled) return;

    final currentState = state;
    if (currentState is! BranchManagerSettingAndAggregatorsLoaded) {
      return;
    }

    result.when(
      failure: (failure) =>
          emit(BranchManagerSettingAndAggregatorsFailure(failure)),
      success: (availableAggregators) {
        branchResult.when(
          failure: (failure) =>
              emit(BranchManagerSettingAndAggregatorsFailure(failure)),
          success: (addedAggregators) {
            emit(
              BranchManagerSettingAndAggregatorsLoaded(
                currentState.data.copyWith(
                  availableAggregators: availableAggregators,
                  addedAggregators: addedAggregators,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> addAggregator({required String aggregatorId}) async {
    emit(const BranchManagerSettingAndAggregatorsLoading());

    final result = await _addAggregatorUseCase(aggregatorId: aggregatorId);
    handle(
      result,
      success: (data) => emit(BranchManagerSettingAndAggregatorsLoaded(data)),
      failure: (failure) =>
          emit(BranchManagerSettingAndAggregatorsFailure(failure)),
    );
  }

  Future<void> deleteAggregator({required String aggregatorId}) async {
    emit(const BranchManagerSettingAndAggregatorsLoading());

    final result = await _deleteAggregatorUseCase(aggregatorId: aggregatorId);
    handle(
      result,
      success: (data) => emit(BranchManagerSettingAndAggregatorsLoaded(data)),
      failure: (failure) =>
          emit(BranchManagerSettingAndAggregatorsFailure(failure)),
    );
  }

  Future<void> setAggregatorEnabled({
    required String aggregatorId,
    required bool enabled,
  }) async {
    emit(const BranchManagerSettingAndAggregatorsLoading());

    final result = await _setAggregatorStatusUseCase(
      aggregatorId: aggregatorId,
      enabled: enabled,
    );
    handle(
      result,
      success: (data) => emit(BranchManagerSettingAndAggregatorsLoaded(data)),
      failure: (failure) =>
          emit(BranchManagerSettingAndAggregatorsFailure(failure)),
    );
  }

  Future<void> updateNotification({
    required BranchManagerNotificationType type,
    required bool enabled,
  }) async {
    emit(const BranchManagerSettingAndAggregatorsLoading());

    final result = await _updateNotificationUseCase(
      type: type,
      enabled: enabled,
    );
    handle(
      result,
      success: (data) => emit(BranchManagerSettingAndAggregatorsLoaded(data)),
      failure: (failure) =>
          emit(BranchManagerSettingAndAggregatorsFailure(failure)),
    );
  }
}
