import 'package:flutter/material.dart';
import '../screens/noticias_screen.dart';
import '../screens/eventos_screen.dart';
import '../screens/jogos_screen.dart';

void navigateToNoticias(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const NoticiasScreen()),
  );
}

void navigateToEventos(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const EventosScreen()),
  );
}

void navigateToJogos(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const JogosScreen()),
  );
}
