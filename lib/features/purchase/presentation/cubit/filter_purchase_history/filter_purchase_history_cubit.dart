import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import 'filter_purchase_history_state.dart';

@injectable
class FilterPurchaseHistoryCubit extends SafeCubit<FilterPurchaseHistoryState> {
  FilterPurchaseHistoryCubit() : super(const FilterPurchaseHistoryInit());
}
