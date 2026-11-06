import 'package:assab/generated/l10n.dart';
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
          months: [
            S.current.followupJanuary,
            S.current.followupFebruary,
            S.current.followupMarch,
            S.current.followupApril,
            S.current.followupMay,
            S.current.followupJune,
            S.current.followupJuly,
            S.current.followupAugust,
            S.current.followupSeptember,
            S.current.followupOctober,
            S.current.followupNovember,
            S.current.followupDecember,
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
