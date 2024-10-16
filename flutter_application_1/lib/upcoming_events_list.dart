
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:gtk_flutter/calendar_page.dart';
import 'package:gtk_flutter/src/event.dart';

//if this file is red for you, its probably due to some difference in the events.dart page
//this has to do with the event time variable issue I added on github

class UpcomingEventsList{
    UpcomingEventsList({required this.eventsData});
    //will need to talk to firebase to parse through upcoming events and get the most recent ones
    DateTime currentDate = DateTime.now();
    
    

    Map<DateTime, List<Event>> eventsData;

    List<Event> getUpcomingEvents(){
        List<Event> upcomingEventsList = [];
        for (var event in eventsData.values) {
          for (var y in event){
            if (y.getDate().compareTo(currentDate)>= 0){
            upcomingEventsList.add(y);
            }

          }
    
        }
        return upcomingEventsList;
    }
}



class EventListItem extends StatefulWidget {
  EventListItem(
      {required this.event})
      : super(key: ObjectKey(event));

  final Event event;


  @override
  State<EventListItem> createState() => _EventListItemState();
}

class _EventListItemState extends State<EventListItem> {
  
  @override
  Widget build(BuildContext context) {
    return ListTile(   
      title: Text(widget.event.title,),
      subtitle: Text(widget.event.description),
    );
  }
}