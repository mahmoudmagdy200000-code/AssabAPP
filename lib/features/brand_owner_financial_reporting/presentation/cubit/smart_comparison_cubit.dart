import 'package:injectable/injectable.dart';

import '../../../../core/helpers/safe_cubit.dart';
import '../../domain/enums/brand_owner_smart_compare_type_enum.dart';
import '../../domain/usecases/get_smart_comparison_usecase.dart';
import 'smart_comparison_state.dart';

@injectable
class SmartComparisonCubit extends SafeCubit<SmartComparisonState> {
  final GetSmartComparisonUseCase _getUseCase;

  int? _currentYear;
  int? _currentMonth;
  int? _currentComparedYear;
  int? _currentComparedMonth;
  BrandOwnerSmartCompareTypeEnum _currentType =
      BrandOwnerSmartCompareTypeEnum.month;
  String? _currentBranchId;
  String? _currentComparedBranchId;

  SmartComparisonCubit(this._getUseCase)
    : super(const SmartComparisonInitial());

  int? get currentYear => _currentYear;

  int? get currentMonth => _currentMonth;

  int? get currentComparedYear => _currentComparedYear;

  int? get currentComparedMonth => _currentComparedMonth;

  BrandOwnerSmartCompareTypeEnum get currentType => _currentType;

  String? get currentBranchId => _currentBranchId;

  String? get currentComparedBranchId => _currentComparedBranchId;

  Future<void> loadSmartComparison() async {
    emit(const SmartComparisonLoading());

    final result = await _getUseCase(
      year: _currentYear,
      month: _currentMonth,
      comparedYear: _currentType == BrandOwnerSmartCompareTypeEnum.month
          ? _currentComparedYear
          : null,
      comparedMonth: _currentType == BrandOwnerSmartCompareTypeEnum.month
          ? _currentComparedMonth
          : null,
      type: _currentType,
      branchId: _currentBranchId,
      comparedBranchId: _currentType == BrandOwnerSmartCompareTypeEnum.branch
          ? _currentComparedBranchId
          : null,
    );

    handle(
      result,
      success: (data) {
        _currentYear = data.year;
        _currentMonth = data.month;
        switch (data.type) {
          case BrandOwnerSmartCompareTypeEnum.month:
            _currentComparedYear = data.comparedYear;
            _currentComparedMonth = data.comparedMonth;
            _currentComparedBranchId = null;
          case BrandOwnerSmartCompareTypeEnum.branch:
            _currentComparedYear = null;
            _currentComparedMonth = null;
            _currentComparedBranchId = data.comparedBranchId;
        }
        emit(SmartComparisonSuccess(data: data));
      },
      failure: (failure) => emit(SmartComparisonFailure(failure)),
    );
  }

  void applyFilter({
    int? year,
    int? month,
    int? comparedYear,
    int? comparedMonth,
    BrandOwnerSmartCompareTypeEnum? type,
    required String branchId,
    String? comparedBranchId,
  }) {
    if (year != null) _currentYear = year;
    if (month != null) _currentMonth = month;
    if (type != null) {
      _currentType = type;
      switch (type) {
        case BrandOwnerSmartCompareTypeEnum.month:
          if (comparedYear != null) _currentComparedYear = comparedYear;
          if (comparedMonth != null) _currentComparedMonth = comparedMonth;
          _currentComparedBranchId = null;
        case BrandOwnerSmartCompareTypeEnum.branch:
          _currentComparedYear = null;
          _currentComparedMonth = null;
          _currentComparedBranchId = comparedBranchId;
      }
    } else {
      if (comparedYear != null) _currentComparedYear = comparedYear;
      if (comparedMonth != null) _currentComparedMonth = comparedMonth;
      _currentComparedBranchId = comparedBranchId;
    }
    _currentBranchId = branchId;
    loadSmartComparison();
  }

  void resetFilter() {
    _currentYear = null;
    _currentMonth = null;
    _currentComparedYear = null;
    _currentComparedMonth = null;
    _currentType = BrandOwnerSmartCompareTypeEnum.month;
    _currentBranchId = null;
    _currentComparedBranchId = null;
    loadSmartComparison();
  }
}
