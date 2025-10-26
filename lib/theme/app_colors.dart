// lib/theme/app_colors.dart

import 'package:flutter/material.dart';

class AppColors {
  // Evita que alguien pueda instanciar esta clase
  AppColors._();

  // --- Colores Principales de la Marca ---
  static const Color primary = Color(0xFFFA9066); // Un morado personalizado
  static const Color primaryVariant = Color(0xFF3700B3);
  static const Color secondary = Color(0xFF03DAC6); // Un cyan

  // --- Colores de Fondo ---
  static const Color background = Color(0xFFFAE766); // Blanco
  static const Color surface = Color(0xFFFFFFFF);

  // --- Colores de Texto y Elementos ---
  static const Color onPrimary = Colors.white;
  static const Color onSecondary = Colors.black;
  static const Color onBackground = Colors.black;
  static const Color error = Color(0xFFB00020);

  // --- Colores Neutrales ---
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  static const Color border = Color(0xFFE0E0E0);
}