import 'package:assab/core/errors/repository_mixin.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:injectable/injectable.dart';

import '../datasource/brand_owner_home_remote_data_source.dart';
import '../models/brand_owner_branch_model.dart';
import '../models/brand_owner_home_data_model.dart';
import '../models/brand_owner_payment_request.dart';

@LazySingleton()
class BrandOwnerHomeRepository with RepositoryMixin {
  final BrandOwnerHomeRemoteDataSource _remote;

  BrandOwnerHomeRepository(this._remote);

  FutureApiResult<List<BrandOwnerBranchItemDashboard>>
  getBrandOwnerBranches() async {
    return execute(() async {
      final response = await _remote.getBrandOwnerBranches();

      return response.branches;
    });
  }

  FutureApiResult<BrandOwnerHomeDataModel> getBrandOwnerHomeDashboard({
    String? branchId,
    int? month,
    int? year,
    String? granularity,
  }) async {
    return execute(() async {
      return await _remote.getBrandOwnerHomeDashboard(
        branchId: branchId,
        month: month,
        year: year,
        granularity: granularity,
      );
    });
  }

  FutureApiResult<void> submitOwnerPaymentForm({
    required BrandOwnerPaymentRequest body,
  }) async {
    return execute(() async {
      await _remote.submitOwnerPaymentForm(body: body.toFormData());
    });
  }

  FutureApiResult<void> approveReturnEscalation({
    required String returnId,
  }) async {
    return execute(() async {
      await _remote.approveReturnEscalation(returnId: returnId);
    });
  }

  FutureApiResult<void> rejectReturnEscalation({
    required String returnId,
  }) async {
    return execute(() async {
      await _remote.rejectReturnEscalation(returnId: returnId);
    });
  }
}
