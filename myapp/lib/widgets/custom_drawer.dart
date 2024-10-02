import 'package:flutter/material.dart';
import '../screens/noticias_screen.dart';
import '../screens/eventos_screen.dart';
import '../screens/jogos_screen.dart';
import '../screens/patrocinadores_screen.dart';
import '../screens/feedback_e_avaliacoes_screen.dart';
import '../screens/loja_screen.dart';
import '../screens/notificacao_screen.dart';
import '../screens/perfil_screen.dart';
import '../screens/saude_e_bem_estar_screen.dart';

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
            leading: const Icon(Icons.person_pin_rounded),
            title: const Text('Perfil'),
            onTap: () {
              Navigator.pop(context); // Fecha o drawer
              onSelectScreen(
                  const PerfilScreen()); // Atualiza o conteúdo da tela
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications_active_outlined),
            title: const Text('Notificações'),
            onTap: () {
              Navigator.pop(context); // Fecha o drawer
              onSelectScreen(
                  const NotificacaoScreen()); // Atualiza o conteúdo da tela
            },
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
          ListTile(
            leading: const Icon(Icons.shopping_bag_outlined),
            title: const Text('Loja'),
            onTap: () {
              Navigator.pop(context); // Fecha o drawer
              onSelectScreen(const LojaScreen()); // Atualiza o conteúdo da tela
            },
          ),
          ListTile(
            leading: const Icon(Icons.monitor_heart_outlined),
            title: const Text('Saúde e Bem-Estar'),
            onTap: () {
              Navigator.pop(context); // Fecha o drawer
              onSelectScreen(
                  const SaudeEBemEstarScreen()); // Atualiza o conteúdo da tela
            },
          ),
          ListTile(
            leading: const Icon(Icons.handshake_outlined),
            title: const Text('Patrocinadores'),
            onTap: () {
              Navigator.pop(context); // Fecha o drawer
              onSelectScreen(
                  const PatrocinadoresScreen()); // Atualiza o conteúdo da tela
            },
          ),
          ListTile(
            leading: const Icon(Icons.feedback_outlined),
            title: const Text('Feedback e Avaliações'),
            onTap: () {
              Navigator.pop(context); // Fecha o drawer
              onSelectScreen(
                  const FeedbackEAvaliacoesScreen()); // Atualiza o conteúdo da tela
            },
          ),
        ],
      ),
    );
  }
}
