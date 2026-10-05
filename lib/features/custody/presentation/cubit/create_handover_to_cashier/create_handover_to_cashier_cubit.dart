import 'package:assab/core/helpers/safe_cubit.dart';
import 'package:injectable/injectable.dart';

import '../../../data/models/custody_handover_to_cashier_request.dart';
import '../../../data/repository/custody_repository.dart';
import 'create_handover_to_cashier_state.dart';

@injectable
class CreateHandoverToCashierCubit
    extends SafeCubit<CreateHandoverToCashierState> {
  final CustodyRepository _custodyRepository;

  CreateHandoverToCashierCubit(this._custodyRepository)
    : super(const CreateHandoverToCashierInit());

  Future<void> handoverToCashier({
    required CustodyHandoverToCashierRequest requestModel,
  }) async {
    emit(const CreateHandoverToCashierLoading());

    final result = await _custodyRepository.handoverToCashier(
      body: requestModel,
    );

    handle(
      result,
      failure: (failure) => emit(CreateHandoverToCashierFailure(failure)),
      success: (_) => emit(const CreateHandoverToCashierSuccess()),
    );
  }
}
