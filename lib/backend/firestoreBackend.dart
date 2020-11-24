import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:learning_hub/objects/event.dart';

//initialzes an instance of the Firestore database
final databaseReference = FirebaseFirestore.instance;

//counts the number of events in the database added automatically from Firefly
Future<List<Event>> getEventsList(User firebaseUser) async {
  //https://stackoverflow.com/questions/54456665/how-to-count-the-number-of-documents-firestore-on-flutter
  //gets all events from the database which were added automatically from the pupil dashboard
  QuerySnapshot eventsSnapshot = await databaseReference
      .collection("users")
      .doc(firebaseUser.uid)
      .collection("events")
      .get();

//returns the number of events that were added automatically
  List<DocumentSnapshot> events = eventsSnapshot.docs;

  List<Event> eventsList = new List<Event>();

  events.forEach((event) {
    Event current = new Event.fromFirestore(event);
    current.output();
    eventsList.add(current);
  });

  return eventsList;
}

//given a user id, this checks that the user has a Firestore collection. If not, one is created for them.
void checkFirestoreUser(User firebaseUser) async {
//tries to get a user whose GoogleAuthId is equal to that of the signed-in user.
  QuerySnapshot usersSnapshot = await databaseReference
      .collection("users")
      .where(FieldPath.documentId, isEqualTo: firebaseUser.uid)
      .get();

//https://firebase.google.com/docs/firestore/security/rules-query
//https://firebase.google.com/docs/firestore/query-data/queries
  //https://stackoverflow.com/questions/47876754/query-firestore-database-for-document-id
  //https://atul-sharma-94062.medium.com/how-to-use-cloud-firestore-with-flutter-e6f9e8821b27

  //if no user with the signed-in account is found, a new Firestore document is created with the user's email & id.
  if (usersSnapshot.size == 0) {
    //adds the user to the database
    await databaseReference
        .collection("users")
        .doc(firebaseUser.uid)
        .set({"email": firebaseUser.email});
  }
}

//adds Firefly events to a user's Firestore database, given the user's ID, and a correctly formatted string of the events.
//the current week (A or B) is also passed, as the order of the events string is dependent on the current week.
Future<String> addFirestoreEvents(
    User firebaseUser, String eventsText, String week) async {
/*
First, existing events (added from Firefly) must be deleted, so as to stop duplicates.
Next, the new events are added, with any repetitions accounted for, and with only one event document for each class (provided they have the same teacher and room as well)
This is to try and limit the amount of duplicate data, as well as to make querying more efficient
*/

//fetch all existing Firestore events added from Firefly
  QuerySnapshot fireflyEvents = await databaseReference
      .collection("users")
      .doc(firebaseUser.uid)
      .collection("events")
      .where("platform", isEqualTo: "Firefly")
      .get();

//create a list of these events
  List<DocumentSnapshot> fireflyEventsList = fireflyEvents.docs;

//loop through the list, deleting each event
  fireflyEventsList.forEach((event) {
    databaseReference
        .collection("users")
        .doc(firebaseUser.uid)
        .collection("events")
        .doc(event.id)
        .delete();
  });

//if today is Monday, then the week shown from the web scraping will be the same as the current week. On any other day, the week fetched will be next week.
//the following two weeks are then ordered in a list, with the current week and then next week. This is because the events are scraped in the order of all events happening this week, and then all happening next week.
  List<String> weeks = DateTime.now().weekday == 1
      ? week == "A"
          ? ["A", "B"]
          : ["B", "A"]
      : week == "A"
          ? ["B", "A"]
          : ["A", "B"];

//each event is in the format: "<class>, <teacher>, <start time> - <end time> in <room> (<set>)" (where the <> indicate a parameter)
//first the string is split into a list of events (each being seperated by a semicolon and a space), and then each event is split into individual details accordingly.
  List<String> eventsTextList = eventsText.split("; ");

//sets the first day of the week to be Monday (day 0), and the previous start time to be zero. These are important later on.
  int day = 0;
  int prevStartTime = 0;

  //loops through each event
  for (String eventString in eventsTextList) {
    //first, get the event into three main chunks: the class, the teacher, and then the other details
    List<String> eventDetails = eventString.split(", ");

    //set the list of start time & end time to be an empty list
    List<int> timings = [];

    //initialize other variables for later
    List<String> compoundDetails;
    String classSet;
    String location;

    //check if the other event details contains the word "in". If it does, it means that a location has been given for the event. Otherwise, it means that the event has no location assigned.
    if (eventDetails[2].contains(" in ")) {
      //if the event does have a location:

      //split the last chunk of event details into two parts - the timings of the event (split by " - ") and the location and set of the class
      compoundDetails = eventDetails[2].split(" in ");

      //split the last chunk of the new section at the open bracket. Since the set starts with an open bracket, this will split the set of the class and the location of the class into two items in the array.
      List<String> locationAndSet = compoundDetails[1].split(" (");
      location = locationAndSet[0];

      //this checks if the set for the class is valid. If it is not, it will contain "-/", in which case everything after that can be discarded from the set name.
      //otherwise, only the closing bracket neeeds to be removed to get the set of the class.
      if (locationAndSet[1].contains("-/")) {
        classSet =
            locationAndSet[1].substring(0, locationAndSet[1].indexOf("-/"));
      } else {
        classSet = locationAndSet[1].replaceAll(")", "");
      }
    }
    //this deals with the case where no room is given for the event. In this case, the process of getting the set is much shorter, as the room does not need to be removed, and so the timings and set are just split by " ("
    else {
      //split the timings of the event (seperated by " - ") and the set into an array of length 2
      compoundDetails = eventDetails[2].split(" (");

      //this checks if the set for the class is valid. If it is not, it will contain "-/", in which case everything after that can be discarded from the set name.
      //otherwise, only the closing bracket neeeds to be removed to get the set of the class.
      if (compoundDetails[1].contains("-/")) {
        classSet =
            compoundDetails[1].substring(0, compoundDetails[1].indexOf("-/"));
      } else {
        classSet = compoundDetails[1].replaceAll(")", "");
      }
    }

    //splits the start and end times of the event into a list of two items
    List<String> timingsStrings = compoundDetails[0].split(" - ");

    //converts each time (given in 24 hour format) into an integer. This makes it easier to compare the start and end times of a given event, which is useful later on.
    timingsStrings.forEach((time) {
      timings.add(int.parse(time.replaceAll(":", "")));
    });

    //if the given start time of an event is before the start of the previous event, then that means it must occur the next day. As such, the day is incremented by one.
    if (timings[0] < prevStartTime) {
      day++;
    }

    //the previous start time is then set to the start time of the current event
    prevStartTime = timings[0];

    //mods the event day by 5, so that, if the day is greater than 5, we still get the correct weekday (between 0 and 4 for Monday to Friday)
    int eventDay = day % 5;

    //performs absolute division of the event day by 5, so that, if the day is greater than 5, we know it must occur in the second week (as each user has at least one Firefly event each day, and no Firefly events on weekends).
    String eventWeek = weeks[day ~/ 5];

    //print("Class: ${eventDetails[0]} | Teacher: ${eventDetails[1]} | Start Time: ${timings[0]} | End Time: ${timings[1]} | location: $location | Set: $classSet | Day: $eventDay | Week: $eventWeek");

    //this tries to get all events in the user's events collection where the class, teacher, set, location are the same (and the event was added by Firefly)
    QuerySnapshot matchingEvent = await databaseReference
        .collection("users")
        .doc(firebaseUser.uid)
        .collection("events")
        .where("name", isEqualTo: eventDetails[0])
        .where("platform", isEqualTo: "Firefly")
        .where("classSet", isEqualTo: classSet)
        .where("location", isEqualTo: location)
        .where("teacher", isEqualTo: eventDetails[1])
        .get();

    //if a matching event exists, then the current event's details are simply added to the event just found in the database (to stop too much duplicate data)
    //otherwise, a new event is added according to the given details
    if (matchingEvent.docs.isNotEmpty) {
      //if there is a matching event:

      //fetch the details of the event, including its ID
      DocumentSnapshot firestoreEvent = matchingEvent.docs.first;
      String docId = firestoreEvent.id;

      //fetch the times of the event already in the database, so that they can be modified accordingly
      List<dynamic> times = firestoreEvent.get("times");

      bool exists = false;

      //set the document for the event in the database to the event with the afformentioned ID
      var docToUpdate = databaseReference
          .collection("users")
          .doc(firebaseUser.uid)
          .collection("events")
          .doc(docId);

      //loop through each of the times of the event already in the database (each time is a string, in the format: "<day>, <start time>, <end time>, <weeks>")
      //i.e. if an event occurs every Monday on week A from 9am to 9:35am, it would be saved as: "0, 0900, 0935, A"
      //this is so that we can work out if an event only happens every other week (e.g. just on week A or B), or if it happens every week (on both weeks A & B)
      for (int i = 0; i < times.length; i++) {
        //checks if the current time we've fetched from the array of times is the same as the timings for the event we want to add (excluding when it repeats)
        if (times[i].startsWith(
            "$eventDay, ${timings[0].toString().padLeft(4, '0')}, ${timings[1].toString().padLeft(4, '0')}")) {
          //if a matching time exists for the given event:

          //state that we have already added the event's timings
          exists = true;

          //check whe the event repeats. If it repeats on a week that differs from the week of the event we are currently adding (i.e. to stop duplicate timings), then enter the if statement
          if ((times[i].split(", ")[3] == "B" && eventWeek == "A") ||
              (times[i].split(", ")[3] == "A" && eventWeek == "B")) {
            //this formats the event in a string according to the layout defined earlier. For the repeats, it is set to weeks A&B, as we found that these weeks were different at the top of the if statement.
            String toAdd =
                "$eventDay, ${timings[0].toString().padLeft(4, '0')}, ${timings[1].toString().padLeft(4, '0')}, AB";

            //updates the timings field of the event we are editing. First the value in the timings array that matches is removed.
            await docToUpdate.update(<String, dynamic>{
              "times": FieldValue.arrayRemove([
                "$eventDay, ${timings[0].toString().padLeft(4, '0')}, ${timings[1].toString().padLeft(4, '0')}, ${times[i].split(", ")[3]}"
              ])
            });

            //then the value in the array representing the repeats is re-added, according to the new timings.
            await docToUpdate.update(<String, dynamic>{
              "times": FieldValue.arrayUnion([toAdd])
            });
          }
        }
      }

      //if, having checked every time that the event occurs, there are none matching the time of the current event (exists is false), a new time is added to the event in the database.
      //this, by definition, would only repeat on the current week (although as we continue to loop through the web scraped events, repeats may be added as above)
      if (!exists) {
        //adds a new time to the event's timings field according to the format above
        await docToUpdate.update(<String, dynamic>{
          "times": FieldValue.arrayUnion([
            "$eventDay, ${timings[0].toString().padLeft(4, '0')}, ${timings[1].toString().padLeft(4, '0')}, $eventWeek"
          ])
        });
      }
    }

    //if no matching event exists:
    else {
      //add a new event document to the events collection for the user, with the event details. (Defined above)
      await databaseReference
          .collection("users")
          .doc(firebaseUser.uid)
          .collection("events")
          .add({
        "classSet": classSet,
        "location": location,
        "name": eventDetails[0],
        "platform": "Firefly",
        "teacher": eventDetails[1],
        //the times are set as an array of length 1, in the format used in the above "if" statement, so as to allow for more times to be added in the future
        "times": [
          "$eventDay, ${timings[0].toString().padLeft(4, '0')}, ${timings[1].toString().padLeft(4, '0')}, $eventWeek"
        ]
      });
    }
  }

  //once all events have been added, something needs to be returned, so that we can wait to build the page until all events have been added (so all events are displayed to the user)
  return "done";
}
