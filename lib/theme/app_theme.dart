// lib/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:constelacion/theme/app_colors.dart';

class AppTheme {
  // Hacemos el constructor privado para que no se pueda instanciar la clase
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    // Especifica que es un tema claro

    // --- ESQUEMA DE COLOR ---
    // Usamos los colores definidos en nuestro archivo app_colors.dart
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.error,
      background: AppColors.background,
    ),

    // --- TEMA DE TEXTO ---
    // Aquí defines todos los estilos de texto predeterminados
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: AppColors.textSecondary,
      ),
      labelLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),

    // --- TEMAS DE COMPONENTES ESPECÍFICOS ---
    // Centraliza el estilo de los widgets más comunes
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary, // Color para el título y los iconos
      centerTitle: true, // Centra el título en todos los AppBars
      elevation: 2,
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.secondary,
      foregroundColor: AppColors.onSecondary,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        minimumSize: const Size(200, 50),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );

// Podrías incluso definir un tema oscuro aquí si quisieras
// static final ThemeData darkTheme = ThemeData(...);
}