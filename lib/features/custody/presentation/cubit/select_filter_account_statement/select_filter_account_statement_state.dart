import 'package:equatable/equatable.dart';

import '../../../../../core/enums/custody_export_account_statement_export_format_enum.dart';

class SelectFilterAccountStatementState extends Equatable {
  final CustodyExportAccountStatementExportFormatEnum type;
  final List<String> months;
  final List<int> years;
  final String? selectedMonth;
  final int? selectedYear;

  const SelectFilterAccountStatementState({
    this.type = CustodyExportAccountStatementExportFormatEnum.non,
    this.months = const [],
    this.years = const [],
    this.selectedMonth,
    this.selectedYear,
  });

  SelectFilterAccountStatementState copyWith({
    CustodyExportAccountStatementExportFormatEnum? type,
    List<String>? months,
    List<int>? years,
    String? selectedMonth,
    int? selectedYear,
  }) {
    return SelectFilterAccountStatementState(
      type: type ?? this.type,
      months: months ?? this.months,
      years: years ?? this.years,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedYear: selectedYear ?? this.selectedYear,
    );
  }

  @override
  List<Object?> get props => [type, months, years, selectedMonth, selectedYear];
}
