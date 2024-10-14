import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class EventosScreen extends StatefulWidget {
  const EventosScreen({super.key});

  @override
  _EventosScreenState createState() => _EventosScreenState();
}

class _EventosScreenState extends State<EventosScreen> {
  late DateTime _diaFocado;
  DateTime? _diaSelecionado;

  @override
  void initState() {
    super.initState();
    _diaFocado = DateTime.now();
    _diaSelecionado = _diaFocado;
  }

  void _onDiaSelecionado(DateTime diaSelecionado, DateTime diaFocado) {
    setState(() {
      _diaSelecionado = diaSelecionado;
      _diaFocado = diaFocado;
    });
  }

  void _chooseYear() async {
    final selectedYear = await showDialog<int>(
      context: context,
      builder: (context) {
        int? year;
        return AlertDialog(
          title: const Text('Escolha o Ano'),
          content: SingleChildScrollView(
            child: ListBody(
              children: List.generate(
                DateTime.utc(2040, 12, 31).year - DateTime.now().year + 1,
                (index) {
                  final currentYear = DateTime.now().year + index;
                  return ListTile(
                    title: Text('$currentYear'),
                    onTap: () {
                      year = currentYear;
                      Navigator.of(context).pop(year);
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );

    if (selectedYear != null) {
      setState(() {
        _diaFocado = DateTime(selectedYear, _diaFocado.month, _diaFocado.day);
      });
    }
  }

  void _chooseMonth() async {
    final selectedMonth = await showDialog<int>(
      context: context,
      builder: (context) {
        int? month;
        return AlertDialog(
          title: const Text('Escolha o Mês'),
          content: SingleChildScrollView(
            child: ListBody(
              children: List.generate(12, (index) {
                final currentMonth = index + 1;
                return ListTile(
                  title: Text('${_getMonthName(currentMonth)}'),
                  onTap: () {
                    month = currentMonth;
                    Navigator.of(context).pop(month);
                  },
                );
              }),
            ),
          ),
        );
      },
    );

    if (selectedMonth != null) {
      setState(() {
        _diaFocado = DateTime(_diaFocado.year, selectedMonth, _diaFocado.day);
      });
    }
  }

  String _getMonthName(int month) {
    const monthNames = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro'
    ];
    return monthNames[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos'),
      ),
      body: Column(
        children: [
          // Cabeçalho personalizado para o calendário
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      _diaFocado = DateTime(_diaFocado.year, _diaFocado.month - 1, 1);
                    });
                  },
                ),
                Column(
                  children: [
                    Text(
                      _getMonthName(_diaFocado.month),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${_diaFocado.year}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(() {
                      _diaFocado = DateTime(_diaFocado.year, _diaFocado.month + 1, 1);
                    });
                  },
                ),
              ],
            ),
          ),
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: _diaFocado,
            selectedDayPredicate: (day) => isSameDay(_diaSelecionado, day),
            onDaySelected: _onDiaSelecionado,
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
            locale: 'pt_BR',
            availableCalendarFormats: const {
              CalendarFormat.month: 'Mês',
            },
          ),
          // Botões para selecionar o mês e o ano
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _chooseMonth,
                child: const Text('Escolher Mês'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _chooseYear,
                child: const Text('Escolher Ano'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
