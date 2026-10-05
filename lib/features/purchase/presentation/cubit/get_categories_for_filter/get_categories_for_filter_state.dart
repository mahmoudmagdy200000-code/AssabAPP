import 'package:equatable/equatable.dart';

sealed class GetCategoriesForFilterState extends Equatable {
  const GetCategoriesForFilterState();

  @override
  List<Object> get props => [];
}

final class GetCategoriesForFilterInit extends GetCategoriesForFilterState {
  const GetCategoriesForFilterInit();
}

final class GetCategoriesForFilterLoading extends GetCategoriesForFilterState {
  const GetCategoriesForFilterLoading();
}

final class GetCategoriesForFilterSuccess extends GetCategoriesForFilterState {
  const GetCategoriesForFilterSuccess();
}

final class GetCategoriesForFilterFailure extends GetCategoriesForFilterState {
  const GetCategoriesForFilterFailure();
}
