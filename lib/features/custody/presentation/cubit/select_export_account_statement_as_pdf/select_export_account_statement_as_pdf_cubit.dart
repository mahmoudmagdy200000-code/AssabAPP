import 'package:assab/core/enums/time_keys.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/enums/custody_export_account_statement_export_format_enum.dart';
import '../../../../../core/helpers/safe_cubit.dart';
import 'select_export_account_statement_as_pdf_state.dart';

@injectable
class SelectExportAccountStatementAsPdfCubit
    extends SafeCubit<SelectExportAccountStatementAsPdfState> {
  SelectExportAccountStatementAsPdfCubit()
    : super(const SelectExportAccountStatementAsPdfState());

  void setExportFormat(CustodyExportAccountStatementExportFormatEnum format) {
    emit(state.copyWith(exportFormat: format));
  }

  void setExportTimeFrame(TimeKeys time) {
    emit(state.copyWith(timeFrame: time));
  }
}
