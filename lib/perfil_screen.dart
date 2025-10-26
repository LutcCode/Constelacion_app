// lib/perfil_screen.dart
import 'package:flutter/material.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Pantalla de Perfil',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}