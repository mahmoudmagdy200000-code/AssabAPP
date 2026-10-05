import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/inventory_repository.dart';
import 'get_monthly_details_state.dart';

@injectable
class GetMonthlyDetailsCubit extends SafeCubit<GetMonthlyDetailsState> {
  final InventoryRepository _inventoryRepository;

  GetMonthlyDetailsCubit(this._inventoryRepository)
    : super(const GetMonthlyDetailsInit());

  Future<void> getMonthlyDetails({required String id}) async {
    emit(const GetMonthlyDetailsLoading());

    final result = await _inventoryRepository.getMonthlyInventoryDetails(
      inventoryId: id,
    );

    handle(
      result,
      failure: (failure) => emit(GetMonthlyDetailsFailure(failure)),
      success: (response) => emit(GetMonthlyDetailsSuccess(response)),
    );
  }
}
