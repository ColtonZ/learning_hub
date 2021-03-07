import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:learning_hub/objects/event.dart';

import 'firestoreBackend.dart';

Future<List<Event>> getEvents(
    DateTime eventsDate, User user, List<Event> allEvents) async {
  //get the current week (A or B)
  String week = await getCurrentWeek(databaseReference, user, eventsDate);

  List<Event> events = new List<Event>();

//loop through every event in the user's Firestore database
  for (Event event in allEvents) {
    //foreach event, see if at least one of the times matches today's date
    for (List<String> time in event.times) {
      //if the time occurs both today and this week:
      if (time[0] == (eventsDate.weekday - 1).toString() &&
          time[3].contains(week)) {
        //create a new event (with only the matching time) and add it to the list of events to do
        events.add(new Event(
            classSet: event.classSet,
            id: event.id,
            location: event.location,
            name: event.name,
            platform: event.platform,
            teacher: event.teacher,
            times: [
              [time[0], time[1], time[2], time[3]]
            ]));
      }
    }
  }

//sort the events, as specified in the events class
  events.sort((a, b) => a.compareTo(b));

  return events;
}
