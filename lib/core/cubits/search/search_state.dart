import 'package:equatable/equatable.dart';

sealed class SearchState<T> extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial<T> extends SearchState<T> {
  const SearchInitial();
}

class SearchSuccess<T> extends SearchState<T> {
  final List<T> results;

  const SearchSuccess(this.results);

  @override
  List<Object> get props => [results];
}
