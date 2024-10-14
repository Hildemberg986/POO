import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // Para inicializar o formato de data
import 'widgets/custom_app_bar.dart';
import 'widgets/custom_drawer.dart';
import './screens/view_menu.dart';

void main() async {
  // Certifique-se de que o Flutter está inicializado antes de chamar a função.
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa as configurações de localidade para datas.
  await initializeDateFormatting('pt_BR', null);
  Intl.defaultLocale = 'pt_BR'; // Define a localidade padrão para português do Brasil

  runApp(const MenuApp());
}

class MenuApp extends StatefulWidget {
  const MenuApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MenuAppState createState() => _MenuAppState();
}

class _MenuAppState extends State<MenuApp> {
  // Variável para armazenar a tela atual
  Widget _selectedScreen = const ViewMenu();

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
        appBar: CustomAppBar(onSelectScreen: _updateScreen), // AppBar personalizada
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
