import 'dart:convert';
import 'package:constelacion/main_layout.dart';
import 'package:constelacion/models/lectorModel.dart';
import 'package:constelacion/models/loginModel.dart';
import 'package:constelacion/usuariosNuevo.dart';
import 'package:constelacion/models/ambiente.dart';
import 'package:constelacion/libreriaPage.dart';
import 'package:constelacion/resenaPage.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  final TextEditingController txtUser = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

  Future<void> login() async {
    final response = await http.post(
      Uri.parse('${Ambiente.urlServer}/api/login'),
      body: jsonEncode(<String, dynamic>{
        'email': txtUser.text,
        'password': txtPassword.text,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    Future<void> cargarPersona() async {
      final response = await http.get(
        Uri.parse('${Ambiente.urlServer}/api/persona/${Ambiente.idUser}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      Map<String, dynamic> responseJson = jsonDecode(response.body);
      final persona = LectorModel.fromJson(responseJson);

      Ambiente.idUser = persona.id;
    }

    Map<String, dynamic> responseJson = jsonDecode(response.body);
    final loginResponse = LoginResponse.fromJson(responseJson);


    if (loginResponse.acceso == 'Ok') {
      Ambiente.idUser = loginResponse.idUsuario;

      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Inicio de sesión exitoso',
        confirmBtnText: 'Continuar',
        onConfirmBtnTap: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const MainLayout(),
          ),
          );
        },
      );
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: loginResponse.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          Center(
            child: ClipOval(
              child: Image.network(
                '',
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 50),
          TextFormField(
            controller: txtUser,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Correo electrónico',
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            obscureText: true,
            controller: txtPassword,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Contraseña',
            ),
          ),
          TextButton(
            onPressed: () {
              login();
            },
            child: const Text('Accesar'),

          ),
          TextButton(
            onPressed: () {
              // 👇 Navega a la pantalla de registro (Usuariosnuevo)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Usuariosnuevo(),
                ),
              );
            },
            child: const Text(
              'Nuevo Usuario',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}