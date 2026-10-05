import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/receive_assets_respons.dart';
import '../../../data/repositories/fixed_assets_repository.dart';

part 'fixed_assets_get_receive_assets_state.dart';

@injectable
class FixedAssetsGetReceiveAssetsCubit
    extends SafeCubit<FixedAssetsGetReceiveAssetsState> {
  final FixedAssetsRepository _repository;

  FixedAssetsGetReceiveAssetsCubit(this._repository)
    : super(FixedAssetsGetReceiveAssetsInitial());

  Future<void> getReceiveAssets({required String requestId}) async {
    emit(FixedAssetsGetReceiveAssetsLoading());

    final result = await _repository.getReceiveAssets(requestId: requestId);

    handle(
      result,
      success: (data) =>
          emit(FixedAssetsGetReceiveAssetsSuccess(data: data.items)),
      failure: (failure) =>
          emit(FixedAssetsGetReceiveAssetsFailure(failure: failure)),
    );
  }
}
