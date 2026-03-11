import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final SharedPreferences sharedPreferences;

  ThemeCubit(this.sharedPreferences) : super(ThemeMode.light) {
    _loadTheme();
  }

  void _loadTheme() {
    final isDark = sharedPreferences.getBool(AppConstants.themeModeKey) ?? false;
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleTheme() {
    final isDark = state == ThemeMode.dark;
    final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
    sharedPreferences.setBool(AppConstants.themeModeKey, !isDark);
    emit(newMode);
  }

  bool get isDark => state == ThemeMode.dark;
}
