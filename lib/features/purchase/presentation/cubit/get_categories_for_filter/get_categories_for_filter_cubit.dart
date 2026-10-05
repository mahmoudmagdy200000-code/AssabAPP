import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'get_categories_for_filter_state.dart';

@injectable
class GetCategoriesForFilterCubit extends Cubit<GetCategoriesForFilterState> {
  GetCategoriesForFilterCubit() : super(const GetCategoriesForFilterInit());
}
