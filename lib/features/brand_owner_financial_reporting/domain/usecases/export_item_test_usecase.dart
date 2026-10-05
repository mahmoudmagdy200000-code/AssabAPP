import 'package:injectable/injectable.dart';

import '../../../../core/utils/api_result.dart';
import '../repositories/item_test_repository.dart';

@LazySingleton()
class ExportItemTestUseCase {
  final ItemTestRepository _repository;

  ExportItemTestUseCase(this._repository);

  Future<ApiResult<String>> call({
    required String testId,
    required String formatType,
  }) {
    return _repository.exportTest(
      testId: testId,
      formatType: formatType,
    );
  }
}
