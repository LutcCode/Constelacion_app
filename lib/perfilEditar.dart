import 'dart:convert';
import 'package:constelacion/theme/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/ambiente.dart';
import 'models/lectorModel.dart';
import 'package:constelacion/main_layout.dart';

class perfilEditar extends StatefulWidget {
  const perfilEditar({super.key});

  @override
  State<perfilEditar> createState() => _perfilEditarState();
}

class _perfilEditarState extends State<perfilEditar> {
  final TextEditingController txtNombre = TextEditingController();
  final TextEditingController txtApp = TextEditingController();
  final TextEditingController txtApm = TextEditingController();
  bool isLoading = true;

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

        txtNombre.text = lector.name.toString();
        txtApp.text = lector.app_lector.toString();
        txtApm.text = lector.apm_lector.toString();
      } else {
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

  Future<void> EnviarPerfil() async {
    if (txtNombre.text.isEmpty || txtApm.text.isEmpty || txtApp.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, llena todos los campos')),
      );
      return;
    }
    setState(() => isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('${Ambiente.urlServer}/api/persona/update'),
        body: jsonEncode(<String, dynamic>{
          'id': Ambiente.idUser,
          'name': txtNombre.text,
          'app_lector': txtApp.text,
          'apm_lector': txtApm.text,
        }),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      if (response.body == "ok") {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainLayout()),
          (Route<dynamic> route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar el perfil')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    cargarLector();
  }

  @override
  Widget build(BuildContext context) {
    final double fieldWidth = MediaQuery.of(context).size.width * (2 / 3);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.editarPerfil)),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //const SizedBox(height: 10),
              CircleAvatar(
                radius: 50,
                backgroundImage: const AssetImage("images/icono1.png"),
                backgroundColor: Colors.grey[200],
                onBackgroundImageError: (exception, stackTrace) {
                  print('Error al cargar la imagen local: $exception');
                },
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: fieldWidth,
                child: TextFormField(
                  controller: txtNombre,
                  decoration: const InputDecoration(
                    labelText: AppStrings.nombre,
                    border: OutlineInputBorder(),
                    hintText: AppStrings.nombre,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: fieldWidth,
                child: TextFormField(
                  controller: txtApp,
                  decoration: const InputDecoration(
                    labelText: AppStrings.app,
                    border: OutlineInputBorder(),
                    hintText: AppStrings.app,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: fieldWidth,
                child: TextFormField(
                  controller: txtApm,
                  decoration: const InputDecoration(
                    labelText: AppStrings.apm,
                    border: OutlineInputBorder(),
                    hintText: AppStrings.apm,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: fieldWidth,
                child: ElevatedButton(
                  onPressed: EnviarPerfil,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text(AppStrings.guardar),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
