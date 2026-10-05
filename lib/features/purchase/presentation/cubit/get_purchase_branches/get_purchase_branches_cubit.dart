import 'package:assab/features/purchase/data/repository/purchase_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import 'get_purchase_branches_state.dart';

@injectable
class GetPurchaseBranchesCubit extends SafeCubit<GetPurchaseBranchesState> {
  final PurchaseRepository _purchaseRepository;

  GetPurchaseBranchesCubit(this._purchaseRepository)
    : super(const GetPurchaseBranchesInit());

  void getPurchaseBranches({
    required String itemId,
    required String quantity,
    String? availability,
    String? responseTime,
    String? distance,
  }) async {
    emit(const GetPurchaseBranchesLoading());

    final result = await _purchaseRepository.getPurchaseBranches(
      itemId: itemId,
      quantity: quantity,
      availability: availability,
      responseTime: responseTime,
      distance: distance,
    );

    handle(
      result,
      failure: (failure) => emit(GetPurchaseBranchesFailure(failure)),
      success: (success) => emit(GetPurchaseBranchesSuccess(success)),
    );
  }
}
