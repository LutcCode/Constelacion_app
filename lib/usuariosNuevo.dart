import 'dart:convert';
import 'package:constelacion/loginPage.dart';
import 'package:constelacion/theme/app_strings.dart';
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
        'suscripcion': false,
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
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const loginPage()),
            (route) => false,
          );
        },
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error al guardar lector')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final double fieldWidth = MediaQuery.of(context).size.width * (2 / 3);
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.registro)),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 25),
              SizedBox(
                width: fieldWidth,
                child: TextFormField(
                  controller: txtName,
                  decoration: const InputDecoration(
                    labelText: AppStrings.nombre,
                    border: OutlineInputBorder(),
                    hintText: AppStrings.nombre,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: fieldWidth,
                child: TextFormField(
                  controller: txtAppLector,
                  decoration: const InputDecoration(
                    labelText: AppStrings.app,
                    border: OutlineInputBorder(),
                    hintText: AppStrings.app,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: fieldWidth,
                child: TextFormField(
                  controller: txtApmLector,
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
                child: TextFormField(
                  controller: txtEdad,
                  decoration: const InputDecoration(
                    labelText: AppStrings.edad,
                    border: OutlineInputBorder(),
                    hintText: AppStrings.edad,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: fieldWidth,
                child: TextFormField(
                  controller: txtFechaNacimiento,
                  decoration: const InputDecoration(
                    labelText: AppStrings.fechaNacimiento,
                    border: OutlineInputBorder(),
                    hintText: AppStrings.fechaNacimiento,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: fieldWidth,
                child: TextFormField(
                  controller: txtEmail,
                  decoration: const InputDecoration(
                    labelText: AppStrings.correo,
                    border: OutlineInputBorder(),
                    hintText: AppStrings.correo,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: fieldWidth,
                child: TextFormField(
                  controller: txtPassword,
                  decoration: const InputDecoration(
                    labelText: AppStrings.contrasena,
                    border: OutlineInputBorder(),
                    hintText: AppStrings.contrasena,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: fieldWidth,
                child: ElevatedButton(
                  onPressed: guardarLector,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: const Text(AppStrings.registrar),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _campoTexto(
    String label,
    TextEditingController controller, {
    TextInputType tipo = TextInputType.text,
    bool ocultar = false,
  }) {
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
