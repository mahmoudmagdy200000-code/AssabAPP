import 'dart:async';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../../../core/utils/app_logger.dart';
import '../../../data/repository/inventory_repository.dart';
import 'get_monthly_completed_products_state.dart';

@injectable
class GetMonthlyCompletedProductsCubit
    extends SafeCubit<GetMonthlyCompletedProductsState> {
  final InventoryRepository _inventoryRepository;

  GetMonthlyCompletedProductsCubit(this._inventoryRepository)
    : super(const GetMonthlyCompletedProductsInit());

  bool _isFirstTime = true;
  bool _isSubscribed = false;
  StreamSubscription? _subscription;

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    _subscription = null;
    return super.close();
  }

  Future<void> getMonthlyInventoryCompletedProducts({
    required String inventoryId,
  }) async {
    if (_isFirstTime) {
      emit(const GetMonthlyCompletedProductsLoading());
      _isFirstTime = false;
    }

    final result = await _inventoryRepository
        .getMonthlyInventoryCompletedProducts(inventoryId: inventoryId);

    handle(
      result,
      failure: (failure) =>
          emit(GetMonthlyCompletedProductsFailure(failure: failure)),
      success: (response) {
        emit(GetMonthlyCompletedProductsSuccess(response: response));
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
            failure: (_) {
              AppLogger.log(
                'CompletedProducts realtime error (non-fatal)',
                tag: 'GetMonthlyCompletedProductsCubit',
              );
            },
            success: (product) {
              if (state is! GetMonthlyCompletedProductsSuccess) {
                return;
              }

              final current = state as GetMonthlyCompletedProductsSuccess;

              // Replace existing product or add new one
              final index = current.response.completedProducts.indexWhere(
                (p) => p.id == product.data.id,
              );

              final updatedList = [...current.response.completedProducts];

              if (index != -1) {
                updatedList[index] = product.data
                    .toMonthlyInventoryPendingProduct();
              } else {
                updatedList.add(
                  product.data.toMonthlyInventoryPendingProduct(),
                );
              }

              emit(
                GetMonthlyCompletedProductsSuccess(
                  response: current.response.copyWith(
                    completedProducts: updatedList,
                    completed: index != -1
                        ? current.response.completed
                        : current.response.completed + 1,
                  ),
                ),
              );
            },
          );
        });
  }

  Future<void> unsubscribeFromMonthlyInventoryProducts({
    required String inventoryId,
  }) async {
    await _inventoryRepository.unsubscribeFromMonthlyInventoryProducts(
      inventoryId: inventoryId,
    );
  }
}
