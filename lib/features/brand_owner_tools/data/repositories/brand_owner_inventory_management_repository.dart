import 'package:assab/core/errors/repository_mixin.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:injectable/injectable.dart';

import '../datasources/brand_owner_inventory_remote_data_source.dart';
import '../models/brand_owner_daily_inventory_details_response.dart';
import '../models/brand_owner_daily_inventory_requests_response.dart';
import '../models/brand_owner_wast_and_damage_details_response.dart';
import '../models/brand_owner_wast_and_damage_requests_response.dart';

@LazySingleton()
class BrandOwnerInventoryManagementRepository with RepositoryMixin {
  final BrandOwnerInventoryRemoteDataSource _remoteDataSource;

  BrandOwnerInventoryManagementRepository(this._remoteDataSource);

  FutureApiResult<BrandOwnerDailyInventoryRequestsResponse>
  getDailyInventoryRequests({int? page}) {
    return execute(() async {
      return _remoteDataSource.getDailyInventoryRequests(page: page);
    });
  }

  FutureApiResult<BrandOwnerWastAndDamageRequestsResponse>
  getWastAndDamageRequests({int? page}) {
    return execute(() async {
      return _remoteDataSource.getWasteDamageRequests(page: page);
    });
  }

  FutureApiResult<BrandOwnerDailyInventoryDetailsResponse>
  getDailyInventoryDetails({required String requestId}) {
    return execute(() async {
      return _remoteDataSource.getDailyInventoryDetails(requestId: requestId);
    });
  }

  FutureApiResult<BrandOwnerWastAndDamageDetailsResponse>
  getWastAndDamageDetails({required String requestId}) {
    return execute(() async {
      return _remoteDataSource.getWasteDamageDetails(requestId: requestId);
    });
  }

  FutureApiResult<void> approveDailyInventoryRequest({
    required String requestId,
  }) {
    return execute(() async {
      return _remoteDataSource.approveDailyInventoryRequest(
        requestId: requestId,
      );
    });
  }

  FutureApiResult<void> rejectDailyInventoryRequest({
    required String requestId,
  }) {
    return execute(() async {
      return _remoteDataSource.rejectDailyInventoryRequest(
        requestId: requestId,
      );
    });
  }

  FutureApiResult<void> approveWastAndDamageRequest({
    required String requestId,
  }) {
    return execute(() async {
      return _remoteDataSource.approveWasteDamageRequest(requestId: requestId);
    });
  }

  FutureApiResult<void> rejectWastAndDamageRequest({
    required String requestId,
  }) {
    return execute(() async {
      return _remoteDataSource.rejectWasteDamageRequest(requestId: requestId);
    });
  }
}
