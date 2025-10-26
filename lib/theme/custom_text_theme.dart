// lib/theme/custom_text_theme.dart
import 'package:flutter/material.dart';

// 1. Define tu clase de estilos personalizados
class CustomTextTheme {
  final TextStyle pageTitle;
  final TextStyle cardSubtitle;
  final TextStyle warningText;

  const CustomTextTheme({
    required this.pageTitle,
    required this.cardSubtitle,
    required this.warningText,
  });
}

// 2. Define los estilos que quieres usar
const customTextTheme = CustomTextTheme(
  pageTitle: TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  ),
  cardSubtitle: TextStyle(fontSize: 14, color: Colors.grey),
  warningText: TextStyle(
    fontSize: 16,
    color: Colors.red,
    fontStyle: FontStyle.italic,
  ),
);
