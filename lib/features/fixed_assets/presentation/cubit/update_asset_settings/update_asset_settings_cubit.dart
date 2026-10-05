import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/fixed_assets_search_setting_request.dart';
import '../../../data/repositories/fixed_assets_repository.dart';
import 'update_asset_settings_state.dart';

@injectable
class UpdateAssetSettingsCubit extends SafeCubit<UpdateAssetSettingsState> {
  final FixedAssetsRepository _repository;

  UpdateAssetSettingsCubit(this._repository)
    : super(const UpdateAssetSettingsInit());

  Future<void> updateAssetSettings({
    required FixedAssetsSearchSettingRequest request,
  }) async {
    emit(const UpdateAssetSettingsLoading());

    final result = await _repository.updateAssetSettings(request: request);

    handle(
      result,
      success: (_) => emit(const UpdateAssetSettingsSuccess()),
      failure: (failure) => emit(UpdateAssetSettingsFailure(failure)),
    );
  }
}
