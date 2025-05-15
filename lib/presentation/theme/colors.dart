import 'package:flutter/material.dart';

class AppColors {
  // 🎨 Paleta original (comentada para futura referencia)
  static const Color oldBackground = Color(0xFFA6DCEF);
  static const Color oldSecondary = Color(0xFF75C9C8);
  static const Color oldHighlight = Color(0xFFFFA726);


  static const Color header = Color(0xFF301B92); // Header (Turquesa oscuro)
  static const Color cardBackground = Colors.white; // Fondo de tarjetas
  static const Color labelBackground =
      Color(0xFF35919E); // Fondo de label eventos
  static const Color primaryWhite = Colors.white; // Blanco principal


  // 🎨 Paleta base y fondos
  static const Color backgroundLight = Color(0xFF4DD0E2); // Tu fondo Cyan
  static const Color backgroundDark = Color(0xFF047B8A); // Tu fondo oscuro

  // 🎨 Colores Core (sugeridos para el modo claro)
  static const Color primaryBrand = Color(0xFF023E8A); // Azul profundo (ej. Header, Botones Primarios)
  static const Color secondaryBrand = Color(0xFF35919E); // Tu Teal (ej. Acentos secundarios)
  static const Color surface = Colors.white; // Fondo de tarjetas, dialogos, etc.
  static const Color onPrimary = Colors.white; // Texto/Iconos sobre PrimaryBrand
  static const Color onSecondary = Colors.white; // Texto/Iconos sobre SecondaryBrand
  static const Color onSurface = Colors.black87; // Texto/Iconos sobre Surface (blanco)
  static const Color error = Color(0xFFB00020); // Rojo estándar para errores
  static const Color onError = Colors.white; // Texto/Iconos sobre Error
  static const Color inputFillLight = Color(0xFFF0F4F8); // Gris muy claro para rellenos de input en modo claro (opcional, puedes usar surfaceContainerHighest)


  // 🎨 Colores de eventos (mantener si son específicos)
  static const Color eventBath = Color(0xFF4FC3F7); // Eventos de baño (Azul claro)
  static const Color eventVetConsult = Color(0xFF81C784); // Consultas veterinarias (Verde pastel)
  static const Color eventMedicine = Color(0xFFFFA726); // Medicinas (Amarillo pastel - buen acento)
  static const Color eventVaccine = Color(0xFF64B5F6); // Vacunas (Celeste)
  static const Color eventOther = Color(0xFFBA68C8); // Otros eventos (Púrpura claro)

  // 🎨 Colores de resaltado (mantener si son específicos)
  static const Color markerBorder = Color(0xFFFFD54F); // Resaltado de días cargados (Amarillo dorado pastel - buen acento)
  static const Color selectedDay = Color(0xFF023E8A); // Día seleccionado (Usar el nuevo primario para consistencia, o mantener si tiene un rol visual único)

  // 🎨 Botones y acciones (mapear en el tema)
  static const Color formatButtonBackground = Colors.white; // Esto debería venir de Surface o CardColor
  static const Color formatButtonForeground = Color(0xFF35919E); // Esto debería venir de OnSurface o Secondary

  // 🎨 Otros
  static const Color transparent = Colors.transparent;

// Puedes añadir otros colores semánticos si es necesario, como:
// static const Color outline = Colors.grey;
// static const Color disabled = Colors.grey;
}
