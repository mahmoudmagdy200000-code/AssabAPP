import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repositories/fixed_assets_repository.dart';
import 'fixed_assets_transfer_details_state.dart';

@injectable
class FixedAssetsTransferDetailsCubit
    extends SafeCubit<FixedAssetsTransferDetailsState> {
  final FixedAssetsRepository _repository;

  FixedAssetsTransferDetailsCubit(this._repository)
    : super(const FixedAssetsTransferDetailsInitial());

  Future<void> getTransferDetails({required String requestId}) async {
    emit(const FixedAssetsTransferDetailsLoading());
    final result = await _repository.getTransferDetails(requestId: requestId);

    handle(
      result,
      success: (details) => emit(FixedAssetsTransferDetailsSuccess(details)),
      failure: (failure) => emit(FixedAssetsTransferDetailsFailure(failure)),
    );
  }
}
