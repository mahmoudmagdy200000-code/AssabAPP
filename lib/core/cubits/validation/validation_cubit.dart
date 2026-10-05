import 'package:assab/core/utils/app_logger.dart';

import '../../helpers/safe_cubit.dart';
import 'validation_state.dart';

class ValidationCubit extends SafeCubit<ValidationState> {
  final Set<String> _requiredFields;
  final Set<String> _optionalFields;

  bool _isEmitting = false;

  ValidationCubit({
    required Set<String> requiredFields,
    Set<String> optionalFields = const {},
  }) : _requiredFields = {...requiredFields},
       _optionalFields = {...optionalFields},
       super(const ValidationState());

  void validateFieldAndStoreValue({
    required String fieldName,
    required String value,
    bool? isValid,
    bool log = false,
  }) {
    final updatedValidity = Map<String, bool?>.from(state.fieldsValidity);
    final updatedValue = Map<String, String>.from(state.fieldsValue);

    if (isValid != null) updatedValidity[fieldName] = isValid;
    updatedValue[fieldName] = value;

    final stack = StackTrace.current;

    if (log) {
      AppLogger.log(
        tag: 'ValidationCubit',
        'validateFieldAndStoreValue: Field $fieldName validated as ${isValid != null ? (isValid ? 'valid' : 'invalid') : 'unchanged'} with value "$value"\nStackTrace:\n$stack',
      );
    }

    _emitWithValidation(updatedValidity, updatedValue);
  }

  /// Validate field and store value with specific type
  void validateFieldAndStoreTypedValue<T>({
    required String fieldName,
    required T value,
    bool? isValid,
    bool log = false,
  }) {
    final updatedValidity = Map<String, bool?>.from(state.fieldsValidity);
    final updatedTypedValue = Map<String, dynamic>.from(state.fieldsValueTyped);

    if (isValid != null) updatedValidity[fieldName] = isValid;
    updatedTypedValue[fieldName] = value;

    if (log) {
      AppLogger.log(
        tag: 'ValidationCubit',
        'validateFieldAndStoreTypedValue<$T>: Field $fieldName validated as ${isValid != null ? (isValid ? 'valid' : 'invalid') : 'unchanged'} with value "$value"',
      );
    }

    _emitWithValidationTyped(
      updatedValidity,
      state.fieldsValue,
      updatedTypedValue,
    );
  }

  /// Validate field and store list with specific type
  void validateFieldAndStoreList<T>({
    required String fieldName,
    required List<T> value,
    bool? isValid,
    bool log = false,
  }) {
    final updatedValidity = Map<String, bool?>.from(state.fieldsValidity);
    final updatedTypedValue = Map<String, dynamic>.from(state.fieldsValueTyped);

    if (isValid != null) updatedValidity[fieldName] = isValid;
    updatedTypedValue[fieldName] = value;

    if (log) {
      AppLogger.log(
        tag: 'ValidationCubit',
        'validateFieldAndStoreList<$T>: Field $fieldName validated as ${isValid != null ? (isValid ? 'valid' : 'invalid') : 'unchanged'} with ${value.length} items',
      );
    }

    _emitWithValidationTyped(
      updatedValidity,
      state.fieldsValue,
      updatedTypedValue,
    );
  }

  void validateField(String fieldName, bool isValid, {bool log = false}) {
    final updatedValidity = Map<String, bool?>.from(state.fieldsValidity)
      ..[fieldName] = isValid;

    final stack = StackTrace.current;

    if (log) {
      AppLogger.log(
        tag: 'ValidationCubit',
        'validateField: Field $fieldName validated as ${isValid ? 'valid' : 'invalid'}\nStackTrace:\n$stack',
      );
    }

    _emitWithValidation(updatedValidity, state.fieldsValue);
  }

  void toggleFieldRequirement(String fieldName, {required bool isRequired}) {
    final updatedValidity = Map<String, bool?>.from(state.fieldsValidity);

    if (isRequired) {
      AppLogger.log(
        tag: 'ValidationCubit',
        'toggleFieldRequirement: Making $fieldName required',
      );
      _optionalFields.remove(fieldName);
      _requiredFields.add(fieldName);
      updatedValidity[fieldName] ??= false;
    } else {
      AppLogger.log(
        tag: 'ValidationCubit',
        'toggleFieldRequirement: Making $fieldName optional',
      );
      _requiredFields.remove(fieldName);
      _optionalFields.add(fieldName);
    }

    _emitWithValidation(updatedValidity, state.fieldsValue);
  }

  void addDynamicFields(Set<String> fields) {
    _requiredFields.addAll(fields);
    final updatedValidity = Map<String, bool?>.from(state.fieldsValidity);
    for (final field in fields) {
      updatedValidity.putIfAbsent(field, () => false);
    }

    for (final field in fields) {
      AppLogger.log('addDynamicFields: Field $field added as required');
    }

    _emitWithValidation(updatedValidity, state.fieldsValue);
  }

  void removeDynamicFields(Set<String> fields) {
    _requiredFields.removeAll(fields);
    final updatedValidity = Map<String, bool?>.from(state.fieldsValidity)
      ..removeWhere((key, _) => fields.contains(key));

    final updatedValues = Map<String, String>.from(state.fieldsValue)
      ..removeWhere((key, _) => fields.contains(key));

    for (final field in fields) {
      AppLogger.log(
        tag: 'ValidationCubit',
        'removeDynamicFields: Removed fields $field from validation',
      );
    }

    _emitWithValidation(updatedValidity, updatedValues);
  }

  void _emitWithValidation(
    Map<String, bool?> updatedValidity,
    Map<String, String> updatedValues,
  ) {
    if (_isEmitting) {
      AppLogger.log('Skipped emit: Another emit is in progress');
      return;
    }

    if (isClosed) {
      AppLogger.log(
        tag: 'ValidationCubit',
        'Skipped emit: Cubit is already closed',
      );
      return;
    }

    _isEmitting = true;

    try {
      final allRequiredPresent = updatedValidity.keys.toSet().containsAll(
        _requiredFields,
      );

      final allRequiredValid = updatedValidity.entries
          .where((e) => _requiredFields.contains(e.key))
          .every((e) => e.value ?? false);

      _logFieldsReuiredNotValidated();

      AppLogger.log(
        tag: 'ValidationCubit',
        '_emitWithValidation: allRequiredPresent=$allRequiredPresent, allRequiredValid=$allRequiredValid',
      );

      emit(
        state.copyWith(
          fieldsValidity: updatedValidity,
          fieldsValue: updatedValues,
          enableButton:
              allRequiredPresent &&
              allRequiredValid &&
              state.fieldsValidity.values.any((v) => v == true),
        ),
      );
    } finally {
      _isEmitting = false;
    }
  }

  void _emitWithValidationTyped(
    Map<String, bool?> updatedValidity,
    Map<String, String> updatedValues,
    Map<String, dynamic> updatedTypedValues,
  ) {
    if (_isEmitting) {
      AppLogger.log(
        tag: 'ValidationCubit',
        'Skipped emit: Another emit is in progress',
      );
      return;
    }

    if (isClosed) {
      AppLogger.log(
        tag: 'ValidationCubit',
        'Skipped emit: Cubit is already closed',
      );
      return;
    }

    _isEmitting = true;

    try {
      final allRequiredPresent = updatedValidity.keys.toSet().containsAll(
        _requiredFields,
      );

      final allRequiredValid = updatedValidity.entries
          .where((e) => _requiredFields.contains(e.key))
          .every((e) => e.value ?? false);

      _logFieldsReuiredNotValidated();

      emit(
        state.copyWith(
          fieldsValidity: updatedValidity,
          fieldsValue: updatedValues,
          fieldsValueTyped: updatedTypedValues,
          enableButton:
              allRequiredPresent &&
              allRequiredValid &&
              state.fieldsValidity.values.any((v) => v == true),
        ),
      );
    } finally {
      _isEmitting = false;
    }
  }

  void updateFieldValue(String fieldName, String value) {
    final updatedValue = Map<String, String>.from(state.fieldsValue);
    updatedValue[fieldName] = value;

    _emitWithValidation(state.fieldsValidity, updatedValue);
  }

  bool fieldIsRequired(String fieldName) {
    return _requiredFields.contains(fieldName);
  }

  void resetFieldValidity(String fieldName) {
    final updatedValidity = Map<String, bool?>.from(state.fieldsValidity);
    updatedValidity[fieldName] = false;

    _emitWithValidation(updatedValidity, state.fieldsValue);
  }

  bool fieldIsExists(String fieldName) {
    return state.fieldsValidity.containsKey(fieldName);
  }

  String? errorMsg(bool? value, String msg) {
    return value != null ? (value ? null : msg) : null;
  }

  bool fieldIsValid(String fieldName) {
    return state.fieldsValidity[fieldName] == true;
  }

  String getFieldValue(String fieldName) {
    return state.fieldsValue[fieldName] ?? '';
  }

  /// Get typed value with specific type (supports Model classes)
  T? getTypedValue<T>(String fieldName) {
    return state.getTypedValue<T>(fieldName);
  }

  /// Get list value with specific type (supports List of Model classes)
  List<T>? getListValue<T>(String fieldName) {
    return state.getListValue<T>(fieldName);
  }

  /// Check if a typed field exists
  bool typedFieldExists(String fieldName) {
    return state.fieldsValueTyped.containsKey(fieldName);
  }

  /// Update typed value without changing validity
  void updateTypedValue<T>(String fieldName, T value) {
    final updatedTypedValue = Map<String, dynamic>.from(state.fieldsValueTyped);
    updatedTypedValue[fieldName] = value;

    _emitWithValidationTyped(
      state.fieldsValidity,
      state.fieldsValue,
      updatedTypedValue,
    );
  }

  /// Remove typed field value
  void removeTypedField(String fieldName) {
    final updatedTypedValue = Map<String, dynamic>.from(state.fieldsValueTyped)
      ..remove(fieldName);

    final updatedValidity = Map<String, bool?>.from(state.fieldsValidity)
      ..remove(fieldName);

    _emitWithValidationTyped(
      updatedValidity,
      state.fieldsValue,
      updatedTypedValue,
    );
  }

  void _logFieldsReuiredNotValidated() {
    final notValidated = _requiredFields.where((field) {
      final isValid = state.fieldsValidity[field];
      return isValid != true;
    }).toList();

    if (notValidated.isNotEmpty) {
      AppLogger.log(
        tag: 'ValidationCubit',
        'Validation failed: The following required fields are not valid: ${notValidated.join(', ')}',
      );
    }
  }

  Set<String> get requiredFields => _requiredFields;

  Set<String> get optionalFields => _optionalFields;

  @override
  Future<void> close() {
    _requiredFields.clear();
    _optionalFields.clear();
    return super.close();
  }
}
