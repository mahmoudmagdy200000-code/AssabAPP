import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/inventory_repository.dart';
import 'get_wasted_damage_items_state.dart';

@injectable
class GetWastedDamageItemsCubit extends SafeCubit<GetWastedDamageItemsState> {
  final InventoryRepository _inventoryRepository;

  GetWastedDamageItemsCubit(this._inventoryRepository)
    : super(const GetWastedDamageItemsInit());

  Future<void> getWastedDamageItems() async {
    emit(const GetWastedDamageItemsLoading());

    final result = await _inventoryRepository
        .getInventoryWasteDamageProductsFromClosedOrders();

    handle(
      result,
      success: (response) => emit(GetWastedDamageItemsSuccess(response)),
      failure: (failure) => emit(GetWastedDamageItemsFailure(failure)),
    );
  }
}
