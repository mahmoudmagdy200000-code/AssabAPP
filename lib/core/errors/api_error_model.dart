abstract class BaseApiErrorModel {
  String get getErrorMessage;
  final String? message;
  final Map<String, dynamic>? errors;

  BaseApiErrorModel({required this.message, required this.errors});
}

class DioErrorModel implements BaseApiErrorModel {
  @override
  final String? message;
  @override
  final Map<String, dynamic>? errors;

  DioErrorModel({required this.message, this.errors});

  factory DioErrorModel.fromJson(Map<String, dynamic> json) {
    return DioErrorModel(
      message: json['message'] as String?,
      errors: json['errors'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'errors': errors};
  }

  @override
  String get getErrorMessage {
    if (errors == null || errors!.isEmpty) {
      return message ?? 'An unexpected error occurred';
    }

    try {
      return errors!.entries.map((e) => "${e.value.join(',')}").join('\n');
    } catch (e) {
      return message ?? 'An unexpected error occurred';
    }
  }
}

class RealtimeErrorModel implements BaseApiErrorModel {
  @override
  final String? message;
  @override
  final Map<String, dynamic>? errors;

  RealtimeErrorModel({required this.message, this.errors});

  @override
  String get getErrorMessage => message ?? 'An unexpected error occurred';
}

class LocalErrorModel implements BaseApiErrorModel {
  @override
  final String? message;
  @override
  final Map<String, dynamic>? errors;

  LocalErrorModel({required this.message, this.errors});

  @override
  String get getErrorMessage => message ?? 'An unexpected error occurred';
}
