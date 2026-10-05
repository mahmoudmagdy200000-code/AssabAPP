import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/inventory_repository.dart';
import 'get_monthly_setup_info_state.dart';

@injectable
class GetMonthlySetupInfoCubit extends SafeCubit<GetMonthlySetupInfoState> {
  final InventoryRepository _inventoryRepository;

  GetMonthlySetupInfoCubit(this._inventoryRepository)
    : super(const GetMonthlySetupInfoInit());

  Future<void> getMonthlySetupInfo() async {
    emit(const GetMonthlySetupInfoLoading());

    final result = await _inventoryRepository.getMonthlySetupInfo();

    handle(
      result,
      success: (response) => emit(GetMonthlySetupInfoSuccess(response.data)),
      failure: (failure) => emit(GetMonthlySetupInfoFailure(failure)),
    );
  }
}
