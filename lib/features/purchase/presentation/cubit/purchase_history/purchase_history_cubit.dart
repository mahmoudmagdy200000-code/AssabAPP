import 'package:assab/core/helpers/paginator.dart';
import 'package:assab/features/purchase/data/repository/purchase_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/purchase_history_response.dart';
import 'purchase_history_state.dart';

@injectable
class PurchaseHistoryCubit extends SafeCubit<PurchaseHistoryState> {
  final PurchaseRepository _purchaseRepository;

  late final Paginator<PurchaseHistoryData, PurchaseHistoryResponse> paginator;

  String? _perspective;
  String? _type;
  String? _dateRange;

  PurchaseHistoryCubit(this._purchaseRepository)
    : super(const PurchaseHistoryInit()) {
    paginator = Paginator<PurchaseHistoryData, PurchaseHistoryResponse>(
      fetchPage: (page) => _purchaseRepository.getPurchaseHistory(
        page: page,
        perspective: _perspective,
        type: _type,
        dateRange: _dateRange,
      ),
      extractData: (response) => response.data,
      extractMeta: (response) => MetaInfo(
        currentPage: response.meta.currentPage,
        lastPage: response.meta.lastPage,
        total: response.meta.total,
      ),
    );
  }

  void getPurchaseHistory({
    bool loadMore = false,
    String? perspective,
    String? type,
    String? dateRange,
  }) async {
    _perspective = perspective;
    _type = type;
    _dateRange = dateRange;

    if (!loadMore) {
      paginator.reset();
      emit(const PurchaseHistoryLoading());
    }

    final result = await paginator.loadNextPage();

    handle(
      result,
      failure: (failure) {
        emit(PurchaseHistoryFailure(failure));
      },
      success: (data) {
        emit(PurchaseHistorySuccess(data));
      },
    );
  }
}
