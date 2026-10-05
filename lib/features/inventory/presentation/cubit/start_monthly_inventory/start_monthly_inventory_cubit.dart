import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/start_monthly_inventory_request.dart';
import '../../../data/repository/inventory_repository.dart';
import 'start_monthly_inventory_state.dart';

@injectable
class StartMonthlyInventoryCubit extends SafeCubit<StartMonthlyInventoryState> {
  final InventoryRepository _inventoryRepository;

  StartMonthlyInventoryCubit(this._inventoryRepository)
    : super(const StartMonthlyInventoryInit());

  Future<void> startMonthlyInventory({
    required StartMonthlyInventoryRequest request,
  }) async {
    emit(const StartMonthlyInventoryLoading());

    final result = await _inventoryRepository.startMonthlyInventory(
      request: request,
    );

    handle(
      result,
      success: (response) => emit(StartMonthlyInventorySuccess(response)),
      failure: (failure) => emit(StartMonthlyInventoryFailure(failure)),
    );
  }
}
