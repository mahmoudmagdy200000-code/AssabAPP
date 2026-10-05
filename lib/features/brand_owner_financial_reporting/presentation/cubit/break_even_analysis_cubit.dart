import 'package:injectable/injectable.dart';

import '../../../../core/helpers/safe_cubit.dart';
import '../../domain/usecases/get_break_even_analysis_usecase.dart';
import 'break_even_analysis_state.dart';

@injectable
class BreakEvenAnalysisCubit extends SafeCubit<BreakEvenAnalysisState> {
  final GetBreakEvenAnalysisUseCase _getUseCase;

  int? _currentYear;
  int? _currentMonth;
  String? _currentBranchId;

  BreakEvenAnalysisCubit(this._getUseCase)
    : super(const BreakEvenAnalysisInitial());

  int? get currentYear => _currentYear;

  int? get currentMonth => _currentMonth;

  String get currentBranchId => _currentBranchId ?? '';

  Future<void> loadBreakEvenAnalysis() async {
    emit(const BreakEvenAnalysisLoading());
    final result = await _getUseCase(
      year: _currentYear,
      month: _currentMonth,
      branchId: _currentBranchId ?? '',
    );
    handle(
      result,
      success: (data) {
        _currentYear = data.year;
        _currentMonth = data.month;
        _currentBranchId = data.branchId;
        emit(BreakEvenAnalysisSuccess(data: data));
      },
      failure: (failure) => emit(BreakEvenAnalysisFailure(failure)),
    );
  }

  void applyFilter({int? year, int? month, required String branchId}) {
    if (year != null) _currentYear = year;
    if (month != null) _currentMonth = month;
    _currentBranchId = branchId;
    loadBreakEvenAnalysis();
  }

  void resetFilter() {
    _currentYear = null;
    _currentMonth = null;
    _currentBranchId = '1';
    loadBreakEvenAnalysis();
  }
}
