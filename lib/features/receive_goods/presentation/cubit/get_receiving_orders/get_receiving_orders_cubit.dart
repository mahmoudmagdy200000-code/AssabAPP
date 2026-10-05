import 'package:assab/core/helpers/paginator.dart';
import 'package:assab/features/receive_goods/data/repository/receive_goods_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/receive_goods_in_progress_orders_response.dart';
import 'get_receiving_orders_state.dart';

@injectable
class GetReceivingOrdersCubit extends SafeCubit<GetReceivingOrdersState> {
  final ReceiveGoodsRepository _receiveGoodsRepository;

  late final Paginator<ReceiveGoodsOrder, ReceiveGoodsInProgressOrdersResponse>
  inProgressPaginator;

  late final Paginator<ReceiveGoodsOrder, ReceiveGoodsInProgressOrdersResponse>
  missingPaginator;

  late final Paginator<ReceiveGoodsOrder, ReceiveGoodsInProgressOrdersResponse>
  completedPaginator;

  GetReceivingOrdersCubit(this._receiveGoodsRepository)
    : super(const GetReceivingOrdersInit()) {
    inProgressPaginator =
        Paginator<ReceiveGoodsOrder, ReceiveGoodsInProgressOrdersResponse>(
          fetchPage: (page) async => await _receiveGoodsRepository
              .getReceivingOrdersInProgress(page: page),
          extractData: (response) => response.data,
          extractMeta: (response) => MetaInfo(
            currentPage: response.meta.currentPage,
            lastPage: response.meta.lastPage,
            total: response.meta.total,
          ),
        );

    missingPaginator =
        Paginator<ReceiveGoodsOrder, ReceiveGoodsInProgressOrdersResponse>(
          fetchPage: (page) async => await _receiveGoodsRepository
              .getReceivingOrdersMissing(page: page),
          extractData: (response) => response.data,
          extractMeta: (response) => MetaInfo(
            currentPage: response.meta.currentPage,
            lastPage: response.meta.lastPage,
            total: response.meta.total,
          ),
        );

    completedPaginator =
        Paginator<ReceiveGoodsOrder, ReceiveGoodsInProgressOrdersResponse>(
          fetchPage: (page) async => await _receiveGoodsRepository
              .getReceivingOrdersCompleted(page: page),
          extractData: (response) => response.data,
          extractMeta: (response) => MetaInfo(
            currentPage: response.meta.currentPage,
            lastPage: response.meta.lastPage,
            total: response.meta.total,
          ),
        );
  }

  void getReceivingOrdersInProgress({bool loadMore = false}) async {
    if (!loadMore) {
      inProgressPaginator.reset();
      emit(const GetReceivingOrdersInProgressLoading());
    }

    final result = await inProgressPaginator.loadNextPage();

    handle(
      result,
      success: (orders) {
        emit(GetReceivingOrdersInProgressSuccess(orders));
      },
      failure: (failure) {
        emit(GetReceivingOrdersInProgressFailure(failure));
      },
    );
  }

  void getReceivingOrdersMissing({bool loadMore = false}) async {
    if (!loadMore) {
      missingPaginator.reset();
      emit(const GetReceivingOrdersMissingLoading());
    }

    final result = await missingPaginator.loadNextPage();

    handle(
      result,
      success: (orders) {
        emit(GetReceivingOrdersMissingSuccess(orders));
      },
      failure: (failure) {
        emit(GetReceivingOrdersMissingFailure(failure));
      },
    );
  }

  void getReceivingOrdersCompleted({bool loadMore = false}) async {
    if (!loadMore) {
      completedPaginator.reset();
      emit(const GetReceivingOrdersCompletedLoading());
    }

    final result = await completedPaginator.loadNextPage();

    handle(
      result,
      success: (orders) {
        emit(GetReceivingOrdersCompletedSuccess(orders));
      },
      failure: (failure) {
        emit(GetReceivingOrdersCompletedFailure(failure));
      },
    );
  }
}
