import 'package:flutter/material.dart';
import 'package:constelacion/theme/app_strings.dart';

class resenaNueva extends StatefulWidget {
  const resenaNueva({super.key});

  @override
  State<resenaNueva> createState() => _resenaNuevaState();
}

class _resenaNuevaState extends State<resenaNueva> {
  final TextEditingController _acercaController = TextEditingController();
  final TextEditingController _resenaController = TextEditingController();

  @override
  void dispose() {
    _acercaController.dispose();
    _resenaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Mi reseña"),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Campo “Acerca del libro”
                TextField(
                  controller: _acercaController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: "Acerca del libro",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // Campo “Reseña”
                TextField(
                  controller: _resenaController,
                  maxLines: 7,
                  decoration: const InputDecoration(
                    labelText: "Reseña",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),

                // Botón “Publicar”
                ElevatedButton(
                  onPressed: () {
                    print("Acerca del libro: ${_acercaController.text}");
                    print("Reseña: ${_resenaController.text}");
                  },
                  child: const Text("Publicar"),
                ),
              ],
            ),
        ),
    );
  }
}