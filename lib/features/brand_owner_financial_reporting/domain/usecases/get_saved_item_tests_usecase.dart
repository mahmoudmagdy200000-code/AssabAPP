import 'package:injectable/injectable.dart';

import '../../../../core/utils/api_result.dart';
import '../entities/item_test_saved_test_entity.dart';
import '../repositories/item_test_repository.dart';

@LazySingleton()
class GetSavedItemTestsUseCase {
  final ItemTestRepository _repository;

  GetSavedItemTestsUseCase(this._repository);

  Future<ApiResult<List<ItemTestSavedTestEntity>>> call() {
    return _repository.getSavedTests();
  }
}
