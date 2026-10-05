import 'package:assab/core/helpers/paginator.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/helpers/safe_cubit.dart';
import '../../data/models/brand_owner_requests_models.dart';
import '../../data/repositories/brand_owner_requests_repository.dart';
import 'brand_owner_requests_custody_sales_transfers_state.dart';

@injectable
class BrandOwnerRequestsCustodySalesTransfersCubit
    extends SafeCubit<BrandOwnerRequestsCustodySalesTransfersState> {
  final BrandOwnerRequestsRepository _repository;

  late final Paginator<
    BrandOwnerSalesTransferItemModel,
    BrandOwnerRequestsCustodySalesTransfersResponse
  >
  paginator;

  BrandOwnerRequestsCustodySalesTransfersCubit(this._repository)
    : super(const BrandOwnerRequestsCustodySalesTransfersInitial()) {
    paginator = Paginator(
      fetchPage: (page) => _repository
          .getBrandOwnerRequestsCustodySalesTransfersView(page: page),
      extractData: (response) => response.data,
      extractMeta: (response) => MetaInfo(
        currentPage: response.meta.currentPage,
        lastPage: response.meta.lastPage,
        total: response.meta.total,
      ),
    );
  }

  Future<void> getBrandOwnerRequestsCustodySalesTransfersView({
    bool loadMore = false,
  }) async {
    if (!loadMore) {
      paginator.reset();
      emit(const BrandOwnerRequestsCustodySalesTransfersLoading());
    }

    final result = await paginator.loadNextPage();

    handle(
      result,
      success: (response) =>
          emit(BrandOwnerRequestsCustodySalesTransfersSuccess(response)),
      failure: (failure) =>
          emit(BrandOwnerRequestsCustodySalesTransfersFailure(failure)),
    );
  }

  Future<void> getBrandOwnerSalesTransferDetailsScreen({
    required String requestId,
  }) async {
    emit(const BrandOwnerRequestsCustodySalesTransfersLoading());

    final result = await _repository.getBrandOwnerSalesTransferDetailsScreen(
      requestId: requestId,
    );

    handle(
      result,
      success: (details) =>
          emit(BrandOwnerSalesTransferDetailsSuccess(details)),
      failure: (failure) =>
          emit(BrandOwnerRequestsCustodySalesTransfersFailure(failure)),
    );
  }
}
