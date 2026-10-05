import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/fixed_assets_modify_request.dart';
import '../../../data/repositories/fixed_assets_repository.dart';
import 'modify_asset_state.dart';

@injectable
class ModifyAssetCubit extends SafeCubit<ModifyAssetState> {
  final FixedAssetsRepository _repository;

  ModifyAssetCubit(this._repository) : super(const ModifyAssetInit());

  Future<void> modifyAssetStatus({
    required FixedAssetsModifyRequest request,
  }) async {
    emit(const ModifyAssetLoading());

    final result = await _repository.modifyAssetStatus(request: request);

    handle(
      result,
      success: (data) => emit(const ModifyAssetSuccess()),
      failure: (failure) => emit(ModifyAssetFailure(failure)),
    );
  }
}
