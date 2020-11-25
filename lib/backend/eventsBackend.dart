import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:learning_hub/objects/event.dart';

import 'firestoreBackend.dart';

Future<List<Event>> eventsToday(User user, List<Event> allEvents) async {
  String week = await getCurrentWeek(user);

  List<Event> events = new List<Event>();

  for (Event event in allEvents) {
    for (List<String> time in event.times) {
      if (time[0] == (DateTime.now().weekday - 1).toString() &&
          time[3].contains(week)) {
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

  events.sort((a, b) => a.compareTo(b));

  return events;
}
