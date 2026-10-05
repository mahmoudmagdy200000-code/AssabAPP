import '../../cubits/locale/locale_cubit.dart';
import 'error_messages.dart';
import '../../di/dependency_injection.dart';

class ErrorLocaleResolver {
  ErrorLocaleResolver._();

  static LocaleCubit get _cubit => getIt<LocaleCubit>();

  static String resolve(ErrorMessageKey key) {
    final languageCode = _cubit.state.languageCode;
    return ErrorMessages.resolve(key, languageCode);
  }

  static String get currentLanguage => _cubit.state.languageCode;
}
