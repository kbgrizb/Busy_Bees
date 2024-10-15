

import 'package:flutter/material.dart';
import 'package:gtk_flutter/objects/events.dart';
import 'package:gtk_flutter/src/event.dart';
import 'package:gtk_flutter/upcoming_events_list.dart';
import 'package:gtk_flutter/upcoming_events_page.dart';
import 'package:gtk_flutter/upcoming_events_list.dart';
import 'package:gtk_flutter/upcoming_events_page.dart';
import 'package:table_calendar/table_calendar.dart';
import 'src/widgets.dart';
//https://pub.dev/packages/table_calendar <-- where I got the table calendar

//**********for testing, can be replaced with the events stored in the cloud************

//List<Events> eventsData = [(Events(DateTime(2024, 10, 20, 17, 30), 'testing', 'test'))];
//UpcomingEventsList eventsList = UpcomingEventsList(eventsData: eventsData);

class CalendarPage extends StatefulWidget {
  CalendarPage({super.key/*,required this.eventsData*/});
  //List<Events> eventsData;

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, List<Event>> events = {};
  TextEditingController _eventNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
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

List<Event>? list;

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
              title: Text("Add New Event"),
              content: Column(
                children: [
               TextField(
                controller: _eventNameController,
                decoration: InputDecoration(hintText: "Event Name"),
                ),
                TextField(
                controller: _descriptionController,
                decoration: InputDecoration(hintText: "Event Description"),
                ),
              ]),
              actions: [
                ElevatedButton(
                  onPressed: (){
                    if (events[_selectedDay] != null){
                      list = events[_selectedDay]!;
                      events.addAll({_selectedDay!: [...list!, ...[Event(_selectedDay as DateTime, _eventNameController.text, _descriptionController.text)]],});
                    }else{
                    
                    events.addAll({
                      _selectedDay!:[Event(_selectedDay as DateTime, _eventNameController.text, _descriptionController.text)]
                    });
                    }
                    _eventNameController.text = "";
                    _descriptionController.text = "";
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
        focusedDay: _focusedDay,
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
                subtitle: Text(value[index].description),
              ),
            );
        });
      })
      )
      ],
      ),
    bottomNavigationBar: 
    
                ElevatedButton(onPressed: () async {await Navigator.of(context).push(
              MaterialPageRoute(
        
                builder: (context) => UpcomingEventsPage(upcomingEventsList: UpcomingEventsList(eventsData: _getEventsForDay(_selectedDay!))),
                //*********************eventsList is the events stored in the cloud, a test item is commented out at the top****************
              ),
            );},
                child: const Icon(Icons.list)),
              
    );
    
  }
}







