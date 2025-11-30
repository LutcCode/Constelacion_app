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
  // 1. CREAMOS UNA LLAVE GLOBAL PARA EL FORMULARIO
  final _formKey = GlobalKey<FormState>();

  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtAppLector = TextEditingController();
  final TextEditingController txtApmLector = TextEditingController();
  final TextEditingController txtUsuario = TextEditingController();
  final TextEditingController txtEdad = TextEditingController();
  final TextEditingController txtFechaNacimiento = TextEditingController();
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

  Future<void> guardarLector() async {
    // 2. VERIFICAMOS SI EL FORMULARIO ES VÁLIDO ANTES DE ENVIAR
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('${Ambiente.urlServer}/api/persona/new'),
        body: jsonEncode(<String, dynamic>{
          'name': txtName.text,
          'app_lector': txtAppLector.text,
          'apm_lector': txtApmLector.text,
          'usuario': txtUsuario.text,
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
        if (!mounted) return;
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
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar lector')),
        );
      }
    } else {
      // Si faltan campos, mostramos un mensaje rápido
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, llena todos los campos')),
      );
    }
  }

  // Función auxiliar para validar campos vacíos
  String? _validarCampo(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final double fieldWidth = MediaQuery.of(context).size.width * (2 / 3);
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.registro)),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            // 3. ENVOLVEMOS LA COLUMNA EN UN FORM CON LA LLAVE
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 25),
                SizedBox(
                  width: fieldWidth,
                  child: TextFormField(
                    controller: txtName,
                    validator: _validarCampo, // 4. AGREGAMOS VALIDATOR A CADA CAMPO
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
                    validator: _validarCampo,
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
                    validator: _validarCampo,
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
                    controller: txtUsuario,
                    validator: _validarCampo,
                    decoration: const InputDecoration(
                      labelText: AppStrings.usuario,
                      border: OutlineInputBorder(),
                      hintText: AppStrings.usuario,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: fieldWidth,
                  child: TextFormField(
                    controller: txtEdad,
                    validator: _validarCampo,
                    keyboardType: TextInputType.number, // Teclado numérico
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
                    validator: _validarCampo,
                    readOnly: true, // Evita que el teclado se abra
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(), // Fecha inicial (hoy)
                        firstDate: DateTime(1900), // Fecha mínima permitida
                        lastDate: DateTime.now(), // Fecha máxima (hoy)
                      );

                      if (pickedDate != null) {
                        // Formateamos la fecha a String (YYYY-MM-DD)
                        // Puedes ajustar el formato según lo que espere tu backend
                        String formattedDate =
                            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";

                        setState(() {
                          txtFechaNacimiento.text = formattedDate;
                        });
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: AppStrings.fechaNacimiento,
                      border: OutlineInputBorder(),
                      hintText: 'Selecciona tu fecha',
                      suffixIcon: Icon(Icons.calendar_today), // Ícono de calendario
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: fieldWidth,
                  child: TextFormField(
                    controller: txtEmail,
                    validator: _validarCampo,
                    keyboardType: TextInputType.emailAddress,
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
                    validator: _validarCampo,
                    obscureText: true,
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
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
