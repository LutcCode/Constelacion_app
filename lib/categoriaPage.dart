import 'dart:convert';
import 'package:constelacion/categoriaNueva.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:constelacion/models/ambiente.dart';
import 'package:constelacion/models/CategoriaModel.dart';

class categoriaPage extends StatefulWidget {
  const categoriaPage({super.key});

  @override
  State<categoriaPage> createState() => _categoriaPageState();
}

class _categoriaPageState extends State<categoriaPage> {
  List<CategoriaModel> categorias = [];
  bool isLoading = true;

  Future<void> fnGetCategorias() async {
    try {
      final response = await http.post(
        Uri.parse('${Ambiente.urlServer}/api/categorias'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (response.statusCode == 200) {
        Iterable mapCategorias = jsonDecode(response.body);
        categorias = List<CategoriaModel>.from(
          mapCategorias.map((model) => CategoriaModel.fromJson(model)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al cargar las categorias')),
        );
      }
    } catch (e) {
      print('Ocurrió un error al obtener las categorías: $e');
    }
    setState(() {
      isLoading = false;
    });
  }

  Widget _listViewCategorias() {
    if (categorias.isEmpty) {
      return const Center(child: Text('No hay categorias disponibles'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: categorias.length,
      itemBuilder: (context, index) {
        final categoria = categorias[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      categoriaNueva(idCategoria: categoria.id),
                ),
              );
            },
            title: Text(
              'ID: ${categoria.id}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Nivel: ${categoria.categoria}'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fnGetCategorias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _listViewCategorias(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const categoriaNueva(idCategoria: 0),
            ),
          );
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
