import 'package:flutter/material.dart';
import 'package:gtk_flutter/src/event.dart';
import 'package:gtk_flutter/upcoming_events_list.dart';


// ignore: must_be_immutable
class UpcomingEventsPage extends StatefulWidget{
  UpcomingEventsPage({required this.upcomingEventsList});

  UpcomingEventsList upcomingEventsList;

  

  @override
  State<UpcomingEventsPage> createState() => _UpcomingEventsPageState();
}

class _UpcomingEventsPageState extends State<UpcomingEventsPage> {
 

  
  @override
  Widget build(BuildContext context) {
    List<Event> upcomingEventsList = widget.upcomingEventsList.getUpcomingEvents();
    return Scaffold(
       appBar: AppBar(
          title: const Text('Upcoming Events'),
        ),
         body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: upcomingEventsList.map((item) {
            return EventListItem(
              event: item,
              
            );
          }).toList(),
        ),
    );
  }

}