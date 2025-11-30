// lib/theme/app_colors.dart

import 'package:flutter/material.dart';

class AppColors {
  // Evita que alguien pueda instanciar esta clase
  AppColors._();

  // --- Colores Principales de la Marca ---
  static const Color primary = Color(0xFF121E4C); // Un morado personalizado
  static const Color primaryVariant = Color(0xFFB9BAD5);
  static const Color secondary = Color(0xFF9897BA); // Un cyan

  // --- Colores de Fondo ---
  static const Color background = Color(0xFFF2EBFA); // Blanco
  static const Color surface = Color(0xFFE6DDF0);

  // --- Colores de Texto y Elementos ---
  static const Color onPrimary = Color(0xFFD7BD88);
  static const Color onSecondary = Colors.black;
  static const Color onBackground = Colors.black;
  static const Color error = Color(0xFF292950);

  // --- Colores Neutrales ---
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  static const Color border = Color(0xFFD3D6F2);
}