import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Center(
        child: Image.asset(
          'assets/icons/Prancheta_20.png',
          height: 100,
          width: 200,
        ),
      ),
      backgroundColor: const Color.fromRGBO(38, 42, 79, 1),
      toolbarHeight: 100,
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
