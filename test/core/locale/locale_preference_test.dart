import 'package:assab/core/cubits/locale/locale_cubit.dart';
import 'package:assab/core/helpers/shared_preferences_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Arabic and English choices persist across cubit recreation', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = SharedPreferencesHelper(Logger(level: Level.off));
    await prefs.init();
    final cubit = LocaleCubit(prefs);

    final arabic = cubit.stream.firstWhere((locale) => locale.languageCode == 'ar');
    cubit.setLocale('ar');
    await arabic;
    expect(LocaleCubit(prefs).state.languageCode, 'ar');

    final english = cubit.stream.firstWhere((locale) => locale.languageCode == 'en');
    cubit.setLocale('en');
    await english;
    expect(LocaleCubit(prefs).state.languageCode, 'en');
    await cubit.close();
  });
}
