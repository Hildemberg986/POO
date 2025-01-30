import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart'; // Para formatar datas e horários

class EventosScreen extends StatefulWidget {
  const EventosScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EventosScreenState createState() => _EventosScreenState();
}

class _EventosScreenState extends State<EventosScreen> {
  List<Meeting> meetings = [];
  List<Meeting> eventsForDay = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 500, // Altura aumentada para 500 pixels
            child: SfCalendar(
              view: CalendarView.month,
              dataSource: MeetingDataSource(meetings),
              monthViewSettings: const MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                showTrailingAndLeadingDates: false,
              ),
              onTap: (CalendarTapDetails details) {
                if (details.targetElement == CalendarElement.calendarCell) {
                  _showEventsForDay(details.date!);
                }
              },
            ),
          ),
          if (eventsForDay.isNotEmpty)
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Eventos do dia:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ...eventsForDay.map(
                        (event) => Container(
                          decoration: BoxDecoration(
                            color: event.background.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text(event.eventName),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Descrição: ${event.description}'),
                                Text('Local: ${event.local}'),
                                Text(
                                    'Data de Início: ${DateFormat('dd/MM/yyyy HH:mm').format(event.from)}'),
                                Text(
                                    'Data de Fim: ${DateFormat('dd/MM/yyyy HH:mm').format(event.to)}'),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _editEvent(event),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => _deleteEvent(event),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addEvent(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addEvent() async {
    final newEvent = await showDialog<Meeting>(
      context: context,
      builder: (context) => const AddEventDialog(),
    );

    if (newEvent != null) {
      setState(() {
        meetings.add(newEvent);
      });
      _updateEventsForDay();
    }
  }

  void _editEvent(Meeting event) async {
    final editedEvent = await showDialog<Meeting>(
      context: context,
      builder: (context) => AddEventDialog(event: event),
    );

    if (editedEvent != null) {
      setState(() {
        final index = meetings.indexOf(event);
        if (index != -1) {
          meetings[index] = editedEvent;
        }
      });
      _updateEventsForDay();
    }
  }

  void _deleteEvent(Meeting event) {
    setState(() {
      meetings.remove(event);
      eventsForDay.remove(event);
    });
    _updateEventsForDay();
  }

  void _showEventsForDay(DateTime day) {
    final events = meetings.where((event) {
      // Verifica se o dia está dentro do intervalo do evento (inclusive)
      return day.isAfter(event.from.subtract(const Duration(days: 1))) &&
          (day.isAtSameMomentAs(event.to) || day.isBefore(event.to));
    }).toList();

    setState(() {
      eventsForDay = events;
    });
  }

  void _updateEventsForDay() {
    // Atualiza os eventos para o dia atual
    final today = DateTime.now();
    _showEventsForDay(today);
  }
}

class AddEventDialog extends StatefulWidget {
  final Meeting? event;

  const AddEventDialog({Key? key, this.event}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddEventDialogState createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  final _formKey = GlobalKey<FormState>();
  final _eventNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _localController = TextEditingController();
  DateTime _startDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  DateTime _endDate = DateTime.now().add(const Duration(hours: 1));
  TimeOfDay _endTime = TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 1);

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      _eventNameController.text = widget.event!.eventName;
      _descriptionController.text = widget.event!.description;
      _localController.text = widget.event!.local;
      _startDate = widget.event!.from;
      _startTime = TimeOfDay.fromDateTime(widget.event!.from);
      _endDate = widget.event!.to;
      _endTime = TimeOfDay.fromDateTime(widget.event!.to);
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        if (isStart) {
          _startDate = date;
        } else {
          _endDate = date;
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final time = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (time != null) {
      setState(() {
        if (isStart) {
          _startTime = time;
        } else {
          _endTime = time;
        }
      });
    }
  }

  // Função para gerar uma cor aleatória (evitando cores muito escuras)
  Color _generateRandomColor() {
    final random = Random();
    return Color.fromRGBO(
      random.nextInt(200), // Red (0-200 para evitar cores escuras)
      random.nextInt(200), // Green (0-200 para evitar cores escuras)
      random.nextInt(200), // Blue (0-200 para evitar cores escuras)
      1.0, // Opacidade
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.event == null
          ? const Text('Adicionar Evento')
          : const Text('Editar Evento'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _eventNameController,
              decoration: const InputDecoration(labelText: 'Nome do Evento'),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Insira um nome' : null,
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descrição'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira uma descrição para o evento';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _localController,
              decoration: const InputDecoration(labelText: 'Local'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira um local para o evento';
                }
                return null;
              },
            ),
            ListTile(
              title: Text(
                  'Data de Início: ${DateFormat('dd/MM/yyyy').format(_startDate)}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, true),
            ),
            ListTile(
              title: Text('Hora de Início: ${_startTime.format(context)}'),
              trailing: const Icon(Icons.access_time),
              onTap: () => _selectTime(context, true),
            ),
            ListTile(
              title: Text(
                  'Data de Fim: ${DateFormat('dd/MM/yyyy').format(_endDate)}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, false),
            ),
            ListTile(
              title: Text('Hora de Fim: ${_endTime.format(context)}'),
              trailing: const Icon(Icons.access_time),
              onTap: () => _selectTime(context, false),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.of(context).pop(Meeting(
                    _eventNameController.text,
                    DateTime(
                      _startDate.year,
                      _startDate.month,
                      _startDate.day,
                      _startTime.hour,
                      _startTime.minute,
                    ),
                    DateTime(
                      _endDate.year,
                      _endDate.month,
                      _endDate.day,
                      _endTime.hour,
                      _endTime.minute,
                    ),
                    _generateRandomColor(), // Cor aleatória
                    false,
                    _descriptionController.text,
                    _localController.text,
                  ));
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(
    this.eventName,
    this.from,
    this.to,
    this.background,
    this.isAllDay,
    this.description,
    this.local,
  );

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  String description;
  String local;
}
