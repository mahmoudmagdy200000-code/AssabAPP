import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repositories/fixed_assets_repository.dart';
import 'get_requests_details_state.dart';

@injectable
class GetRequestsDetailsCubit extends SafeCubit<GetRequestsDetailsState> {
  final FixedAssetsRepository _repository;

  GetRequestsDetailsCubit(this._repository)
    : super(const GetRequestsDetailsInit());

  Future<void> getModifyDetails({required String requestId}) async {
    emit(const GetRequestsDetailsLoading());
    final result = await _repository.getModifyDetails(requestId: requestId);

    handle(
      result,
      success: (details) =>
          emit(GetRequestsDetailsModificationSuccess(details)),
      failure: (failure) => emit(GetRequestsDetailsFailure(failure)),
    );
  }
}
