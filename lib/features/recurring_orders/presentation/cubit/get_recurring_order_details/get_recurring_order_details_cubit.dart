import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/recurring_order_repository.dart';
import 'get_recurring_order_details_state.dart';

@injectable
class GetRecurringOrderDetailsCubit
    extends SafeCubit<GetRecurringOrderDetailsState> {
  final RecurringOrderRepository _recurringOrderRepository;

  GetRecurringOrderDetailsCubit(this._recurringOrderRepository)
    : super(const GetRecurringOrderDetailsInit());

  Future<void> getRecurringOrderDetails({required String id}) async {
    emit(const GetRecurringOrderDetailsLoading());

    final response = await _recurringOrderRepository.getRecurringOrderDetails(
      id: id,
    );

    handle(
      response,
      failure: (failure) => emit(GetRecurringOrderDetailsFailure(failure)),
      success: (details) => emit(GetRecurringOrderDetailsSuccess(details)),
    );
  }
}
