import 'package:assab/core/errors/repository_mixin.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/brand_owner_control_panel_repository.dart';
import '../datasources/brand_owner_asset_overview_remote_data_source.dart';
import '../models/brand_owner_control_panel_model.dart';

@LazySingleton(as: BrandOwnerControlPanelRepository)
class BrandOwnerControlPanelRepositoryImpl
    with RepositoryMixin
    implements BrandOwnerControlPanelRepository {
  final BrandOwnerAssetOverviewRemoteDataSource _dataSource;

  BrandOwnerControlPanelRepositoryImpl(this._dataSource);

  @override
  FutureApiResult<BrandOwnerControlPanelModel> getControlPanelData() {
    return execute(() => _dataSource.getControlPanelData());
  }
}
