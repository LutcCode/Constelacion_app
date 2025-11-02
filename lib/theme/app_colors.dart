// lib/theme/app_colors.dart

import 'package:flutter/material.dart';

class AppColors {
  // Evita que alguien pueda instanciar esta clase
  AppColors._();

  // --- Colores Principales de la Marca ---
  static const Color primary = Color(0xFF5B506C); // Un morado personalizado
  static const Color primaryVariant = Color(0xFFC6C4DD);
  static const Color secondary = Color(0xFFB1A4C3); // Un cyan

  // --- Colores de Fondo ---
  static const Color background = Color(0xFFF2EBFA); // Blanco
  static const Color surface = Color(0xFFE6DDF0);

  // --- Colores de Texto y Elementos ---
  static const Color onPrimary = Colors.white;
  static const Color onSecondary = Colors.black;
  static const Color onBackground = Colors.black;
  static const Color error = Color(0xFF493759);

  // --- Colores Neutrales ---
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  static const Color border = Color(0xFFE2D3F2);
}