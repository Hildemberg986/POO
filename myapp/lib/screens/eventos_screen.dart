import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventosScreen extends StatefulWidget {
  const EventosScreen({Key? key}) : super(key: key);

  @override
  _EventosScreenState createState() => _EventosScreenState();
}

class _EventosScreenState extends State<EventosScreen> {
  List<Meeting> meetings = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendário de Eventos'),
      ),
      body: SfCalendar(
        view: CalendarView.month,
        dataSource: MeetingDataSource(meetings),
        monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
        ),
        onTap: (CalendarTapDetails details) {
          if (details.targetElement == CalendarElement.calendarCell) {
            _showEventsForDay(details.date!);
          }
        },
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

  void _showEventsForDay(DateTime day) {
    final events = meetings.where((event) {
      return event.from.isAtSameMomentAs(day) ||
          (event.from.isBefore(day) && event.to.isAfter(day));
    }).toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eventos no dia ${day.day}/${day.month}/${day.year}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: events
              .map(
                (event) => ListTile(
                  title: Text(event.eventName),
                  subtitle: Text(
                      '${event.from.hour}:${event.from.minute} - ${event.to.hour}:${event.to.minute}'),
                ),
              )
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}

class AddEventDialog extends StatefulWidget {
  const AddEventDialog({Key? key}) : super(key: key);

  @override
  _AddEventDialogState createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  final _formKey = GlobalKey<FormState>();
  final _eventNameController = TextEditingController();
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now().add(const Duration(hours: 1));

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adicionar Evento'),
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
            ListTile(
              title: Text('Início: ${_startTime.toString()}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _startTime,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_startTime),
                  );
                  if (time != null) {
                    setState(() {
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
              title: Text('Fim: ${_endTime.toString()}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _endTime,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_endTime),
                  );
                  if (time != null) {
                    setState(() {
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
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}