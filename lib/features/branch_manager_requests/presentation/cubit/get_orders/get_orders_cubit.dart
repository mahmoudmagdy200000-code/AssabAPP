import 'package:assab/core/helpers/paginator.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/orders_response.dart';
import '../../../data/repository/requests_repository.dart';
import '../../../domain/entities/orders_entity.dart';
import 'get_orders_state.dart';

@injectable
class GetOrdersCubit extends SafeCubit<GetOrdersState> {
  final RequestsRepository _requestsRepository;

  late final Paginator<OrderData, OrdersEntity> paginator;

  GetOrdersCubit(this._requestsRepository) : super(const GetOrdersInit()) {
    paginator = Paginator<OrderData, OrdersEntity>(
      fetchPage: (page) => _requestsRepository.getOrders(page: page),
      extractData: (response) => response.orders,
      extractMeta: (response) => MetaInfo(
        currentPage: response.meta.currentPage,
        lastPage: response.meta.lastPage,
        total: response.meta.total,
      ),
    );
  }

  void getOrders({bool loadMore = false}) async {
    if (!loadMore) {
      paginator.reset();
      emit(const GetOrdersLoading());
    }

    final result = await paginator.loadNextPage();

    handle(
      result,
      failure: (failure) => emit(GetOrdersFailure(failure)),
      success: (orders) => emit(GetOrdersSuccess(orders)),
    );
  }
}
