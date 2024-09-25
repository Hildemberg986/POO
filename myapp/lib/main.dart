import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
void main() {
  MaterialApp app = MaterialApp(
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: Scaffold(
        appBar: AppBar(
            title: const Text(
          "Cachaça Hub",
           style: GoogleFonts.roboto(),
        )),
        body: const Center(
            child: Column(children: [
          Text("Apenas começando..."),
          Text("No meio..."),
          Text("Terminando...")
        ])),
        bottomNavigationBar: const Text("Botão 1"),
      ));

  runApp(app);
}
