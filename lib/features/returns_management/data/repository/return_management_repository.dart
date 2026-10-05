import 'package:assab/core/errors/repository_mixin.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:assab/features/returns_management/data/data_sources/return_management_remote_data_source.dart';
import 'package:injectable/injectable.dart';

import '../models/create_return_request.dart';
import '../models/return_goods_details_response.dart';
import '../models/return_goods_response.dart';

@LazySingleton()
class ReturnManagementRepository with RepositoryMixin {
  final ReturnManagementRemoteDataSource _returnManagementRemoteDataSource;

  ReturnManagementRepository(this._returnManagementRemoteDataSource);

  FutureApiResult<void> createReturnRequest({
    required CreateReturnRequest body,
  }) => execute(() async {
    return _returnManagementRemoteDataSource.createReturnRequest(
      body: body.toFormData(),
    );
  });

  FutureApiResult<void> acceptReturnRejection({required String id}) => execute(
    () async => _returnManagementRemoteDataSource.acceptReturnRejection(id: id),
  );

  FutureApiResult<void> escalateReturn({
    required String id,
    required String reason,
  }) => execute(() async {
    return _returnManagementRemoteDataSource.escalateReturn(
      id: id,
      body: {'reason': reason},
    );
  });

  FutureApiResult<ReturnGoodsResponse> getInprogressReturns() => execute(
    () async => _returnManagementRemoteDataSource.getInpogressReturns(),
  );

  FutureApiResult<ReturnGoodsResponse> getCompletedReturns() => execute(
    () async => _returnManagementRemoteDataSource.getCompletedReturns(),
  );

  FutureApiResult<ReturnGoodsDetailsResponse> getReturnDetails({
    required String id,
  }) => execute(() async {
    return _returnManagementRemoteDataSource.getReturnDetials(id: id);
  });
}
