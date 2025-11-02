// lib/main_layout.dart

import 'package:constelacion/categoriaPage.dart';
import 'package:constelacion/resenaNueva.dart';
import 'package:flutter/material.dart';
import 'package:constelacion/resenaPage.dart';
import 'package:constelacion/foro_screen.dart';
import 'package:constelacion/loginPage.dart';
import 'package:constelacion/perfil_screen.dart';
import 'package:constelacion/theme/app_strings.dart';
import 'package:constelacion/create_book_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 2;

  final List<Widget> _screens = [
    const resenaNueva(),
    const CreateBookScreen(),
    const loginPage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.forum_outlined),
            label: AppStrings.navResenias,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: AppStrings.miLectura,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: "Categorias",
          ),
        ],
      ),
    );
  }
}
