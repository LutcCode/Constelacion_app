import 'dart:convert';
import 'package:constelacion/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:constelacion/models/ambiente.dart';
import 'package:constelacion/usuariosPage.dart';
import 'package:constelacion/models/lectorModel.dart';
import 'package:quickalert/quickalert.dart';

class Usuariosnuevo extends StatefulWidget {
  const Usuariosnuevo({super.key});

  @override
  State<Usuariosnuevo> createState() => _UsuariosnuevoState();
}

class _UsuariosnuevoState extends State<Usuariosnuevo> {
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtAppLector = TextEditingController();
  final TextEditingController txtApmLector = TextEditingController();
  final TextEditingController txtEdad = TextEditingController();
  final TextEditingController txtFechaNacimiento = TextEditingController();
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

  Future<void> guardarLector() async {
    final response = await http.post(
      Uri.parse('${Ambiente.urlServer}/api/persona/new'),
      body: jsonEncode(<String, dynamic>{
        'name': txtName.text,
        'app_lector': txtAppLector.text,
        'apm_lector': txtApmLector.text,
        'edad': txtEdad.text,
        'fecha_nacimiento': txtFechaNacimiento.text,
        'email': txtEmail.text,
        'password': txtPassword.text,
        'suscripcion': false
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.body == 'ok') {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Registro realizado Correctamente',
        confirmBtnText: 'Continuar',
        onConfirmBtnTap: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const loginPage(),
            ),
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al guardar lector')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECEFF1),
      appBar: AppBar(
        title: const Text('Registro'),
        backgroundColor: const Color(0xFF9FC5D6),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 150,
            child: Image.network(
              '',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 16),

          _campoTexto('Nombre:', txtName),
          _campoTexto('Apellido Paterno:', txtAppLector),
          _campoTexto('Apellido Materno:', txtApmLector),
          _campoTexto('Edad:', txtEdad, tipo: TextInputType.number),
          _campoTexto('Fecha de Nacimiento:', txtFechaNacimiento),
          _campoTexto('Email:', txtEmail),
          _campoTexto('Contraseña:', txtPassword, ocultar: true),

          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: guardarLector,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9FC5D6),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text('Registrar', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  Widget _campoTexto(String label, TextEditingController controller,
      {TextInputType tipo = TextInputType.text, bool ocultar = false}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          TextFormField(
            controller: controller,
            keyboardType: tipo,
            obscureText: ocultar,
          ),
        ],
      ),
    );
  }
}