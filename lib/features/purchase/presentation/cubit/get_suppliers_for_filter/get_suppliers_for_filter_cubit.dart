import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/paginator.dart';
import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/suppliers_for_filter_purchase_items_response.dart';
import '../../../data/repository/purchase_repository.dart';
import 'get_suppliers_for_filter_state.dart';

@injectable
class GetSuppliersForFilterCubit extends SafeCubit<GetSuppliersForFilterState> {
  final PurchaseRepository _purchaseRepository;

  late final Paginator<
    SuppliersForFilterPurchaseItemsResponseData,
    SuppliersForFilterPurchaseItemsResponse
  >
  paginator;

  GetSuppliersForFilterCubit(this._purchaseRepository)
    : super(const GetSuppliersForFilterInit()) {
    paginator =
        Paginator<
          SuppliersForFilterPurchaseItemsResponseData,
          SuppliersForFilterPurchaseItemsResponse
        >(
          fetchPage: (page) async => await _purchaseRepository
              .getSuppliersForFilterPurchaseItems(page: page),
          extractData: (response) => response.data,
          extractMeta: (response) => MetaInfo(
            currentPage: response.meta.currentPage,
            lastPage: response.meta.lastPage,
            total: response.meta.total,
          ),
        );
  }

  Future<void> getSuppliers({bool loadMore = false}) async {
    if (!loadMore) {
      paginator.reset();
      emit(const GetSuppliersForFilterLoading());
    }

    final result = await paginator.loadNextPage();

    handle(
      result,
      failure: (failure) => emit(GetSuppliersForFilterFailure(failure)),
      success: (data) => emit(GetSuppliersForFilterSuccess(data)),
    );
  }
}
