import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'colors.dart'; // Asegúrate de importar tu paleta
class ThemeController extends GetxController {
  final _storage = GetStorage();
  late ThemeMode themeMode;

  ThemeController() {
    final storedTheme = _storage.read('isDarkMode') ?? false;
    themeMode = storedTheme ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme(bool isDark) async {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    await Future.delayed(const Duration(milliseconds: 800));
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _storage.write('isDarkMode', isDark);
    update();

    Get.back();
  }
}

// 🌞 Tema Claro - cyan / celeste
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.background,
  primaryColor: AppColors.header,
  cardColor: AppColors.cardBackground,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.header,
    foregroundColor: AppColors.primaryWhite,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.black87),
    titleLarge: TextStyle(color: Colors.black87),
  ),
  iconTheme: const IconThemeData(color: Colors.black87),
  colorScheme: ColorScheme.light(
    primary: AppColors.header,
    secondary: AppColors.labelBackground,
  ),
);

// 🌙 Tema Oscuro - morado + amarillo para resaltar
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.oldHeader,
  primaryColor: AppColors.oldHeader,
  cardColor: const Color(0xFF1E1E1E),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.oldHeader,
    foregroundColor: AppColors.primaryWhite,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.white70),
    titleLarge: TextStyle(color: Colors.white),
  ),
  iconTheme: const IconThemeData(color: Colors.white70),
  colorScheme: ColorScheme.dark(
    primary: AppColors.oldHeader,
    secondary: AppColors.oldHighlight, // Amarillo pastel para detalles
  ),
);

