//this is where events will be stored and saved to cloud
/*
import 'dart:js_interop';

import 'package:firebase_database/firebase_database.dart';
import 'package:gtk_flutter/src/event.dart';

class Events{

  DatabaseReference ref = FirebaseDatabase.instance.ref('Events');


  Future<void> saveData(Object? eventData) async {
    await ref.set(eventData);
  }
  

  Future<void> getData() async {
    ref.onValue.listen((DatabaseEvent event) {
    final data = event.snapshot.value;
    saveData(data);
});

}
}*/