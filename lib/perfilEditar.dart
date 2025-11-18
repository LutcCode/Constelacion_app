import 'dart:convert';
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
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Column(
        children: [
          const SizedBox(height: 20), // Un poco de espacio arriba
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage("images/icono1.png"),
            backgroundColor: Colors.grey[200],
            onBackgroundImageError: (exception, stackTrace) {
              print('Error al cargar la imagen local: $exception');
            },
          ),
          TextField(
            controller: txtNombre,
            decoration: const InputDecoration(
              labelText: "Nombre(s)",
              border: OutlineInputBorder(),
            ),
          ),
          TextField(
            controller: txtApp,
            decoration: const InputDecoration(
              labelText: "Apellido Paterno",
              border: OutlineInputBorder(),
            ),
          ),
          TextField(
            controller: txtApm,
            decoration: const InputDecoration(
              labelText: "Apellido Materno",
              border: OutlineInputBorder(),
            ),
          ),
          ElevatedButton(
            onPressed: EnviarPerfil,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.blueAccent,
              textStyle: const TextStyle(fontSize: 18),
            ),
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }
}
