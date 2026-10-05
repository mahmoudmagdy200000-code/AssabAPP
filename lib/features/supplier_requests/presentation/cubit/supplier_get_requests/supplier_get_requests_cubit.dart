import 'package:assab/core/helpers/paginator.dart';
import 'package:assab/features/supplier_requests/data/models/supplier_orders_response.dart';
import 'package:assab/features/supplier_requests/data/repository/supplier_requests_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import 'supplier_get_requests_state.dart';

@injectable
class SupplierGetRequestsCubit extends SafeCubit<SupplierGetRequestsState> {
  final SupplierRequestsRepository _supplierRequestsRepository;

  late final Paginator<SupplierOrder, SupplierOrdersResponse> paginator;

  SupplierGetRequestsCubit(this._supplierRequestsRepository)
    : super(const SupplierGetRequestsInit()) {
    paginator = Paginator<SupplierOrder, SupplierOrdersResponse>(
      fetchPage: (page) =>
          _supplierRequestsRepository.getSupplierOrders(page: page),
      extractData: (response) => response.data,
      extractMeta: (response) => MetaInfo(
        currentPage: response.meta.currentPage,
        lastPage: response.meta.lastPage,
        total: response.meta.total,
      ),
    );
  }

  void getRequests({bool loadMore = false}) async {
    if (!loadMore) {
      paginator.reset();
      emit(const SupplierGetRequestsLoading());
    }

    final result = await paginator.loadNextPage();

    handle(
      result,
      failure: (failure) {
        emit(SupplierGetRequestsFailure(failure));
      },
      success: (requests) {
        emit(SupplierGetRequestsSuccess(requests));
      },
    );
  }
}
