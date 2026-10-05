import 'package:injectable/injectable.dart';

import '../../../../core/utils/api_result.dart';
import '../entities/price_simulator_item_info_entity.dart';
import '../repositories/price_simulator_repository.dart';

@LazySingleton()
class GetPriceSimulatorItemInfoUseCase {
  final PriceSimulatorRepository _repository;

  GetPriceSimulatorItemInfoUseCase(this._repository);

  Future<ApiResult<PriceSimulatorItemInfoEntity>> call({
    required String branchId,
    required String itemId,
  }) {
    return _repository.getItemInfo(branchId: branchId, itemId: itemId);
  }
}
