import 'package:flutter/material.dart';
import 'package:constelacion/theme/app_strings.dart';

class resenaNueva extends StatefulWidget {
  const resenaNueva({super.key});

  @override
  State<resenaNueva> createState() => _resenaNuevaState();
}

class _resenaNuevaState extends State<resenaNueva> {
  final TextEditingController txtacerca = TextEditingController();
  final TextEditingController txtresena = TextEditingController();


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
                TextField(
                  controller: txtacerca,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: "Acerca del libro",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: txtresena,
                  maxLines: 7,
                  decoration: const InputDecoration(
                    labelText: "Reseña",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    print("Acerca del libro: ${txtacerca.text}");
                    print("Reseña: ${txtresena.text}");
                  },
                  child: const Text("Publicar"),
                ),
              ],
            ),
        ),
    );
  }
}