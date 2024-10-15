import 'dart:core';

class Event {
    final String title;
    final DateTime dateAndTime;
    final String description;
    Event(this.title, this.description, this.dateAndTime);

    @override
    String toString(){
      return title;
    }

    DateTime getDate(){
      return dateAndTime;
    }


}


*/
