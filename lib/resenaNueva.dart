import 'dart:convert';
import 'package:constelacion/libreriaPage.dart';
import 'package:constelacion/main_layout.dart';
import 'package:constelacion/models/ambiente.dart';
import 'package:constelacion/models/resenaModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:constelacion/theme/app_strings.dart';

class resenaNueva extends StatefulWidget {
  final int idResena;
  final int? idLibro;

  const resenaNueva({super.key, required this.idResena, this.idLibro});

  @override
  State<resenaNueva> createState() => _resenaNuevaState();
}

class _resenaNuevaState extends State<resenaNueva> {
  List<ResenaModel> resena = [];
  bool isLoading = true;
  int? IdResena;

  final TextEditingController txtAcerca = TextEditingController();
  final TextEditingController txtResena = TextEditingController();

  Future<void> CargarResena() async {
    setState(() => isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('${Ambiente.urlServer}/api/resena'),
        body: jsonEncode(<String, dynamic>{'id': widget.idResena}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        final resena = ResenaModel.fromJson(responseJson);
        setState(() {
          txtAcerca.text = resena.descripcion ?? '';
          txtResena.text = resena.resena ?? '';
          IdResena = resena.id;
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Error cargando reseña')));
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error 1: ${e.toString()}')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> EnviarResena() async {
    if (txtAcerca.text.isEmpty || txtResena.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, llena todos los campos')),
      );
      return;
    }
    setState(() => isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('${Ambiente.urlServer}/api/resena/new'),
        body: jsonEncode(<String, dynamic>{
          'id': IdResena,
          'id_libro': widget.idLibro,
          'descripcion': txtAcerca.text,
          'resena': txtResena.text,
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
          const SnackBar(content: Text('Error al guardar la reseña')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error 2: ${e.toString()}')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> EliminarResena() async {
    if (IdResena == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se ha creado una reseña')),
      );
      return;
    }
    setState(() => isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('${Ambiente.urlServer}/api/resena/delete'),
        body: jsonEncode(<String, dynamic>{'id': IdResena}),
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
          const SnackBar(content: Text('Error al guardar la reseña')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error 2: ${e.toString()}')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.idResena != 0) {
      CargarResena();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mi reseña")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: txtAcerca,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Acerca del libro",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: txtResena,
              maxLines: 7,
              decoration: const InputDecoration(
                labelText: "Reseña",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: EnviarResena,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.blueAccent,
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text("Publicar"),
            ),
            if (widget.idResena != 0) ...[
              const SizedBox(height: 10), // Un poco de espacio entre botones
              ElevatedButton(
                onPressed: EliminarResena,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor:
                      Colors.redAccent, // Color rojo para indicar eliminación
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text("Eliminar"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
