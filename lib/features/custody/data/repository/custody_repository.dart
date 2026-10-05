import 'package:assab/core/errors/repository_mixin.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:assab/features/custody/data/data_sources/custody_remote_data_source.dart';
import 'package:injectable/injectable.dart';

import '../models/branch_custody_transactions_response.dart';
import '../models/custody_branch_balance_response.dart';
import '../models/custody_create_request_transfer_request_model.dart';
import '../models/custody_get_past_requests_response.dart';
import '../models/custody_handover_to_cashier_request.dart';
import '../models/custody_personal_balance_only_response.dart';
import '../models/custody_personal_balance_response.dart';
import '../models/custody_recipients_response.dart';
import '../models/custody_request_cash_in_request_model.dart';
import '../models/custody_request_details_response.dart';
import '../models/custody_requests_response.dart';
import '../models/custody_reuse_past_request_request_model.dart';
import '../models/custody_trend_balance_state_response.dart';
import '../models/personal_custody_transactions_response.dart';

@LazySingleton()
class CustodyRepository with RepositoryMixin {
  final CustodyRemoteDataSource _custodyRemoteDataSource;

  CustodyRepository(this._custodyRemoteDataSource);

  FutureApiResult<void> requestCashIn({
    required CustodyRequestCashInRequestModel requestModel,
  }) => execute(() async {
    return _custodyRemoteDataSource.requestCashIn(requestModel.toFormData());
  });

  FutureApiResult<void> reusePastRequestCashIn({
    required CustodyReusePastRequestRequestModel requestModel,
  }) => execute(() async {
    return _custodyRemoteDataSource.reusePastRequestCashIn(
      requestModel.toFormData(),
    );
  });

  FutureApiResult<void> requestTransfer({
    required CustodyCreateRequestTransferRequestModel requestModel,
  }) => execute(() async {
    return _custodyRemoteDataSource.requestTransfer(requestModel);
  });

  FutureApiResult<CustodyRequestsResponse> getRequests({
    required String? status,
    required String? timePeriod,
  }) => execute(() async {
    return _custodyRemoteDataSource.getRequests(
      status: status,
      timePeriod: timePeriod,
    );
  });

  FutureApiResult<CustodyGetPastRequestsResponse> getPastRequests() =>
      execute(() async => _custodyRemoteDataSource.getPastRequests());

  FutureApiResult<CustodyPersonalBalanceOnlyResponse>
  getPersonalBalanceOnly() =>
      execute(() async => _custodyRemoteDataSource.getPersonalBalanceOnly());

  FutureApiResult<CustodyPersonalBalanceResponse> getPersonalBalance({
    required String? month,
    required String? year,
  }) => execute(() async {
    return _custodyRemoteDataSource.getPersonalBalance(
      month: month,
      year: year,
    );
  });

  FutureApiResult<PersonalCustodyTransactionsResponse>
  getPersonalBalanceTransactions({
    required String? month,
    required String? year,
  }) => execute(() async {
    return _custodyRemoteDataSource.getPersonalBalanceTransactions(
      month: month,
      year: year,
    );
  });

  FutureApiResult<String> getPersonalBalanceTransactionsExportPdf({
    required String? timePeriod,
    required String? type,
  }) => execute(() async {
    final response = await _custodyRemoteDataSource
        .getPersonalBalanceTransactionsExportPdf(
          timePeriod: timePeriod,
          type: type,
        );
    return response.fileUrl;
  });

  FutureApiResult<BranchCustodyTransactionsResponse> getBranchTransactions({
    required String? status,
    required String? timePeriod,
  }) => execute(() async {
    return _custodyRemoteDataSource.getBranchTransactions(
      status: status,
      timePeriod: timePeriod,
    );
  });

  FutureApiResult<CustodyBranchBalanceResponse> getBranchBalance() =>
      execute(() async => _custodyRemoteDataSource.getBranchBalance());

  FutureApiResult<void> handoverToCashier({
    required CustodyHandoverToCashierRequest body,
  }) => execute(() async {
    return _custodyRemoteDataSource.handoverToCashier(body: body);
  });

  FutureApiResult<CustodyRecipientsResponse> getRecipients() =>
      execute(() async => _custodyRemoteDataSource.getRecipients());

  FutureApiResult<CustodyTrendBalanceStateResponse> getTrendBalanceState({
    required String? month,
    required String? year,
    required String? custodyType,
    required String? granularity,
  }) => execute(() async {
    return _custodyRemoteDataSource.getTrendBalanceState(
      month: month,
      year: year,
      custodyType: custodyType,
      granularity: granularity,
    );
  });

  FutureApiResult<CustodyRequestDetailsResponse> getRequestDetails({
    required String id,
  }) => execute(() async {
    return _custodyRemoteDataSource.getRequestDetails(id: id);
  });
}
