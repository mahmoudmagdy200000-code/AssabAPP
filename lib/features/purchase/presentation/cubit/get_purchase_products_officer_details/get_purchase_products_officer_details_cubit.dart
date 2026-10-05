import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/purchase_repository.dart';
import 'get_purchase_products_officer_details_state.dart';

@injectable
class GetPurchaseProductsOfficerDetailsCubit
    extends SafeCubit<GetPurchaseProductsOfficerDetailsState> {
  final PurchaseRepository _purchaseRepository;

  GetPurchaseProductsOfficerDetailsCubit(this._purchaseRepository)
    : super(const GetPurchaseProductsOfficerDetailsInit());

  void getPurchaseProductOfficerDetails() async {
    emit(const GetPurchaseProductsOfficerDetailsLoading());

    final result = await _purchaseRepository.getPurchaseProductOfficerDetails();

    handle(
      result,
      failure: (failure) {
        emit(GetPurchaseProductsOfficerDetailsFailure(failure));
      },
      success: (response) {
        emit(GetPurchaseProductsOfficerDetailsSuccess(response.data));
      },
    );
  }
}
