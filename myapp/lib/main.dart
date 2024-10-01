import 'package:flutter/material.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/custom_drawer.dart';

void main() => runApp(const MenuApp());

class MenuApp extends StatefulWidget {
  const MenuApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MenuAppState createState() => _MenuAppState();
}

class _MenuAppState extends State<MenuApp> {
  // Variável para armazenar a tela atual
  Widget _selectedScreen = Center(
      child: Image.asset(
    'assets/icons/icon_transparente.png',
    width: 150,
  ));

  // Função para atualizar a tela exibida
  void _updateScreen(Widget screen) {
    setState(() {
      _selectedScreen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: const CustomAppBar(), // AppBar personalizada
        body: _selectedScreen, // Exibe a tela selecionada
        backgroundColor: const Color.fromRGBO(180, 187, 228, 1),
        drawer: CustomDrawer(
          onSelectScreen:
              _updateScreen, // Passa a função de atualização de tela
        ),
      ),
    );
  }
}
