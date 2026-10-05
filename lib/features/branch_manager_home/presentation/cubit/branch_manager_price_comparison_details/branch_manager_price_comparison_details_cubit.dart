import 'package:assab/core/helpers/safe_cubit.dart';
import 'package:assab/features/branch_manager_home/domain/repositories/branch_manager_price_comparison_repository.dart';
import 'package:assab/features/branch_manager_home/presentation/cubit/branch_manager_price_comparison_details/branch_manager_price_comparison_details_state.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class BranchManagerPriceComparisonDetailsCubit
    extends SafeCubit<BranchManagerPriceComparisonDetailsState> {
  final BranchManagerPriceComparisonRepository _repository;

  BranchManagerPriceComparisonDetailsCubit(this._repository)
    : super(const BranchManagerPriceComparisonDetailsInit());

  Future<void> loadDetails({required String comparisonId}) async {
    emit(const BranchManagerPriceComparisonDetailsLoading());

    final result = await _repository.getPriceComparisonDetails(
      comparisonId: comparisonId,
    );

    handle(
      result,
      success: (response) {
        emit(BranchManagerPriceComparisonDetailsSuccess(response));
      },
      failure: (failure) =>
          emit(BranchManagerPriceComparisonDetailsFailure(failure)),
    );
  }
}
