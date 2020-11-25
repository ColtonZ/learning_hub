import 'package:cloud_firestore/cloud_firestore.dart';

//this is a class for each event
class Event implements Comparable<Event> {
  //this just says which variables are needed for each event object
  final String id;
  final String classSet;
  final String location;
  final String name;
  final String platform;
  final String teacher;
  final List<List<String>> times;

  //constructor
  Event(
      {this.id,
      this.classSet,
      this.location,
      this.name,
      this.platform,
      this.teacher,
      this.times});

  //creates a event object, given a line from a text file
  factory Event.fromFirestore(DocumentSnapshot document) {
    Map<String, dynamic> documentMap = document.data();
    List<List<String>> t = new List<List<String>>();
    (documentMap["times"] as List).forEach((time) {
      t.add(time.toString().split(", "));
    });
    return Event(
      //return the event's subject, room, teacher and time, having taken in the event details as a comma separated list
      id: document.id,
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

//https://www.woolha.com/tutorials/dart-sorting-list-with-comparator-and-comparable

  int compareTo(Event other) {
    if (times[0][1] == other.times[0][1]) {
      if (times[0][2] == other.times[0][2]) {
        return name.compareTo(other.name);
      } else {
        return int.parse(times[0][2]) - int.parse(other.times[0][2]);
      }
    } else {
      return int.parse(times[0][1]) - int.parse(other.times[0][1]);
    }
  }
}
