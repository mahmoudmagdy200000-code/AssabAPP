import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/purchase_repository.dart';
import 'get_purchase_products_branch_details_state.dart';

@injectable
class GetPurchaseProductsBranchDetailsCubit
    extends SafeCubit<GetPurchaseProductsBranchDetailsState> {
  final PurchaseRepository _purchaseRepository;
  GetPurchaseProductsBranchDetailsCubit(this._purchaseRepository)
    : super(const GetPurchaseProductsBranchDetailsInit());

  void getPurchaseProductsBranchDetails({required String branchId}) async {
    emit(const GetPurchaseProductsBranchDetailsLoading());

    final result = await _purchaseRepository.getPurchaseProductBranchDetails(
      branchId: branchId,
    );

    handle(
      result,
      failure: (failure) {
        emit(GetPurchaseProductsBranchDetailsFailure(failure));
      },
      success: (response) {
        emit(GetPurchaseProductsBranchDetailsSuccess(response));
      },
    );
  }
}
