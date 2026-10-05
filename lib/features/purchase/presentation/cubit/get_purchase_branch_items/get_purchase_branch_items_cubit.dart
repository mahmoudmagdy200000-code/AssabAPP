import 'package:assab/core/helpers/paginator.dart';
import 'package:assab/features/purchase/data/models/purchase_branch_items_response.dart';
import 'package:assab/features/purchase/data/repository/purchase_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import 'get_purchase_branch_items_state.dart';

@injectable
class GetPurchaseBranchItemsCubit
    extends SafeCubit<GetPurchaseBranchItemsState> {
  final PurchaseRepository _purchaseRepository;

  late final Paginator<PurchaseBranchItemData, PurchaseBranchItemsResponse>
  paginator;

  String? _supplierId;
  String? _categoryId;

  GetPurchaseBranchItemsCubit(this._purchaseRepository)
    : super(const GetPurchaseBranchItemsInit()) {
    paginator = Paginator<PurchaseBranchItemData, PurchaseBranchItemsResponse>(
      fetchPage: (page) async =>
          await _purchaseRepository.getPurchaseBranchItems(
            page: page,
            supplierId: _supplierId,
            categoryId: _categoryId,
          ),
      extractData: (response) => response.data,
      extractMeta: (response) => MetaInfo(
        currentPage: response.meta.currentPage,
        lastPage: response.meta.lastPage,
        total: response.meta.total,
      ),
    );
  }

  void getPurchaseBranchItems({
    String? supplierId,
    String? categoryId,
    bool loadMore = false,
  }) async {
    _supplierId = supplierId;
    _categoryId = categoryId;

    if (!loadMore) {
      paginator.reset();
      emit(const GetPurchaseBranchItemsLoading());
    }

    final result = await paginator.loadNextPage();

    handle(
      result,
      failure: (error) {
        emit(GetPurchaseBranchItemsFailure(error));
      },
      success: (data) {
        emit(GetPurchaseBranchItemsSuccess(data));
      },
    );
  }
}
