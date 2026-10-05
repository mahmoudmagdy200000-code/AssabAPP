import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/receive_assets_request.dart';
import '../../../data/repositories/fixed_assets_repository.dart';

part 'fixed_assets_receive_assets_state.dart';

@injectable
class FixedAssetsReceiveAssetsCubit
    extends SafeCubit<FixedAssetsReceiveAssetsState> {
  final FixedAssetsRepository _repository;

  FixedAssetsReceiveAssetsCubit(this._repository)
    : super(FixedAssetsReceiveAssetsInitial());

  Future<void> receiveAssets({required ReceiveAssetsRequest request}) async {
    emit(FixedAssetsReceiveAssetsLoading());

    final result = await _repository.receiveAssets(request: request);

    handle(
      result,
      success: (data) => emit(const FixedAssetsReceiveAssetsSuccess()),
      failure: (failure) =>
          emit(FixedAssetsReceiveAssetsFailure(failure: failure)),
    );
  }
}
