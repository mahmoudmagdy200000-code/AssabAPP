import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/custody_create_request_transfer_request_model.dart';
import '../../../data/models/custody_request_cash_in_request_model.dart';
import '../../../data/models/custody_reuse_past_request_request_model.dart';
import '../../../data/repository/custody_repository.dart';
import 'custody_create_request_state.dart';

@injectable
class CustodyCreateRequestCubit extends SafeCubit<CustodyCreateRequestState> {
  final CustodyRepository _custodyRepository;

  CustodyCreateRequestCubit(this._custodyRepository)
    : super(const CustodyCreateRequestInit());

  void createCashInRequest({
    required CustodyRequestCashInRequestModel requestModel,
  }) async {
    emit(const CustodyCreateRequestLoading());

    final result = await _custodyRepository.requestCashIn(
      requestModel: requestModel,
    );

    handle(
      result,
      failure: (failure) => emit(CustodyCreateRequestFailure(failure)),
      success: (_) => emit(const CustodyCreateRequestSuccess()),
    );
  }

  void createReusePastRequest({
    required CustodyReusePastRequestRequestModel requestModel,
  }) async {
    emit(const CustodyCreateRequestLoading());

    final result = await _custodyRepository.reusePastRequestCashIn(
      requestModel: requestModel,
    );

    handle(
      result,
      failure: (failure) => emit(CustodyCreateReusePastRequestFailure(failure)),
      success: (_) => emit(const CustodyCreateRequestSuccess()),
    );
  }

  void createTransferRequest({
    required CustodyCreateRequestTransferRequestModel requestModel,
  }) async {
    emit(const CustodyCreateRequestLoading());

    final result = await _custodyRepository.requestTransfer(
      requestModel: requestModel,
    );

    handle(
      result,
      failure: (failure) => emit(CustodyCreateRequestFailure(failure)),
      success: (_) => emit(const CustodyCreateRequestSuccess()),
    );
  }
}
