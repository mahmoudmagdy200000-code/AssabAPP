import 'dart:async';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/monthly_inventory_pending_products_response.dart';
import '../../../data/repository/inventory_repository.dart';
import 'get_monthly_pending_products_state.dart';

@injectable
class GetMonthlyPendingProductsCubit
    extends SafeCubit<GetMonthlyPendingProductsState> {
  final InventoryRepository _inventoryRepository;

  GetMonthlyPendingProductsCubit(this._inventoryRepository)
    : super(const GetMonthlyPendingProductsInit());

  bool _isFirstTime = true;
  bool _isSubscribed = false;
  StreamSubscription? _subscription;

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    _subscription = null;
    return super.close();
  }

  Future<void> getMonthlyInventoryPendingProducts({
    required String inventoryId,
  }) async {
    if (_isFirstTime) {
      emit(const GetMonthlyPendingProductsLoading());
      _isFirstTime = false;
    }

    final result = await _inventoryRepository
        .getMonthlyInventoryPendingProducts(
          inventoryId: inventoryId,
          completedOnly: false,
        );

    handle(
      result,
      failure: (failure) =>
          emit(GetMonthlyPendingProductsFailure(failure: failure)),
      success: (response) {
        emit(GetMonthlyPendingProductsSuccess(response: response));
        // Subscribe AFTER emitting success so state is correct when
        // first realtime event arrives.
        _subscribeToMonthlyInventoryProducts(inventoryId: inventoryId);
      },
    );
  }

  void _subscribeToMonthlyInventoryProducts({required String inventoryId}) {
    if (_isSubscribed) return;
    _isSubscribed = true;

    _subscription = _inventoryRepository
        .subscribeToMonthlyInventoryProducts(inventoryId: inventoryId)
        .listen((result) {
          handle(
            result,
            failure: (_) {},
            success: (product) {
              if (state is! GetMonthlyPendingProductsSuccess) {
                return;
              }

              final current = state as GetMonthlyPendingProductsSuccess;

              final updated =
                  Map<String, MonthlyInventoryPendingProduct>.from(
                      current.response.productsMap,
                    )
                    ..[product.data.id] = product.data
                        .toMonthlyInventoryPendingProduct();

              emit(
                GetMonthlyPendingProductsSuccess(
                  response: current.response.copyWith(productsMap: updated),
                ),
              );
            },
          );
        });
  }
}
