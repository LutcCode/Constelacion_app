import 'package:constelacion/loginPage.dart';
import 'package:constelacion/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:constelacion/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Constelación Literaria',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const loginPage(),
    );
  }
}

