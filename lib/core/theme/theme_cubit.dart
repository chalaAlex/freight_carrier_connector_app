import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> with WidgetsBindingObserver {
  ThemeCubit() : super(const ThemeState(ThemeMode.system)) {
    WidgetsBinding.instance.addObserver(this);
  }

  /// Called when system theme changes
  @override
  void didChangePlatformBrightness() {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;

    if (brightness == Brightness.dark) {
      emit(const ThemeState(ThemeMode.dark));
    } else {
      emit(const ThemeState(ThemeMode.light));
    }
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }
}
