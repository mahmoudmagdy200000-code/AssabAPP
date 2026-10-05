enum CustodyExportAccountStatementExportFormatEnum {
  non(''),
  dailyView('daily'),
  detailedView('detailed');

  final String _value;

  const CustodyExportAccountStatementExportFormatEnum(this._value);

  String get value => _value;

  static CustodyExportAccountStatementExportFormatEnum fromValue(String value) {
    return CustodyExportAccountStatementExportFormatEnum.values.firstWhere(
      (enumValue) => enumValue.value == value,
      orElse: () => CustodyExportAccountStatementExportFormatEnum.non,
    );
  }
}
