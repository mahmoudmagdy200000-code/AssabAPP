import 'package:assab/features/branch_manager_requests/data/repository/requests_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import 'branch_get_modification_state.dart';

@injectable
class BranchGetModificationCubit extends SafeCubit<BranchGetModificationState> {
  final RequestsRepository _requestsRepository;

  BranchGetModificationCubit(this._requestsRepository)
    : super(const BranchGetModificationInit());

  void getBranchModification({
    required String orderId,
    required String itemId,
  }) async {
    emit(const BranchGetModificationLoading());

    final result = await _requestsRepository.getModification(
      orderId: orderId,
      itemId: itemId,
    );

    handle(
      result,
      success: (data) {
        emit(BranchGetModificationSuccess(data));
      },
      failure: (failure) {
        emit(BranchGetModificationFailure(failure));
      },
    );
  }
}
