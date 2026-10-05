import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/create_wast_and_damage_request.dart';
import '../../../data/repository/inventory_repository.dart';
import 'create_waste_damage_state.dart';

@injectable
class CreateWasteDamageCubit extends SafeCubit<CreateWasteDamageState> {
  final InventoryRepository _inventoryRepository;

  CreateWasteDamageCubit(this._inventoryRepository)
    : super(const CreateWasteDamageInit());

  Future<void> createWasteDamageReport({
    required CreateWastAndDamageRequest request,
  }) async {
    emit(const CreateWasteDamageLoading());

    final result = await _inventoryRepository.createWasteDamageReport(
      request: request,
    );

    handle(
      result,
      failure: (failure) => emit(CreateWasteDamageFailure(failure)),
      success: (_) => emit(const CreateWasteDamageSuccess()),
    );
  }
}
