enum ErrorMessageKey {
  noInternet,
  timeout,
  invalidFormat,
  badRequest,
  unauthorized,
  forbidden,
  validationFailed,
  notFound,
  serverError,
  sessionExpired,
  connectionClosed,
  unexpected,
  cached,
}

class ErrorMessages {
  const ErrorMessages._();

  static const Map<ErrorMessageKey, Map<String, String>> _messages = {
    ErrorMessageKey.noInternet: {
      'en': 'No internet connection. Please check your network and try again.',
      'ar': 'لا يوجد اتصال بالإنترنت. يرجى التحقق من الشبكة والمحاولة مجدداً.',
    },
    ErrorMessageKey.timeout: {
      'en': 'The request took too long. Please try again.',
      'ar': 'استغرق الطلب وقتاً طويلاً. يرجى المحاولة مجدداً.',
    },
    ErrorMessageKey.invalidFormat: {
      'en': 'Something went wrong with the response. Please try again.',
      'ar': 'حدث خطأ في البيانات المستلمة. يرجى المحاولة مجدداً.',
    },
    ErrorMessageKey.badRequest: {
      'en': 'Your request could not be processed. Please check your input.',
      'ar': 'تعذّر معالجة طلبك. يرجى التحقق من البيانات المدخلة.',
    },
    ErrorMessageKey.unauthorized: {
      'en': 'You are not authorized. Please log in and try again.',
      'ar': 'غير مصرح لك بالدخول. يرجى تسجيل الدخول والمحاولة مجدداً.',
    },
    ErrorMessageKey.forbidden: {
      'en': 'You do not have permission to perform this action.',
      'ar': 'ليس لديك صلاحية للقيام بهذه العملية.',
    },
    ErrorMessageKey.validationFailed: {
      'en': 'Some fields are invalid. Please review your input and try again.',
      'ar': 'بعض الحقول غير صحيحة. يرجى مراجعة البيانات والمحاولة مجدداً.',
    },
    ErrorMessageKey.notFound: {
      'en': 'The requested item could not be found.',
      'ar': 'لم يتم العثور على العنصر المطلوب.',
    },
    ErrorMessageKey.serverError: {
      'en': 'A server error occurred. Please try again later.',
      'ar': 'حدث خطأ في الخادم. يرجى المحاولة لاحقاً.',
    },
    ErrorMessageKey.sessionExpired: {
      'en': 'Your session has expired. Please log in again.',
      'ar': 'انتهت صلاحية جلستك. يرجى تسجيل الدخول مجدداً.',
    },
    ErrorMessageKey.connectionClosed: {
      'en': 'The connection was closed unexpectedly. Please try again.',
      'ar': 'أُغلق الاتصال بشكل غير متوقع. يرجى المحاولة مجدداً.',
    },
    ErrorMessageKey.cached: {
      'en': 'Could not load saved data. Please try again.',
      'ar': 'تعذّر تحميل البيانات المحفوظة. يرجى المحاولة مجدداً.',
    },
    ErrorMessageKey.unexpected: {
      'en': 'An unexpected error occurred. Please try again.',
      'ar': 'حدث خطأ غير متوقع. يرجى المحاولة مجدداً.',
    },
  };

  static String resolve(ErrorMessageKey key, String languageCode) {
    final translations =
        _messages[key] ?? _messages[ErrorMessageKey.unexpected]!;
    return translations[languageCode] ?? translations['en']!;
  }

  static const List<String> supportedLanguages = ['en', 'ar'];
}
