import 'package:assab/features/inventory/data/models/daily_inventory_request.dart';
import 'package:assab/features/inventory/data/repository/inventory_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import 'create_inventory_state.dart';

@injectable
class CreateInventoryCubit extends SafeCubit<CreateInventoryState> {
  final InventoryRepository _inventoryRepository;

  CreateInventoryCubit(this._inventoryRepository)
    : super(const CreateInventoryInit());

  void createDailyInventory({
    required String id,
    required DailyInventoryRequest request,
  }) async {
    emit(const CreateInventoryLoading());

    final result = await _inventoryRepository.createDailyInventory(
      id: id,
      request: request,
    );

    handle(
      result,
      failure: (error) {
        emit(CreateInventoryFailure(error));
      },
      success: (data) {
        emit(const CreateInventorySuccess());
      },
    );
  }
}
