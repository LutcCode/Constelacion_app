// lib/foro_screen.dart
import 'package:flutter/material.dart';

class ForoScreen extends StatelessWidget {
  const ForoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Pantalla del Foro',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
