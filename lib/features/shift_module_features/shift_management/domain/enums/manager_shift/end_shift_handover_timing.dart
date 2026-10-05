enum HandoverTiming {
  today('today'),
  yesterday('yesterday');

  final String _value;

  const HandoverTiming(this._value);

  String get value => _value;

  static HandoverTiming fromString(String value) {
    return HandoverTiming.values.firstWhere(
      (e) => e._value == value,
      orElse: () => today,
    );
  }
}
