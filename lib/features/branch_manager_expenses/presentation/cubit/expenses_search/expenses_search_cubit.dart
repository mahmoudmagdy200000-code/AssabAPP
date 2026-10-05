import 'package:injectable/injectable.dart';

import '../../../../../core/enums/expenses_filter_keys.dart';
import '../../../../../core/enums/filter_status.dart';
import '../../../../../core/enums/time_keys.dart';
import '../../../../../core/helpers/paginator.dart';
import '../../../../../core/helpers/safe_cubit.dart';
import '../../../../../shared/models/meta_model/meta_model.dart';
import '../../../data/models/all_expense_response_model.dart';
import '../../../data/models/expense_data_model.dart';
import '../../../data/repository/branch_manager_expenses_repository.dart';
import 'expenses_search_state.dart';

@injectable
class ExpensesSearchCubit extends SafeCubit<ExpensesSearchState> {
  final BranchManagerExpensesRepository _branchManagerExpensesRepository;

  late final Paginator<ExpenseDataModel, AllExpenseResponseModel> paginator;

  ExpensesFilterKeys? _currentType;
  FilterStatus? _currentStatus;
  TimeKeys? _period;
  int _itemCount = 0;

  ExpensesSearchCubit(this._branchManagerExpensesRepository)
    : super(const ExpensesSearchInitial()) {
    paginator = Paginator<ExpenseDataModel, AllExpenseResponseModel>(
      fetchPage: (int page) {
        return _branchManagerExpensesRepository.getSearchExpenses(
          page: page,
          type: _currentType,
          status: _currentStatus,
          period: _period,
        );
      },
      extractData: (res) => res.data,
      extractMeta: (res) => MetaInfo(
        currentPage: res.meta.currentPage,
        lastPage: res.meta.lastPage,
        total: res.meta.total,
      ),
    );
  }

  void getSearchExpenses({
    required ExpensesFilterKeys? type,
    required FilterStatus? status,
    required TimeKeys? period,
    bool loadMore = false,
  }) async {
    _currentType = type;
    _currentStatus = status;
    _period = period;

    if (!loadMore) {
      paginator.reset();
      emit(const ExpensesSearchLoading());
    }

    final result = await paginator.loadNextPage();

    handle(
      result,
      failure: (f) => emit(ExpensesSearchFailure(f)),
      success: (items) {
        _itemCount = items.length;

        emit(
          ExpensesSearchSuccess(
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

  bool get hasMore => paginator.hasMore;

  int get itemCount => _itemCount;
}
