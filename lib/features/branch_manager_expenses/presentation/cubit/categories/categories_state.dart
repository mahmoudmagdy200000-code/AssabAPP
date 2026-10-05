part of 'categories_cubit.dart';

sealed class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object> get props => [];
}

final class CategoriesInitial extends CategoriesState {
  const CategoriesInitial();
}

final class CategoriesLoading extends CategoriesState {
  const CategoriesLoading();
}

final class CategoriesSuccess extends CategoriesState {
  final List<ExpensesMainCategoryResponseEntity> categories;

  const CategoriesSuccess(this.categories);

  @override
  List<Object> get props => [categories];
}

final class GetSupCategoriesSuccess extends CategoriesState {
  final SupCategoriesResponse categories;

  const GetSupCategoriesSuccess(this.categories);

  @override
  List<Object> get props => [categories];
}

final class CategoriesFailure extends CategoriesState {
  final ApiFailure failure;

  const CategoriesFailure(this.failure);

  @override
  List<Object> get props => [failure];
}

final class CategoriesDeleteLoading extends CategoriesState {
  const CategoriesDeleteLoading();
}

final class CategoriesDeleteSuccess extends CategoriesState {
  const CategoriesDeleteSuccess();
}

final class CategoriesDeleteFailure extends CategoriesState {
  final ApiFailure failure;

  const CategoriesDeleteFailure(this.failure);

  @override
  List<Object> get props => [failure];
}

final class CategoriesUpdateLoading extends CategoriesState {
  const CategoriesUpdateLoading();
}

final class CategoriesUpdateSuccess extends CategoriesState {
  const CategoriesUpdateSuccess();
}

final class CategoriesUpdateFailure extends CategoriesState {
  final ApiFailure failure;

  const CategoriesUpdateFailure(this.failure);

  @override
  List<Object> get props => [failure];
}

final class CategoriesAddLoading extends CategoriesState {
  const CategoriesAddLoading();
}

final class CategoriesAddSuccess extends CategoriesState {
  const CategoriesAddSuccess();
}

final class CategoriesAddFailure extends CategoriesState {
  final ApiFailure failure;

  const CategoriesAddFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
