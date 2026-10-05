import 'package:injectable/injectable.dart';

import '../../../../core/utils/api_result.dart';
import '../repositories/item_test_repository.dart';

@LazySingleton()
class EmailItemTestUseCase {
  final ItemTestRepository _repository;

  EmailItemTestUseCase(this._repository);

  Future<ApiResult<void>> call({
    required String testId,
    required String email,
  }) {
    return _repository.emailTest(
      testId: testId,
      email: email,
    );
  }
}
