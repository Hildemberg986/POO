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
  bool _maisDeUmDia = false;

  String formatTimeOfDay(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

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

  void _adicionarEvento(
      DateTime dataInicio,
      DateTime dataFim,
      String nome,
      String descricao,
      String local,
      TimeOfDay? horaInicio,
      TimeOfDay? horaFim) {
    if (dataInicio.isAfter(dataFim)) return;

    final evento = EventoModel(
      nome: nome,
      descricao: descricao,
      local: local,
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

  void _editarEvento(
      EventoModel eventoParaEditar,
      DateTime dataInicio,
      DateTime dataFim,
      String nome,
      String descricao,
      String local,
      TimeOfDay? horaInicio,
      TimeOfDay? horaFim) {
    setState(() {
      for (var dia = dataInicio;
          !dia.isAfter(dataFim);
          dia = dia.add(const Duration(days: 1))) {
        _eventos[dia]?.remove(eventoParaEditar);
      }
      _adicionarEvento(
          dataInicio, dataFim, nome, descricao, local, horaInicio, horaFim);
    });
  }

  Future<void> _mostrarModalAdicionarEvento(
      {EventoModel? eventoParaEditar}) async {
    DateTime? dataInicio = eventoParaEditar?.dataInicio ?? _diaSelecionado;
    DateTime? dataFim = eventoParaEditar?.dataFim ?? _diaSelecionado;
    TimeOfDay? horaInicio = eventoParaEditar?.horaInicio;
    TimeOfDay? horaFim = eventoParaEditar?.horaFim;
    final TextEditingController nomeController =
        TextEditingController(text: eventoParaEditar?.nome);
    final TextEditingController descricaoController =
        TextEditingController(text: eventoParaEditar?.descricao);
    final TextEditingController localController =
        TextEditingController(text: eventoParaEditar?.local);
    bool diaTodo = eventoParaEditar?.horaInicio == null &&
        eventoParaEditar?.horaFim == null;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              eventoParaEditar == null ? 'Adicionar Evento' : 'Editar Evento'),
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
                    TextField(
                      controller: localController,
                      decoration:
                          const InputDecoration(labelText: 'Local do Evento'),
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      title: const Text('Data Início'),
                      subtitle: Text(DateFormat('dd/MM/yyyy')
                          .format(dataInicio ?? DateTime.now())),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final dataSelecionada = await showDatePicker(
                          context: context,
                          initialDate: dataInicio ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (dataSelecionada != null) {
                          setState(() {
                            dataInicio = dataSelecionada;
                            if (!_maisDeUmDia) {
                              dataFim = dataInicio;
                            }
                          });
                        }
                      },
                    ),
                    ListTile(
                      title: const Text('Mais de um dia?'),
                      trailing: Switch(
                        value: _maisDeUmDia,
                        onChanged: (value) {
                          setState(() {
                            _maisDeUmDia = value;
                            if (!value) {
                              dataFim = dataInicio;
                            }
                          });
                        },
                      ),
                    ),
                    if (_maisDeUmDia) ...[
                      ListTile(
                        title: const Text('Data Fim'),
                        subtitle: Text(DateFormat('dd/MM/yyyy')
                            .format(dataFim ?? DateTime.now())),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final dataSelecionada = await showDatePicker(
                            context: context,
                            initialDate: dataFim ?? DateTime.now(),
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
                    ],
                    ListTile(
                      title: const Text('Dia Todo'),
                      trailing: Switch(
                        value: diaTodo,
                        onChanged: (value) {
                          setState(() {
                            diaTodo = value;
                            if (value) {
                              // Se "Dia Todo" estiver marcado, define as horas para 00:00 e 23:59
                              horaInicio = const TimeOfDay(hour: 0, minute: 0);
                              horaFim = const TimeOfDay(hour: 23, minute: 59);
                            } else {
                              // Se desmarcar "Dia Todo", permite que o usuário defina as horas
                              horaInicio =
                                  null; // Aqui, você pode deixar o campo de hora em branco
                              horaFim =
                                  null; // Aqui, você pode deixar o campo de hora em branco
                            }
                          });
                        },
                      ),
                    ),
                    if (!diaTodo) ...[
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
                      ),
                    ],
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
                // Verificar se horaInicio e horaFim estão definidos
                if (dataInicio != null && dataFim != null) {
                  if (!diaTodo && (horaInicio == null || horaFim == null)) {
                    // Exibir um alerta ou aviso se as horas não estiverem definidas e "Dia Todo" não estiver marcado
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Por favor, defina as horas de início e fim.'),
                      ),
                    );
                    return;
                  }

                  if (eventoParaEditar != null) {
                    _editarEvento(
                        eventoParaEditar,
                        dataInicio!,
                        dataFim!,
                        nomeController.text,
                        descricaoController.text,
                        localController.text,
                        diaTodo
                            ? const TimeOfDay(hour: 0, minute: 0)
                            : horaInicio,
                        diaTodo
                            ? const TimeOfDay(hour: 23, minute: 59)
                            : horaFim);
                  } else {
                    _adicionarEvento(
                        dataInicio!,
                        dataFim!,
                        nomeController.text,
                        descricaoController.text,
                        localController.text,
                        diaTodo
                            ? const TimeOfDay(hour: 0, minute: 0)
                            : horaInicio,
                        diaTodo
                            ? const TimeOfDay(hour: 23, minute: 59)
                            : horaFim);
                  }
                  nomeController.clear();
                  descricaoController.clear();
                  localController.clear();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _deletarEvento(EventoModel evento) {
    setState(() {
      for (var dia = evento.dataInicio;
          !dia.isAfter(evento.dataFim);
          dia = dia.add(const Duration(days: 1))) {
        _eventos[dia]?.remove(evento);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _mostrarModalAdicionarEvento(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SfCalendar(
              view: CalendarView.month,
              maxDate: DateTime(2100),
              minDate: DateTime(2023),
              headerStyle: const CalendarHeaderStyle(
                textAlign: TextAlign.center,
                textStyle: TextStyle(fontSize: 20),
              ),
              onTap: (CalendarTapDetails details) {
                if (details.targetElement == CalendarElement.calendarCell) {
                  _onDiaSelecionado(details.date!);
                }
              },
              monthViewSettings: const MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
              ),
              // Os eventos serão exibidos no calendário.
              dataSource:
                  EventosDataSource(_carregarEventosPorDia(_diaSelecionado!)),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _carregarEventosPorDia(_diaSelecionado!).length,
              itemBuilder: (context, index) {
                final evento = _carregarEventosPorDia(_diaSelecionado!)[index];
                return ListTile(
                  title: Text(evento.nome),
                  subtitle: Text(
                    '${evento.local}\n${evento.descricao}\nInício: ${DateFormat('dd/MM/yyyy').format(evento.dataInicio)} às ${evento.horaInicio != null ? formatTimeOfDay(evento.horaInicio!) : 'Não definido'}\nFim: ${DateFormat('dd/MM/yyyy').format(evento.dataFim)} às ${evento.horaFim != null ? formatTimeOfDay(evento.horaFim!) : 'Não definido'}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _mostrarModalAdicionarEvento(
                            eventoParaEditar: evento),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _deletarEvento(evento);
                        },
                      ),
                    ],
                  ),
                );
              },
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
  final String local;
  final DateTime dataInicio;
  final DateTime dataFim;
  final Color cor;
  final TimeOfDay? horaInicio;
  final TimeOfDay? horaFim;

  EventoModel({
    required this.nome,
    required this.descricao,
    required this.local,
    required this.dataInicio,
    required this.dataFim,
    required this.cor,
    this.horaInicio,
    this.horaFim,
  });
}

class EventosDataSource extends CalendarDataSource {
  EventosDataSource(List<EventoModel> eventos) {
    appointments = eventos;
  }

  @override
  DateTime getStartTime(int index) {
    return (appointments![index] as EventoModel).dataInicio;
  }

  @override
  DateTime getEndTime(int index) {
    return (appointments![index] as EventoModel).dataFim;
  }

  @override
  String getSubject(int index) {
    return (appointments![index] as EventoModel).nome;
  }

  @override
  Color getColor(int index) {
    return (appointments![index] as EventoModel).cor;
  }
}
