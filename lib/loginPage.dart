import 'dart:convert';
import 'package:constelacion/main_layout.dart';
import 'package:constelacion/models/lectorModel.dart';
import 'package:constelacion/models/loginModel.dart';
import 'package:constelacion/usuariosNuevo.dart';
import 'package:constelacion/models/ambiente.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;
import 'package:constelacion/resetPasswordPage.dart';
import 'package:constelacion/theme/app_strings.dart';

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
            MaterialPageRoute(builder: (context) => const MainLayout()),
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
      text:
          'Ingresa tu correo electrónico para enviarte un enlace de restablecimiento:',
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
        body: jsonEncode(<String, String>{'email': email}),
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
          text:
              'Se ha enviado un enlace de restablecimiento. Copia el token y úsalo en la siguiente pantalla.',
          confirmBtnText: 'Ir a Restablecer',
          onConfirmBtnTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ResetPasswordPage(),
              ),
            );
          },
        );
      } else {
        String errorMessage =
            responseJson['message'] ??
            'Ocurrió un error al intentar enviar el correo.';

        if (responseJson.containsKey('email') &&
            responseJson['email'] is List) {
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

  @override
  Widget build(BuildContext context) {
    //final double imageSize = MediaQuery.of(context).size.width * 0.45;
    final double fieldWidth = MediaQuery.of(context).size.width * (2 / 3);
    return Scaffold(
      //backgroundColor: const Color.fromARGB(255, 2, 41, 72),
      //appBar: AppBar(centerTitle: true,title: const Text('Login'),),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: ClipOval(
                child: Image.asset(
                  "images/logo.png", // Asegúrate de que esta ruta coincida con tu carpeta real
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.grey,
                        ),
                      ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: fieldWidth,
              child: TextFormField(
                controller: txtUser,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: AppStrings.correo,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: fieldWidth,
              child: TextFormField(
                controller: txtPassword,
                obscureText: true,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: AppStrings.contrasena,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: fieldWidth,
              child: ElevatedButton(
                onPressed: () {
                  login();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text(AppStrings.entrar),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                showForgotPasswordDialog(context);
              },
              child: const Text(
                AppStrings.olvideContrasena,
                style: TextStyle(color: Colors.black87, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: fieldWidth,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Usuariosnuevo(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text(AppStrings.crearCuenta),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
