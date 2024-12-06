import 'dart:core';

class Event {
    final String title;
    final DateTime dateAndTime;
    final String description;
    final String username;
    final int color;
    Event(this.title, this.description, this.dateAndTime,this.username,this.color);

  

  DateTime getDate(){
    return dateAndTime;
  }
  @override
    String getTitle(){
      return title;
    }

    String getUsername(){
      return username;
    }
    int getColor(){
      return color;
    }


}


