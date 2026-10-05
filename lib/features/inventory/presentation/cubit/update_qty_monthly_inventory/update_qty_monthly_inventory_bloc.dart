import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/utils/bloc_debounce.dart';
import '../../../data/repository/inventory_repository.dart';
import 'update_qty_monthly_inventory_event.dart';
import 'update_qty_monthly_inventory_state.dart';

@injectable
class UpdateQtyMonthlyInventoryBloc
    extends
        Bloc<UpdateQtyMonthlyInventoryEvent, UpdateQtyMonthlyInventoryState> {
  final InventoryRepository _inventoryRepository;

  UpdateQtyMonthlyInventoryBloc(this._inventoryRepository)
    : super(const UpdateQtyMonthlyInventoryInit()) {
    on<UpdateQtyMonthlyInventoryRequested>(
      _onUpdateRequested,
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }

  Future<void> _onUpdateRequested(
    UpdateQtyMonthlyInventoryRequested event,
    Emitter<UpdateQtyMonthlyInventoryState> emit,
  ) async {
    emit(const UpdateQtyMonthlyInventoryLoading());

    final result = await _inventoryRepository.updateMonthlyInventoryProduct(
      inventoryId: event.inventoryId,
      productId: event.productId,
      request: event.request,
    );

    result.when(
      failure: (failure) =>
          emit(UpdateQtyMonthlyInventoryFailure(failure: failure)),
      success: (_) => emit(const UpdateQtyMonthlyInventorySuccess()),
    );
  }
}
