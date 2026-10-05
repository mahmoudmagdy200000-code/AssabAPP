import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../domain/use_cases/get_brand_owner_asset_overview_use_case.dart';
import 'brand_owner_asset_overview_state.dart';

@injectable
class BrandOwnerAssetOverviewCubit
    extends SafeCubit<BrandOwnerAssetOverviewState> {
  final GetBrandOwnerAssetOverviewUseCase _getOverviewUseCase;

  BrandOwnerAssetOverviewCubit(this._getOverviewUseCase)
    : super(const BrandOwnerAssetOverviewInitial());

  Future<void> load() async {
    emit(const BrandOwnerAssetOverviewLoading());

    final result = await _getOverviewUseCase();

    handle(
      result,
      success: (overview) =>
          emit(BrandOwnerAssetOverviewSuccess(overview)),
      failure: (failure) =>
          emit(BrandOwnerAssetOverviewFailure(failure)),
    );
  }
}
