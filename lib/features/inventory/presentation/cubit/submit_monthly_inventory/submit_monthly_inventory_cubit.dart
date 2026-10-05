import 'package:injectable/injectable.dart';
import 'package:assab/features/inventory/data/repository/inventory_repository.dart';
import 'package:assab/features/inventory/presentation/cubit/submit_monthly_inventory/submit_monthly_inventory_state.dart';

import '../../../../../core/helpers/safe_cubit.dart';

@injectable
class SubmitMonthlyInventoryCubit
    extends SafeCubit<SubmitMonthlyInventoryState> {
  final InventoryRepository _inventoryRepository;

  SubmitMonthlyInventoryCubit(this._inventoryRepository)
    : super(const SubmitMonthlyInventoryInit());

  Future<void> submitMonthlyInventory({required String inventoryId}) async {
    emit(const SubmitMonthlyInventoryLoading());

    final result = await _inventoryRepository.submitMonthlyInventory(
      inventoryId: inventoryId,
    );

    handle(
      result,
      failure: (failure) => emit(SubmitMonthlyInventoryFailure(failure)),
      success: (_) => emit(const SubmitMonthlyInventorySuccess()),
    );
  }
}
