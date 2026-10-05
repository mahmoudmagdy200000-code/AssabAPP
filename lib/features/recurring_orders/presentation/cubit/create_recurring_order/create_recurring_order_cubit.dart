import 'package:assab/features/recurring_orders/data/repository/recurring_order_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/create_recurring_order_request.dart';
import 'create_recurring_order_state.dart';

@injectable
class CreateRecurringOrderCubit extends SafeCubit<CreateRecurringOrderState> {
  final RecurringOrderRepository _recurringOrderRepository;

  CreateRecurringOrderCubit(this._recurringOrderRepository)
    : super(const CreateRecurringOrderInit());

  Future<void> createRecurringOrder(CreateRecurringOrderRequest request) async {
    emit(const CreateRecurringOrderLoading());

    final result = await _recurringOrderRepository.createRecurringOrder(
      request,
    );

    handle(
      result,
      failure: (failure) => emit(CreateRecurringOrderFailure(failure)),
      success: (value) => emit(const CreateRecurringOrderSuccess()),
    );
  }
}
