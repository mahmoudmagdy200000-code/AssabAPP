import 'package:assab/core/enums/time_keys.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/enums/custody_transactions_types_enum.dart';
import '../../../../../core/helpers/safe_cubit.dart';
import 'select_filter_custody_transactions_state.dart';

@injectable
class SelectFilterCustodyTransactionsCubit
    extends SafeCubit<SelectFilterCustodyTransactionsState> {
  SelectFilterCustodyTransactionsCubit()
    : super(const SelectFilterCustodyTransactionsState());

  void setType(CustodyTransactionsTypesEnum type) {
    emit(state.copyWith(type: type));
  }

  void setDate(TimeKeys time) {
    emit(state.copyWith(time: time));
  }

  void clearFilters() {
    emit(const SelectFilterCustodyTransactionsState());
  }
}
