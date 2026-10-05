import '../../../../core/utils/future_api_result.dart';
import '../../data/models/brand_owner_control_panel_model.dart';

abstract class BrandOwnerControlPanelRepository {
  FutureApiResult<BrandOwnerControlPanelModel> getControlPanelData();
}
