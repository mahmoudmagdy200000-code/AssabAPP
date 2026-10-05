import 'package:assab/core/helpers/paginator.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/supplier_items_response.dart';
import '../../../data/repository/supplier_requests_repository.dart';
import 'get_supplier_items_state.dart';

@injectable
class GetSupplierItemsCubit extends SafeCubit<GetSupplierItemsState> {
  final SupplierRequestsRepository _supplierRequestsRepository;

  late final Paginator<SupplierItem, SupplierItemsResponse> paginator;

  GetSupplierItemsCubit(this._supplierRequestsRepository)
    : super(GetSupplierItemsInit()) {
    paginator = Paginator<SupplierItem, SupplierItemsResponse>(
      fetchPage: (page) async =>
          await _supplierRequestsRepository.getSupplierItem(page: page),
      extractData: (response) => response.data,
      extractMeta: (response) => MetaInfo(
        currentPage: response.meta.currentPage,
        lastPage: response.meta.lastPage,
        total: response.meta.total,
      ),
    );
  }

  void getSupplierItems({bool loadMore = false}) async {
    if (!loadMore) {
      paginator.reset();
      emit(GetSupplierItemsLoading());
    }

    final result = await paginator.loadNextPage();

    handle(
      result,
      success: (data) {
        emit(GetSupplierItemsSuccess(data));
      },
      failure: (failure) {
        emit(GetSupplierItemsFailure(failure));
      },
    );
  }
}
