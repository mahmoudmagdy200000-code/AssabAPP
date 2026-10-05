import 'package:assab/features/inventory/data/repository/inventory_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import 'get_inventory_employee_state.dart';

@injectable
class GetInventoryEmployeeCubit extends SafeCubit<GetInventoryEmployeeState> {
  final InventoryRepository _inventoryRepository;

  GetInventoryEmployeeCubit(this._inventoryRepository)
    : super(const GetInventoryEmployeeInit());

  void getInventoryEmployees() async {
    emit(const GetInventoryEmployeeLoading());

    final result = await _inventoryRepository.getInventoryEmployees();

    handle(
      result,
      failure: (error) {
        emit(GetInventoryEmployeeFailure(error));
      },
      success: (data) {
        emit(GetInventoryEmployeeSuccess(data.data));
      },
    );
  }
}
