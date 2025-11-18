import 'package:constelacion/PerfilPage.dart';
import 'package:constelacion/libreriaPage.dart';
import 'package:constelacion/resenasPage.dart';
import 'package:flutter/material.dart';
import 'package:constelacion/theme/app_strings.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 1;

  final List<Widget> _screens = [
    const ResenasPage(),
    const LibreriaPage(),
    const PerfilPage()
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
            icon: Icon(Icons.menu_book_outlined),
            label: AppStrings.miLectura,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: AppStrings.perfil,
          ),

        ],
      ),
    );
  }
}
