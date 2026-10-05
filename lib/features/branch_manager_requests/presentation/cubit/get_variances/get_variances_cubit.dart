import 'package:assab/core/helpers/paginator.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/variances_response.dart';
import '../../../data/repository/requests_repository.dart';
import 'get_variances_state.dart';

@injectable
class GetVariancesCubit extends SafeCubit<GetVariancesState> {
  final RequestsRepository _requestsRepository;

  late final Paginator<VarianceItem, VariancesResponse> paginator;

  GetVariancesCubit(this._requestsRepository)
    : super(const GetVariancesInit()) {
    paginator = Paginator<VarianceItem, VariancesResponse>(
      fetchPage: (page) async =>
          await _requestsRepository.getVariances(page: page),
      extractData: (response) => response.data,
      extractMeta: (response) => MetaInfo(
        currentPage: response.meta.currentPage,
        lastPage: response.meta.lastPage,
        total: response.meta.total,
      ),
    );
  }

  void getVariances({bool loadMore = false}) async {
    if (!loadMore) {
      paginator.reset();
      emit(const GetVariancesLoading());
    }

    final result = await paginator.loadNextPage();

    handle(
      result,
      failure: (failure) => emit(GetVariancesFailure(failure)),
      success: (variances) => emit(GetVariancesSuccess(variances)),
    );
  }
}
