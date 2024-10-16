import 'dart:core';

class Event {
    final String title;
    final DateTime dateAndTime;
    final String description;
    final String username;
    Event(this.title, this.description, this.dateAndTime,this.username);

  

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


}


