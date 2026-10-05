import 'package:assab/core/enums/time_keys.dart';
import 'package:assab/core/helpers/safe_cubit.dart';
import 'package:assab/features/branch_manager_home/domain/repositories/branch_manager_price_comparison_repository.dart';
import 'package:assab/features/branch_manager_home/presentation/cubit/branch_manager_price_comparison/branch_manager_price_comparison_state.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class BranchManagerPriceComparisonCubit
    extends SafeCubit<BranchManagerPriceComparisonState> {
  final BranchManagerPriceComparisonRepository _repository;

  BranchManagerPriceComparisonCubit(this._repository)
    : super(const BranchManagerPriceComparisonInit());

  TimeKeys? _selectedTimeKey;
  String? _selectedItemId;
  String? _selectedSupplierId;

  TimeKeys? get selectedTimeKey => _selectedTimeKey;
  String? get selectedItemId => _selectedItemId;
  String? get selectedSupplierId => _selectedSupplierId;

  Future<void> loadPriceComparisons({
    TimeKeys? timeKey,
    String? itemId,
    String? supplierId,
  }) async {
    _selectedTimeKey = timeKey;
    _selectedItemId = itemId;
    _selectedSupplierId = supplierId;

    emit(const BranchManagerPriceComparisonLoading());

    final result = await _repository.getSavedPriceComparisons(
      timeKey: timeKey,
      itemId: itemId,
      supplierId: supplierId,
    );

    handle(
      result,
      success: (comparisons) {
        emit(BranchManagerPriceComparisonSuccess(comparisons));
      },
      failure: (failure) => emit(BranchManagerPriceComparisonFailure(failure)),
    );
  }

  void clearFilters() {
    _selectedTimeKey = null;
    _selectedItemId = null;
    _selectedSupplierId = null;
  }
}
