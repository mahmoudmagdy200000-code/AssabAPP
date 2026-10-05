import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/brand_owner_home_repository.dart';
import 'brand_owner_branches_state.dart';

@injectable
class BrandOwnerBranchesCubit extends SafeCubit<BrandOwnerBranchesState> {
  final BrandOwnerHomeRepository _repository;

  BrandOwnerBranchesCubit(this._repository)
    : super(const BrandOwnerBranchesInit());

  Future<void> loadBranches() async {
    emit(const BrandOwnerBranchesLoading());

    final result = await _repository.getBrandOwnerBranches();

    handle(
      result,
      success: (branches) => emit(BrandOwnerBranchesSuccess(branches)),
      failure: (failure) => emit(BrandOwnerBranchesFailure(failure)),
    );
  }
}
