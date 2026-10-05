import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../helpers/safe_cubit.dart';
import '../../helpers/shared_preferences_helper.dart';

@singleton
class ThemeCubit extends SafeCubit<ThemeMode> {
  final SharedPreferencesHelper _prefs;

  ThemeCubit(this._prefs) : super(_getInitialTheme(_prefs));

  static ThemeMode _getInitialTheme(SharedPreferencesHelper prefs) {
    final stored = prefs.getTheme();
    if (stored == ThemeMode.dark.name) return ThemeMode.dark;
    if (stored == ThemeMode.light.name) return ThemeMode.light;
    return ThemeMode.light;
  }

  void toggle(ThemeMode newTheme) async {
    await _prefs.setTheme(newTheme.name);
    emit(newTheme);
  }
}
