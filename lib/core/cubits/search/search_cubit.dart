import '../../helpers/safe_cubit.dart';
import 'search_state.dart';

class SearchCubit<T> extends SafeCubit<SearchState<T>> {
  SearchCubit() : super(SearchInitial<T>());

  List<T> _original = [];

  void setData(List<T> data) {
    _original = data;
    emit(SearchSuccess<T>(List.from(data)));
  }

  void search(String query, bool Function(T item, String query) match) {
    if (query.isEmpty) {
      emit(SearchSuccess<T>(List.from(_original)));
    } else {
      final results = _original.where((item) => match(item, query)).toList();
      emit(SearchSuccess<T>(results));
    }
  }

  void clear() => emit(SearchSuccess<T>(List.from(_original)));
}
