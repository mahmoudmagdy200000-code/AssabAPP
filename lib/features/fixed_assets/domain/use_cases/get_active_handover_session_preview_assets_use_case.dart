import 'package:injectable/injectable.dart';

import '../../../../core/utils/future_api_result.dart';
import '../../data/models/fixed_assets_active_handover_session_preview_response.dart';
import '../../data/repositories/fixed_assets_repository.dart';

@LazySingleton()
class GetActiveHandoverSessionPreviewAssetsUseCase {
  final FixedAssetsRepository _repository;

  GetActiveHandoverSessionPreviewAssetsUseCase(this._repository);

  FutureApiResult<FixedAssetsActiveHandoverSessionPreviewResponse> call({
    required String sessionId,
  }) {
    return _repository.getActiveHandoverSessionPreview(sessionId: sessionId);
  }
}
