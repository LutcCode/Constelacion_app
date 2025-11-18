import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:constelacion/perfilEditar.dart';
import 'package:constelacion/resenaPage.dart';
import 'package:http/http.dart' as http;
import 'models/LibroModel.dart';
import 'models/ambiente.dart';
import 'models/lectorModel.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final PageController _pageController = PageController();
  int _selectedPage = 0;

  List<LibroModel> libros = [];
  final TextEditingController txtNombre = TextEditingController();
  bool isLoading = true;

  void _goToPage(int index) {
    setState(() => _selectedPage = index);
    _pageController.jumpToPage(index);
  }

  void _mostrarAlertaCorona() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text('Deseas tener la membresia premium?.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> cargarLector() async {
    try {
      final response = await http.post(
        Uri.parse('${Ambiente.urlServer}/api/persona'),
        body: jsonEncode(<String, dynamic>{'id': Ambiente.idUser}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        final lector = LectorModel.fromJson(responseJson);

        txtNombre.text =
            '${lector.name} ${lector.app_lector} ${lector.apm_lector}';
      } else {
        print(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al cargar las clases')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
    setState(() {
      isLoading = false;
    });
  }

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
        libros = List<LibroModel>.from(
          responseJson.map((model) => LibroModel.fromJson(model)),
        );
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

  Widget _gridLibros() {
    if (libros.isEmpty) {
      return const Center(child: Text('No hay libros disponibles'));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 0.65,
      ),
      itemCount: libros.length,
      itemBuilder: (context, index) {
        final libro = libros[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          elevation: 3.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child:
                    libro.imagen.isNotEmpty
                        ? Image.network(
                          libro.imagen,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => const Center(
                                child: Icon(
                                  Icons.book,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              ),
                        )
                        : const Center(
                          child: Icon(Icons.book, size: 40, color: Colors.grey),
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
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    cargarLector();
    CargarLibros();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const perfilEditar()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage("images/icono1.png"),
            backgroundColor: Colors.grey[200],
            onBackgroundImageError: (exception, stackTrace) {
              print('Error al cargar la imagen local: $exception');
            },
          ),
          Text(txtNombre.text),
          Text("Vampirecell"),
          TextButton(
            onPressed: _mostrarAlertaCorona,
            child: const Text('Corona'),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child:
                        isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : _gridLibros(),
                  ),
                ),

                const VerticalDivider(width: 2, color: Colors.grey),

                Expanded(
                  child: SingleChildScrollView(
                    child:
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _gridLibros(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
