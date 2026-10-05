import 'package:equatable/equatable.dart';

class ValidationState extends Equatable {
  final Map<String, bool?> fieldsValidity;
  final Map<String, String> fieldsValue;
  final Map<String, dynamic> fieldsValueTyped;
  final bool enableButton;

  const ValidationState({
    this.fieldsValidity = const {},
    this.fieldsValue = const {},
    this.fieldsValueTyped = const {},
    this.enableButton = false,
  });

  ValidationState copyWith({
    Map<String, bool?>? fieldsValidity,
    Map<String, String>? fieldsValue,
    Map<String, dynamic>? fieldsValueTyped,
    bool? enableButton,
  }) {
    return ValidationState(
      fieldsValidity: fieldsValidity ?? this.fieldsValidity,
      fieldsValue: fieldsValue ?? this.fieldsValue,
      fieldsValueTyped: fieldsValueTyped ?? this.fieldsValueTyped,
      enableButton: enableButton ?? this.enableButton,
    );
  }

  /// Get typed value with specific type (supports Model classes)
  T? getTypedValue<T>(String fieldName) {
    final value = fieldsValueTyped[fieldName];
    return value is T ? value : null;
  }

  /// Get list value with specific type (supports List of Model classes)
  List<T>? getListValue<T>(String fieldName) {
    final value = fieldsValueTyped[fieldName];
    if (value is List) {
      return value.whereType<T>().toList();
    }

    return null;
  }

  /// Check if list field has items
  bool hasListItems(String fieldName) {
    final value = fieldsValueTyped[fieldName];
    return value is List && value.isNotEmpty;
  }

  /// Get list length for a field
  int getListLength(String fieldName) {
    final value = fieldsValueTyped[fieldName];
    return value is List ? value.length : 0;
  }

  @override
  List<Object> get props => [
    fieldsValidity,
    fieldsValue,
    fieldsValueTyped,
    enableButton,
  ];
}
