import 'package:constelacion/resenaNueva.dart';
import 'package:constelacion/resenaPage.dart';
import 'package:flutter/material.dart';

class LibreriaPage extends StatelessWidget {
  final List<Map<String, String>> libros;

  const LibreriaPage({super.key, required this.libros});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mi librería"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: libros.isEmpty
            ? const Center(
          child: Text(
            "Crea en constelación de libros tu propia librería",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        )
            : GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // columnas
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.6,
          ),
          itemCount: libros.length,
          itemBuilder: (context, index) {
            final libro = libros[index];
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Image.network(
                    libro['imagen'] ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.book, size: 50),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  libro['autor'] ?? 'Autor desconocido',
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => resenaPage(
                      titulo: libro['titulo'] ?? '',
                      ),
                    ),
                    );
                  },
                  child: const Text("Reseña"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class resenaPage extends StatelessWidget {
final String titulo;
const resenaPage({super.key, required this.titulo});

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text("Reseña de $titulo")),
    body: const Center(
      child: Text("Aquí irá la reseña del libro."),
    ),
  );
}
}

// Ejemplo de uso
void main() {
  runApp(const MaterialApp(
    home: resenaNueva(
      libros: [
        {
          'titulo': 'El Principito',
          'autor': 'Antoine de Saint-Exupéry',
          'imagen': 'https://example.com/elprincipito.jpg'
        },
      ],
      // Prueba vacío o agrega elementos aquí
    ),
  ));
}
