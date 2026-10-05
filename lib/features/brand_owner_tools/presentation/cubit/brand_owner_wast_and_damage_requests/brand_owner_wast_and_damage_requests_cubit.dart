import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/paginator.dart';
import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/brand_owner_wast_and_damage_requests_response.dart';
import '../../../domain/use_cases/get_brand_owner_wast_and_damage_requests_use_case.dart';
import 'brand_owner_wast_and_damage_requests_state.dart';

@injectable
class BrandOwnerWastAndDamageRequestsCubit
    extends SafeCubit<BrandOwnerWastAndDamageRequestsState> {
  final GetBrandOwnerWastAndDamageRequestsUseCase
  _getBrandOwnerWastAndDamageRequestsUseCase;

  late final Paginator<
    BrandOwnerWastAndDamageRequest,
    BrandOwnerWastAndDamageRequestsResponse
  >
  paginator;

  BrandOwnerWastAndDamageRequestsCubit(
    this._getBrandOwnerWastAndDamageRequestsUseCase,
  ) : super(const BrandOwnerWastAndDamageRequestsInitial()) {
    paginator =
        Paginator<
          BrandOwnerWastAndDamageRequest,
          BrandOwnerWastAndDamageRequestsResponse
        >(
          fetchPage: (page) => _getBrandOwnerWastAndDamageRequestsUseCase(page),
          extractData: (response) => response.data,
          extractMeta: (response) => MetaInfo(
            currentPage: response.meta.currentPage,
            lastPage: response.meta.lastPage,
            total: response.meta.total,
          ),
        );
  }

  Future<void> load({bool loadMore = false}) async {
    if (!loadMore) {
      paginator.reset();
      emit(const BrandOwnerWastAndDamageRequestsLoading());
    }

    final result = await paginator.loadNextPage();

    handle(
      result,
      failure: (failure) =>
          emit(BrandOwnerWastAndDamageRequestsFailure(failure)),
      success: (response) =>
          emit(BrandOwnerWastAndDamageRequestsSuccess(response)),
    );
  }
}
