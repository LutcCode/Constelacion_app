import 'dart:convert';
import 'package:constelacion/models/lectorModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:constelacion/models/loginModel.dart';
import 'usuariosNuevo.dart';
import 'models/ambiente.dart';
import 'usuariosNuevo.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  List<LectorModel> personas = [];

  void fnGetPersonas() async {
    try {
      final response = await http.post(
        Uri.parse('${Ambiente.urlServer}/api/persona/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        Iterable mapPersonas = jsonDecode(response.body);
        personas = List<LectorModel>.from(
          mapPersonas.map((model) => LectorModel.fromJson(model)),
        );
        setState(() {});
      } else {
        throw Exception('Error al cargar personas');
      }
    } catch (e) {
      debugPrint('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al obtener personas')),
      );
    }
  }

  Widget _listViewPersonas() {
    return ListView.builder(
      itemCount: personas.length,
      itemBuilder: (context, index) {
        final persona = personas[index];
        return ListTile(
          title: Text(persona.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Email: ${persona.email ?? 'N/A'}'),
              Text('Edad: ${persona.edad ?? '-'}'),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Usuariosnuevo(idPersona: persona.id),
              ),
            ).then((_) => fnGetPersonas());
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fnGetPersonas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECEFF1),
      appBar: AppBar(
        title: const Text('P E R S O N A S'),
        backgroundColor: const Color(0xFF9FC5D6),
      ),
      body: personas.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _listViewPersonas(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Usuariosnuevo(idPersona: 0),
            ),
          ).then((_) => fnGetPersonas());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}