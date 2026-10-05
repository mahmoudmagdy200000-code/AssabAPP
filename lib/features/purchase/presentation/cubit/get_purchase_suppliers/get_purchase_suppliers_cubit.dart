import 'package:assab/features/purchase/data/repository/purchase_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import 'get_purchase_suppliers_state.dart';

@injectable
class GetPurchaseSuppliersCubit extends SafeCubit<GetPurchaseSuppliersState> {
  final PurchaseRepository _purchaseRepository;

  GetPurchaseSuppliersCubit(this._purchaseRepository)
    : super(const GetPurchaseSuppliersInit());

  void getPurchaseSuppliers({
    required String itemId,
    required String quantity,
    String? availability,
    int? timeDelivery,
  }) async {
    emit(const GetPurchaseSuppliersLoading());

    final result = await _purchaseRepository.getPurchaseSuppliers(
      itemId: itemId,
      quantity: quantity,
      availability: availability,
      timeDelivery: timeDelivery,
    );

    handle(
      result,
      failure: (failure) {
        emit(GetPurchaseSuppliersFailure(failure));
      },
      success: (response) {
        emit(GetPurchaseSuppliersSuccess(response));
      },
    );
  }
}
