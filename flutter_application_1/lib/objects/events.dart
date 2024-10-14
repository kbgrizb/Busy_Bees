class Events {
  Events({required this.dateAndTime, required this.description});

  DateTime dateAndTime;
  String description;

  DateTime getDate(){
    return dateAndTime;
  }

}