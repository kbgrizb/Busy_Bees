

import 'package:flutter/material.dart';
import 'package:gtk_flutter/src/event.dart';
import 'package:table_calendar/table_calendar.dart';
import 'src/widgets.dart';
//https://pub.dev/packages/table_calendar <-- where I got the table calendar

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, List<Event>> events = {};
  TextEditingController _eventNameController = TextEditingController();
  CalendarFormat calendarFormat = CalendarFormat.month;
  late final ValueNotifier<List<Event>> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedEvents.value = _getEventsForDay(selectedDay);
      });
    }
  }

List<Event> _getEventsForDay(DateTime day){
  return events[day]??[];
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BusyBees'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (context){
            return AlertDialog(
              scrollable: true,
              title: Text("Event Name"),
              content: Padding(padding: EdgeInsets.all(8),
              child: TextField(controller: _eventNameController),
              ),
              actions: [
                ElevatedButton(
                  onPressed: (){
                    events.addAll({
                      _selectedDay!:[Event(_eventNameController.text)]
                    });
                    Navigator.of(context).pop();
                    _selectedEvents.value = _getEventsForDay(_selectedDay!);
                  },
                  child: Text("OK"),
                )
              ],
            );
          });
        },
        child: Icon(Icons.add),
        ),
      body: Column(
        children: [
        TableCalendar(
        headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        ),
        firstDay: DateTime.utc(2024, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: DateTime.now(),
        eventLoader: _getEventsForDay,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: _onDaySelected,
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
      ),
      SizedBox(height: 8.0),
      Expanded(
      child: ValueListenableBuilder<List<Event>>
        (valueListenable: _selectedEvents, 
        builder: (context,value,_){
          return ListView.builder(
            itemCount: value.length,
            itemBuilder: (context, index){
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                onTap: ()=>print(""),
                title:Text("${value[index]}"),
              ),
            );
        });
      })
      )
      ],
      ),
    );
  }
  }