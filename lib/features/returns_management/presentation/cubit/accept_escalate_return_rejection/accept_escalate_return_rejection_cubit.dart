import 'package:assab/features/returns_management/data/repository/return_management_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import 'accept_escalate_return_rejection_state.dart';

@injectable
class AcceptEscalateReturnRejectionCubit
    extends SafeCubit<AcceptEscalateReturnRejectionState> {
  final ReturnManagementRepository _returnManagementRepository;

  AcceptEscalateReturnRejectionCubit(this._returnManagementRepository)
    : super(const AcceptEscalateReturnRejectionInit());

  Future<void> acceptReturnRejection({required String id}) async {
    emit(const AcceptEscalateReturnRejectionLoading());

    final result = await _returnManagementRepository.acceptReturnRejection(
      id: id,
    );

    handle(
      result,
      success: (_) => emit(const AcceptEscalateReturnRejectionSuccess()),
      failure: (failure) => emit(AcceptEscalateReturnRejectionFailure(failure)),
    );
  }

  Future<void> escalateReturn({
    required String id,
    required String reason,
  }) async {
    emit(const AcceptEscalateReturnRejectionLoading());

    final result = await _returnManagementRepository.escalateReturn(
      id: id,
      reason: reason,
    );

    handle(
      result,
      success: (_) => emit(const AcceptEscalateReturnRejectionSuccess()),
      failure: (failure) => emit(AcceptEscalateReturnRejectionFailure(failure)),
    );
  }
}
