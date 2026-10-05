import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/purchase_repository.dart';
import 'save_compare_price_state.dart';

@injectable
class SaveComparePriceCubit extends SafeCubit<SaveComparePriceState> {
  final PurchaseRepository _purchaseRepository;

  SaveComparePriceCubit(this._purchaseRepository)
    : super(const SaveComparePriceInit());

  void saveComparePrices({required String id}) async {
    emit(const SaveComparePriceLoading());

    final result = await _purchaseRepository.saveComparePrices(id: id);

    handle(
      result,
      failure: (error) {
        emit(SaveComparePriceFailure(error));
      },
      success: (_) {
        emit(const SaveComparePriceSuccess());
      },
    );
  }
}
