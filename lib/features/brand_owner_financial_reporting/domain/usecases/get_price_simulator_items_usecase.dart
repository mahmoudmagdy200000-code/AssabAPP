import 'package:injectable/injectable.dart';

import '../../../../core/utils/api_result.dart';
import '../entities/price_simulator_item_entity.dart';
import '../repositories/price_simulator_repository.dart';

@LazySingleton()
class GetPriceSimulatorItemsUseCase {
  final PriceSimulatorRepository _repository;

  GetPriceSimulatorItemsUseCase(this._repository);

  Future<ApiResult<List<PriceSimulatorItemEntity>>> call() {
    return _repository.getItems();
  }
}
