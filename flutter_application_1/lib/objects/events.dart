class Events {
  final DateTime dateAndTime;
  final String description;
  final String title;
  Events(this.dateAndTime, this.title, this.description);

  

  DateTime getDate(){
    return dateAndTime;
  }
  @override
    String toString(){
      return title;
    }

}
/*
class Event {
    final String title;
    final String description;
    Event(this.title, this.description);

    @override
    String toString(){
      return title;
    }


}*/