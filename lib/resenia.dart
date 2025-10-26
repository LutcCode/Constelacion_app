import 'package:flutter/material.dart';

class resenia extends StatefulWidget {
  const resenia({super.key});

  @override
  State<resenia> createState() => _reseniaState();
}

class _reseniaState extends State<resenia> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Pantalla de la reseña',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}