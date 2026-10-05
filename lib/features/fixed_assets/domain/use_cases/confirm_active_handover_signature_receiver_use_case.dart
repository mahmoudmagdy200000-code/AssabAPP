import 'package:injectable/injectable.dart';

import '../../../../core/utils/future_api_result.dart';
import '../../data/repositories/fixed_assets_repository.dart';

@LazySingleton()
class ConfirmActiveHandoverSignatureReceiverUseCase {
  final FixedAssetsRepository _repository;

  ConfirmActiveHandoverSignatureReceiverUseCase(this._repository);

  FutureApiResult<void> call({required String sessionId}) {
    return _repository.confirmActiveHandoverSessionSignatureReceiver(
      sessionId: sessionId,
    );
  }
}
