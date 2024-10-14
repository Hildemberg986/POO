import 'package:flutter/material.dart';
import 'package:myapp/screens/view_menu.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function(Widget) onSelectScreen;
  const CustomAppBar({super.key, required this.onSelectScreen});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: GestureDetector(
        onTap: () {
          onSelectScreen(const ViewMenu());
        },  
        child: Center(
          child: Image.asset(
            'assets/icons/Prancheta_20.png', // Caminho da imagem original no AppBar
            height: 100,
            width: 200,
          ),
        ), // Fim do Center
      ), // Fim do GestureDetector
      backgroundColor: const Color.fromRGBO(38, 42, 79, 1),
      toolbarHeight: 100,
      leadingWidth: 100,
      iconTheme: const IconThemeData(
        color: Colors.white, // Cor do ícone do menu
        size: 40,
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 20), // Adiciona margem à esquerda
        child: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Abre o Drawer
            },
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
