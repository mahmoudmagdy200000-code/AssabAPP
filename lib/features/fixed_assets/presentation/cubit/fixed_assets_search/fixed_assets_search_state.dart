part of 'fixed_assets_search_cubit.dart';

sealed class FixedAssetsSearchState extends Equatable {
  const FixedAssetsSearchState();

  @override
  List<Object> get props => [];
}

final class FixedAssetsSearchInitial extends FixedAssetsSearchState {}

final class FixedAssetsSearchLoading extends FixedAssetsSearchState {}

final class FixedAssetsSearchSuccess extends FixedAssetsSearchState {
  final FixedAssetsSearchResponse results;

  const FixedAssetsSearchSuccess(this.results);

  @override
  List<Object> get props => [results];
}

final class FixedAssetsSearchFailure extends FixedAssetsSearchState {
  final ApiFailure failure;

  const FixedAssetsSearchFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
