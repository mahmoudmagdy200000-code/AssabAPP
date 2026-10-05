import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../domain/use_cases/get_brand_owner_asset_overview_performance_summary_use_case.dart';
import 'brand_owner_asset_overview_performance_summary_state.dart';

@injectable
class BrandOwnerAssetOverviewPerformanceSummaryCubit
    extends SafeCubit<BrandOwnerAssetOverviewPerformanceSummaryState> {
  final GetBrandOwnerAssetOverviewPerformanceSummaryUseCase
  _getPerformanceSummaryUseCase;

  BrandOwnerAssetOverviewPerformanceSummaryCubit(
    this._getPerformanceSummaryUseCase,
  ) : super(const BrandOwnerAssetOverviewPerformanceSummaryInitial());

  Future<void> load() async {
    emit(const BrandOwnerAssetOverviewPerformanceSummaryLoading());

    final result = await _getPerformanceSummaryUseCase();

    handle(
      result,
      success: (summary) =>
          emit(BrandOwnerAssetOverviewPerformanceSummarySuccess(summary)),
      failure: (failure) =>
          emit(BrandOwnerAssetOverviewPerformanceSummaryFailure(failure)),
    );
  }
}
