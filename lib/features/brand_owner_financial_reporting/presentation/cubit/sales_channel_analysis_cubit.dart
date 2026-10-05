import 'package:injectable/injectable.dart';

import '../../../../core/helpers/safe_cubit.dart';
import '../../domain/usecases/get_sales_channel_analysis_usecase.dart';
import 'sales_channel_analysis_state.dart';

@injectable
class SalesChannelAnalysisCubit extends SafeCubit<SalesChannelAnalysisState> {
  final GetSalesChannelAnalysisUseCase _getUseCase;

  int? _currentYear;
  int? _currentMonth;
  int? _currentComparedYear;
  int? _currentComparedMonth;
  String? _currentBranchId;

  SalesChannelAnalysisCubit(this._getUseCase)
    : super(const SalesChannelAnalysisInitial());

  int? get currentYear => _currentYear;
  int? get currentMonth => _currentMonth;
  int? get currentComparedYear => _currentComparedYear;
  int? get currentComparedMonth => _currentComparedMonth;
  String get currentBranchId => _currentBranchId ?? '';

  Future<void> loadSalesChannelAnalysis() async {
    emit(const SalesChannelAnalysisLoading());

    final result = await _getUseCase(
      year: _currentYear,
      month: _currentMonth,
      comparedYear: _currentComparedYear,
      comparedMonth: _currentComparedMonth,
      branchId: _currentBranchId,
    );

    handle(
      result,
      success: (data) {
        _currentYear = data.year;
        _currentMonth = data.month;
        _currentComparedYear = data.comparedYear;
        _currentComparedMonth = data.comparedMonth;
        emit(SalesChannelAnalysisSuccess(data: data));
      },
      failure: (failure) => emit(SalesChannelAnalysisFailure(failure)),
    );
  }

  void applyFilter({
    int? year,
    int? month,
    int? comparedYear,
    int? comparedMonth,
    required String branchId,
  }) {
    if (year != null) _currentYear = year;
    if (month != null) _currentMonth = month;
    if (comparedYear != null) _currentComparedYear = comparedYear;
    if (comparedMonth != null) _currentComparedMonth = comparedMonth;
    _currentBranchId = branchId;
    loadSalesChannelAnalysis();
  }

  void resetFilter() {
    _currentYear = null;
    _currentMonth = null;
    _currentComparedYear = null;
    _currentComparedMonth = null;
    _currentBranchId = '1';
    loadSalesChannelAnalysis();
  }
}
