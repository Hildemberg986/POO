import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

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
          Expanded(
            child: SfCalendar(
              view: CalendarView.month,
              dataSource: MeetingDataSource(meetings),
              monthViewSettings: const MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
              ),
              onTap: (CalendarTapDetails details) {
                if (details.targetElement == CalendarElement.calendarCell) {
                  _showEventsForDay(details.date!);
                } else if (details.targetElement ==
                    CalendarElement.appointment) {
                  _editEvent(details.appointments![0]);
                }
              },
            ),
          ),
          if (eventsForDay.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Eventos do dia:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...eventsForDay.map(
                    (event) => ListTile(
                      title: Text(event.eventName),
                      subtitle: Text(
                          '${event.from.hour}:${event.from.minute} - ${event.to.hour}:${event.to.minute}'),
                      onTap: () => _editEvent(event),
                    ),
                  ),
                ],
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
    }
  }

  void _showEventsForDay(DateTime day) {
    final events = meetings.where((event) {
      return event.from.year == day.year &&
          event.from.month == day.month &&
          event.from.day == day.day;
    }).toList();

    setState(() {
      eventsForDay = events;
    });
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
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now().add(const Duration(hours: 1));

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      _eventNameController.text = widget.event!.eventName;
      _descriptionController.text = widget.event!.description;
      _startTime = widget.event!.from;
      _endTime = widget.event!.to;
    }
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira um nome para o evento';
                }
                return null;
              },
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
            ListTile(
  title: Text('Início: ${_startTime.toLocal().toString().substring(0, 16)}'),
  trailing: const Icon(Icons.calendar_today),
  onTap: () async {
    // Selecionar a data
    final date = await showDatePicker(
      context: context,
      initialDate: _startTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      // Selecionar a hora
      final time = await showTimePicker(
        // ignore: use_build_context_synchronously
        context: context,
        initialTime: TimeOfDay.fromDateTime(_startTime),
      );
      if (time != null) {
        setState(() {
          // Juntar data e hora
          _startTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  },
),
ListTile(
  title: Text('Fim: ${_endTime.toLocal().toString().substring(0, 16)}'),
  trailing: const Icon(Icons.calendar_today),
  onTap: () async {
    // Selecionar a data
    final date = await showDatePicker(
      context: context,
      initialDate: _endTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      // Selecionar a hora
      final time = await showTimePicker(
        // ignore: use_build_context_synchronously
        context: context,
        initialTime: TimeOfDay.fromDateTime(_endTime),
      );
      if (time != null) {
        setState(() {
          // Juntar data e hora
          _endTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  },
),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop(Meeting(
                _eventNameController.text,
                _startTime,
                _endTime,
                Colors.blue,
                false,
                _descriptionController.text,
              ));
            }
          },
          child: const Text('Salvar'),
        ),
      ],
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
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay,
      this.description);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  String description;
}
