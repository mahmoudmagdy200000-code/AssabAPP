import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/recurring_order_repository.dart';
import 'get_next_scheduled_recurring_orders_state.dart';

@injectable
class GetNextScheduledRecurringOrdersCubit
    extends SafeCubit<GetNextScheduledRecurringOrdersState> {
  final RecurringOrderRepository _recurringOrderRepository;

  GetNextScheduledRecurringOrdersCubit(this._recurringOrderRepository)
    : super(const GetNextScheduledRecurringOrdersInit());

  Future<void> getNextScheduledRecurringOrders() async {
    emit(const GetNextScheduledRecurringOrdersLoading());

    final response = await _recurringOrderRepository
        .getNextSchedulingRecurringOrders();

    handle(
      response,
      failure: (failure) =>
          emit(GetNextScheduledRecurringOrdersFailure(failure)),
      success: (orders) => emit(GetNextScheduledRecurringOrdersSuccess(orders)),
    );
  }
}
