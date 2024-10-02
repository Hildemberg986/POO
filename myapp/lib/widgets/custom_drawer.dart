import 'package:flutter/material.dart';
import '../screens/noticias_screen.dart';
import '../screens/eventos_screen.dart';
import '../screens/jogos_screen.dart';

class CustomDrawer extends StatelessWidget {
  final Function(Widget) onSelectScreen;

  const CustomDrawer({super.key, required this.onSelectScreen});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            color: const Color.fromRGBO(38, 42, 79, 1),
            height: 150,
            child: const Center(
                child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 35,
                fontFamily: 'Raleway', 
                fontWeight: FontWeight.bold,
              ),
            )),
          ),
          ListTile(
            leading: const Icon(Icons.newspaper),
            title: const Text('Noticias'),
            onTap: () {
              Navigator.pop(context); // Fecha o drawer
              onSelectScreen(
                  const NoticiasScreen()); // Atualiza o conteúdo da tela
            },
          ),
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text('Eventos'),
            onTap: () {
              Navigator.pop(context); // Fecha o drawer
              onSelectScreen(
                  const EventosScreen()); // Atualiza o conteúdo da tela
            },
          ),
          ListTile(
            leading: const Icon(Icons.sports),
            title: const Text('Jogos'),
            onTap: () {
              Navigator.pop(context); // Fecha o drawer
              onSelectScreen(
                  const JogosScreen()); // Atualiza o conteúdo da tela
            },
          ),
        ],
      ),
    );
  }
}
