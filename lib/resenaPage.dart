import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:constelacion/theme/app_strings.dart';
import 'package:http/http.dart' as http;
import 'models/ambiente.dart';
import 'models/resenaModel.dart';

class resenaPage extends StatefulWidget {
  final int idResena;
  const resenaPage({super.key, required this.idResena});

  @override
  State<resenaPage> createState() => _resenaPageState();
}

class _resenaPageState extends State<resenaPage> {
  bool isLoading = true;

  final TextEditingController txtTitulo = TextEditingController();
  final TextEditingController txtAutor = TextEditingController();
  final TextEditingController txtImagen = TextEditingController();
  final TextEditingController txtDescripcion = TextEditingController();
  final TextEditingController txtResena = TextEditingController();

  Future<void> cargarResena() async {
    try {
      final response = await http.post(
        Uri.parse('${Ambiente.urlServer}/api/libro/resena'),
        body: jsonEncode(<String, dynamic>{'id': widget.idResena}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        final resena = ResenaModel.fromJson(responseJson);

        txtTitulo.text = resena.titulo.toString();
        txtAutor.text = resena.autor.toString();
        txtImagen.text = resena.imagen.toString();
        txtDescripcion.text = resena.descripcion.toString();
        txtResena.text = resena.resena.toString();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al cargar las clases')),
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

  @override
  void initState() {
    super.initState();
    cargarResena();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${AppStrings.appName}')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child:
                              txtImagen.text.isNotEmpty
                                  ? Image.network(
                                    txtImagen.text,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
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
                        const SizedBox(width: 16.0),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  txtTitulo.text,
                                  // 6. Se centra el texto
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Text(
                                txtAutor.text,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal, // Se quita el bold para diferenciarlo del título
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // 7. Se añade un divisor y espaciado para separar secciones
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),

                    // 8. Se añade Padding y se centra el texto de la descripción
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        txtDescripcion.text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),

                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),

                    // 9. Se añade Padding y se centra el texto de la reseña
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        txtResena.text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
          ),
    );
  }
}