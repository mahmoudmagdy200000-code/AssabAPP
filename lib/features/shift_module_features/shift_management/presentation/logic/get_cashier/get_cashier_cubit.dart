import 'package:injectable/injectable.dart';

import '../../../../../../core/helpers/safe_cubit.dart';
import '../../../data/mapper/cashier_mapper.dart';
import '../../../data/repository/shift_management_repository_imp.dart';
import 'get_cashier_state.dart';

@injectable
class GetCashierCubit extends SafeCubit<GetCashierState> {
  final ShiftManagementRepositoryImp _shiftManagementRepositoryImp;

  GetCashierCubit(this._shiftManagementRepositoryImp)
    : super(const GetCashierInitial());

  Future<void> getCashiers() async {
    emit(const GetCashierLoading());

    final result = await _shiftManagementRepositoryImp.getCashiers();

    handle(
      result,
      failure: (f) => emit(GetCashierFailure(f)),
      success: (cashiers) => emit(
        GetCashierSuccess(cashiers.data.map((e) => e.toEntity()).toList()),
      ),
    );
  }
}
