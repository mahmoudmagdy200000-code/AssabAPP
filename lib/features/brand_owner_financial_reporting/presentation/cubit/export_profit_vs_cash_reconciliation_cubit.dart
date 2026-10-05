import 'package:injectable/injectable.dart';

import '../../../../core/helpers/safe_cubit.dart';
import '../../domain/usecases/export_profit_vs_cash_reconciliation_usecase.dart';
import 'export_profit_vs_cash_reconciliation_state.dart';

@injectable
class ExportProfitVsCashReconciliationCubit
    extends SafeCubit<ExportProfitVsCashReconciliationState> {
  final ExportProfitVsCashReconciliationUseCase _exportUseCase;

  ExportProfitVsCashReconciliationCubit(this._exportUseCase)
    : super(const ExportProfitVsCashReconciliationInit());

  Future<void> exportProfitVsCashReconciliation({
    required String formatType,
  }) async {
    emit(const ExportProfitVsCashReconciliationLoading());

    final result = await _exportUseCase(
      formatType: formatType,
    );

    handle(
      result,
      success: (fileUrl) {
        emit(ExportProfitVsCashReconciliationSuccess(fileUrl));
      },
      failure: (failure) =>
          emit(ExportProfitVsCashReconciliationFailure(failure)),
    );
  }

  Future<void> exportProfitVsCashReconciliationByEmail({
    required String email,
  }) async {
    emit(const ExportProfitVsCashReconciliationEmailLoading());

    final result = await _exportUseCase.emailReport(
      email: email,
    );

    handle(
      result,
      success: (_) {
        emit(const ExportProfitVsCashReconciliationEmailSuccess());
      },
      failure: (failure) =>
          emit(ExportProfitVsCashReconciliationEmailFailure(failure)),
    );
  }
}
