import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> with WidgetsBindingObserver {
  static const _prefKey = 'theme_mode';

  ThemeCubit() : super(const ThemeState(ThemeMode.system)) {
    WidgetsBinding.instance.addObserver(this);
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefKey);
    if (saved == 'light') {
      emit(const ThemeState(ThemeMode.light));
    } else if (saved == 'dark') {
      emit(const ThemeState(ThemeMode.dark));
    }
    // else stay system
  }

  Future<void> setLight() async {
    emit(const ThemeState(ThemeMode.light));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, 'light');
  }

  Future<void> setDark() async {
    emit(const ThemeState(ThemeMode.dark));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, 'dark');
  }

  Future<void> setSystem() async {
    emit(const ThemeState(ThemeMode.system));
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefKey);
  }

  void toggle() {
    final isDark =
        state.themeMode == ThemeMode.dark ||
        (state.themeMode == ThemeMode.system &&
            WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                Brightness.dark);
    if (isDark) {
      setLight();
    } else {
      setDark();
    }
  }

  @override
  void didChangePlatformBrightness() {
    // Only react to system changes if user hasn't manually picked a mode
    if (state.themeMode == ThemeMode.system) {
      // Re-emit system so MaterialApp re-evaluates brightness
      emit(const ThemeState(ThemeMode.system));
    }
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }
}
