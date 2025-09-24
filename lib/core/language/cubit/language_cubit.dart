import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  static const String _languageCodeKey = 'language_code';

  LanguageCubit() : super(const LanguageLoaded(Locale('en'))) {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageCodeKey);
    if (languageCode != null) {
      emit(LanguageLoaded(Locale(languageCode)));
    } else {
      emit(const LanguageLoaded(Locale('en')));
    }
  }

  Future<void> changeLanguage(Locale newLocale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageCodeKey, newLocale.languageCode);
    emit(LanguageLoaded(newLocale));
  }
}
