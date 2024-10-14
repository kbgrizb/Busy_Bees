

import 'package:flutter/material.dart';
import 'package:gtk_flutter/objects/events.dart';
import 'package:gtk_flutter/upcoming_events_list.dart';
import 'package:gtk_flutter/upcoming_events_page.dart';
import 'package:table_calendar/table_calendar.dart';
import 'src/widgets.dart';
//https://pub.dev/packages/table_calendar <-- where I got the table calendar

//for testing
//List<Events> eventsData = [(Events(date: DateTime(2024, 10, 20, 17, 30), description: 'test'))];
//UpcomingEventsList eventsList = UpcomingEventsList(eventsData: eventsData);

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat calendarFormat = CalendarFormat.month;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BusyBees'),
      ),
      body: 
      TableCalendar(
        headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        ),
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: DateTime.now(),
      selectedDayPredicate: (day) {
  return isSameDay(_selectedDay, day);
},
onDaySelected: (selectedDay, focusedDay) {
  setState(() {
    _selectedDay = selectedDay;
    _focusedDay = focusedDay;
  });
},
onPageChanged: (focusedDay) {
  focusedDay = focusedDay;
},
    ),
    /*bottomNavigationBar: 
    
               / ElevatedButton(onPressed: () async {await Navigator.of(context).push(
              MaterialPageRoute(
        
                builder: (context) => UpcomingEventsPage(upcomingEventsList: eventsList),
              ),
            );},
                child: const Icon(Icons.accessible)),*/
              
   
    );
    
  }
  }