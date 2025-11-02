import 'package:flutter/material.dart';
import 'lista_lecturas_page.dart';
import 'resenas_page.dart';

class PerfilPage extends StatefulWidget {
  final String nombre;
  final String usuario;

  const PerfilPage({
    Key? key,
    required this.nombre,
    required this.usuario,
  }) : super(key: key);

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final PageController _pageController = PageController();
  int _selectedPage = 0;

  void _goToPage(int index) {
    setState(() => _selectedPage = index);
    _pageController.jumpToPage(index);
  }

  void _mostrarAlertaCorona() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text('Deseas tener la membresia premium?.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Column(
        children: [
          Text(widget.nombre),
          Text(widget.usuario),
          TextButton(
            onPressed: _mostrarAlertaCorona,
            child: const Text('Corona'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _menuButton('Lista de Lecturas', 0),
              _menuButton('Reseñas', 1),
            ],
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _selectedPage = index),
              children: const [
                ListaLecturasPage(),
                ResenasPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuButton(String title, int index) {
    return TextButton(
      onPressed: () => _goToPage(index),
      child: Text(title),
    );
  }
}
