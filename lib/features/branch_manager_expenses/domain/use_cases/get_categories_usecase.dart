import 'package:assab/features/branch_manager_expenses/domain/entities/expenses_sup_category_entity.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/api_error_handler.dart';
import '../../../../core/utils/api_result.dart';
import '../../data/repository/branch_manager_expenses_repository.dart';
import '../entities/expenses_main_category_response_entity.dart';
import '../strategies/category_strategy.dart';

@LazySingleton()
class GetCategoriesUseCase {
  final BranchManagerExpensesRepository _branchManagerExpensesRepository;

  GetCategoriesUseCase(this._branchManagerExpensesRepository);

  Future<ApiResult<List<ExpensesMainCategoryResponseEntity>>> getCategories({
    required CategoryStrategy type,
  }) async {
    try {
      final result = await _branchManagerExpensesRepository.getCategories();

      return result.when(
        success: (response) {
          final filtered = response.data
              .where((e) => e.type.toLowerCase() == type.value.toLowerCase())
              .toList();

          final mainCategories = filtered
              .where((e) => e.parent == null)
              .toList();

          final entities = mainCategories.map((main) {
            final subCategories = filtered
                .where((e) => e.parent?.id == main.id)
                .map(
                  (sub) =>
                      ExpensesSupCategoryEntity(id: sub.id, name: sub.name),
                )
                .toList();

            return ExpensesMainCategoryResponseEntity(
              id: main.id,
              name: main.name,
              type: main.type,
              subCategories: subCategories,
            );
          }).toList();

          return ApiResult.success(entities);
        },
        failure: (error) => ApiResult.failure(error),
      );
    } catch (e, st) {
      return ApiResult.failure(ApiErrorHandler.handle(e, st));
    }
  }
}
