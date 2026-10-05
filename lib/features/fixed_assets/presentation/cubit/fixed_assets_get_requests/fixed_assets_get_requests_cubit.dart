import 'package:assab/core/helpers/paginator.dart';
import 'package:assab/features/fixed_assets/data/repositories/fixed_assets_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/errors/api_failure.dart';
import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/fixed_assets_disposals_requests_response.dart';
import '../../../data/models/fixed_assets_handovers_requests_response.dart';
import '../../../data/models/fixed_assets_modification_requests_response.dart';
import '../../../data/models/fixed_assets_transfers_requests_response.dart';

part 'fixed_assets_get_requests_state.dart';

@injectable
class FixedAssetsGetRequestsCubit
    extends SafeCubit<FixedAssetsGetRequestsState> {
  final FixedAssetsRepository _repository;

  late final Paginator<
    FixedAssetsModificationRequestsItem,
    FixedAssetsModificationRequestsResponse
  >
  modificationRequestsPaginator;
  late final Paginator<
    FixedAssetsTransfersRequestsItem,
    FixedAssetsTransfersRequestsResponse
  >
  transfersRequestsPaginator;

  late final Paginator<
    FixedAssetsDisposalsRequestsItem,
    FixedAssetsDisposalsRequestsResponse
  >
  disposalsRequestsPaginator;

  late final Paginator<
    FixedAssetsHandoverRequestsItem,
    FixedAssetsHandoversRequestsResponse
  >
  handoverRequestsPaginator;

  FixedAssetsGetRequestsCubit(this._repository)
    : super(FixedAssetsGetRequestsInitial()) {
    modificationRequestsPaginator =
        Paginator<
          FixedAssetsModificationRequestsItem,
          FixedAssetsModificationRequestsResponse
        >(
          fetchPage: (page) => _repository.getModificationRequests(page: page),
          extractData: (response) => response.items,
          extractMeta: (response) => MetaInfo(
            currentPage: response.meta.currentPage,
            lastPage: response.meta.lastPage,
            total: response.meta.total,
          ),
        );
    transfersRequestsPaginator =
        Paginator<
          FixedAssetsTransfersRequestsItem,
          FixedAssetsTransfersRequestsResponse
        >(
          fetchPage: (page) => _repository.getTransfersRequests(page: page),
          extractData: (response) => response.items,
          extractMeta: (response) => MetaInfo(
            currentPage: response.meta.currentPage,
            lastPage: response.meta.lastPage,
            total: response.meta.total,
          ),
        );
    disposalsRequestsPaginator =
        Paginator<
          FixedAssetsDisposalsRequestsItem,
          FixedAssetsDisposalsRequestsResponse
        >(
          fetchPage: (page) => _repository.getDisposalsRequests(page: page),
          extractData: (response) => response.items,
          extractMeta: (response) => MetaInfo(
            currentPage: response.meta.currentPage,
            lastPage: response.meta.lastPage,
            total: response.meta.total,
          ),
        );
    handoverRequestsPaginator =
        Paginator<
          FixedAssetsHandoverRequestsItem,
          FixedAssetsHandoversRequestsResponse
        >(
          fetchPage: (page) => _repository.getHandoverRequests(page: page),
          extractData: (response) => response.items,
          extractMeta: (response) => MetaInfo(
            currentPage: response.meta.currentPage,
            lastPage: response.meta.lastPage,
            total: response.meta.total,
          ),
        );
  }

  Future<void> fetchModificationRequests({bool loadMore = false}) async {
    if (!loadMore) {
      modificationRequestsPaginator.reset();
      emit(FixedAssetsGetModificationRequestsLoading());
    }

    final result = await modificationRequestsPaginator.loadNextPage();

    handle(
      result,
      success: (data) => emit(FixedAssetsGetModificationRequestsSuccess(data)),
      failure: (failure) =>
          emit(FixedAssetsGetModificationRequestsFailure(failure)),
    );
  }

  Future<void> fetchTransfersRequests({bool loadMore = false}) async {
    if (!loadMore) {
      transfersRequestsPaginator.reset();
      emit(FixedAssetsGetTransfersRequestsLoading());
    }

    final result = await transfersRequestsPaginator.loadNextPage();

    handle(
      result,
      success: (data) => emit(FixedAssetsGetTransfersRequestsSuccess(data)),
      failure: (failure) =>
          emit(FixedAssetsGetTransfersRequestsFailure(failure)),
    );
  }

  Future<void> fetchDisposalsRequests({bool loadMore = false}) async {
    if (!loadMore) {
      disposalsRequestsPaginator.reset();
      emit(FixedAssetsGetDisposalsRequestsLoading());
    }

    final result = await disposalsRequestsPaginator.loadNextPage();

    handle(
      result,
      success: (data) => emit(FixedAssetsGetDisposalsRequestsSuccess(data)),
      failure: (failure) =>
          emit(FixedAssetsGetDisposalsRequestsFailure(failure)),
    );
  }

  Future<void> fetchHandoverRequests({bool loadMore = false}) async {
    if (!loadMore) {
      handoverRequestsPaginator.reset();
      emit(const FixedAssetsGetHandoverRequestsLoading());
    }

    final result = await handoverRequestsPaginator.loadNextPage();

    handle(
      result,
      success: (data) => emit(FixedAssetsGetHandoverRequestsSuccess(data)),
      failure: (failure) =>
          emit(FixedAssetsGetHandoverRequestsFailure(failure)),
    );
  }
}
