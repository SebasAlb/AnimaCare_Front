import 'package:animacare_front/presentation/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {

  ThemeController() {
    final storedTheme = _storage.read('isDarkMode') ?? false;
    themeMode = storedTheme ? ThemeMode.dark : ThemeMode.light;
  }
  final GetStorage _storage = GetStorage();
  late ThemeMode themeMode;

  void toggleTheme(bool isDark) {
    // Hacer síncrona si no hay awaits
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

// 🌞 Tema Claro - Basado en paleta sugerida
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  // Color de fondo del Scaffold (tu color base)
  scaffoldBackgroundColor: AppColors.backgroundLight,

  // Colores del esquema de colores (ColorScehme es el estándar moderno)
  colorScheme: ColorScheme.light(
    primary: AppColors.primaryBrand, // Tu nuevo azul profundo
    onPrimary: AppColors.onPrimary, // Blanco para texto/iconos sobre azul
    secondary: AppColors.secondaryBrand, // Tu Teal para acentos
    onSecondary: AppColors.onSecondary, // Blanco para texto/iconos sobre teal
    surface: AppColors.surface, // Blanco para superficies (tarjetas, etc.)
    onSurface: AppColors.onSurface, // Negro/Gris oscuro para texto/iconos sobre blanco
    error: AppColors.error, // Rojo para errores
    onError: AppColors.onError, // Blanco para texto/iconos sobre rojo
    background: AppColors.backgroundLight, // Mapear background también si se usa
    onBackground: AppColors.onSurface, // Texto/Iconos sobre el background
    // Otros colores útiles:
    surfaceContainerHighest: AppColors.inputFillLight, // Relleno de inputs
    // outline: Colors.grey, // Color para bordes
    // Añadir colores terciarios si se usan más de dos colores de acento
  ),

  // Propiedades heredadas/mapeadas de ColorScheme
  primaryColor: AppColors.primaryBrand, // Mapear old primary a la nueva primaryBrand
  cardColor: AppColors.surface, // Mapear cardColor a la nueva surface (blanco)
  shadowColor: Colors.black.withOpacity(0.2), // Usar un color de sombra con opacidad

  // Temas específicos de widgets
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.primaryBrand, // AppBar usa el nuevo color primario
    foregroundColor: AppColors.onPrimary, // Iconos/Texto de AppBar sobre el primario
    titleTextStyle: TextStyle( // Estilo del título del AppBar
        color: AppColors.onPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold),
    iconTheme: IconThemeData(color: AppColors.onPrimary), // Color de iconos en AppBar
  ),

  textTheme: TextTheme(
    // Definir estilos de texto que usen los colores "On"
    bodyMedium: TextStyle(color: AppColors.onSurface), // Texto normal sobre fondo/superficie
    titleLarge: TextStyle(color: AppColors.primaryBrand, fontWeight: FontWeight.bold, fontSize: 22), // Títulos grandes, quizás con el color primario
    labelLarge: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.bold), // Etiquetas/Headers de sección
    bodyLarge: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w600), // Texto ligeramente más grande o importante
    // Añadir otros estilos de texto (headlineLarge, titleMedium, bodySmall, labelSmall, etc.)
  ),

  iconTheme: IconThemeData(color: AppColors.onSurface), // Color por defecto de iconos (sobre fondo/superficie)

  // Otros temas de widgets si los necesitas (ej. ElevatedButtonTheme, TextButtonTheme, InputDecorationTheme)
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryBrand, // Fondo del botón primario
      foregroundColor: AppColors.onPrimary, // Texto del botón primario
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primaryBrand, // Color del texto del botón de texto
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.inputFillLight, // Relleno del campo de texto
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none, // O define un OutlineInputBorder temático
    ),
    hintStyle: TextStyle(color: AppColors.onSurface.withOpacity(0.6)), // Estilo del hint
    prefixIconColor: AppColors.onSurface.withOpacity(0.8), // Color por defecto para iconos prefix
  ),

);

// 🌙 Tema Oscuro - (Asegúrate de que este también use colores semánticos adecuados para el modo oscuro)
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.backgroundDark,
  // Colores del esquema de colores para modo oscuro
  colorScheme: ColorScheme.dark(
    primary: AppColors.oldHighlight, // Naranja vibrante como color primario oscuro
    onPrimary: Colors.black, // Texto/Iconos sobre naranja (negro para contraste)
    secondary: AppColors.eventVaccine, // Celeste vibrante como color secundario oscuro
    onSecondary: Colors.black, // Texto/Iconos sobre celeste (negro para contraste)
    surface: const Color(0xFF1E1E1E), // Gris muy oscuro para superficies
    onSurface: Colors.white70, // Gris claro para texto/iconos sobre superficies oscuras
    error: const Color(0xFFCF6679), // Rojo de error para modo oscuro
    onError: Colors.black, // Texto/Iconos sobre rojo de error
    background: AppColors.backgroundDark, // Mapear background también
    onBackground: Colors.white70, // Texto/Iconos sobre el background oscuro
    surfaceContainerHighest: Colors.grey.shade800, // Relleno de inputs oscuro
    // outline: Colors.grey.shade600, // Color para bordes oscuros si se usan
  ),
  primaryColor: AppColors.backgroundDark, // Mapear old primary
  cardColor: const Color(0xFF1E1E1E), // Tu color de tarjeta oscuro
  shadowColor: Colors.white12, // Sombra para modo oscuro

  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.backgroundDark, // AppBar oscuro
    foregroundColor: AppColors.primaryWhite, // Iconos/Texto de AppBar oscuro
    titleTextStyle: TextStyle(color: AppColors.primaryWhite, fontSize: 20, fontWeight: FontWeight.bold),
    iconTheme: IconThemeData(color: AppColors.primaryWhite),
  ),

  textTheme: TextTheme(
    bodyMedium: TextStyle(color: AppColors.onSurface),
    titleLarge: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.bold, fontSize: 22),
    labelLarge: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.w600),
  ),

  iconTheme: IconThemeData(color: AppColors.onSurface),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.backgroundDark, // Fondo del botón primario oscuro
      foregroundColor: AppColors.onSurface, // Texto del botón primario oscuro
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.oldHighlight, // Quizás usar oldHighlight para botones de texto en oscuro
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey.shade800, // Relleno del campo de texto oscuro
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(color: AppColors.onSurface.withOpacity(0.6)),
    prefixIconColor: AppColors.onSurface.withOpacity(0.8),
  ),

);
