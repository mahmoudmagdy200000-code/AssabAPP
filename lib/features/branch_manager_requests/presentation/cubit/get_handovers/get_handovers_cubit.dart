import 'package:assab/core/helpers/paginator.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/handovers_response.dart';
import '../../../data/repository/requests_repository.dart';
import 'get_handovers_state.dart';

@injectable
class GetHandoversCubit extends SafeCubit<GetHandoversState> {
  final RequestsRepository _requestsRepository;

  late final Paginator<HandoversResponseItem, HandoversResponse> paginator;

  GetHandoversCubit(this._requestsRepository)
    : super(const GetHandoversInit()) {
    paginator = Paginator<HandoversResponseItem, HandoversResponse>(
      fetchPage: (page) async =>
          await _requestsRepository.getHandovers(page: page),
      extractData: (response) => response.data,
      extractMeta: (response) => MetaInfo(
        currentPage: response.meta.currentPage,
        lastPage: response.meta.lastPage,
        total: response.meta.total,
      ),
    );
  }

  void getHandovers({bool loadMore = false}) async {
    if (!loadMore) {
      paginator.reset();
      emit(const GetHandoversLoading());
    }

    final result = await paginator.loadNextPage();

    handle(
      result,
      failure: (failure) => emit(GetHandoversFailure(failure)),
      success: (handovers) => emit(GetHandoversSuccess(handovers)),
    );
  }
}
