import 'package:injectable/injectable.dart';

import '../../../../core/helpers/safe_cubit.dart';
import '../../domain/usecases/get_profit_vs_cash_reconciliation_usecase.dart';
import 'profit_vs_cash_reconciliation_state.dart';

@injectable
class ProfitVsCashReconciliationCubit
    extends SafeCubit<ProfitVsCashReconciliationState> {
  final GetProfitVsCashReconciliationUseCase _getUseCase;

  ProfitVsCashReconciliationCubit(this._getUseCase)
    : super(const ProfitVsCashReconciliationInitial());

  Future<void> loadProfitVsCashReconciliation() async {
    emit(const ProfitVsCashReconciliationLoading());

    final result = await _getUseCase();

    handle(
      result,
      success: (data) {
        emit(ProfitVsCashReconciliationSuccess(data: data));
      },
      failure: (failure) =>
          emit(ProfitVsCashReconciliationFailure(failure)),
    );
  }
}
