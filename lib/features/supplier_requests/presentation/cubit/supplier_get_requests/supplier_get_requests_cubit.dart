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

  String? _statusFilter;
  String? _dateFrom;
  String? _dateTo;
  int _lastTotal = 0;

  String? get statusFilter => _statusFilter;
  String? get dateFrom => _dateFrom;
  String? get dateTo => _dateTo;
  bool get hasActiveFilters =>
      _statusFilter != null || _dateFrom != null || _dateTo != null;

  SupplierGetRequestsCubit(this._supplierRequestsRepository)
    : super(const SupplierGetRequestsInit()) {
    paginator = Paginator<SupplierOrder, SupplierOrdersResponse>(
      fetchPage: (page) => _supplierRequestsRepository.getSupplierOrders(
        page: page,
        status: _statusFilter,
        dateFrom: _dateFrom,
        dateTo: _dateTo,
      ),
      extractData: (response) => response.data,
      extractMeta: (response) {
        _lastTotal = response.meta.total;
        return MetaInfo(
          currentPage: response.meta.currentPage,
          lastPage: response.meta.lastPage,
          total: response.meta.total,
        );
      },
    );
  }

  Future<void> setStatusFilter(String? status) async {
    if (_statusFilter == status) return;
    _statusFilter = status;
    await getRequests();
  }

  Future<void> setDateRange({String? dateFrom, String? dateTo}) async {
    _dateFrom = dateFrom;
    _dateTo = dateTo;
    await getRequests();
  }

  Future<void> clearFilters() async {
    if (!hasActiveFilters) return;
    _statusFilter = null;
    _dateFrom = null;
    _dateTo = null;
    await getRequests();
  }

  Future<void> getRequests({bool loadMore = false}) async {
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
        emit(
          SupplierGetRequestsSuccess(
            requests,
            total: _lastTotal > 0 ? _lastTotal : requests.length,
            statusFilter: _statusFilter,
            dateFrom: _dateFrom,
            dateTo: _dateTo,
          ),
        );
      },
    );
  }
}
