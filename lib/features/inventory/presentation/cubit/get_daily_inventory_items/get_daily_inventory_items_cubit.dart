import 'package:assab/features/inventory/data/repository/inventory_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import 'get_daily_inventory_items_state.dart';

@injectable
class GetDailyInventoryItemsCubit
    extends SafeCubit<GetDailyInventoryItemsState> {
  final InventoryRepository _inventoryRepository;

  GetDailyInventoryItemsCubit(this._inventoryRepository)
    : super(const GetDailyInventoryItemsInit());

  void getInventoryDailyQuickBranchItems() async {
    emit(const GetDailyInventoryItemsLoading());

    final result = await _inventoryRepository
        .getInventoryDailyQuickBranchItems();

    handle(
      result,
      failure: (error) {
        emit(GetDailyInventoryItemsFailure(error));
      },
      success: (data) {
        emit(GetDailyInventoryItemsSuccess(data.data));
      },
    );
  }
}
