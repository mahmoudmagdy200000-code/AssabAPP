import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/recurring_order_repository.dart';
import 'get_paused_recurring_orders_state.dart';

@injectable
class GetPausedRecurringOrdersCubit
    extends SafeCubit<GetPausedRecurringOrdersState> {
  final RecurringOrderRepository _recurringOrderRepository;

  GetPausedRecurringOrdersCubit(this._recurringOrderRepository)
    : super(const GetPausedRecurringOrdersInit());

  Future<void> getPausedRecurringOrders() async {
    emit(const GetPausedRecurringOrdersLoading());

    final response = await _recurringOrderRepository.getPausedRecurringOrders();

    handle(
      response,
      failure: (failure) => emit(GetPausedRecurringOrdersFailure(failure)),
      success: (orders) => emit(GetPausedRecurringOrdersSuccess(orders)),
    );
  }
}
