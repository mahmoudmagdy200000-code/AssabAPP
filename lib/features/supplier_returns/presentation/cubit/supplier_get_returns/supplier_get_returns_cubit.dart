import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/paginator.dart';
import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/supplier_returns_response.dart';
import '../../../data/repository/supplier_returns_repository.dart';
import 'supplier_get_returns_state.dart';

@injectable
class SupplierGetReturnsCubit extends SafeCubit<SupplierGetReturnsState> {
  final SupplierReturnsRepository _supplierReturnsRepository;

  late final Paginator<SupplierReturnData, SupplierReturnsResponse> paginator;

  SupplierGetReturnsCubit(this._supplierReturnsRepository)
    : super(const SupplierGetReturnsInit()) {
    paginator = Paginator<SupplierReturnData, SupplierReturnsResponse>(
      fetchPage: (page) =>
          _supplierReturnsRepository.getSupplierReturns(page: page),
      extractData: (response) => response.data,
      extractMeta: (response) => MetaInfo(
        currentPage: response.meta.currentPage,
        lastPage: response.meta.lastPage,
        total: response.meta.total,
      ),
    );
  }

  Future<void> getReturns({bool loadMore = false}) async {
    if (!loadMore) {
      paginator.reset();
      emit(const SupplierGetReturnsLoading());
    }

    final result = await paginator.loadNextPage();

    handle(
      result,
      success: (data) {
        emit(SupplierGetReturnsSuccess(data));
      },
      failure: (failure) {
        emit(SupplierGetReturnsFailure(failure));
      },
    );
  }
}
