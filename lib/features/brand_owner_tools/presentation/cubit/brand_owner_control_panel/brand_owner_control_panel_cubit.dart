import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../domain/use_cases/get_brand_owner_control_panel_use_case.dart';
import 'brand_owner_control_panel_state.dart';

@injectable
class BrandOwnerControlPanelCubit
    extends SafeCubit<BrandOwnerControlPanelState> {
  final GetBrandOwnerControlPanelUseCase _getControlPanelUseCase;

  BrandOwnerControlPanelCubit(this._getControlPanelUseCase)
    : super(const BrandOwnerControlPanelInitial());

  Future<void> load() async {
    emit(const BrandOwnerControlPanelLoading());

    final result = await _getControlPanelUseCase();

    handle(
      result,
      success: (data) => emit(BrandOwnerControlPanelSuccess(data)),
      failure: (failure) => emit(BrandOwnerControlPanelFailure(failure)),
    );
  }
}
