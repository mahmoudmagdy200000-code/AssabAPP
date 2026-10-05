import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../helpers/safe_cubit.dart';
import '../../helpers/shared_preferences_helper.dart';

@LazySingleton()
class LocaleCubit extends SafeCubit<Locale> {
  final SharedPreferencesHelper _prefs;

  LocaleCubit(this._prefs) : super(Locale(_prefs.getLanguageCode()));

  void setLocale(String languageCode) async {
    if (languageCode != state.languageCode) {
      await _prefs.setLanguageCode(languageCode);
      emit(Locale(languageCode));
    }
  }

  bool get isArabic => state.languageCode == 'ar';
}
