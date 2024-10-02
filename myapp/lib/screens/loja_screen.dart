import 'package:flutter/material.dart';

class LojaScreen extends StatelessWidget {
  const LojaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Aqui estão os itens da loja',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}