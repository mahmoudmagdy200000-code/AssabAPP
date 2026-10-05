import 'package:injectable/injectable.dart';

import '../../../../core/helpers/safe_cubit.dart';
import '../../domain/usecases/export_break_even_analysis_usecase.dart';
import 'export_break_even_analysis_state.dart';

@injectable
class ExportBreakEvenAnalysisCubit
    extends SafeCubit<ExportBreakEvenAnalysisState> {
  final ExportBreakEvenAnalysisUseCase _exportUseCase;

  ExportBreakEvenAnalysisCubit(this._exportUseCase)
    : super(const ExportBreakEvenAnalysisInit());

  Future<void> exportBreakEvenAnalysis({
    required int year,
    required int month,
    required String branchId,
    required String formatType,
  }) async {
    emit(const ExportBreakEvenAnalysisLoading());

    final result = await _exportUseCase(
      year: year,
      month: month,
      branchId: branchId,
      formatType: formatType,
    );

    handle(
      result,
      success: (fileUrl) {
        emit(ExportBreakEvenAnalysisSuccess(fileUrl));
      },
      failure: (failure) => emit(ExportBreakEvenAnalysisFailure(failure)),
    );
  }
}
