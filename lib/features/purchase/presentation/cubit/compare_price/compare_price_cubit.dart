import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/purchase_repository.dart';
import 'compare_price_state.dart';

@injectable
class ComparePriceCubit extends SafeCubit<ComparePriceState> {
  final PurchaseRepository _purchaseRepository;

  ComparePriceCubit(this._purchaseRepository) : super(const ComparePriceInit());

  void comparePrices({required String itemId}) async {
    emit(const ComparePriceLoading());

    final result = await _purchaseRepository.comparePurchasePrices(
      itemId: itemId,
    );

    handle(
      result,
      failure: (error) {
        emit(ComparePriceFailure(error));
      },
      success: (data) {
        emit(ComparePriceSuccess(data));
      },
    );
  }
}
