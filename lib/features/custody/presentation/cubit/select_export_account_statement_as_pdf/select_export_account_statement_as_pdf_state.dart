import 'package:assab/core/enums/time_keys.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/enums/custody_export_account_statement_export_format_enum.dart';

class SelectExportAccountStatementAsPdfState extends Equatable {
  final CustodyExportAccountStatementExportFormatEnum exportFormat;
  final TimeKeys timeFrame;

  const SelectExportAccountStatementAsPdfState({
    this.exportFormat = CustodyExportAccountStatementExportFormatEnum.non,
    this.timeFrame = TimeKeys.non,
  });

  SelectExportAccountStatementAsPdfState copyWith({
    CustodyExportAccountStatementExportFormatEnum? exportFormat,
    TimeKeys? timeFrame,
  }) {
    return SelectExportAccountStatementAsPdfState(
      exportFormat: exportFormat ?? this.exportFormat,
      timeFrame: timeFrame ?? this.timeFrame,
    );
  }

  @override
  List<Object> get props => [exportFormat, timeFrame];
}
