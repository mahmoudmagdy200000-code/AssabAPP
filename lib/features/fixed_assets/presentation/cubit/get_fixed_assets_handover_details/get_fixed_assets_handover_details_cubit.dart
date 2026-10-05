import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repositories/fixed_assets_repository.dart';
import 'get_fixed_assets_handover_details_state.dart';

@injectable
class GetFixedAssetsHandoverDetailsCubit
    extends SafeCubit<GetFixedAssetsHandoverDetailsState> {
  final FixedAssetsRepository _repository;

  GetFixedAssetsHandoverDetailsCubit(this._repository)
    : super(const GetFixedAssetsHandoverDetailsInit());

  Future<void> getHandoverDetails({
    required String handoverId,
    bool loading = true,
  }) async {
    if (loading) {
      emit(const GetFixedAssetsHandoverDetailsLoading());
    }

    final result = await _repository.getHandoverDetails(handoverId: handoverId);

    handle(
      result,
      success: (data) {
        emit(GetFixedAssetsHandoverDetailsSuccess(data));
      },
      failure: (failure) => emit(GetFixedAssetsHandoverDetailsFailure(failure)),
    );
  }
}
