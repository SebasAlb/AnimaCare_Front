import 'package:animacare_front/presentation/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final GetStorage _storage = GetStorage();

  // Usando Rx para hacer el tema reactivo
  final Rx<ThemeMode> _themeMode = ThemeMode.light.obs;

  // Getter para acceder al tema actual
  ThemeMode get themeMode => _themeMode.value;

  ThemeController() {
    final storedTheme = _storage.read('isDarkMode') ?? false;
    _themeMode.value = storedTheme ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme(bool isDark) {
    final newMode = isDark ? ThemeMode.dark : ThemeMode.light;
    if (_themeMode.value == newMode) return;

    _themeMode.value = newMode;
    _storage.write('isDarkMode', isDark);
    // No necesitamos llamar a update() cuando usamos variables Rx
  }
}

// Los temas se mantienen igual
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.backgroundLight,
  colorScheme: const ColorScheme.light(
    primary: AppColors.primaryBrand,
    secondary: AppColors.accentCoral,
    onSecondary: AppColors.onSecondary,
    onSurface: AppColors.onSurface,
    surfaceContainerHighest: AppColors.inputFillLight,
  ),
  primaryColor: AppColors.headerLight,
  cardColor: AppColors.surface,
  shadowColor: Colors.black.withOpacity(0.2),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primaryBrand,
    foregroundColor: AppColors.onPrimary,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: AppColors.onPrimary,
    ),
    iconTheme: IconThemeData(color: AppColors.onPrimary),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: AppColors.onSurface),
    titleLarge: TextStyle(
      color: AppColors.primaryBrand,
      fontWeight: FontWeight.bold,
      fontSize: 22,
    ),
    labelLarge:
    TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.bold),
    bodyLarge:
    TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w600),
  ),
  iconTheme: const IconThemeData(color: AppColors.onSurface),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryBrand,
      foregroundColor: AppColors.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primaryBrand,
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.inputFillLight,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(color: AppColors.onSurface.withOpacity(0.6)),
    prefixIconColor: AppColors.onSurface.withOpacity(0.8),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.backgroundDark,
  colorScheme: ColorScheme.dark(
    primary: AppColors.eventMedicine,
    secondary: AppColors.secondaryDark,
    surface: AppColors.surfaceDark,
    onSurface: AppColors.onSurfaceDark,
    surfaceContainerHighest: AppColors.inputFillDark,
  ),
  primaryColor: AppColors.headerDark,
  cardColor: AppColors.surfaceDark,
  shadowColor: Colors.white12,
  iconTheme: const IconThemeData(color: AppColors.onSurfaceDark),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.eventMedicine,
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.secondaryDark,
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.inputFillDark,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(color: AppColors.onSurfaceDark.withOpacity(0.6)),
    prefixIconColor: AppColors.onSurfaceDark.withOpacity(0.8),
  ),
);