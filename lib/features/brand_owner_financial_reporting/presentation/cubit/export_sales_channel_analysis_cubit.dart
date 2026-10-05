import 'package:injectable/injectable.dart';

import '../../../../core/helpers/safe_cubit.dart';
import '../../domain/usecases/export_sales_channel_analysis_usecase.dart';
import 'export_sales_channel_analysis_state.dart';

@injectable
class ExportSalesChannelAnalysisCubit
    extends SafeCubit<ExportSalesChannelAnalysisState> {
  final ExportSalesChannelAnalysisUseCase _exportUseCase;

  ExportSalesChannelAnalysisCubit(this._exportUseCase)
    : super(const ExportSalesChannelAnalysisInit());

  Future<void> exportSalesChannelAnalysis({
    required int year,
    required int month,
    required int comparedYear,
    required int comparedMonth,
    required String branchId,
    required String formatType,
  }) async {
    emit(const ExportSalesChannelAnalysisLoading());

    final result = await _exportUseCase(
      year: year,
      month: month,
      comparedYear: comparedYear,
      comparedMonth: comparedMonth,
      branchId: branchId,
      formatType: formatType,
    );

    handle(
      result,
      success: (fileUrl) {
        emit(ExportSalesChannelAnalysisSuccess(fileUrl));
      },
      failure: (failure) =>
          emit(ExportSalesChannelAnalysisFailure(failure)),
    );
  }

  Future<void> exportSalesChannelAnalysisByEmail({
    required int year,
    required int month,
    required int comparedYear,
    required int comparedMonth,
    required String branchId,
    required String email,
  }) async {
    emit(const ExportSalesChannelAnalysisEmailLoading());

    final result = await _exportUseCase.emailReport(
      year: year,
      month: month,
      comparedYear: comparedYear,
      comparedMonth: comparedMonth,
      branchId: branchId,
      email: email,
    );

    handle(
      result,
      success: (_) {
        emit(const ExportSalesChannelAnalysisEmailSuccess());
      },
      failure: (failure) =>
          emit(ExportSalesChannelAnalysisEmailFailure(failure)),
    );
  }
}
