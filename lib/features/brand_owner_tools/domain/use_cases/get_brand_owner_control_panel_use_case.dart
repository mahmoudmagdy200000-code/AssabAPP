import 'package:injectable/injectable.dart';

import '../../../../core/utils/future_api_result.dart';
import '../../data/models/brand_owner_control_panel_model.dart';
import '../repositories/brand_owner_control_panel_repository.dart';

@LazySingleton()
class GetBrandOwnerControlPanelUseCase {
  final BrandOwnerControlPanelRepository _repository;

  GetBrandOwnerControlPanelUseCase(this._repository);

  FutureApiResult<BrandOwnerControlPanelModel> call() {
    return _repository.getControlPanelData();
  }
}
