import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:constelacion/models/ambiente.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> resetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      title: 'Restableciendo...',
      text: 'Enviando nueva contraseña...',
      barrierDismissible: false,
    );

    try {
      final response = await http.post(
        // Endpoint de Laravel para completar el reset
        Uri.parse('${Ambiente.urlServer}/api/password/reset'),
        body: jsonEncode(<String, dynamic>{
          'token': _tokenController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'password_confirmation': _passwordConfirmController.text,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      Navigator.pop(context); // Cierra el loading

      Map<String, dynamic> responseJson = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Éxito
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: responseJson['message'] ?? 'Contraseña restablecida exitosamente. Inicia sesión.',
          confirmBtnText: 'Ir a Login',
          onConfirmBtnTap: () {
            // Navega de vuelta al login (cierra esta página)
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        );
      } else {
        // Error de validación o del servidor
        String errorMessage = responseJson['message'] ?? 'Error al restablecer la contraseña.';

        // Muestra errores específicos de Laravel (ej. Token inválido)
        if (responseJson.containsKey('email') && responseJson['email'] is List) {
          errorMessage = responseJson['email'][0];
        } else if (responseJson.containsKey('password') && responseJson['password'] is List) {
          errorMessage = responseJson['password'][0];
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
        text: 'Error de conexión: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Contraseña'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Ingresa el token de verificación y tu nueva contraseña.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Campo Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa tu correo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Campo Token
              TextFormField(
                controller: _tokenController,
                decoration: const InputDecoration(
                  labelText: 'Token de Verificación',
                  hintText: 'Copia el token del enlace del log',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.vpn_key),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa el token';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Campo Nueva Contraseña
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Nueva Contraseña',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_reset),
                ),
                validator: (value) {
                  if (value == null || value.length < 8) {
                    return 'La contraseña debe tener al menos 8 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Campo Confirmar Contraseña
              TextFormField(
                controller: _passwordConfirmController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirmar Contraseña',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Botón Restablecer
              ElevatedButton(
                onPressed: resetPassword,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Restablecer Contraseña', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}