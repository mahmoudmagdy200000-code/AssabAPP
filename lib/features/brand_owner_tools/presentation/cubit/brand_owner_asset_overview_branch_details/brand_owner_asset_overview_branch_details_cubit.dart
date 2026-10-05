import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../domain/use_cases/get_brand_owner_asset_overview_branch_details_use_case.dart';
import 'brand_owner_asset_overview_branch_details_state.dart';

@injectable
class BrandOwnerAssetOverviewBranchDetailsCubit
    extends SafeCubit<BrandOwnerAssetOverviewBranchDetailsState> {
  final GetBrandOwnerAssetOverviewBranchDetailsUseCase
  _getBranchDetailsUseCase;

  BrandOwnerAssetOverviewBranchDetailsCubit(this._getBranchDetailsUseCase)
    : super(const BrandOwnerAssetOverviewBranchDetailsInitial());

  Future<void> load({required String branchId}) async {
    emit(const BrandOwnerAssetOverviewBranchDetailsLoading());

    final result = await _getBranchDetailsUseCase(branchId: branchId);

    handle(
      result,
      success: (branch) =>
          emit(BrandOwnerAssetOverviewBranchDetailsSuccess(branch)),
      failure: (failure) =>
          emit(BrandOwnerAssetOverviewBranchDetailsFailure(failure)),
    );
  }
}
