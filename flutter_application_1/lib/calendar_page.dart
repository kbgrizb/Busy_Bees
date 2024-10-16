import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gtk_flutter/app_state.dart';
import 'package:gtk_flutter/src/event.dart';
import 'package:gtk_flutter/upcoming_events_list.dart';
import 'package:gtk_flutter/upcoming_events_page.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'src/widgets.dart';

class CalendarPage extends StatefulWidget {
  CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  TextEditingController _eventNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  CalendarFormat calendarFormat = CalendarFormat.month;
  late final ValueNotifier<List<Event>> _selectedEvents;

  StreamSubscription<QuerySnapshot>? _guestBookSubscription;
  Map<DateTime, List<Event>> events = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    getEventsFromFirestore();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    _eventNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> getEventsFromFirestore() async {
    FirebaseFirestore.instance.collection('events').snapshots().listen((snapshot) {
      setState(() {
        events.clear();  

        for (var doc in snapshot.docs) {
          DateTime eventDate = (doc['date'] as Timestamp).toDate();
          DateTime normalizedDate = DateTime(eventDate.year, eventDate.month, eventDate.day);

          Event event = Event(
            doc['eventname'],
            doc['description'],
            eventDate,
          );

          if (events[normalizedDate] != null) {
            events[normalizedDate]!.add(event);
          } else {
            events[normalizedDate] = [event];
          }
        }
        _selectedEvents.value = _getEventsForDay(_selectedDay!);
      });
    });
  }

  List<Event> _getEventsForDay(DateTime day) {
    DateTime normalizedDay = DateTime(day.year, day.month, day.day);
    return events[normalizedDay] ?? [];
  }

  // On day selected handler
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedEvents.value = _getEventsForDay(selectedDay);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BusyBees'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final appState = context.read<ApplicationState>();
          if (!appState.loggedIn) {
            context.push('/sign-in');
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  scrollable: true,
                  title: const Text("Add New Event"),
                  content: Column(
                    children: [
                      TextField(
                        controller: _eventNameController,
                        decoration: const InputDecoration(hintText: "Event Name"),
                      ),
                      TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(hintText: "Event Description"),
                      ),
                    ],
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        DateTime selectedDay = DateTime(
                          _selectedDay!.year, _selectedDay!.month, _selectedDay!.day);

                        FirebaseFirestore.instance.collection('events').add({
                          'description': _descriptionController.text,
                          'date': selectedDay,  // Save normalized date
                          'eventname': _eventNameController.text,
                          'name': FirebaseAuth.instance.currentUser!.displayName,
                          'userId': FirebaseAuth.instance.currentUser!.uid,
                        });

                        if (events[selectedDay] != null) {
                          events[selectedDay]!.add(
                            Event(_eventNameController.text, _descriptionController.text, selectedDay),
                          );
                        } else {
                          events[selectedDay] = [
                            Event(_eventNameController.text, _descriptionController.text, selectedDay)
                          ];
                        }
                        _eventNameController.clear();
                        _descriptionController.clear();
                        Navigator.of(context).pop();
                        _selectedEvents.value = _getEventsForDay(selectedDay);
                      },
                      child: const Text("OK"),
                    ),
                  ],
                );
              },
            );
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
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
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(value[index].getTitle()),
                        subtitle: Text(value[index].description),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => UpcomingEventsPage(
                upcomingEventsList: UpcomingEventsList(eventsData: events),
              ),
            ),
          );
        },
        child: const Icon(Icons.list),
      ),
    );
  }
}
