import 'package:injectable/injectable.dart';

import '../../../../../core/enums/custody_export_account_statement_export_format_enum.dart';
import '../../../../../core/helpers/safe_cubit.dart';
import 'select_filter_account_statement_state.dart';

@injectable
class SelectFilterAccountStatementCubit
    extends SafeCubit<SelectFilterAccountStatementState> {
  SelectFilterAccountStatementCubit()
    : super(
        SelectFilterAccountStatementState(
          months: const [
            'January',
            'February',
            'March',
            'April',
            'May',
            'June',
            'July',
            'August',
            'September',
            'October',
            'November',
            'December',
          ],
          years: List.generate(
            DateTime.now().year - 2000 + 1,
            (index) => 2000 + index,
          ),
        ),
      );

  void setType(CustodyExportAccountStatementExportFormatEnum type) {
    emit(state.copyWith(type: type));
  }

  void setMonth(String months) {
    emit(state.copyWith(selectedMonth: months));
  }

  void setYear(int year) {
    emit(state.copyWith(selectedYear: year));
  }

  void clearFilters() {
    emit(
      SelectFilterAccountStatementState(
        months: state.months,
        years: state.years,
      ),
    );
  }
}
