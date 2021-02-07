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

  //creates a event object, given a Firestore document
  factory Event.fromFirestore(DocumentSnapshot document) {
    Map<String, dynamic> documentMap = document.data();
    List<List<String>> t = new List<List<String>>();
    //loop through each of the event's times, and convert it into a list
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

//https://www.woolha.com/tutorials/dart-sorting-list-with-comparator-and-comparable

//defines how to compare events to each other (for sorting a list of events)
  int compareTo(Event other) {
    //if the tasks start at the same time, compare their end times; otherwise return the difference of their times
    if (times[0][1] == other.times[0][1]) {
      //if the tasks end at the same time, compare their names alphabetically; otherwise return the difference of their times
      if (times[0][2] == other.times[0][2]) {
        //return the alphabetical difference of their names (if two events have the same name, start time and end time, the order is arbitrary)
        return name.compareTo(other.name);
      } else {
        return int.parse(times[0][2]) - int.parse(other.times[0][2]);
      }
    } else {
      return int.parse(times[0][1]) - int.parse(other.times[0][1]);
    }
  }
}
