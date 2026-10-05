import 'package:injectable/injectable.dart';

import '../../../../core/helpers/safe_cubit.dart';
import '../../domain/usecases/get_branches_for_filter_usecase.dart';
import 'brand_owner_branches_for_filter_state.dart';

@injectable
class BrandOwnerBranchesForFilterCubit
    extends SafeCubit<BrandOwnerBranchesForFilterState> {
  final GetBranchesForFilterUseCase _useCase;

  BrandOwnerBranchesForFilterCubit(this._useCase)
    : super(const BrandOwnerBranchesForFilterInit());

  Future<void> loadBranches() async {
    emit(const BrandOwnerBranchesForFilterLoading());

    final result = await _useCase();

    handle(
      result,
      success: (branches) =>
          emit(BrandOwnerBranchesForFilterSuccess(branches)),
      failure: (failure) =>
          emit(BrandOwnerBranchesForFilterFailure(failure)),
    );
  }
}
