import 'dart:convert';
import 'package:constelacion/theme/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:constelacion/perfilEditar.dart';
import 'package:constelacion/resenaPage.dart';
import 'package:http/http.dart' as http;
import 'models/LibroModelLibreria.dart';
import 'models/ambiente.dart';
import 'models/lectorModel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final PageController _pageController = PageController();
  int _selectedPage = 0;

  List<LibroModelLibreria> libros = [];
  List<LibroModelLibreria> librosResenas = [];
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
        libros = List<LibroModelLibreria>.from(
          responseJson.map((model) => LibroModelLibreria.fromJson(model)),
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

  Future<void> CargarLibrosResenas() async {
    try {
      final response = await http.post(
        Uri.parse('${Ambiente.urlServer}/api/libros/lector/resenas'),
        body: jsonEncode(<String, dynamic>{'id_lector': Ambiente.idUser}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        Iterable responseJson = jsonDecode(response.body);
        librosResenas = List<LibroModelLibreria>.from(
          responseJson.map((model) => LibroModelLibreria.fromJson(model)),
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
            ],
          ),
        );
      },
    );
  }

  Widget _gridResenas() {
    if (librosResenas.isEmpty) {
      return const Center(child: Text('No hay libros disponibles'));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 1.5,
      ),
      itemCount: librosResenas.length,
      itemBuilder: (context, index) {
        final libroResena = librosResenas[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          elevation: 3.0,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => resenaPage(idResena: libroResena.id),
                ),
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                  height: double.infinity,
                  child:
                      libroResena.imagen.isNotEmpty
                          ? Image.network(
                            libroResena.imagen,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => const Center(
                                  child: Icon(
                                    Icons.book,
                                    size: 30,
                                    color: Colors.grey,
                                  ),
                                ),
                          )
                          : const Center(
                            child: Icon(
                              Icons.book,
                              size: 30,
                              color: Colors.grey,
                            ),
                          ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          libroResena.nombre_libro,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          libroResena.id_resena.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
    CargarLibrosResenas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.perfil),
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
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
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
                  const SizedBox(height: 10),
                  Text(txtNombre.text),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: _mostrarAlertaCorona,
                        icon: const FaIcon(
                          FontAwesomeIcons.crown,
                          color: Colors.amber,
                          size: 20,
                        ),
                        label: const Text(
                          AppStrings.premiun,
                          style: TextStyle(color: Colors.amber),
                        ),
                      ),
                      const SizedBox(width: 20),
                      TextButton.icon(
                        onPressed: () {
                          Ambiente.idUser = 0;
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/',
                            (Route<dynamic> route) => false,
                          );
                        },
                        icon: const Icon(Icons.logout, color: Colors.red),
                        label: const Text(
                          AppStrings.cerrarSesion,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  "Lista de Lecturas",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              const Divider(indent: 20, endIndent: 20),
                              Expanded(child: _gridLibros()),
                            ],
                          ),
                        ),
                        const VerticalDivider(width: 1, color: Colors.grey),
                        Expanded(
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  "Reseñas",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              const Divider(indent: 20, endIndent: 20),
                              Expanded(child: _gridResenas()),
                            ],
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
