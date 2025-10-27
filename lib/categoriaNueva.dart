import 'package:flutter/material.dart';

class categoriaNueva extends StatefulWidget {
  final int idCategoria;
  const categoriaNueva({super.key, required this.idCategoria});

  @override
  State<categoriaNueva> createState() => _categoriaNuevaState();
}

class _categoriaNuevaState extends State<categoriaNueva> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Categoría')),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Nombre de la Categoría'),
          ),
          ElevatedButton(onPressed: () {}, child: Text('Guardar')),
        ],
      ),
    );
  }
}
