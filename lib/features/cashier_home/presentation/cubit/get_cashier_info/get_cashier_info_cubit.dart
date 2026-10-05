import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/cashier_home_repository.dart';
import 'get_cashier_info_state.dart';

@injectable
class GetCashierInfoCubit extends SafeCubit<GetCashierInfoState> {
  final CashierHomeRepository _repository;

  GetCashierInfoCubit(this._repository) : super(const GetCashierInfoInit());

  Future<void> getCashierInfo() async {
    emit(const GetCashierInfoLoading());

    final result = await _repository.getCashierInfo();

    handle(
      result,
      failure: (failure) => emit(GetCashierInfoFailure(failure: failure)),
      success: (response) => emit(GetCashierInfoSuccess(response: response)),
    );
  }
}
