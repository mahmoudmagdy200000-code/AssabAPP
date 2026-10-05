import 'package:assab/core/enums/time_keys.dart';
import 'package:assab/core/helpers/safe_cubit.dart';
import 'package:assab/features/branch_manager_home/domain/repositories/branch_manager_price_comparison_repository.dart';
import 'package:assab/features/branch_manager_home/presentation/cubit/branch_manager_export_price_comparison/branch_manager_export_price_comparison_state.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'branch_manager_create_order_with_recommended_source_state.dart';

@injectable
class BranchManagerCreateOrderWithRecommendedSourceCubit
    extends SafeCubit<BranchManagerCreateOrderWithRecommendedSourceState> {
  final BranchManagerPriceComparisonRepository _repository;

  BranchManagerCreateOrderWithRecommendedSourceCubit(this._repository)
    : super(const BranchManagerCreateOrderWithRecommendedSourceInit());

  Future<void> createOrderWithRecommendedSource({required String id}) async {
    emit(const BranchManagerCreateOrderWithRecommendedSourceLoading());

    final result = await _repository.createOrderWithRecommendedSource(id: id);

    handle(
      result,
      success: (_) {
        emit(const BranchManagerCreateOrderWithRecommendedSourceSuccess());
      },
      failure: (failure) =>
          emit(BranchManagerCreateOrderWithRecommendedSourceFailure(failure)),
    );
  }
}
