import 'package:injectable/injectable.dart';

import '../../../../core/helpers/safe_cubit.dart';
import '../../domain/usecases/get_menu_engineering_usecase.dart';
import 'menu_engineering_state.dart';

@injectable
class MenuEngineeringCubit extends SafeCubit<MenuEngineeringState> {
  final GetMenuEngineeringUseCase _getUseCase;

  int? _currentYear;
  int? _currentMonth;
  int? _currentComparedYear;
  int? _currentComparedMonth;
  String? _currentBranchId;

  MenuEngineeringCubit(this._getUseCase)
    : super(const MenuEngineeringInitial());

  int? get currentYear => _currentYear;
  int? get currentMonth => _currentMonth;
  int? get currentComparedYear => _currentComparedYear;
  int? get currentComparedMonth => _currentComparedMonth;
  String? get currentBranchId => _currentBranchId;

  Future<void> loadMenuEngineering() async {
    emit(const MenuEngineeringLoading());
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
        _currentBranchId = data.branchId;
        emit(MenuEngineeringSuccess(data: data));
      },
      failure: (failure) => emit(MenuEngineeringFailure(failure)),
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
    loadMenuEngineering();
  }

  void resetFilter() {
    _currentYear = null;
    _currentMonth = null;
    _currentComparedYear = null;
    _currentComparedMonth = null;
    _currentBranchId = null;
    loadMenuEngineering();
  }
}
