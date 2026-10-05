import 'package:injectable/injectable.dart';

import '../../../../core/helpers/safe_cubit.dart';
import '../../domain/usecases/export_profit_and_loss_statement_usecase.dart';
import 'export_profit_and_loss_statement_state.dart';

@injectable
class ExportProfitAndLossStatementCubit
    extends SafeCubit<ExportProfitAndLossStatementState> {
  final ExportProfitAndLossStatementUseCase _exportUseCase;

  ExportProfitAndLossStatementCubit(this._exportUseCase)
    : super(const ExportProfitAndLossStatementInit());

  Future<void> exportProfitAndLossStatement({
    required int year,
    required int month,
    required String branchId,
    required String formatType,
  }) async {
    emit(const ExportProfitAndLossStatementLoading());

    final result = await _exportUseCase(
      year: year,
      month: month,
      branchId: branchId,
      formatType: formatType,
    );

    handle(
      result,
      success: (fileUrl) {
        emit(ExportProfitAndLossStatementSuccess(fileUrl));
      },
      failure: (failure) => emit(ExportProfitAndLossStatementFailure(failure)),
    );
  }

  Future<void> exportProfitAndLossStatementByEmail({
    required int year,
    required int month,
    required String branchId,
    required String email,
  }) async {
    emit(const ExportProfitAndLossStatementEmailLoading());

    final result = await _exportUseCase.emailReport(
      year: year,
      month: month,
      branchId: branchId,
      email: email,
    );

    handle(
      result,
      success: (_) {
        emit(const ExportProfitAndLossStatementEmailSuccess());
      },
      failure: (failure) =>
          emit(ExportProfitAndLossStatementEmailFailure(failure)),
    );
  }
}
