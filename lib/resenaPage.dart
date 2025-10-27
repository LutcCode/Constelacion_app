import 'package:flutter/material.dart';
import 'package:constelacion/theme/app_strings.dart';

class resenaPage extends StatefulWidget {
  const resenaPage({super.key});

  @override
  State<resenaPage> createState() => _resenaPageState();
}

class _resenaPageState extends State<resenaPage> {
  // AJUSTE: Inicializamos la URL como una cadena vacía.
  String _imageUrl = '';
  late final TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: _imageUrl);
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Text('${AppStrings.appName}'
              ),
            ),
          ],
        ),
      ),
    );
  }
}
