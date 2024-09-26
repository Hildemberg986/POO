import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CounterDisplay extends StatelessWidget {
  const CounterDisplay({required this.count, super.key});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Text('Count: $count');
  }
}

class CounterIncrementor extends StatelessWidget {
  const CounterIncrementor({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Text('Increment'),
    );
  }
}

class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _counter = 0;

  void _increment() {
    setState(() {
      ++_counter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CounterIncrementor(onPressed: _increment),
        const SizedBox(width: 16),
        CounterDisplay(count: _counter),
      ],
    );
  }
}

void main() {
  // Configurar a cor da barra de status para preta
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.black, // Cor da barra de status
    statusBarIconBrightness: Brightness.light, // Ícones brancos
  ));

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false, // Remover o banner de debug
      home: Scaffold(
        appBar: AppBar( // Adicionando a AppBar
          title: const Text(
            'Contador',
            style: TextStyle(color: Colors.white), // Definindo a cor do texto como branco
          ),
          backgroundColor: const Color.fromARGB(255, 117, 0, 226),
        ),
        body: const SafeArea( // SafeArea para evitar sobreposição
          child: Center(
            child: Counter(),
          ),
        ),
      ),
    ),
  );
}
