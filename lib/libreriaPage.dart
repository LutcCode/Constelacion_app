import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:constelacion/models/ambiente.dart';
import 'package:constelacion/models/LibroModel.dart';
import 'package:constelacion/theme/app_strings.dart';
import 'package:constelacion/libreriaNuevo.dart';

class LibreriaPage extends StatefulWidget {
  const LibreriaPage({super.key});

  @override
  State<LibreriaPage> createState() => _LibreriaPageState();
}

class _LibreriaPageState extends State<LibreriaPage> {
  // Estado para la lista de libros
  List<LibroModel> _libros = [];
  bool _isLoading = true;

  final String _apiUrl = '${Ambiente.urlServer}/api/libros';

  @override
  void initState() {
    super.initState();
    fetchLibros();
  }

  Future<void> fetchLibros() async {
    if (Ambiente.idUser == 0) {
      setState(() {
        _isLoading = false;
      });
      print("Error: Ambiente.idUser es 0. Asegúrate de iniciar sesión.");
      return;
    }

    // El endpoint de Laravel /api/libros
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
      );

      if (response.statusCode == 200) {
        // Asumimos que Laravel devuelve una lista JSON
        List jsonList = jsonDecode(response.body);

        setState(() {
          // Mapeamos la lista JSON a una lista de LibroModel
          _libros = jsonList.map((json) => LibroModel.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        print('Error al cargar libros. Código: ${response.statusCode}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error de Conexión al cargar libros: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.libreria),
      ),
      body: _buildBody(),

      // Botón flotante para agregar un nuevo libro (+)
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateBookScreen()),
          );
          fetchLibros();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Widget para manejar los diferentes estados de la vista
  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_libros.isEmpty) {
      return const Center(child: Text("¡Aún no tienes libros! Agrega uno."));
    }

    return RefreshIndicator(
      onRefresh: fetchLibros, // Permite recargar deslizando hacia abajo
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: GridView.builder(
          itemCount: _libros.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 0.5,
          ),
          itemBuilder: (context, index) {
            final libro = _libros[index];
            return _BookGridItem(
              title: libro.nombre_libro,
              author: libro.autor,
              imageUrl: libro.imagen, // Pasamos la URL de la imagen
            );
          },
        ),
      ),
    );
  }
}

// --- WIDGET AUXILIAR PARA REPRESENTAR CADA LIBRO ---

class _BookGridItem extends StatelessWidget {
  final String title;
  final String author;
  final String imageUrl;

  const _BookGridItem({
    required this.title,
    required this.author,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Contenedor de la Portada
        Expanded(
          flex: 4,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            // Si la URL es válida, muestra la imagen; si no, muestra 'Portada'
            child: imageUrl.isNotEmpty
                ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.book, size: 30)),
            )
                : const Center(child: Text("Portada")),
          ),
        ),
        const SizedBox(height: 4),

        // 2. Título y Autor
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          author,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),

        // 3. Botón de Reseña
        SizedBox(
          height: 20,
          child: ElevatedButton(
            onPressed: () {
              // TODO: Navegación a la Reseña del libro
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            ),
            child: const Text("Reseña", style: TextStyle(fontSize: 10)),
          ),
        ),
      ],
    );
  }
}