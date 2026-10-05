import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repositories/fixed_assets_repository.dart';
import 'fixed_assets_disposals_details_state.dart';

@injectable
class FixedAssetsDisposalsDetailsCubit
    extends SafeCubit<FixedAssetsDisposalsDetailsState> {
  final FixedAssetsRepository _repository;

  FixedAssetsDisposalsDetailsCubit(this._repository)
    : super(const FixedAssetsDisposalsDetailsInitial());

  Future<void> getDisposalsDetails({required String requestId}) async {
    emit(const FixedAssetsDisposalsDetailsLoading());
    final result = await _repository.getDisposalsDetails(requestId: requestId);

    handle(
      result,
      success: (details) => emit(FixedAssetsDisposalsDetailsSuccess(details)),
      failure: (failure) => emit(FixedAssetsDisposalsDetailsFailure(failure)),
    );
  }
}
