import 'package:assab/features/purchase/data/repository/purchase_repository.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/helpers/safe_cubit.dart';
import 'get_purchase_products_supplier_details_state.dart';

@injectable
class GetPurchaseProductsSupplierDetailsCubit
    extends SafeCubit<GetPurchaseProductsSupplierDetailsState> {
  final PurchaseRepository _purchaseRepository;

  GetPurchaseProductsSupplierDetailsCubit(this._purchaseRepository)
    : super(const GetPurchaseProductsSupplierDetailsInit());

  void getPurchaseProductsSupplierDetails({required String supplierId}) async {
    emit(const GetPurchaseProductsSupplierDetailsLoading());

    final result = await _purchaseRepository.getPurchaseProductSupplierDetails(
      supplierId: supplierId,
    );

    handle(
      result,
      failure: (failure) {
        emit(GetPurchaseProductsSupplierDetailsFailure(failure));
      },
      success: (details) {
        emit(GetPurchaseProductsSupplierDetailsSuccess(details));
      },
    );
  }
}
