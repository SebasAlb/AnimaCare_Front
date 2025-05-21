import 'package:flutter/material.dart';

class AppColors {
  // 🧱 Fondos base
  static const Color backgroundDark = Color(0xFF047B8A); // Teal profundo

  // 🎨 Headers
  static const Color headerLight = Color(0xFF27069F); // Azul oscuro vibrante
  static const Color headerDark = Color(0xFF376103); // Verde oscuro neutro

  // 🧊 Colores de superficie
  static const Color cardBackground = Colors.white;
  static const Color surface = Colors.white;
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // 🎯 Texto/iconos sobre fondo
  static const Color onSurface = Colors.black87;
  static const Color onSurfaceDark = Colors.white70;
  static const Color onPrimary = Colors.white;
  static const Color onSecondary = Colors.white;
  static const Color onError = Colors.white;

  // 🌈 Colores principales
  static const Color primaryBrand = Color(0xFF023E8A); // Azul profundo
  static const Color secondaryBrand = Color(0xFF35919E); // Teal

  // 🌞 Tema claro - acento cálido para contraste
  static const Color accentCoral = Color(0xFFFF8A65); // Coral (naranja suave)

  // 🌙 Tema oscuro - acento frío contrastante
  static const Color secondaryDark = Color(0xFF80CBC4); // Teal claro

  // 🧪 Inputs
  static const Color inputFillLight = Color(0xFFF0F4F8); // Claro
  static final Color inputFillDark = Colors.grey.shade800;

  // 🚨 Errores
  static const Color error = Color(0xFFB00020);
  static const Color errorDark = Color(0xFFCF6679);

  // 📌 Eventos
  static const Color eventBath = Color(0xFF4FC3F7);
  static const Color eventVetConsult = Color(0xFF81C784);
  static const Color eventMedicine = Color(0xFFFFA726);
  static const Color eventVaccine = Color(0xFF64B5F6);
  static const Color eventOther = Color(0xFFBA68C8);

  // ✨ Resaltados
  static const Color markerBorder = Color(0xFFFFD54F);
  static const Color selectedDay = Color(0xFF023E8A);

  // 🎛️ Botones
  static const Color formatButtonBackground = Colors.white;
  static const Color formatButtonForeground = Color(0xFF35919E);

  // 🔲 Misceláneo
  static const Color transparent = Colors.transparent;

  // Para íconos/textos en tarjetas modo claro
  static const Color petCardIconLight = primaryBrand;

// Para íconos/textos en tarjetas modo oscuro
  static const Color petCardIconDark = eventMedicine;
}
