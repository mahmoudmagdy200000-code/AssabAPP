import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../core/helpers/paginator.dart';
import '../../../../../../../core/helpers/safe_cubit.dart';
import '../../../../data/model/cashier_model.dart';
import '../../../../data/model/get_all_cashiers_and_managers_response_model.dart';
import '../../../../domain/entity/handover_user_item.dart';
import 'fetch_manager_state.dart';

@injectable
class FetchManagerCubit extends SafeCubit<FetchManagerState> {
  final ShiftManagementRepositoryImp _repository;

  late final Paginator<HandoverUserItem, GetAllCashiersAndManagersResponse>
  paginator;

  FetchManagerCubit(this._repository) : super(FetchManagerInitial()) {
    paginator = Paginator<HandoverUserItem, GetAllCashiersAndManagersResponse>(
      fetchPage: (page) async {
        /// SAME repo function
        return _repository.getAllCashiersAndManagers(page: page);
      },
      extractData: (response) {
        /// ONLY managers
        return response.data.branchManagers
            .map(
              (m) => HandoverUserItem(
                id: m.id,
                name: m.name,
                image: m.image,
                status: m.status.value ?? CashierStatus.deactivated,
                branchName: m.branch.name,
                isManager: true,
              ),
            )
            .toList();
      },
      extractMeta: (response) => MetaInfo(
        currentPage: response.meta.currentPage,
        lastPage: response.meta.lastPage,
        total: response.meta.total,
      ),
    );
  }

  /// Initial fetch
  Future<void> initFetch() async {
    paginator.reset();
    emit(FetchManagerLoading());

    final result = await paginator.loadNextPage();

    handle(
      result,
      failure: (f) => emit(FetchManagerFailure(failure: f)),
      success: (managers) {
        if (managers.isEmpty) {
          emit(FetchManagerEmpty());
        } else {
          emit(FetchManagerSuccess(managers: managers));
        }
      },
    );
  }

  /// Pagination
  Future<void> loadMore() async {
    if (!paginator.hasMore) return;

    emit(FetchManagerPaginationLoading());

    final result = await paginator.loadNextPage();

    handle(
      result,
      failure: (f) => emit(FetchManagerFailure(failure: f)),
      success: (moreManagers) {
        final currentManagers = state is FetchManagerSuccess
            ? (state as FetchManagerSuccess).managers
            : <HandoverUserItem>[];

        emit(
          FetchManagerSuccess(managers: [...currentManagers, ...moreManagers]),
        );
      },
    );
  }
}
