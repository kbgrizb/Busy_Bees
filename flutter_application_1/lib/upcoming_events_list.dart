
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:gtk_flutter/calendar_page.dart';
import 'package:gtk_flutter/objects/events.dart';

//if this file is red for you, its probably due to some difference in the events.dart page
//this has to do with the event time variable issue I added on github

class UpcomingEventsList{
    UpcomingEventsList({required this.eventsData});
    //will need to talk to firebase to parse through upcoming events and get the most recent ones
    DateTime currentDate = DateTime.now();

    List<Events> eventsData;

    Duration duration = 14 as Duration;


    List<Events> getUpcomingEvents(){
        List<Events> upcomingEventsList = [];
        for (var event in eventsData) {
            if (event.getDate().difference(currentDate) <= duration){
                upcomingEventsList.add(event);
            }
          
        }
        return upcomingEventsList;
    }
    
}

typedef ToDoListChangedCallback = Function(Events item);
typedef ToDoListRemovedCallback = Function(Events item);


class EventListItem extends StatefulWidget {
  EventListItem(
      {required this.event})
      : super(key: ObjectKey(event));

  final Events event;


  
  TextStyle? _getTextStyle(BuildContext context) {

    return const TextStyle(
      color: Colors.black54,
      //decoration: TextDecoration.lineThrough,
    );
  }

  @override
  State<EventListItem> createState() => _EventListItemState();
}

class _EventListItemState extends State<EventListItem> {
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap:
        () async {await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CalendarPage(),
              ),
            
            );
        //HomeScreen: flora_dialog
      },
      
      onLongPress: 
           () {
            }
          ,
     
        
        //style: ElevatedButton.styleFrom(backgroundColor: widget.flora.type.rgbColor), //change
        //child: Text (widget.flora.getNumLocations()),
         
      
      title: Text(
        widget.event.getDate().toString(),
        style: widget._getTextStyle(context),
      ),
    );
  }
}