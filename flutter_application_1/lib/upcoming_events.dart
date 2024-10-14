
import 'dart:core';


import 'package:gtk_flutter/objects/events.dart';

class UpcomingEventsList{
    UpcomingEventsList({required this.eventsData});
    //will need to talk to firebase to parse through upcoming events and get the most recent ones
    DateTime currentDate = DateTime.now();

    List<Events> eventsData;

    Duration duration = 14 as Duration;


    List<Events> getUpcomingEvents(){
        List<Events> upcomingEventsList = [];
        for (var event in eventsData) {
            if (currentDate.difference(event.getDate()) <= duration){
                upcomingEventsList.add(event);
            }
          
        }
        return upcomingEventsList;
    }
    
}