import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:meta/meta.dart';

import '../../../../../../core/helpers/paginator.dart';
import '../../../../../../core/helpers/safe_cubit.dart';
import '../../../data/mapper/manager_shift/branch_manager.dart';
import '../../../data/model/branch_response_model.dart';
import '../../../data/model/manager_shift_management_models/branch_model.dart';
import '../../../domain/entity/cashier_entity.dart';

part 'get_branches_state.dart';

class GetBranchesCubit extends SafeCubit<GetBranchesState> {
  final ShiftManagementRepositoryImp _repository;

  GetBranchesCubit(this._repository) : super(GetBranchesInitial());

  Paginator<BranchModel, BranchesResponseModel>? _branchesPaginator;
  final List<BranchEntity> _branches = [];

  String? storeBranch;

  bool get hasMore => _branchesPaginator?.hasMore ?? false;

  Future<void> getBranches({required bool resetPagination}) async {
    if (_branchesPaginator == null || resetPagination) {
      _branchesPaginator = Paginator<BranchModel, BranchesResponseModel>(
        fetchPage: (page) => _repository.getBranches(page: page),
        extractData: (res) => res.data,
        extractMeta: (res) => MetaInfo(
          currentPage: res.meta.currentPage,
          lastPage: res.meta.lastPage,
          total: res.meta.total,
        ),
      );
    }

    if (resetPagination) {
      _branchesPaginator!.reset();
      _branches.clear();
      emit(GetBranchesLoading());
    }

    final result = await _branchesPaginator!.loadNextPage();

    handle(
      result,
      failure: (f) {
        emit(GetBranchesFailure(f));
      },
      success: (items) {
        if (items.isEmpty && _branches.isEmpty) {
          emit(GetBranchesEmpty());
          return;
        }

        _branches.addAll(items.map((e) => e.toEntity()));

        emit(GetBranchesSuccess(List.unmodifiable(_branches)));
      },
    );
  }
}
