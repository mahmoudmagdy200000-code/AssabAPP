abstract class CategoryStrategy {
  String get value;
}

class PurchaseCategoryStrategy implements CategoryStrategy {
  @override
  String get value => 'purchase';
}

class ExpenseCategoryStrategy implements CategoryStrategy {
  @override
  String get value => 'expense';
}
