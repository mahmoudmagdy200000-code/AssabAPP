import 'package:injectable/injectable.dart';

import '../../../../core/helpers/safe_cubit.dart';
import '../../domain/usecases/get_brand_owner_reports_and_analytics_usecase.dart';
import 'brand_owner_reports_and_analytics_state.dart';

@injectable
class BrandOwnerReportsAndAnalyticsCubit
    extends SafeCubit<BrandOwnerReportsAndAnalyticsState> {
  final GetBrandOwnerReportsAndAnalyticsUseCase _useCase;

  BrandOwnerReportsAndAnalyticsCubit(this._useCase)
    : super(const BrandOwnerReportsAndAnalyticsInitial());

  Future<void> loadReportsAndAnalytics() async {
    emit(const BrandOwnerReportsAndAnalyticsLoading());

    final result = await _useCase();

    handle(
      result,
      success: (data) => emit(BrandOwnerReportsAndAnalyticsSuccess(data)),
      failure: (failure) => emit(BrandOwnerReportsAndAnalyticsFailure(failure)),
    );
  }
}
