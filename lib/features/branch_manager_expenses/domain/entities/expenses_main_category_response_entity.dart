import 'expenses_sup_category_entity.dart';

class ExpensesMainCategoryResponseEntity {
  final String id;
  final String name;
  final String type;
  final List<ExpensesSupCategoryEntity> subCategories;

  ExpensesMainCategoryResponseEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.subCategories,
  });
}
