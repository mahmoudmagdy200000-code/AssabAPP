import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/brand_owner_home_repository.dart';
import 'brand_owner_home_state.dart';

@injectable
class BrandOwnerHomeCubit extends SafeCubit<BrandOwnerHomeState> {
  final BrandOwnerHomeRepository _repository;

  BrandOwnerHomeCubit(this._repository)
    : super(const BrandOwnerHomeInitial());

  Future<void> loadDashboard({
    String? branchId,
    int? month,
    int? year,
    String? granularity,
  }) async {
    emit(const BrandOwnerHomeLoading());

    final result = await _repository.getBrandOwnerHomeDashboard(
      branchId: branchId,
      month: month,
      year: year,
      granularity: granularity,
    );

    handle(
      result,
      success: (data) => emit(BrandOwnerHomeSuccess(data)),
      failure: (failure) => emit(BrandOwnerHomeFailure(failure)),
    );
  }
}
