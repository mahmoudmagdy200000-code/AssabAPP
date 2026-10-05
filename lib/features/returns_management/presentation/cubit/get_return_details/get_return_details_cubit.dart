import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/return_management_repository.dart';
import 'get_return_details_state.dart';

@injectable
class GetReturnDetailsCubit extends SafeCubit<GetReturnDetailsState> {
  final ReturnManagementRepository _returnManagementRepository;

  GetReturnDetailsCubit(this._returnManagementRepository)
    : super(const GetReturnDetailsInit());

  Future<void> getReturnDetails({required String id}) async {
    emit(const GetReturnDetailsLoading());

    final result = await _returnManagementRepository.getReturnDetails(id: id);

    handle(
      result,
      success: (data) {
        emit(GetReturnDetailsSuccess(data));
      },
      failure: (failure) {
        emit(GetReturnDetailsFailure(failure));
      },
    );
  }
}
