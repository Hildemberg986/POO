import 'package:flutter/material.dart';

class ViewMenu extends StatelessWidget {
  const ViewMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Image.asset(
      'assets/icons/logo_vazada_v2.png',
      width: 150,
      color: const Color.fromRGBO(0, 0, 0, 0.08),
    ));
  }
}
