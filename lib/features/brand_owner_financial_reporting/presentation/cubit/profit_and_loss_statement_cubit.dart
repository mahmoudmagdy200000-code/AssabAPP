import 'package:injectable/injectable.dart';

import '../../../../core/helpers/safe_cubit.dart';
import '../../domain/usecases/get_profit_and_loss_statement_usecase.dart';
import 'profit_and_loss_statement_state.dart';

@injectable
class ProfitAndLossStatementCubit
    extends SafeCubit<ProfitAndLossStatementState> {
  final GetProfitAndLossStatementUseCase _getUseCase;

  int? _currentYear;
  int? _currentMonth;
  String? _currentBranchId;

  ProfitAndLossStatementCubit(this._getUseCase)
    : super(const ProfitAndLossStatementInitial());

  Future<void> loadProfitAndLossStatement() async {
    emit(const ProfitAndLossStatementLoading());

    final result = await _getUseCase(
      year: _currentYear,
      month: _currentMonth,
      branchId: _currentBranchId,
    );

    handle(
      result,
      success: (data) {
        _currentYear = data.year;
        _currentMonth = data.month;
        emit(ProfitAndLossStatementSuccess(data: data));
      },
      failure: (failure) => emit(ProfitAndLossStatementFailure(failure)),
    );
  }

  void applyFilter({int? year, int? month, String? branchId}) {
    if (year != null) _currentYear = year;
    if (month != null) _currentMonth = month;
    _currentBranchId = branchId;
    loadProfitAndLossStatement();
  }
}
