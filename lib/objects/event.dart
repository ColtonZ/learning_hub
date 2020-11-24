import 'package:cloud_firestore/cloud_firestore.dart';

//this is a class for each event
class Event {
  //this just says which variables are needed for each event object
  final String classSet;
  final String location;
  final String name;
  final String platform;
  final String teacher;
  final List<String> times;

  //constructor
  Event(
      {this.classSet,
      this.location,
      this.name,
      this.platform,
      this.teacher,
      this.times});

  //creates a event object, given a line from a text file
  factory Event.fromFirestore(DocumentSnapshot document) {
    Map<String, dynamic> documentMap = document.data();
    List<String> t = new List<String>();
    (documentMap["times"] as List).forEach((time) {
      t.add(time);
    });
    return Event(
      //return the event's subject, room, teacher and time, having taken in the event details as a comma separated list
      classSet: document["classSet"],
      location: document["location"],
      name: document["name"],
      platform: document["platform"],
      teacher: document["teacher"],
      times: t,
    );
  }

  void output() {
    print(
        "classSet: $classSet | location: $location | name: $name | platform: $platform | teacher: $teacher | times: $times");
  }
}
