import 'package:base_code/app/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final ThemeMode themeMode;
  final Locale locale;

  SettingsState({required this.themeMode, required this.locale});

  SettingsState copyWith({ThemeMode? themeMode, Locale? locale}) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
      : super(SettingsState(
            themeMode: ThemeMode.system, locale: const Locale('en'))) {
    loadFromStorage();
  }

  Future<void> loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString(LocalPrefsKey.THEME_MODE) ?? 'system';
    final lang = prefs.getString(LocalPrefsKey.LANGUAGE) ?? 'en';

    emit(SettingsState(
      themeMode: _stringToThemeMode(theme),
      locale: Locale(lang),
    ));
  }

  Future<void> updateTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(LocalPrefsKey.THEME_MODE, _themeModeToString(mode));
    emit(state.copyWith(themeMode: mode));
  }

  Future<void> updateLanguage(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(LocalPrefsKey.LANGUAGE, locale.languageCode);
    emit(state.copyWith(locale: locale));
  }

  static ThemeMode _stringToThemeMode(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
      default:
        return 'system';
    }
  }
}
