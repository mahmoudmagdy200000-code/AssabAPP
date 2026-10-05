import 'package:assab/core/errors/repository_mixin.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:injectable/injectable.dart';

import '../data_source/brand_owner_requests_remote_data_source.dart';

import '../models/brand_owner_requests_models.dart';

@LazySingleton()
class BrandOwnerRequestsRepository with RepositoryMixin {
  final BrandOwnerRequestsRemoteDataSource _remote;

  BrandOwnerRequestsRepository(this._remote);

  FutureApiResult<BrandOwnerRequestsCustodySalesTransfersResponse>
  getBrandOwnerRequestsCustodySalesTransfersView({required int page}) async {
    return execute(() async {
      return _remote.getCashSalesTransfers(page: page);
    });
  }

  FutureApiResult<BrandOwnerSalesTransferDetailsModel>
  getBrandOwnerSalesTransferDetailsScreen({required String requestId}) async {
    return execute(() async {
      return _remote.getCashSalesTransferDetails(transferId: requestId);
    });
  }

  FutureApiResult<BrandOwnerPaymentLogResponse> getBrandOwnerPaymentLogScreen({
    String? type,
    String? sortByDate,
    String? branchId,
    int? page,
  }) async {
    return execute(() async {
      return _remote.getPaymentLogs(
        type: type,
        sortByDate: sortByDate,
        branchId: branchId,
        page: page,
      );
    });
  }

  FutureApiResult<BrandOwnerPaymentLogDetailsModel>
  getBrandOwnerPaymentLogDetailsScreen({required String paymentLogId}) async {
    return execute(() async {
      return _remote.getPaymentLogDetails(id: paymentLogId);
    });
  }

  FutureApiResult<BrandOwnerPaymentLogBranchModel>
  getBrandOwnerPaymentLogBranches() async {
    return execute(() async {
      return await _remote.getBranches();
    });
  }

  FutureApiResult<void> approveExpense({required String expenseId}) async {
    return execute(() async {
      return _remote.approveBrandOwnerExpense(id: expenseId);
    });
  }

  FutureApiResult<void> rejectExpense({
    required String expenseId,
    required String reason,
  }) async {
    return execute(() async {
      return _remote.rejectBrandOwnerExpense(
        id: expenseId,
        reason: {'reason': reason},
      );
    });
  }

  FutureApiResult<void> approveCustodyRequest({
    required String requestId,
  }) async {
    return execute(() async {
      return _remote.approveBrandOwnerCustodyRequest(id: requestId);
    });
  }

  FutureApiResult<void> rejectCustodyRequest({
    required String requestId,
    required String reason,
  }) async {
    return execute(() async {
      return _remote.rejectBrandOwnerCustodyRequest(
        id: requestId,
        reason: {'reason': reason},
      );
    });
  }

  FutureApiResult<void> approveSalesTransfer({
    required String salesTransferId,
  }) async {
    return execute(() async {
      return _remote.approveBrandOwnerCashSalesTransfer(id: salesTransferId);
    });
  }

  FutureApiResult<void> rejectSalesTransfer({
    required String salesTransferId,
    required String reason,
  }) async {
    return execute(() async {
      return _remote.rejectBrandOwnerCashSalesTransfer(
        id: salesTransferId,
        reason: {'reason': reason},
      );
    });
  }
}
