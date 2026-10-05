import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/custody_repository.dart';
import 'get_custody_details_state.dart';

@injectable
class GetCustodyDetailsCubit extends SafeCubit<GetCustodyDetailsState> {
  final CustodyRepository _custodyRepository;

  GetCustodyDetailsCubit(this._custodyRepository)
    : super(const GetCustodyDetailsInit());

  Future<void> getRequestDetails({required String requestId}) async {
    emit(const GetCustodyDetailsLoading());

    final result = await _custodyRepository.getRequestDetails(id: requestId);

    handle(
      result,
      failure: (failure) => emit(GetCustodyDetailsFailure(failure)),
      success: (details) => emit(GetCustodyRequestDetailsSuccess(details)),
    );
  }
}
