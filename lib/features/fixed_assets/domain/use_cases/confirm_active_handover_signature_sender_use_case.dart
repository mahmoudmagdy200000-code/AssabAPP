import 'package:injectable/injectable.dart';

import '../../../../core/utils/future_api_result.dart';
import '../../data/repositories/fixed_assets_repository.dart';

@LazySingleton()
class ConfirmActiveHandoverSignatureSenderUseCase {
  final FixedAssetsRepository _repository;

  ConfirmActiveHandoverSignatureSenderUseCase(this._repository);

  FutureApiResult<void> call({required String sessionId}) {
    return _repository.confirmActiveHandoverSessionSignatureSender(
      sessionId: sessionId,
    );
  }
}
