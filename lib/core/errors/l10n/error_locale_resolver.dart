import '../../cubits/locale/locale_cubit.dart';
import 'error_messages.dart';
import '../../di/dependency_injection.dart';

class ErrorLocaleResolver {
  ErrorLocaleResolver._();

  static String resolve(ErrorMessageKey key) {
    return ErrorMessages.resolve(key, currentLanguage);
  }

  static String get currentLanguage => getIt.isRegistered<LocaleCubit>()
      ? getIt<LocaleCubit>().state.languageCode
      : 'en';
}
