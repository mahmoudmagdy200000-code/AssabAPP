import 'package:assab/core/errors/api_failure.dart';

import '../../../data/models/brand_owner_control_panel_model.dart';

sealed class BrandOwnerControlPanelState {
  const BrandOwnerControlPanelState();
}

final class BrandOwnerControlPanelInitial extends BrandOwnerControlPanelState {
  const BrandOwnerControlPanelInitial();
}

final class BrandOwnerControlPanelLoading extends BrandOwnerControlPanelState {
  const BrandOwnerControlPanelLoading();
}

final class BrandOwnerControlPanelSuccess extends BrandOwnerControlPanelState {
  final BrandOwnerControlPanelModel data;

  const BrandOwnerControlPanelSuccess(this.data);
}

final class BrandOwnerControlPanelFailure extends BrandOwnerControlPanelState {
  final ApiFailure failure;

  const BrandOwnerControlPanelFailure(this.failure);
}
