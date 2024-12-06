import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:go_router/go_router.dart';
import 'package:gtk_flutter/app_state.dart';
import 'package:gtk_flutter/profile_screen.dart';
import 'package:gtk_flutter/src/event.dart';
import 'package:gtk_flutter/upcoming_events_list.dart';
import 'package:gtk_flutter/upcoming_events_page.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'src/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
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
  TextEditingController _timeController = TextEditingController();
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
    _timeController.dispose();
    super.dispose();
  }

  Future<void> getEventsFromFirestore() async {
    FirebaseFirestore.instance
        .collection('events')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        events.clear();
        for (var doc in snapshot.docs) {
          Map<String, dynamic> map = doc.data();
          DateTime eventDate = (doc['date'] as Timestamp).toDate();
          DateTime normalizedDate = DateTime(eventDate.year, eventDate.month, eventDate.day);
          int clrNum = Colors.black.value;
          if (map.containsKey('color')){
            clrNum = map['color'];
          }
          Event event = Event(
            doc['eventname'],
            doc['description'],
            eventDate,
            doc['name'],
            clrNum
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
Widget _buildEventMarkers(List<Event> events) {
    return Row(
      mainAxisSize: MainAxisSize.min, 
      children: events.map((event) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 1),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Color(event.color),
            shape: BoxShape.circle,
          ),
        );
      }).toList(),
    );
  }
  @override
  Widget build(BuildContext context) {
    final currentColor = context.watch<ApplicationState>().currentColor;

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
                          decoration:
                              const InputDecoration(hintText: "Event Name"),
                        ),
                        TextField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                              hintText: "Event Description"),
                        ),
                        TextField(
                          controller: _timeController,
                          decoration: const InputDecoration(
                              hintText: "Time"),
                          keyboardType: TextInputType.datetime,
                        ),
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {

                          List<String> hoursAndMinutes = _timeController.text.split(':');
                          int hours;
                          int minutes;
                          
                          if(hoursAndMinutes.length > 1) {
                            hours = int.parse(hoursAndMinutes[0]);
                            minutes = int.parse(hoursAndMinutes[1]);
                          } else {
                            hours = 0;
                            minutes = 0;
                          }

                          DateTime selectedDay = DateTime(_selectedDay!.year,
                              _selectedDay!.month, _selectedDay!.day, hours, minutes);
                            int current = currentColor.value;
                          FirebaseFirestore.instance.collection('events').add({
                            'description': _descriptionController.text,
                            'date': selectedDay, // Save normalized date
                            'eventname': _eventNameController.text,
                            'name':
                                FirebaseAuth.instance.currentUser!.displayName,
                            'userId': FirebaseAuth.instance.currentUser!.uid,
                            'color': current
                          });

                          String curUser =
                              FirebaseAuth.instance.currentUser!.uid;

                          if (events[selectedDay] != null) {
                            events[selectedDay]!.add(
                              Event(
                                  _eventNameController.text,
                                  _descriptionController.text,
                                  DateTime(selectedDay.year,
                                  selectedDay.month,
                                  selectedDay.day,
                                  hours,
                                  minutes,
                                  ),
                                  curUser,current),
                            );
                          } else {
                            events[selectedDay] = [
                              Event(
                                  _eventNameController.text,
                                  _descriptionController.text,
                                  DateTime(selectedDay.year,
                                  selectedDay.month,
                                  selectedDay.day,
                                  hours,
                                  minutes,
                                  ),
                                  curUser,current)
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
            Image.asset('assets/BeeBanner.png'),
            TableCalendar(
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
              ),
              firstDay: DateTime.utc(2024, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarStyle: CalendarStyle(
                  defaultTextStyle: const TextStyle(color: Colors.orange),
                  weekendTextStyle: const TextStyle(color: Colors.amber),
                  // Changed to reflect chosen color
                  todayDecoration: BoxDecoration(
                      color: currentColor, shape: BoxShape.circle),
                  selectedDecoration: BoxDecoration(
                      color: currentColor, shape: BoxShape.circle),
                  markerDecoration: BoxDecoration(
                      color: currentColor, shape: BoxShape.circle)),
              eventLoader: _getEventsForDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: _onDaySelected,
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarBuilders: CalendarBuilders(
          markerBuilder: (context, day, events) {
            if (events.isEmpty) return SizedBox();
            return Positioned(
              bottom: 4, 
              left: 0,
              right: 0,
              child: Center(
                child: _buildEventMarkers(_getEventsForDay(day)),
              ));},
      ),
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
                        margin:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Text(value[index].dateAndTime.hour.toString() + ':' + value[index].dateAndTime.minute.toString()),
                          title: Text(value[index].getTitle()),
                          subtitle: Text(value[index].description),
                          trailing: Text(value[index].getUsername()),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Profile Button
                  ElevatedButton.icon(
                    onPressed: () async {
                      final currentUser = FirebaseAuth.instance.currentUser;
                      final username = currentUser?.displayName ?? "Guest";
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                                username: username, userColor: currentColor)),
                      );
                    },
                    icon: const Icon(Icons.person),
                    label: const Text('Profile'),
                  ),
                  // Moved Upcoming Events button
                  const SizedBox(width: 35.0),
                  ElevatedButton(
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UpcomingEventsPage(
                            upcomingEventsList:
                                UpcomingEventsList(eventsData: events),
                          ),
                        ),
                      );
                    },
                    child: const Icon(Icons.list),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
