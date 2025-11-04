import 'dart:convert';
import 'package:constelacion/resenaPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:constelacion/models/ambiente.dart';
import 'package:constelacion/models/resenaModel.dart';

class ResenasPage extends StatefulWidget {
  const ResenasPage({super.key});

  @override
  State<ResenasPage> createState() => _ResenasPageState();
}

class _ResenasPageState extends State<ResenasPage> {
  List<ResenaModel> resenas = [];
  bool isLoading = true;

  Future<void> cargarResenas() async {
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
        resenas = List<ResenaModel>.from(
          responseJson.map((model) => ResenaModel.fromJson(model)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al cargar las clases')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  Widget _listViewResenas() {
    if (resenas.isEmpty) {
      return const Center(
        child: Text('No hay reseñas disponibles'),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: resenas.length,
      itemBuilder: (context, index) {
        final resena = resenas[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => resenaPage(),
                ),
              );
            },
            title: Text('ID: ${resena.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Descripcion: ${resena.descripcion}'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    cargarResenas();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resenas')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _listViewResenas(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const resenaPage(),
            ),
          );
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}