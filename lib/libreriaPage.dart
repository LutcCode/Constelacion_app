import 'dart:convert';
import 'package:constelacion/resenaNueva.dart';
import 'package:constelacion/resenaPage.dart';
import 'package:constelacion/models/ambiente.dart';
import 'package:constelacion/models/libroModel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

// Se corrige la clase para que sea un StatelessWidget simple y funcional.
// Se eliminaron los métodos y clases incorrectos.
class LibreriaPage extends StatelessWidget {
  const LibreriaPage({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mi Librería"),
      ),
      body: const Center(
        child: Text("Aquí se mostrará la lista de libros."),
      ),
    );
  }
}
