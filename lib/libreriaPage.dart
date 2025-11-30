import 'dart:convert';
import 'package:constelacion/libreriaNuevo.dart';
import 'package:constelacion/resenaNueva.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:constelacion/models/ambiente.dart';
import 'package:constelacion/models/LibroModelLibreria.dart';
import 'package:constelacion/theme/app_strings.dart';

class LibreriaPage extends StatefulWidget {
  const LibreriaPage({super.key});

  @override
  State<LibreriaPage> createState() => _LibreriaPageState();
}

class _LibreriaPageState extends State<LibreriaPage> {
  List<LibroModelLibreria> libros = [];
  List<LibroModelLibreria> librosFiltrados = []; // <-- lista filtrada
  bool isLoading = true;

  TextEditingController searchController = TextEditingController(); // <-- controlador

  Future<void> CargarLibros() async {
    try {
      final response = await http.post(
        Uri.parse('${Ambiente.urlServer}/api/libros/lector/completo'),
        body: jsonEncode(<String, dynamic>{'id_lector': Ambiente.idUser}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        Iterable responseJson = jsonDecode(response.body);
        libros = List<LibroModelLibreria>.from(
          responseJson.map((model) => LibroModelLibreria.fromJson(model)),
        );

        librosFiltrados = libros; // <-- inicializar filtrados
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al cargar los libros')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
    setState(() {
      isLoading = false;
    });
  }

  // --------------------------
  // 🔍 FUNCIÓN PARA FILTRAR
  // --------------------------
  void _filtrarLibros(String query) {
    final q = query.toLowerCase();

    setState(() {
      librosFiltrados = libros.where((libro) {
        return libro.nombre_libro.toLowerCase().contains(q);
      }).toList();
    });
  }

  // --------------------------
  // 🔍 SEARCH BAR COMPLETA
  // --------------------------
  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        controller: searchController,
        onChanged: _filtrarLibros,
        decoration: InputDecoration(
          hintText: 'Buscar libro...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }

  Widget _gridLibros() {
    if (librosFiltrados.isEmpty) {
      return const Center(child: Text('No hay libros disponibles'));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 0.65,
      ),
      itemCount: librosFiltrados.length, // <-- usar filtrados
      itemBuilder: (context, index) {
        final libro = librosFiltrados[index]; // <-- usar filtrados
        return Card(
          clipBehavior: Clip.antiAlias,
          elevation: 3.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: libro.imagen.isNotEmpty
                    ? Image.network(
                  libro.imagen,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Center(
                    child: Icon(
                      Icons.book,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                )
                    : const Center(
                  child: Icon(
                    Icons.book,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  libro.nombre_libro,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.rate_review, size: 20),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => resenaNueva(
                                idResena: libro.id_resena, idLibro: libro.id),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                libreriaNuevo(idLibro: libro.id),
                          ),
                        );
                        CargarLibros();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.visibility, size: 20),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => resenaNueva(
                                idResena: libro.id_resena, idLibro: libro.id),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    CargarLibros();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.libreria)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          _searchBar(),            // <-- AGREGADO AQUÍ
          Expanded(child: _gridLibros()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const libreriaNuevo()),
          );

          CargarLibros();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
