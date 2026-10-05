import 'package:injectable/injectable.dart';

import '../../../../core/helpers/safe_cubit.dart';
import '../../domain/usecases/get_sales_channel_level2_usecase.dart';
import 'sales_channel_level2_state.dart';

@injectable
class SalesChannelLevel2Cubit
    extends SafeCubit<SalesChannelLevel2State> {
  final GetSalesChannelLevel2UseCase _getUseCase;

  int? _currentYear;
  int? _currentMonth;
  int? _currentComparedYear;
  int? _currentComparedMonth;
  String? _currentBranchId;

  SalesChannelLevel2Cubit(this._getUseCase)
    : super(const SalesChannelLevel2Initial());

  int? get currentYear => _currentYear;
  int? get currentMonth => _currentMonth;
  int? get currentComparedYear => _currentComparedYear;
  int? get currentComparedMonth => _currentComparedMonth;
  String? get currentBranchId => _currentBranchId;

  Future<void> loadSalesChannelLevel2() async {
    emit(const SalesChannelLevel2Loading());

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
        emit(
          SalesChannelLevel2Success(
            data: data,
            branchId: _currentBranchId,
          ),
        );
      },
      failure: (failure) => emit(SalesChannelLevel2Failure(failure)),
    );
  }

  void applyFilter({
    int? year,
    int? month,
    int? comparedYear,
    int? comparedMonth,
    String? branchId,
  }) {
    if (year != null) _currentYear = year;
    if (month != null) _currentMonth = month;
    if (comparedYear != null) _currentComparedYear = comparedYear;
    if (comparedMonth != null) _currentComparedMonth = comparedMonth;
    _currentBranchId = branchId;
    loadSalesChannelLevel2();
  }
}
