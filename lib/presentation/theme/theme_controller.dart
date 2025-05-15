import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'colors.dart';
class ThemeController extends GetxController {
  final _storage = GetStorage();
  late ThemeMode themeMode;

  ThemeController() {
    final storedTheme = _storage.read('isDarkMode') ?? false;
    themeMode = storedTheme ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme(bool isDark) { // Hacer síncrona si no hay awaits
    // --- ELIMINAR EL DIÁLOGO Y LA PAUSA INTENCIONAL ---
    // Get.dialog(
    //   const Center(child: CircularProgressIndicator()),
    //   barrierDismissible: false,
    // );
    // await Future.delayed(const Duration(milliseconds: 800)); // <-- ¡ELIMINAR!

    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _storage.write('isDarkMode', isDark);

    // update() notificará a los GetBuilder y a GetMaterialApp (via builder)
    // que el estado ha cambiado, lo que activa AnimatedTheme.
    update();

    // --- ELIMINAR EL CIERRE DEL DIÁLOGO ---
    // Get.back(); // <-- ELIMINAR!
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
    labelLarge: TextStyle(color: Colors.black87), // Asegúrate de tener labelLarge
    bodyLarge: TextStyle(color: Colors.black87), // Asegúrate de tener bodyLarge
  ),
  iconTheme: const IconThemeData(color: Colors.black87),
  colorScheme: ColorScheme.light(
    primary: AppColors.header,
    secondary: AppColors.labelBackground,
    onPrimary: AppColors.primaryWhite, // Color para texto/iconos sobre el color primario
    surfaceContainerHighest: Colors.grey.shade200, // Un color para rellenos de input/superficies elevadas
  ),
  shadowColor: Colors.black, // Define color de sombra en el tema
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
    labelLarge: TextStyle(color: Colors.white70), // Asegúrate de tener labelLarge
    bodyLarge: TextStyle(color: Colors.white70), // Asegúrate de tener bodyLarge
  ),
  iconTheme: const IconThemeData(color: Colors.white70),
  colorScheme: ColorScheme.dark(
    primary: AppColors.oldHeader, // O tu color primario en modo oscuro
    secondary: AppColors.oldHighlight,
    onPrimary: Colors.white, // Color para texto/iconos sobre el color primario oscuro
    surfaceContainerHighest: Colors.grey.shade800, // Un color oscuro para rellenos de input/superficies elevadas
  ),
);

