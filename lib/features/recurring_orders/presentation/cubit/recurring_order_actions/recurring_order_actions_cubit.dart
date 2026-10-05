import 'package:assab/features/recurring_orders/data/repository/recurring_order_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/update_recurring_order_request.dart';
import 'recurring_order_actions_state.dart';

@injectable
class RecurringOrderActionsCubit extends SafeCubit<RecurringOrderActionsState> {
  final RecurringOrderRepository _recurringOrderRepository;

  RecurringOrderActionsCubit(this._recurringOrderRepository)
    : super(const RecurringOrderActionsInit());

  Future<void> deleteRecurringOrder({required String id}) async {
    emit(const RecurringOrderActionsLoading());
    final result = await _recurringOrderRepository.deleteRecurringOrder(id: id);
    handle(
      result,
      failure: (failure) => emit(RecurringOrderActionsFailure(failure)),
      success: (_) => emit(const RecurringOrderActionsSuccess()),
    );
  }

  Future<void> pauseRecurringOrder({required String id}) async {
    emit(const RecurringOrderActionsLoading());
    final result = await _recurringOrderRepository.pauseRecurringOrder(id: id);
    handle(
      result,
      failure: (failure) => emit(RecurringOrderActionsFailure(failure)),
      success: (_) => emit(const RecurringOrderActionsSuccess()),
    );
  }

  Future<void> resumeRecurringOrder({required String id}) async {
    emit(const RecurringOrderActionsLoading());
    final result = await _recurringOrderRepository.resumeRecurringOrder(id: id);
    handle(
      result,
      failure: (failure) => emit(RecurringOrderActionsFailure(failure)),
      success: (_) => emit(const RecurringOrderActionsSuccess()),
    );
  }

  Future<void> updateRecurringOrder({
    required String id,
    required UpdateRecurringOrderRequest request,
  }) async {
    emit(const RecurringOrderActionsLoading());
    final result = await _recurringOrderRepository.updateRecurringOrder(
      id: id,
      request: request,
    );

    handle(
      result,
      failure: (failure) => emit(RecurringOrderActionsFailure(failure)),
      success: (_) => emit(const RecurringOrderActionsSuccess()),
    );
  }
}
