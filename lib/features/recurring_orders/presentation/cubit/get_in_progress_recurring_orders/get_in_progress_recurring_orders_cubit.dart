import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/recurring_order_repository.dart';
import 'get_in_progress_recurring_orders_state.dart';

@injectable
class GetInProgressRecurringOrdersCubit
    extends SafeCubit<GetInProgressRecurringOrdersState> {
  final RecurringOrderRepository _recurringOrderRepository;

  GetInProgressRecurringOrdersCubit(this._recurringOrderRepository)
    : super(const GetInProgressRecurringOrdersInit());

  Future<void> getInProgressRecurringOrders() async {
    emit(const GetInProgressRecurringOrdersLoading());

    final response = await _recurringOrderRepository
        .getInProgressRecurringOrders();

    handle(
      response,
      failure: (failure) => emit(GetInProgressRecurringOrdersFailure(failure)),
      success: (orders) => emit(GetInProgressRecurringOrdersSuccess(orders)),
    );
  }
}
