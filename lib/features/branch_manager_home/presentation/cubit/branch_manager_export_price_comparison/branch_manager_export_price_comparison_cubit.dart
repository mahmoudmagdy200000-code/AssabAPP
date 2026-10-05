import 'package:assab/core/enums/time_keys.dart';
import 'package:assab/core/helpers/safe_cubit.dart';
import 'package:assab/features/branch_manager_home/domain/repositories/branch_manager_price_comparison_repository.dart';
import 'package:assab/features/branch_manager_home/presentation/cubit/branch_manager_export_price_comparison/branch_manager_export_price_comparison_state.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class BranchManagerExportPriceComparisonCubit
    extends SafeCubit<BranchManagerExportPriceComparisonState> {
  final BranchManagerPriceComparisonRepository _repository;

  BranchManagerExportPriceComparisonCubit(this._repository)
    : super(const BranchManagerExportPriceComparisonInit());

  Future<void> exportPriceComparison({
    required String comparisonId,
    required String formatType,
  }) async {
    emit(const BranchManagerExportPriceComparisonLoading());

    final result = await _repository.exportPriceComparison(
      comparisonId: comparisonId,
      formatType: formatType,
    );

    handle(
      result,
      success: (fileUrl) {
        emit(BranchManagerExportPriceComparisonSuccess(fileUrl));
      },
      failure: (failure) =>
          emit(BranchManagerExportPriceComparisonFailure(failure)),
    );
  }
}
