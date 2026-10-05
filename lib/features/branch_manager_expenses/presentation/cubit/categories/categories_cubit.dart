import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/features/branch_manager_expenses/data/repository/branch_manager_expenses_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/add_sup_category_request.dart';
import '../../../data/models/sup_categories_response.dart';
import '../../../data/models/update_sup_category_request.dart';
import '../../../domain/entities/expenses_main_category_response_entity.dart';
import '../../../domain/strategies/category_strategy.dart';
import '../../../domain/use_cases/get_categories_usecase.dart';

part 'categories_state.dart';

@injectable
class CategoriesCubit extends SafeCubit<CategoriesState> {
  final GetCategoriesUseCase _getCategoriesUseCase;
  final BranchManagerExpensesRepository _branchManagerExpensesRepository;

  CategoriesCubit(
    this._getCategoriesUseCase,
    this._branchManagerExpensesRepository,
  ) : super(const CategoriesInitial());

  void getCategories({required CategoryStrategy type}) async {
    emit(const CategoriesLoading());

    final result = await _getCategoriesUseCase.getCategories(type: type);

    handle(
      result,
      success: (categories) => emit(CategoriesSuccess(categories)),
      failure: (failure) => emit(CategoriesFailure(failure)),
    );
  }

  void getAllCategories() async {
    emit(const CategoriesLoading());

    final result = await _branchManagerExpensesRepository.getAllCategories();

    handle(
      result,
      success: (categories) => emit(CategoriesSuccess(categories)),
      failure: (failure) => emit(CategoriesFailure(failure)),
    );
  }

  void getSupCategories({required String categoryId}) async {
    emit(const CategoriesLoading());

    final result = await _branchManagerExpensesRepository.getSupCategories(
      categoryId: categoryId,
    );

    handle(
      result,
      success: (categories) => emit(GetSupCategoriesSuccess(categories)),
      failure: (failure) => emit(CategoriesFailure(failure)),
    );
  }

  void deleteCategories({required String id}) async {
    emit(const CategoriesDeleteLoading());

    final result = await _branchManagerExpensesRepository.deleteCategory(
      id: id,
    );

    handle(
      result,
      success: (_) => emit(const CategoriesDeleteSuccess()),
      failure: (failure) => emit(CategoriesDeleteFailure(failure)),
    );
  }

  void updateSupCategory({
    required String id,
    required UpdateSupCategoryRequest model,
  }) async {
    emit(const CategoriesUpdateLoading());

    final result = await _branchManagerExpensesRepository.updateSupCategory(
      id: id,
      model: model,
    );

    handle(
      result,
      success: (_) => emit(const CategoriesUpdateSuccess()),
      failure: (failure) => emit(CategoriesUpdateFailure(failure)),
    );
  }

  void addSupCategory({required AddSupCategoryRequest model}) async {
    emit(const CategoriesAddLoading());

    final result = await _branchManagerExpensesRepository.addSupCategory(
      model: model,
    );

    handle(
      result,
      success: (_) => emit(const CategoriesAddSuccess()),
      failure: (failure) => emit(CategoriesAddFailure(failure)),
    );
  }
}
