import 'package:flutter/material.dart';
import 'package:constelacion/theme/app_strings.dart';

class resenaNueva extends StatefulWidget {
  const resenaNueva({super.key, required List<Map<String, String>> libros});

  @override
  State<resenaNueva> createState() => _resenaNuevaState();
}

class _resenaNuevaState extends State<resenaNueva> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${AppStrings.appName}')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 1, child: Container()),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(labelText: 'Título'),
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: 'Autor'),
                      ),
                      const Text('Calificacion'),
                      TextField(
                        decoration: InputDecoration(labelText: '4.5'),
                      )
                    ],
                  ),
                ),
              ],
            ),
            TextField(decoration: InputDecoration(labelText: 'Categoría')),
            TextField(decoration: InputDecoration(labelText: 'Opiniones')),
          ],
        ),
      ),
    );
  }
}
