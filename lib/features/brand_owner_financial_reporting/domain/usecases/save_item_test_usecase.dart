import 'package:injectable/injectable.dart';

import '../../../../core/utils/api_result.dart';
import '../entities/item_test_result_entity.dart';
import '../repositories/item_test_repository.dart';

@LazySingleton()
class SaveItemTestUseCase {
  final ItemTestRepository _repository;

  SaveItemTestUseCase(this._repository);

  Future<ApiResult<void>> call(ItemTestResultEntity result) {
    return _repository.saveTest(result);
  }
}
