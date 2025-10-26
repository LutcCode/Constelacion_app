// lib/main_layout.dart

import 'package:flutter/material.dart';
import 'package:constelacion/resenaPage.dart';
import 'package:constelacion/foro_screen.dart';
import 'package:constelacion/perfil_screen.dart';
import 'package:constelacion/theme/app_strings.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 2;

  final List<Widget> _screens = [
    const ForoScreen(),
    const PerfilScreen(),
    const resenaPage(),
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
            label: AppStrings.navForo,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: AppStrings.navPerfil,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: AppStrings.navResenias,
          ),
        ],
      ),
    );
  }
}
