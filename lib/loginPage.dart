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
import 'package:constelacion/resetPasswordPage.dart';

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

  // ======================LA CONTRASEÑA===================================

  void showForgotPasswordDialog(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    QuickAlert.show(
      context: context,
      type: QuickAlertType.info,
      title: 'Restablecer Contraseña',
      text: 'Ingresa tu correo electrónico para enviarte un enlace de restablecimiento:',
      widget: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: "Correo electrónico",
            border: OutlineInputBorder(),
          ),
        ),
      ),
      confirmBtnText: 'Enviar Enlace',
      cancelBtnText: 'Cancelar',
      showCancelBtn: true,
      onConfirmBtnTap: () {
        Navigator.pop(context);
        if (emailController.text.isNotEmpty) {
          sendPasswordResetLink(emailController.text.trim());
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.warning,
            text: 'Por favor, ingresa tu correo electrónico.',
          );
        }
      },
      onCancelBtnTap: () {
        Navigator.pop(context);
      },
    );
  }

  Future<void> sendPasswordResetLink(String email) async {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      title: 'Enviando...',
      text: 'Comprobando tu correo electrónico...',
      barrierDismissible: false,
    );

    try {
      final response = await http.post(
        Uri.parse('${Ambiente.urlServer}/api/password/email'),
        body: jsonEncode(<String, String>{
          'email': email,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      Navigator.pop(context);

      Map<String, dynamic> responseJson = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Enlace Enviado',
          text: 'Se ha enviado un enlace de restablecimiento. Copia el token y úsalo en la siguiente pantalla.',
          confirmBtnText: 'Ir a Restablecer',
          onConfirmBtnTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ResetPasswordPage()),
            );
          },
        );
      } else {
        String errorMessage = responseJson['message'] ?? 'Ocurrió un error al intentar enviar el correo.';

        if (responseJson.containsKey('email') && responseJson['email'] is List) {
          errorMessage = responseJson['email'][0];
        }

        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: errorMessage,
        );
      }
    } catch (e) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Error de conexión. Verifica tu conexión a internet.',
      );
    }
  }

  // ==========================================================
  // WIDGET BUILDER
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: ClipOval(
                child: Image.network(
                  'https://placehold.co/150x150/EEEEEE/333333?text=Logo',
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, size: 80, color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            TextFormField(
              controller: txtUser,
              keyboardType: TextInputType.emailAddress,
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
            const SizedBox(height: 20),
            // Botón Accesar
            ElevatedButton(
              onPressed: () {
                login();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text(
                'Accesar',
                style: TextStyle(fontSize: 18),
              ),
            ),

            const SizedBox(height: 10),
            // Botón Olvidé mi Contraseña
            TextButton(
              onPressed: () {
                showForgotPasswordDialog(context);
              },
              child: const Text(
                'Olvidé mi Contraseña',
                style: TextStyle(
                  color: Colors.black87, // Color igual a "Nuevo Usuario"
                  fontSize: 16,        // Tamaño igual a "Nuevo Usuario"
                  decoration: TextDecoration.underline,
                ),
              ),
            ),

            // Botón Nuevo Usuario
            TextButton(
              onPressed: () {
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
      ),
    );
  }
}