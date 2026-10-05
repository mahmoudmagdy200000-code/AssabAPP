import 'package:assab/core/errors/repository_mixin.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:assab/features/supplier_returns/data/data_sources/supplier_returns_remote_data_source.dart';
import 'package:injectable/injectable.dart';

import '../models/supplier_return_goods_details_response.dart';
import '../models/supplier_returns_response.dart';

@LazySingleton()
class SupplierReturnsRepository with RepositoryMixin {
  final SupplierReturnsRemoteDataSource _supplierReturnsRemoteDataSource;

  SupplierReturnsRepository(this._supplierReturnsRemoteDataSource);

  FutureApiResult<SupplierReturnsResponse> getSupplierReturns({
    required int page,
  }) => execute(() async {
    return _supplierReturnsRemoteDataSource.getSupplierReturns(page: page);
  });

  FutureApiResult<SupplierReturnGoodsDetailsResponse> getSupplierReturnDetails({
    required String id,
  }) => execute(() async {
    return _supplierReturnsRemoteDataSource.getSupplierReturnDetails(id: id);
  });

  FutureApiResult<void> rejectSupplierReturn({
    required String id,
    required String reason,
  }) => execute(() async {
    return _supplierReturnsRemoteDataSource.rejectSupplierReturn(
      id: id,
      body: {'reason': reason, 'explanation': 'ss'},
    );
  });

  FutureApiResult<void> approveSupplierReturn({required String id}) =>
      execute(() async {
        return _supplierReturnsRemoteDataSource.approveSupplierReturn(id: id);
      });
}
