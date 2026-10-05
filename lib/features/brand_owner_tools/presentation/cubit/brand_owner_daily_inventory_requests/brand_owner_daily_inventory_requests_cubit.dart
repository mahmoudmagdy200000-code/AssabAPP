import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/paginator.dart';
import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/brand_owner_daily_inventory_requests_response.dart';
import '../../../domain/use_cases/get_brand_owner_daily_inventory_requests_use_case.dart';
import 'brand_owner_daily_inventory_requests_state.dart';

@injectable
class BrandOwnerDailyInventoryRequestsCubit
    extends SafeCubit<BrandOwnerDailyInventoryRequestsState> {
  final GetBrandOwnerDailyInventoryRequestsUseCase
  _getBrandOwnerDailyInventoryRequestsUseCase;

  late final Paginator<
    BrandOwnerDailyInventoryRequest,
    BrandOwnerDailyInventoryRequestsResponse
  >
  paginator;

  BrandOwnerDailyInventoryRequestsCubit(
    this._getBrandOwnerDailyInventoryRequestsUseCase,
  ) : super(const BrandOwnerDailyInventoryRequestsInitial()) {
    paginator =
        Paginator<
          BrandOwnerDailyInventoryRequest,
          BrandOwnerDailyInventoryRequestsResponse
        >(
          fetchPage: (page) =>
              _getBrandOwnerDailyInventoryRequestsUseCase(page),
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
      emit(const BrandOwnerDailyInventoryRequestsLoading());
    }

    final result = await paginator.loadNextPage();

    handle(
      result,
      failure: (failure) =>
          emit(BrandOwnerDailyInventoryRequestsFailure(failure)),
      success: (response) =>
          emit(BrandOwnerDailyInventoryRequestsSuccess(response)),
    );
  }
}
