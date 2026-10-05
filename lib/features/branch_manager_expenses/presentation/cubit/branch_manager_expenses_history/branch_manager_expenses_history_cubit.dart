import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/paginator.dart';
import '../../../../../core/helpers/safe_cubit.dart';
import '../../../../../core/utils/future_api_result.dart';
import '../../../../../shared/models/meta_model/meta_model.dart';
import '../../../data/models/all_expense_response_model.dart';
import '../../../data/models/expense_data_model.dart';
import '../../../data/repository/branch_manager_expenses_repository.dart';
import '../../../domain/strategies/expense_category.dart';
import 'branch_manager_expenses_history_state.dart';

@injectable
class BranchManagerExpensesHistoryCubit
    extends SafeCubit<BranchManagerExpensesHistoryState> {
  final BranchManagerExpensesRepository _branchManagerExpensesRepository;

  BranchManagerExpensesHistoryCubit(this._branchManagerExpensesRepository)
    : super(const BranchManagerExpensesHistoryInit()) {
    _initPaginators();
  }

  late final Map<Type, Paginator<ExpenseDataModel, AllExpenseResponseModel>>
  _paginators;

  void _initPaginators() {
    _paginators = {
      AllExpense: _createPaginator(
        (page) => _branchManagerExpensesRepository.getAllExpenses(page: page),
      ),
      DraftExpense: _createPaginator(
        (page) =>
            _branchManagerExpensesRepository.getAllDraftExpenses(page: page),
      ),
      QuickCashExpense: _createPaginator(
        (page) => _branchManagerExpensesRepository.getAllQuickCashExpenses(
          page: page,
        ),
      ),
      SingleInvoiceExpense: _createPaginator(
        (page) => _branchManagerExpensesRepository.getAllSingleInvoiceExpenses(
          page: page,
        ),
      ),
      PreApprovalExpense: _createPaginator(
        (page) => _branchManagerExpensesRepository.getAllPreApprovalExpenses(
          page: page,
        ),
      ),
      GroupInvoicesExpense: _createPaginator(
        (page) => _branchManagerExpensesRepository.getAllGroupedInvoiceExpenses(
          page: page,
        ),
      ),
    };
  }

  Paginator<ExpenseDataModel, AllExpenseResponseModel> _createPaginator(
    FutureApiResult<AllExpenseResponseModel> Function(int page) fetchPage,
  ) {
    return Paginator<ExpenseDataModel, AllExpenseResponseModel>(
      fetchPage: fetchPage,
      extractData: (res) => res.data,
      extractMeta: (res) => MetaInfo(
        currentPage: res.meta.currentPage,
        lastPage: res.meta.lastPage,
        total: res.meta.total,
      ),
    );
  }

  ExpenseCategory _currentCategory = const AllExpense();

  Future<void> loadExpenses({
    ExpenseCategory? type,
    bool loadMore = false,
  }) async {
    if (type != null) {
      _currentCategory = type;

      _paginators[_currentCategory.runtimeType]!.reset();
    }

    final paginator = _paginators[_currentCategory.runtimeType]!;

    if (!loadMore) emit(const BranchManagerExpensesHistoryLoading());

    final result = await paginator.loadNextPage();

    handle(
      result,
      failure: (f) => emit(BranchManagerExpensesHistoryFailure(f)),
      success: (items) {
        emit(
          BranchManagerExpensesHistorySuccess(
            AllExpenseResponseModel(
              data: items,
              meta: MetaModel(
                currentPage: paginator.currentPage - 1,
                lastPage: paginator.hasMore
                    ? paginator.currentPage
                    : paginator.currentPage - 1,
                total: items.length,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> removeDraftExpense({required String id}) async {
    emit(const BranchManagerExpensesHistoryRemoveDraftLoading());

    final result = await _branchManagerExpensesRepository.removeDraftExpense(
      id: id,
    );

    handle(
      result,
      failure: (failure) => emit(BranchManagerExpensesHistoryFailure(failure)),
      success: (_) =>
          emit(const BranchManagerExpensesHistoryRemoveDraftSuccess()),
    );
  }

  bool get hasMore =>
      _paginators[_currentCategory.runtimeType]?.hasMore ?? false;

  ExpenseCategory get currentCategory => _currentCategory;
}
