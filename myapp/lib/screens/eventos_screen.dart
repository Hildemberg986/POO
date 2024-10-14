import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'dart:math';

class EventosScreen extends StatefulWidget {
  const EventosScreen({super.key});

  @override
  _EventosScreenState createState() => _EventosScreenState();
}

class _EventosScreenState extends State<EventosScreen> {
  final DateTime _diaFocado = DateTime.now();
  DateTime? _diaSelecionado;
  final Map<DateTime, List<EventoModel>> _eventos = {};
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _diaSelecionado = _diaFocado;
  }

  List<EventoModel> _carregarEventosPorDia(DateTime dia) {
    return _eventos[dia] ?? [];
  }

  void _onDiaSelecionado(DateTime diaSelecionado) {
    setState(() {
      _diaSelecionado = diaSelecionado;
    });
  }

  void _adicionarEvento(DateTime dataInicio, DateTime dataFim, String nome,
      String descricao, TimeOfDay? horaInicio, TimeOfDay? horaFim) {
    if (dataInicio.isAfter(dataFim)) return;

    final evento = EventoModel(
      nome: nome,
      descricao: descricao,
      dataInicio: dataInicio,
      dataFim: dataFim,
      cor: Color.fromRGBO(
          _random.nextInt(256), _random.nextInt(256), _random.nextInt(256), 1),
      horaInicio: horaInicio,
      horaFim: horaFim,
    );

    setState(() {
      for (var dia = dataInicio;
          !dia.isAfter(dataFim);
          dia = dia.add(const Duration(days: 1))) {
        _eventos[dia] = (_eventos[dia] ?? [])..add(evento);
      }
    });
  }

  Future<void> _mostrarModalAdicionarEvento() async {
    DateTime? dataInicio = _diaSelecionado;
    DateTime? dataFim = _diaSelecionado;
    TimeOfDay? horaInicio;
    TimeOfDay? horaFim;
    final TextEditingController nomeController = TextEditingController();
    final TextEditingController descricaoController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Evento'),
          content: SingleChildScrollView(
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  children: [
                    TextField(
                      controller: nomeController,
                      decoration:
                          const InputDecoration(labelText: 'Nome do Evento'),
                    ),
                    TextField(
                      controller: descricaoController,
                      decoration: const InputDecoration(
                          labelText: 'Descrição do Evento'),
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      title: const Text('Data Início'),
                      subtitle: Text('${dataInicio!.toLocal()}'.split(' ')[0]),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final dataSelecionada = await showDatePicker(
                          context: context,
                          initialDate: dataInicio!,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (dataSelecionada != null) {
                          setState(() {
                            dataInicio = dataSelecionada;
                          });
                        }
                      },
                    ),
                    ListTile(
                      title: const Text('Data Fim'),
                      subtitle: Text('${dataFim!.toLocal()}'.split(' ')[0]),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final dataSelecionada = await showDatePicker(
                          context: context,
                          initialDate: dataFim!,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (dataSelecionada != null) {
                          setState(() {
                            dataFim = dataSelecionada;
                          });
                        }
                      },
                    ),
                    ListTile(
                      title: const Text('Hora Início'),
                      subtitle: Text(
                        horaInicio != null
                            ? '${horaInicio!.hour.toString().padLeft(2, '0')}:${horaInicio!.minute.toString().padLeft(2, '0')}'
                            : 'Não definido',
                      ),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        final horaSelecionada = await showTimePicker(
                          context: context,
                          initialTime: horaInicio ?? TimeOfDay.now(),
                          builder: (BuildContext context, Widget? child) {
                            return MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(alwaysUse24HourFormat: true),
                              child: child ?? Container(),
                            );
                          },
                        );
                        if (horaSelecionada != null) {
                          setState(() {
                            horaInicio = horaSelecionada;
                          });
                        }
                      },
                    ),
                    ListTile(
                      title: const Text('Hora Fim'),
                      subtitle: Text(
                        horaFim != null
                            ? '${horaFim!.hour.toString().padLeft(2, '0')}:${horaFim!.minute.toString().padLeft(2, '0')}'
                            : 'Não definido',
                      ),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        final horaSelecionada = await showTimePicker(
                          context: context,
                          initialTime: horaFim ?? TimeOfDay.now(),
                          builder: (BuildContext context, Widget? child) {
                            return MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(alwaysUse24HourFormat: true),
                              child: child ?? Container(),
                            );
                          },
                        );
                        if (horaSelecionada != null) {
                          setState(() {
                            horaFim = horaSelecionada;
                          });
                        }
                      },
                    )
                  ],
                );
              },
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Salvar'),
              onPressed: () {
                if (dataInicio != null && dataFim != null) {
                  _adicionarEvento(
                    dataInicio!,
                    dataFim!,
                    nomeController.text,
                    descricaoController.text,
                    horaInicio,
                    horaFim,
                  );
                  nomeController.clear(); // Limpar o campo após salvar
                  descricaoController.clear(); // Limpar o campo após salvar
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _mostrarModalAdicionarEvento,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(
                16.0), // Ajuste o valor conforme necessário
            child: SfCalendar(
              view: CalendarView.month,
              maxDate: DateTime(2100),
              minDate: DateTime(2023),
              headerStyle: const CalendarHeaderStyle(
                textAlign: TextAlign.center,
                textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: (CalendarTapDetails details) {
                if (details.targetElement == CalendarElement.calendarCell) {
                  _onDiaSelecionado(details.date!);
                }
              },
              monthViewSettings: const MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                monthCellStyle: MonthCellStyle(
                  backgroundColor: Colors.transparent,
                  textStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              dataSource: EventoDataSource(
                  _eventos.values.expand((eventList) => eventList).toList()),
            ),
          ),
          Expanded(
            child: ListView(
              children: _carregarEventosPorDia(_diaSelecionado!)
                  .map(
                    (evento) => ListTile(
                      title: Text(evento.nome),
                      subtitle: Text(
                        '${evento.descricao}\n'
                        'Início: ${evento.horaInicio != null ? '${DateFormat('dd/MM/yyyy').format(evento.dataInicio)} ${evento.horaInicio!.hour.toString().padLeft(2, '0')}:${evento.horaInicio!.minute.toString().padLeft(2, '0')}' : 'Dia Todo'} - '
                        'Fim: ${evento.horaFim != null ? '${DateFormat('dd/MM/yyyy').format(evento.dataFim)} ${evento.horaFim!.hour.toString().padLeft(2, '0')}:${evento.horaFim!.minute.toString().padLeft(2, '0')}' : 'Dia Todo'}',
                      ),
                      tileColor: evento.cor.withOpacity(0.3),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class EventoModel {
  final String nome;
  final String descricao;
  final DateTime dataInicio;
  final DateTime dataFim;
  final Color cor;
  final TimeOfDay? horaInicio;
  final TimeOfDay? horaFim;

  EventoModel({
    required this.nome,
    required this.descricao,
    required this.dataInicio,
    required this.dataFim,
    required this.cor,
    this.horaInicio,
    this.horaFim,
  });
}

class EventoDataSource extends CalendarDataSource {
  EventoDataSource(List<EventoModel> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    final EventoModel evento = appointments![index] as EventoModel;
    return evento.dataInicio;
  }

  @override
  DateTime getEndTime(int index) {
    final EventoModel evento = appointments![index] as EventoModel;
    return evento.dataFim;
  }

  @override
  String getSubject(int index) {
    final EventoModel evento = appointments![index] as EventoModel;
    return evento.nome;
  }

  @override
  Color getColor(int index) {
    final EventoModel evento = appointments![index] as EventoModel;
    return evento.cor;
  }
}
